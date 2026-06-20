#!/bin/bash
set -e

echo "[*] installing python (latest stable) via uv."
# pre-installs latest CPython so the first `uv run` is fast; use `uv run` / `uv venv` per project
uv python install
echo "[ok] python installed!"
