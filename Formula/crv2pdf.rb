# Hand-written, unlike Formula/carve.rb beside it. That one is generated because
# carve-rs publishes a binary per platform and its release workflow reads the
# digests out of the sidecars it just uploaded. carve-pdf is a bash front end
# with no build step and no per-platform asset, so a tag with a revision pins it
# exactly and a generator would have nothing left to compute.
class Crv2pdf < Formula
  desc "Render Carve documents to paginated PDF, HTML, Markdown or text"
  homepage "https://github.com/markup-carve/carve-pdf"
  url "https://github.com/markup-carve/carve-pdf.git",
      tag:      "0.1.2",
      revision: "e208c8253c71860dd4686618a123e8d19d05f794"
  license "MIT"
  head "https://github.com/markup-carve/carve-pdf.git", branch: "main"

  # The only hard dependency, and it is here for the engine rather than for node
  # itself: nothing renders without a Carve engine, and the engine staged below
  # runs under node. Everything else carve-pdf reaches for degrades to a named
  # fallback and is named in `caveats` instead. That is the split `make check`
  # prints in the repo, where a missing engine is its one fatal result.
  depends_on "node"

  # carve-js and its entire runtime closure, staged rather than npm-installed.
  # Homebrew denies the build phase all network access, and a pinned digest is
  # also what makes two installs of one version the same install.
  resource "carve" do
    url "https://registry.npmjs.org/@markup-carve/carve/-/carve-0.1.10.tgz"
    sha256 "88a7c47eac5420d1c03f87b4dc45b068d3b5b98cdc22e3dc5895ae99040e1609"
  end

  resource "parse5" do
    url "https://registry.npmjs.org/parse5/-/parse5-7.3.0.tgz"
    sha256 "9316ca7af41da9e85071b62b9605aa0a6aaeb0463f833c29e7a331e7898f0420"
  end

  resource "entities" do
    url "https://registry.npmjs.org/entities/-/entities-6.0.1.tgz"
    sha256 "a4de957ab0852f6c91eae59a6000ced5a25a04f0b6e1c3062fbad732a6b5479d"
  end

  def install
    libexec.install "crv2pdf.sh", "lib", "themes"
    (libexec/"crv2pdf.sh").chmod 0755

    # lib/render.mjs and lib/assets.py both name `<tree>/node_modules` as where
    # a Homebrew install keeps the engine, so it has to land beside lib/. Flat,
    # because dist/index.js imports parse5 by bare specifier and node resolves
    # that by walking up from the package directory.
    { "carve" => "@markup-carve/carve", "parse5" => "parse5", "entities" => "entities" }
      .each { |name, dir| resource(name).stage { (libexec/"node_modules"/dir).install Dir["*"] } }

    # crv2pdf.sh calls `node` by name, so the keg's bin goes on PATH and an
    # install does not also depend on the user having node on theirs.
    (bin/"crv2pdf").write_env_script libexec/"crv2pdf.sh",
                                     PATH: "#{formula_opt_bin("node")}:$PATH"
  end

  def caveats
    <<~EOS
      Markdown and plain text work as installed. The rest needs software this
      formula deliberately does not pull in, and each one degrades rather than
      failing:

        python3            HTML and PDF output. Without it, only --md and --txt.
        Chrome or Chromium PDF output. Set CHROME_BIN to point at one.
        websocket-client   PDF output: pip install websocket-client
        Pygments           highlighted code fences; without it they render plain.
        inotify-tools      --watch wakes on a save; without it, a 1s poll.

      Chrome is a cask on macOS and not in Homebrew at all on Linux, so PDF
      needs one step outside brew either way.

      Math, Mermaid diagrams and Chart.js charts render when CARVE_KATEX,
      CARVE_MERMAID or CARVE_CHART point at those packages. Unset, math prints
      as TeX and diagrams and charts print as their source. `crv2pdf --help`
      lists every variable.
    EOS
  end

  test do
    (testpath/"doc.crv").write <<~CRV
      # Heading

      A paragraph with *strong* text.

      - one
      - two
    CRV

    system bin/"crv2pdf", "--md", testpath/"doc.crv", testpath/"doc.md"
    assert_match "Heading", (testpath/"doc.md").read
    assert_match "one", (testpath/"doc.md").read

    system bin/"crv2pdf", "--txt", testpath/"doc.crv", testpath/"doc.txt"
    assert_match "Heading", (testpath/"doc.txt").read

    assert_match(/^crv2pdf \d+\.\d+\.\d+$/, shell_output("#{bin}/crv2pdf --version"))
  end
end
