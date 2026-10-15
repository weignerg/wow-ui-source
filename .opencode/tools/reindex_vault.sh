#!/usr/bin/env bash
# ==============================================================================
# .opencode/tools/reindex_vault.sh  (portable, repo-local)
# ColBERTv2 semantic memory vault reindexer for wow-ui-source.
# Runs strictly on host CPU with zero VRAM allocation.
#
# Usage:
#   reindex_vault.sh [vaultPath] [--all]
#
#   - No arguments (or --all): reindex the repo-local vault at
#     <repo>/.opencode/vault, where <repo> = $(git rev-parse --show-toplevel).
#   - vaultPath given: reindex that specific vault directory instead.
#
# Environment overrides (for portability across machines):
#   VAULT_PATH   full path to the vault to reindex (overrides auto-detection).
#   ENGINE_REPO  path to the host repo that contains the ColBERT engine
#                (harness/memory/colbert_engine.py). Override for portability;
#                if unset the script auto-detects it by scanning upward from
#                this script. If neither a set ENGINE_REPO nor a parent dir
#                with the engine module is found, the script errors out
#                (reference .opencode/DEPENDENCIES.md).
# ==============================================================================
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# --- Resolve the repository root ------------------------------------------------
# Repo = the git top-level working tree. Inside a worktree this is that
# worktree's root, which is exactly where this repo-local .opencode/ tree lives,
# so <repo>/.opencode/vault is the correct vault location here.
REPO_ROOT="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"

# --- Resolve the ColBERT engine -------------------------------------------------
# ENGINE_REPO overrides the auto-detection for portability. If unset, scan
# upward from this script looking for the engine module. If neither a set
# ENGINE_REPO nor a parent dir containing the engine module is found, ENGINE_DIR
# is left empty and the script errors out (it is a hard external dependency;
# see .opencode/DEPENDENCIES.md). No host-specific path is hard-coded.
ENGINE_DIR="${ENGINE_REPO:-}"
if [ -z "$ENGINE_DIR" ]; then
    dir="$SCRIPT_DIR"
    while [ "$dir" != "/" ] && [ ! -f "${dir}/harness/memory/colbert_engine.py" ]; do
        parent="$(cd "${dir}/.." 2>/dev/null && pwd || echo "${dir}/..")"
        if [ "$parent" = "$dir" ]; then
            break
        fi
        dir="$parent"
    done
    if [ -f "${dir}/harness/memory/colbert_engine.py" ]; then
        ENGINE_DIR="$dir"
    else
        ENGINE_DIR=""
        echo "ERROR: ColBERT engine not found (no harness/memory/colbert_engine.py)." >&2
        echo "       Set ENGINE_REPO=<path-to-open-code-harness> or install the engine." >&2
        echo "       (see .opencode/DEPENDENCIES.md)" >&2
        exit 1
    fi
fi

# --- Pick a Python interpreter --------------------------------------------------
STACK_DIR="${USER_HOME:-${HOME}}/.local/share/opencode-sglang-stack"
TARGET_PY="${STACK_DIR}/venv/bin/python"
if [ ! -f "$TARGET_PY" ]; then
    TARGET_PY="python3"
fi

# --- Reindex a single location --------------------------------------------------
reindex_location() {
    loc="${1%/}"
    if [ ! -d "$loc" ]; then
        echo "  - skipping missing location: ${loc}" >&2
        return 0
    fi

    # Skip a location that carries no documents so a stale .index dir does not
    # masquerade as a valid, indexed vault. This uses a portable *.md search;
    # the Python side below skips any hidden/dot-prefixed files, so we do not
    # rely on the -path predicate here (it is not portable across busybox find).
    if [ -z "$(find "$loc" -type f -name '*.md' 2>/dev/null)" ]; then
        echo "  - skipping empty location: ${loc}"
        return 0
    fi

    PYTHONPATH="${ENGINE_DIR}" "$TARGET_PY" -c "
import time, sys
from pathlib import Path

try:
    from harness.memory.colbert_engine import CPUColBERTIndex
    v = Path('${loc}')
    t0 = time.time()
    idx = CPUColBERTIndex(index_dir=v / '.index')
    count = 0
    for md in v.rglob('*.md'):
        if not any(p.startswith('.') for p in md.relative_to(v).parts):
            try:
                rel = str(md.relative_to(v))
                idx.add_document(rel, md.read_text(errors='replace'))
                count += 1
            except Exception:
                pass
    idx.save()
    dt = time.time() - t0
    print(f'Successfully reindexed {count} documents in {dt:.2f}s -> ${loc}/.index/index.json')
except Exception as e:
    print(f'ColBERT reindexing error: {e}', file=sys.stderr)
    sys.exit(1)
"
}

# --- Argument handling (parse BEFORE resolving the vault) -----------------------
targets=()
for arg in "$@"; do
    case "$arg" in
        --all) continue ;;
        --help|-h)
            echo "Usage: $(basename "${BASH_SOURCE[0]}") [vaultPath] [--all]"
            echo "  vaultPath   reindex this specific vault directory"
            echo "  --all       reindex the repo-local vault (<repo>/.opencode/vault)"
            echo ""
            echo "Environment:"
            echo "  VAULT_PATH  override the vault path"
            echo "  ENGINE_REPO override the ColBERT engine host path"
            exit 0
            ;;
        *) targets+=("$arg") ;;
    esac
done

if [ "${#targets[@]}" -gt 0 ]; then
    # A positional vaultPath argument was provided (ignore any --all).
    for t in "${targets[@]}"; do
        reindex_location "$t"
    done
    exit 0
fi

# Default / --all: reindex the repo-local vault.
# VAULT_PATH overrides auto-detection; otherwise use <repo>/.opencode/vault.
if [ -n "${VAULT_PATH:-}" ]; then
    VAULT_PATH="${VAULT_PATH%/}"
else
    VAULT_PATH="${REPO_ROOT}/.opencode/vault"
fi
echo "== repo vault (${VAULT_PATH}) =="
reindex_location "${VAULT_PATH}"

echo "done"
