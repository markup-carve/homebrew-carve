# homebrew-carve

Homebrew tap for the [Carve markup language](https://markup-carve.github.io/carve/) CLI.

```bash
brew install markup-carve/carve/carve
```

That installs the `carve` binary, the Rust implementation's command-line
renderer. It reads Carve source from a file or stdin and writes HTML,
Markdown, plain text or ANSI-colored terminal output.

```bash
carve README.crv > README.html
echo '# Hello /Carve/' | carve
```

## What lives here

One file: `Formula/carve.rb`.

It is **generated**, not hand-maintained. The release workflow in
[markup-carve/carve-rs](https://github.com/markup-carve/carve-rs) builds the
platform archives, publishes them as release assets with a `.sha256` sidecar
each, then rewrites the formula to point at those exact bytes and commits it
here. Editing the formula by hand works until the next release overwrites it.

Platforms the formula covers: macOS on Apple silicon, macOS on Intel, and Linux
on x86-64 (glibc). The release also carries a musl Linux archive and a Windows
archive, which Homebrew does not install; take those from the
[releases page](https://github.com/markup-carve/carve-rs/releases) directly.

## Reporting a problem

A formula that fails to install is a bug in `carve-rs`, not in this repository.
[Open it there](https://github.com/markup-carve/carve-rs/issues), since that is
where both the workflow and the binary come from.
