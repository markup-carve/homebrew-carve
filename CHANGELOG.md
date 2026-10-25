# Changelog

Each version records which formula versions the tap served when it was marked.
`brew install` reads the formulae from `main`, so a formula change reaches users
when it merges, not when a version is tagged.

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
