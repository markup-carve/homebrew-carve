# Changelog

Each version records which formula versions the tap served when it was marked.
`brew install` reads the formulae from `main`, so a formula change reaches users
when it merges, not when a version is tagged.

## [0.1.7]

The tap now installs carve-rs 0.1.14, and `crv2pdf` installs carve-pdf 0.1.6 on the carve-js 0.1.16 engine, so both follow the carve 0.1.14 spec.

### Breaking

- `crv2pdf`: a first-line `---` with no closing `---` is frontmatter that runs to the end of the file, as in the 0.1.14 engines (carve-pdf 0.1.6, markup-carve/carve#5016).

### Fixes

- `crv2pdf` prints in the document's body font instead of the browser serif default, uses one monospace stack for all code, and shows `[/]` and `[!]` task states with their own glyphs (carve-pdf 0.1.6, #28).

### Improvements

- `carve` installs carve-rs 0.1.14, which implements the carve 0.1.14 spec: native `|=` table headers with braced alignment such as `|={>}`, the `carve trace` command, and row and column selection on table includes.
- `crv2pdf` installs carve-pdf 0.1.6: bylines and default page footers follow frontmatter `lang`, and code listings longer than 15 lines split across pages (#28).
- `crv2pdf` stages carve-js 0.1.16, so PDF, HTML and Markdown output follow the carve 0.1.14 spec too (#26).

**Full Changelog**: https://github.com/markup-carve/homebrew-carve/compare/0.1.6...0.1.7

## [0.1.6]

The tap now installs carve 0.1.13 and stages carve-js 0.1.15 for `crv2pdf`.

### Improvements

- Task lists in the CLI and PDF engine recognize progress `[/]`, blocked `[!]`, and open alias `[_]` states (#22).

**Full Changelog**: https://github.com/markup-carve/homebrew-carve/compare/0.1.5...0.1.6

## [0.1.5]

The tap now installs carve-pdf 0.1.5 and stages carve-js 0.1.14 for crv2pdf. The carve formula serves carve 0.1.12.

### Improvements

- `crv2pdf` installs carve-pdf 0.1.5.
- `crv2pdf` stages carve-js 0.1.14 (#20).
- `carve` installs carve 0.1.12.

**Full Changelog**: https://github.com/markup-carve/homebrew-carve/compare/0.1.4...0.1.5

## [0.1.4]

### Fixes

- `brew upgrade crv2pdf` picks up a newly staged engine: the formula revision moves with every engine pin, so an existing 0.1.4 install upgrades (#17).

### Improvements

- `crv2pdf` stages the carve-js 0.1.13 engine, after 0.1.12.
- `carve` follows carve-rs to 0.1.11.

## [0.1.3]

### Improvements

- `crv2pdf` stages the carve-js 0.1.12 engine, after 0.1.11 (#14).
- `carve` follows carve-rs to 0.1.10.

## [0.1.2]

### Improvements

- `crv2pdf` installs carve-pdf 0.1.4, its security release, from its release source archive, pinned by sha256, after serving 0.1.2 (#10, #11, #13).
- `crv2pdf` stages the carve-js 0.1.11 engine, after 0.1.10 (#9, #11).
- `carve` follows carve-rs to 0.1.9.

## [0.1.1]

### Improvements

- New `crv2pdf` formula for carve-pdf 0.1.1 (#4, #5).
- `carve` follows carve-rs to 0.1.7.

## [0.1.0]

- First release of the tap: the `carve` formula installs the prebuilt carve-rs 0.1.4 CLI on macOS and Linux.
