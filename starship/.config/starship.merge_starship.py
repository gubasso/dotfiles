#!/usr/bin/env python
"""
Deep-merge two TOML files (Starship configs, etc.).

Usage:
    python merge_starship.py base.toml patch.toml [-o OUTPUT]

The patch’s scalars override the base; nested tables are merged;
arrays concatenate.  Requires: tomlkit (pip install tomlkit).
"""
import argparse, sys
from pathlib import Path

try:
    import tomlkit
except ImportError:
    sys.exit("Missing tomlkit – pip install tomlkit")

def merge(a, b):
    """Recursively merge dict-like TOML objects:  a ← b"""
    for k, v in b.items():
        if k in a and isinstance(a[k], dict) and isinstance(v, dict):
            merge(a[k], v)
        elif k in a and isinstance(a[k], list) and isinstance(v, list):
            a[k] += v
        else:
            a[k] = v
    return a

def main():
    ap = argparse.ArgumentParser(description="Merge two TOML files")
    ap.add_argument("base"), ap.add_argument("patch")
    ap.add_argument("-o", "--output", default="merged.toml")
    args = ap.parse_args()

    base_doc  = tomlkit.parse(Path(args.base).read_text())
    patch_doc = tomlkit.parse(Path(args.patch).read_text())
    merged    = merge(base_doc, patch_doc)

    Path(args.output).write_text(tomlkit.dumps(merged))
    print(f"✅  Merged config written → {args.output}")

if __name__ == "__main__":
    main()
