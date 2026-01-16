#!/usr/bin/env bash
set -u

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
DOTS_BIN="$ROOT_DIR/bin/.local/bin/dots"
PATH_ORIG="$PATH"

TESTS_PASSED=0
TESTS_FAILED=0

fail() {
    echo "not ok - $1"
    TESTS_FAILED=$((TESTS_FAILED + 1))
    if [[ -n "${RUN_OUTPUT:-}" ]]; then
        echo "--- output"
        echo "$RUN_OUTPUT"
        echo "---"
    fi
    return 1
}

pass() {
    echo "ok - $1"
    TESTS_PASSED=$((TESTS_PASSED + 1))
}

assert_contains() {
    local haystack="$1"
    local needle="$2"
    [[ "$haystack" == *"$needle"* ]]
}

assert_not_contains() {
    local haystack="$1"
    local needle="$2"
    [[ "$haystack" != *"$needle"* ]]
}

assert_eq() {
    local actual="$1"
    local expected="$2"
    [[ "$actual" == "$expected" ]]
}

assert_file_empty() {
    local path="$1"
    [[ ! -s "$path" ]]
}

assert_is_dir() {
    local path="$1"
    [[ -d "$path" && ! -L "$path" ]]
}

assert_symlink_target() {
    local path="$1"
    local expected="$2"
    [[ -L "$path" ]] || return 1
    local target
    target="$(readlink "$path")"
    [[ "$target" == "$expected" ]]
}

create_stub_stow() {
    local path="$1"
    cat <<'STOW' > "$path"
#!/usr/bin/env bash
set -euo pipefail

: "${STOW_LOG:?STOW_LOG not set}"
: "${DOTFILES_PUBLIC:?DOTFILES_PUBLIC not set}"
: "${DOTFILES_PRIVATE:?DOTFILES_PRIVATE not set}"
: "${STOW_STATE_DIR:?STOW_STATE_DIR not set}"

echo "stow $*" >> "$STOW_LOG"

target=""
dir=""
action=""
pkg=""
simulate=0

for arg in "$@"; do
    case "$arg" in
        --target=*) target="${arg#--target=}" ;;
        --dir=*) dir="${arg#--dir=}" ;;
        -S|-D|-R) action="$arg" ;;
        --simulate) simulate=1 ;;
        --ignore=*|--verbose=*) ;;
        *) pkg="$arg" ;;
    esac
done

if [[ -z "$target" || -z "$dir" || -z "$pkg" ]]; then
    exit 0
fi

if [[ $simulate -eq 1 ]]; then
    exit 0
fi

# Simulate a conflict when stowing private repo for the conflict package
if [[ "$action" == "-S" && "$pkg" == "conflict" && "$dir" == "$DOTFILES_PRIVATE" ]]; then
    if [[ ! -f "$STOW_STATE_DIR/conflict_private_failed" ]]; then
        echo "existing target is a symlink" >&2
        touch "$STOW_STATE_DIR/conflict_private_failed"
        exit 1
    fi
fi

# No-op for delete/restow to keep tests deterministic
if [[ "$action" == "-D" || "$action" == "-R" ]]; then
    exit 0
fi

# Simulate stow folding for conflict package (public repo)
if [[ "$action" == "-S" && "$pkg" == "conflict" && "$dir" == "$DOTFILES_PUBLIC" ]]; then
    mkdir -p "$target/.config"
    ln -sf "$dir/$pkg/.config/app" "$target/.config/app"
    exit 0
fi

