#!/usr/bin/env bash
set -euo pipefail

formula_dir="${FORMULA_DIR:-Formula}"

one_version() {
  local name="$1" versions="$2"
  if [[ -z "${versions}" || "${versions}" == *$'\n'* ]]
  then
    echo "::error::Could not read one ${name} version from ${formula_dir}." >&2
    exit 1
  fi
  printf '%s' "${versions}"
}

rust_versions="$(sed -n 's|.*carve-rs/releases/download/\([^/\"]*\)/.*|\1|p' "${formula_dir}/carve.rb" | sort -u)"
pdf_versions="$(sed -n 's|.*carve-pdf/archive/refs/tags/\([^/\"]*\)\.tar\.gz.*|\1|p' "${formula_dir}/crv2pdf.rb" | sort -u)"
js_versions="$(sed -n 's|.*@markup-carve/carve/-/carve-\([^/\"]*\)\.tgz.*|\1|p' "${formula_dir}/crv2pdf.rb" | sort -u)"
rust_pin="$(one_version carve-rs "${rust_versions}")"
pdf_pin="$(one_version carve-pdf "${pdf_versions}")"
js_pin="$(one_version carve-js "${js_versions}")"

rust_latest="$(gh api repos/markup-carve/carve-rs/releases/latest --jq .tag_name)"
pdf_latest="$(gh api repos/markup-carve/carve-pdf/releases/latest --jq .tag_name)"
js_latest="$(curl -fsSL --retry 2 --max-time 20 \
  'https://registry.npmjs.org/-/package/%40markup-carve%2Fcarve/dist-tags' | jq -er .latest)"

status=0
check_pin() {
  local dependency="$1" pin="$2" latest="$3"
  if [[ "${pin}" != "${latest}" ]]
  then
    echo "::error::${dependency} formula pins ${pin}; current published version is ${latest}." >&2
    status=1
  else
    echo "${dependency}: ${pin} is current"
  fi
}

check_pin rust "${rust_pin}" "${rust_latest}"
check_pin pdf "${pdf_pin}" "${pdf_latest}"
check_pin js "${js_pin}" "${js_latest}"
exit "${status}"
