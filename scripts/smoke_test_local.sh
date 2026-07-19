#!/usr/bin/env bash
# Runs the same steps as ci.yml's `smoke` job, locally, in an isolated XDG
# environment (a checkout-relative dir, not your real ~/.config/nvim) so
# it's safe to run repeatedly while iterating without pushing.
#
# Usage:
#   scripts/smoke_test_local.sh          # reuse the local plugin cache
#   scripts/smoke_test_local.sh --clean  # wipe it first (mirrors a cold CI run)
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
xdg_root="$repo_root/.ci-xdg"
cd "$repo_root"

if [[ "${1:-}" == "--clean" ]]; then
  rm -rf "$xdg_root"
fi

mkdir -p "$xdg_root/config" "$xdg_root/data" "$xdg_root/state" "$xdg_root/cache"
ln -sfn "$repo_root" "$xdg_root/config/nvim"

export XDG_CONFIG_HOME="$xdg_root/config"
export XDG_DATA_HOME="$xdg_root/data"
export XDG_STATE_HOME="$xdg_root/state"
export XDG_CACHE_HOME="$xdg_root/cache"

echo "==> Installing plugins from lazy-lock.json"
nvim --headless -c "Lazy! restore" -c "qa"

echo "==> Running smoke test"
nvim --headless -c "luafile scripts/smoke_test.lua"
