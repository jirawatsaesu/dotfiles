#!/bin/bash
set -e

echo "🟡 installing node lts via fnm."
fnm install --lts
# fnm install alone does not put node/npx on PATH for this process — activate explicitly
eval "$(fnm env)"
fnm use --install-if-missing lts-latest
echo "✅ node installed!"
