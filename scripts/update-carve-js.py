#!/usr/bin/env python3
"""Update crv2pdf's pinned npm engine after checking its runtime closure."""

import base64
import hashlib
import json
import re
import sys
import urllib.request
from pathlib import Path

REGISTRY = "https://registry.npmjs.org"
PACKAGE = "%40markup-carve%2Fcarve"
VERSION = re.compile(r"[0-9]+\.[0-9]+\.[0-9]+")


def fetch(path):
    with urllib.request.urlopen(f"{REGISTRY}/{path}", timeout=30) as response:
        return response.read()


def metadata(path):
    return json.loads(fetch(path))


def resource(formula, name):
    match = re.search(rf'  resource "{name}" do\n(?P<body>.*?)\n  end', formula, re.S)
    if not match:
        raise ValueError(f"Missing {name} resource")
    return match


def pinned_version(formula, name):
    body = resource(formula, name)["body"]
    match = re.search(rf'/({re.escape(name)})-([0-9]+\.[0-9]+\.[0-9]+)\.tgz"', body)
    if not match:
        raise ValueError(f"Cannot read {name} resource version")
    return match.group(2)


def update(formula):
    latest = metadata(f"-/package/{PACKAGE}/dist-tags")["latest"]
    if not VERSION.fullmatch(latest):
        raise ValueError(f"Invalid npm latest version: {latest}")

    current = resource(formula, "carve")
    current_version = re.search(r"/carve-([0-9]+\.[0-9]+\.[0-9]+)\.tgz", current["body"])
    if not current_version:
        raise ValueError("Cannot read pinned carve-js version")
    if f"/carve-{latest}.tgz\"" in current["body"]:
        return formula, latest, False
    if tuple(map(int, latest.split("."))) < tuple(map(int, current_version.group(1).split("."))):
        raise ValueError("npm latest would downgrade the pinned engine")

    package = metadata(f"{PACKAGE}/{latest}")
    expected_url = f"{REGISTRY}/@markup-carve/carve/-/carve-{latest}.tgz"
    if package.get("name") != "@markup-carve/carve" or package.get("version") != latest:
        raise ValueError("npm metadata does not match the requested engine")
    if package.get("dependencies") != {"parse5": "^7.3.0"}:
        raise ValueError("Engine runtime dependencies changed; update formula resources first")
    if package.get("peerDependencies") != {"@djot/djot": "^0.3.2"}:
        raise ValueError("Engine peer dependencies changed; review the formula first")
    if package.get("optionalDependencies") or package.get("bundleDependencies") or package.get("bundledDependencies"):
        raise ValueError("Engine gained optional or bundled dependencies; review the formula first")
    parse5_version = pinned_version(formula, "parse5")
    entities_version = pinned_version(formula, "entities")
    parse5 = metadata(f"parse5/{parse5_version}")
    if parse5.get("dependencies") != {"entities": "^6.0.0"}:
        raise ValueError("parse5 runtime dependencies changed; update formula resources first")
    if not parse5_version.startswith("7.") or tuple(map(int, parse5_version.split("."))) < (7, 3, 0):
        raise ValueError("Pinned parse5 does not satisfy the engine dependency")
    if not entities_version.startswith("6."):
        raise ValueError("Pinned entities does not satisfy the parse5 dependency")

    dist = package.get("dist", {})
    if dist.get("tarball") != expected_url:
        raise ValueError("Unexpected npm tarball URL")
    integrity = dist.get("integrity", "")
    if not integrity.startswith("sha512-"):
        raise ValueError("npm tarball has no SHA-512 integrity digest")
    tarball = fetch(expected_url.removeprefix(f"{REGISTRY}/"))
    actual_integrity = base64.b64encode(hashlib.sha512(tarball).digest()).decode()
    if actual_integrity != integrity.removeprefix("sha512-"):
        raise ValueError("npm tarball does not match its integrity digest")
    checksum = hashlib.sha256(tarball).hexdigest()

    body = current["body"]
    new_body, url_count = re.subn(r'^    url ".*"$', f'    url "{expected_url}"', body, count=1, flags=re.M)
    new_body, sha_count = re.subn(r'^    sha256 "[0-9a-f]{64}"$', f'    sha256 "{checksum}"', new_body, count=1, flags=re.M)
    if url_count != 1 or sha_count != 1:
        raise ValueError("Unexpected carve resource layout")
    updated = formula[:current.start("body")] + new_body + formula[current.end("body"):]
    revised, count = re.subn(r"^  revision ([0-9]+)$", lambda match: f"  revision {int(match.group(1)) + 1}", updated, count=1, flags=re.M)
    if count == 0:
        revised, count = re.subn(r'^(  sha256 "[0-9a-f]{64}")$', r'\1\n  revision 1', updated, count=1, flags=re.M)
        if count != 1:
            raise ValueError("Cannot add crv2pdf formula revision")
    return revised, latest, True


def main():
    path = Path(sys.argv[1] if len(sys.argv) > 1 else "Formula/crv2pdf.rb")
    updated, version, changed = update(path.read_text(encoding="utf-8"))
    if changed:
        path.write_text(updated, encoding="utf-8")
    print(f"carve-js {version}: {'updated' if changed else 'already current'}")


if __name__ == "__main__":
    try:
        main()
    except (KeyError, ValueError, OSError) as error:
        sys.exit(f"carve-js formula update failed: {error}")