# Generic stow: symlink files into target
while IFS= read -r -d '' file; do
    rel="${file#$dir/$pkg/}"
    [[ "$rel" == .hooks/* ]] && continue
    dest="$target/$rel"
    mkdir -p "$(dirname "$dest")"
    ln -sf "$file" "$dest"
done < <(find "$dir/$pkg" -type f -print0)
STOW
    chmod +x "$path"
}

create_stub_sudo() {
    local path="$1"
    cat <<'SUDO' > "$path"
#!/usr/bin/env bash
exec "$@"
SUDO
    chmod +x "$path"
}

setup_env() {
    TEST_TMP="$(mktemp -d)"
    HOME_DIR="$TEST_TMP/home"
    mkdir -p "$HOME_DIR"
    DOTFILES_PUBLIC="$HOME_DIR/.dotfiles"
    DOTFILES_PRIVATE="$HOME_DIR/.dotfiles-private"
    mkdir -p "$DOTFILES_PUBLIC" "$DOTFILES_PRIVATE"

    TEST_BIN="$TEST_TMP/bin"
    mkdir -p "$TEST_BIN"

    STOW_STATE_DIR="$TEST_TMP/state"
    mkdir -p "$STOW_STATE_DIR"

    STOW_LOG="$TEST_TMP/stow.log"
    : > "$STOW_LOG"

    create_stub_stow "$TEST_BIN/stow"
    create_stub_sudo "$TEST_BIN/sudo"

    export HOME="$HOME_DIR"
    export DOTFILES_PUBLIC
    export DOTFILES_PRIVATE
    export STOW_LOG
    export STOW_STATE_DIR
    export PATH="$TEST_BIN:$PATH_ORIG"
}

cleanup_env() {
    rm -rf "$TEST_TMP"
    export PATH="$PATH_ORIG"
}

make_file() {
    local base="$1"
    local rel="$2"
    mkdir -p "$(dirname "$base/$rel")"
    echo "data" > "$base/$rel"
}

make_pkg_file() {
    local repo="$1"
    local pkg="$2"
    local rel="$3"
    make_file "$repo/$pkg" "$rel"
}

make_dep() {
    local repo="$1"
    local pkg="$2"
    local dep="$3"
    mkdir -p "$repo/$pkg/.hooks"
    echo "$dep" > "$repo/$pkg/.hooks/depends"
}

run_dots() {
    local input="$1"
    shift
    RUN_OUTPUT=$(printf "%s" "$input" | env HOME="$HOME_DIR" PATH="$PATH" DOTFILES_PUBLIC="$DOTFILES_PUBLIC" DOTFILES_PRIVATE="$DOTFILES_PRIVATE" STOW_LOG="$STOW_LOG" STOW_STATE_DIR="$STOW_STATE_DIR" bash "$DOTS_BIN" "$@" 2>&1)
    RUN_STATUS=$?
}

run_test() {
    local name="$1"
    shift
    if "$@"; then
        pass "$name"
    else
        fail "$name"
    fi
}

# --- Tests ---

test_preview_confirm_default() {
    setup_env
    trap cleanup_env RETURN

    make_pkg_file "$DOTFILES_PUBLIC" "fish" ".config/fish/config.fish"

    run_dots "n\n" fish
    assert_eq "$RUN_STATUS" "0" || return 1
    assert_contains "$RUN_OUTPUT" "dots: STOW PREVIEW" || return 1
    assert_contains "$RUN_OUTPUT" "Proceed with stow?" || return 1
    assert_contains "$RUN_OUTPUT" "Aborted." || return 1
    assert_file_empty "$STOW_LOG" || return 1
}

test_quiet_still_confirms() {
    setup_env
    trap cleanup_env RETURN

    make_pkg_file "$DOTFILES_PUBLIC" "fish" ".config/fish/config.fish"

    run_dots "n\n" -q fish
    assert_eq "$RUN_STATUS" "0" || return 1
    assert_not_contains "$RUN_OUTPUT" "PREVIEW" || return 1
    assert_contains "$RUN_OUTPUT" "Proceed with stow?" || return 1
    assert_file_empty "$STOW_LOG" || return 1
}

test_dry_run_no_execution() {
    setup_env
    trap cleanup_env RETURN

    make_pkg_file "$DOTFILES_PUBLIC" "fish" ".config/fish/config.fish"

    run_dots "" -n -y fish
    assert_eq "$RUN_STATUS" "0" || return 1
    assert_contains "$RUN_OUTPUT" "dry-run mode" || return 1
    assert_file_empty "$STOW_LOG" || return 1
}

test_dependency_resolution_and_label() {
    setup_env
    trap cleanup_env RETURN

    make_pkg_file "$DOTFILES_PUBLIC" "app" ".config/app/config"
    make_pkg_file "$DOTFILES_PUBLIC" "dep1" ".config/dep1/config"
    make_dep "$DOTFILES_PUBLIC" "app" "dep1"

    run_dots "" -n -y app
    assert_eq "$RUN_STATUS" "0" || return 1
    assert_contains "$RUN_OUTPUT" "dep1" || return 1
    assert_contains "$RUN_OUTPUT" "dependency of: app" || return 1

    local dep_line app_line
    dep_line=$(printf "%s" "$RUN_OUTPUT" | awk '/dep1/ {print NR; exit}')
    app_line=$(printf "%s" "$RUN_OUTPUT" | awk '/app/ && !/dependency of/ {print NR; exit}')
    [[ -n "$dep_line" && -n "$app_line" && "$dep_line" -lt "$app_line" ]]
}

test_multi_level_dependency_chain() {
    setup_env
    trap cleanup_env RETURN

    # Create chain: app3 -> app2 -> app1 (like brave-nova -> brave -> bin)
    make_pkg_file "$DOTFILES_PUBLIC" "app1" ".config/app1/config"
    make_pkg_file "$DOTFILES_PUBLIC" "app2" ".config/app2/config"
    make_pkg_file "$DOTFILES_PUBLIC" "app3" ".config/app3/config"
    make_dep "$DOTFILES_PUBLIC" "app2" "app1"
    make_dep "$DOTFILES_PUBLIC" "app3" "app2"

    run_dots "" -n -y app3
    assert_eq "$RUN_STATUS" "0" || return 1

    # All three should appear
    assert_contains "$RUN_OUTPUT" "app1" || return 1
    assert_contains "$RUN_OUTPUT" "app2" || return 1
    assert_contains "$RUN_OUTPUT" "app3" || return 1

    # Verify order: app1 before app2 before app3 (match package listing lines)
    local app1_line app2_line app3_line
    app1_line=$(printf "%s" "$RUN_OUTPUT" | grep -n 'app1 →' | head -1 | cut -d: -f1)
    app2_line=$(printf "%s" "$RUN_OUTPUT" | grep -n 'app2 →' | head -1 | cut -d: -f1)
    app3_line=$(printf "%s" "$RUN_OUTPUT" | grep -n 'app3 →' | head -1 | cut -d: -f1)
    [[ -n "$app1_line" && -n "$app2_line" && -n "$app3_line" ]] || return 1
    [[ "$app1_line" -lt "$app2_line" && "$app2_line" -lt "$app3_line" ]] || return 1
}

test_multiple_dependencies() {
    setup_env
    trap cleanup_env RETURN

    # Create: app depends on both dep1 and dep2 (like brave-nova depends on brave AND bin)
    make_pkg_file "$DOTFILES_PUBLIC" "dep1" ".config/dep1/config"
    make_pkg_file "$DOTFILES_PUBLIC" "dep2" ".config/dep2/config"
    make_pkg_file "$DOTFILES_PUBLIC" "app" ".config/app/config"
    mkdir -p "$DOTFILES_PUBLIC/app/.hooks"
    printf "dep1\ndep2\n" > "$DOTFILES_PUBLIC/app/.hooks/depends"

    run_dots "" -n -y app
    assert_eq "$RUN_STATUS" "0" || return 1

    # All should appear
    assert_contains "$RUN_OUTPUT" "dep1" || return 1
    assert_contains "$RUN_OUTPUT" "dep2" || return 1
    assert_contains "$RUN_OUTPUT" "app" || return 1

    # Both deps should come before app (match package listing lines)
    local dep1_line dep2_line app_line
    dep1_line=$(printf "%s" "$RUN_OUTPUT" | grep -n 'dep1 →' | head -1 | cut -d: -f1)
    dep2_line=$(printf "%s" "$RUN_OUTPUT" | grep -n 'dep2 →' | head -1 | cut -d: -f1)
    app_line=$(printf "%s" "$RUN_OUTPUT" | grep -n 'app →' | head -1 | cut -d: -f1)
    [[ -n "$dep1_line" && -n "$dep2_line" && -n "$app_line" ]] || return 1
    [[ "$dep1_line" -lt "$app_line" && "$dep2_line" -lt "$app_line" ]] || return 1
}

test_no_hooks_skips_deps() {
    setup_env
    trap cleanup_env RETURN

    make_pkg_file "$DOTFILES_PUBLIC" "app" ".config/app/config"
    make_dep "$DOTFILES_PUBLIC" "app" "missing-dep"

    run_dots "" --no-hooks -n -y app
    assert_eq "$RUN_STATUS" "0" || return 1
    assert_not_contains "$RUN_OUTPUT" "dependency of:" || return 1
    assert_not_contains "$RUN_OUTPUT" "Skipped (not found)" || return 1
}

test_sync_permissive_missing_dep_warning() {
    setup_env
    trap cleanup_env RETURN

    make_pkg_file "$DOTFILES_PUBLIC" "app" ".config/app/config"
    make_dep "$DOTFILES_PUBLIC" "app" "missing-dep"

    run_dots "" --sync -p -n -q
    assert_eq "$RUN_STATUS" "0" || return 1
    assert_contains "$RUN_OUTPUT" "Skipped (not found)" || return 1
    assert_contains "$RUN_OUTPUT" "missing-dep" || return 1
    assert_contains "$RUN_OUTPUT" "needed by: app" || return 1
    assert_file_empty "$STOW_LOG" || return 1
}

test_repo_filter_target_detection() {
    setup_env
    trap cleanup_env RETURN

    make_pkg_file "$DOTFILES_PUBLIC" "mix" ".config/mix/config"
    make_pkg_file "$DOTFILES_PRIVATE" "mix" "etc/mix/config"

    run_dots "" -n -y mix
    [[ "$RUN_STATUS" -ne 0 ]] || return 1
    assert_contains "$RUN_OUTPUT" "mixed targets" || return 1

    run_dots "" -n -y -p mix
    assert_eq "$RUN_STATUS" "0" || return 1
}

test_conflict_resolution_unfold() {
    setup_env
    trap cleanup_env RETURN

    make_pkg_file "$DOTFILES_PUBLIC" "conflict" ".config/app/pub.txt"
    make_pkg_file "$DOTFILES_PRIVATE" "conflict" ".config/app/priv.txt"

    run_dots "" -y conflict
    assert_eq "$RUN_STATUS" "0" || return 1

    local target_dir="$HOME/.config/app"
    assert_is_dir "$target_dir" || return 1

    assert_symlink_target "$target_dir/pub.txt" "$DOTFILES_PUBLIC/conflict/.config/app/pub.txt" || return 1
    assert_symlink_target "$target_dir/priv.txt" "$DOTFILES_PRIVATE/conflict/.config/app/priv.txt" || return 1
}

# Run all tests
run_test "preview confirm default" test_preview_confirm_default
run_test "quiet still confirms" test_quiet_still_confirms
run_test "dry-run no execution" test_dry_run_no_execution
run_test "dependency resolution label" test_dependency_resolution_and_label
run_test "multi-level dependency chain" test_multi_level_dependency_chain
run_test "multiple dependencies" test_multiple_dependencies
run_test "no-hooks skips deps" test_no_hooks_skips_deps
run_test "sync permissive warning" test_sync_permissive_missing_dep_warning
run_test "repo filter target detection" test_repo_filter_target_detection
run_test "conflict resolution unfold" test_conflict_resolution_unfold

echo
printf "Passed: %d, Failed: %d\n" "$TESTS_PASSED" "$TESTS_FAILED"

if [[ "$TESTS_FAILED" -ne 0 ]]; then
    exit 1
fi
