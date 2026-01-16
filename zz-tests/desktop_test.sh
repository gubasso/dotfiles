#!/usr/bin/env bash
set -u

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"

TESTS_PASSED=0
TESTS_FAILED=0

fail() {
    echo "not ok - $1"
    TESTS_FAILED=$((TESTS_FAILED + 1))
    if [[ -n "${OUTPUT:-}" ]]; then
        echo "--- output"
        echo "$OUTPUT"
        echo "---"
    fi
    return 1
}

pass() {
    echo "ok - $1"
    TESTS_PASSED=$((TESTS_PASSED + 1))
}

# Check if desktop-file-validate is available
if ! command -v desktop-file-validate >/dev/null 2>&1; then
    echo "SKIP: desktop-file-validate not found (install desktop-file-utils)"
    exit 0
fi

# Find all .desktop files in the repo (excluding zz-* directories)
mapfile -t desktop_files < <(find "$ROOT_DIR" -path "$ROOT_DIR/zz-*" -prune -o -name "*.desktop" -type f -print)

if [[ ${#desktop_files[@]} -eq 0 ]]; then
    echo "SKIP: No .desktop files found"
    exit 0
fi

echo "Testing ${#desktop_files[@]} desktop file(s)..."
echo

for file in "${desktop_files[@]}"; do
    rel_path="${file#$ROOT_DIR/}"
    OUTPUT=$(desktop-file-validate "$file" 2>&1)
    status=$?

    if [[ $status -eq 0 && -z "$OUTPUT" ]]; then
        pass "$rel_path"
    else
        fail "$rel_path"
    fi
done

echo
printf "Passed: %d, Failed: %d\n" "$TESTS_PASSED" "$TESTS_FAILED"

if [[ "$TESTS_FAILED" -ne 0 ]]; then
    exit 1
fi
