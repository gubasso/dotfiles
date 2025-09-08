#!/bin/sh
set -eu

usage() {
  cat >&2 <<'EOF'
Usage: niri-promote-output.sh <SOURCE_OUTPUT> <TARGET_OUTPUT>

Moves all workspaces currently on SOURCE to TARGET.
Final order on TARGET:
  1) all workspaces that came from SOURCE, in the SAME order they had on SOURCE
  2) then any workspaces that were already on TARGET, preserving their order

This uses only Niri IPC (runtime state) — no config parsing.
EOF
  exit 2
}

[ "${1-}" = "-h" ] || [ "${1-}" = "--help" ] && usage
[ "$#" -eq 2 ] || usage

SRC_SPEC=$1   # FROM
TGT_SPEC=$2   # TO
[ "$SRC_SPEC" != "$TGT_SPEC" ] || { echo "Error: SOURCE and TARGET must differ." >&2; exit 2; }

need() { command -v "$1" >/dev/null 2>&1 || { echo "Error: $1 not found." >&2; exit 127; }; }
need niri; need jq; need awk

# Resolve a user spec (connector or "Make Model Serial") to Niri's connector name (.name)
resolve_name() {
  niri msg --json outputs | jq -r --arg SPEC "$1" '
    .[] | select(
      .name == $SPEC
      or
      ((.make + " " + .model + " " + (.serial // "Unknown")) == $SPEC)
    ) | .name
  ' | head -n1
}

SRC=$(resolve_name "$SRC_SPEC" || true)
TGT=$(resolve_name "$TGT_SPEC" || true)
[ -n "${SRC:-}" ] || { echo "Error: source \"$SRC_SPEC\" not found."; exit 1; }
[ -n "${TGT:-}" ] || { echo "Error: target \"$TGT_SPEC\" not found."; exit 1; }

# Capture CURRENT order on SOURCE (before moving): list of refs (name or id), sorted by per-monitor idx
SRC_LIST=$(
  niri msg --json workspaces \
  | jq -r --arg SRC "$SRC" '
      [ .[] | select(.output == $SRC) | {ref: (.name // (.id|tostring)), i: .idx} ]
      | sort_by(.i) | .[].ref
    '
)

# Capture CURRENT order on TARGET (before moving) to preserve later
TGT_BEFORE=$(
  niri msg --json workspaces \
  | jq -r --arg T "$TGT" '
      [ .[] | select(.output == $T) | {ref: (.name // (.id|tostring)), i: .idx} ]
      | sort_by(.i) | .[].ref
    '
)

# Focus target (by name; fall back directionally if name addressing isn't supported)
niri msg action focus-monitor "$TGT" 2>/dev/null || niri msg action focus-monitor-right

# Move every workspace currently on SOURCE to TARGET, preserving the original SOURCE order
# (moving first avoids index churn when we later reorder)
printf '%s\n' "$SRC_LIST" \
| while IFS= read -r REF; do
    [ -n "$REF" ] || continue
    niri msg action move-workspace-to-monitor --reference "$REF" "$TGT"
  done

# Build the final deterministic order on TARGET:
#   moved (SRC_LIST) first, then the original TGT_BEFORE (dedup to avoid double entries)
FINAL_ORDER=$(
  {
    printf '%s\n' "$SRC_LIST"
    printf '%s\n' "$TGT_BEFORE"
  } | awk 'NF { if (!seen[$0]++) print $0 }'
)

# Apply the order by setting explicit indices 1..N on TARGET
i=1
printf '%s\n' "$FINAL_ORDER" \
| while IFS= read -r REF; do
    [ -n "$REF" ] || continue
    niri msg action move-workspace-to-index --reference "$REF" "$i"
    i=$((i+1))
  done

# End focused on TARGET
niri msg action focus-monitor "$TGT" >/dev/null 2>&1 || :
