# homebrew-carve

Homebrew tap for the [Carve markup language](https://markup-carve.github.io/carve/) CLI.

```bash
brew install markup-carve/carve/carve
brew install markup-carve/carve/crv2pdf
```

`carve` is the Rust implementation's command-line renderer. It reads Carve
source from a file or stdin and writes HTML, Markdown, plain text or
ANSI-colored terminal output.

```bash
carve README.crv > README.html
echo '# Hello /Carve/' | carve
```

`crv2pdf` renders a document to a paginated PDF through headless Chrome, and to
standalone HTML, Markdown or text from the same pipeline. It arrives with a
Carve engine already beside it, so nothing has to be npm- or composer-installed
first. PDF output additionally needs Chrome and two Python packages, which
`brew info crv2pdf` spells out.

```bash
crv2pdf report.crv report.pdf
crv2pdf --html report.crv
```

## What lives here

Two formulae, maintained in two different ways.

`Formula/carve.rb` is **generated**, not hand-maintained. The release workflow
in [markup-carve/carve-rs](https://github.com/markup-carve/carve-rs) builds the
platform archives, publishes them as release assets with a `.sha256` sidecar
each, then rewrites the formula to point at those exact bytes and commits it
here. Editing that formula by hand works until the next release overwrites it.

Platforms it covers: macOS on Apple silicon, macOS on Intel, and Linux on
x86-64 (glibc). The release also carries a musl Linux archive and a Windows
archive, which Homebrew does not install; take those from the
[releases page](https://github.com/markup-carve/carve-rs/releases) directly.

`Formula/crv2pdf.rb` is hand-written. Its 0.1.3 archive digest must be filled
in after carve-pdf publishes the tag. The pending formula uses the published
Carve JavaScript package 0.1.11 with a checked digest.

## Reporting a problem

A formula that fails to install is a bug in the repository the formula points
at, not in this one. For `carve` that is
[carve-rs](https://github.com/markup-carve/carve-rs/issues), which owns both
the workflow and the binary. For `crv2pdf` it is
[carve-pdf](https://github.com/markup-carve/carve-pdf/issues).
