#!/usr/bin/env bash
# Install the Claude Code status line on this machine.
# Copies claude-statusline.sh to ~/.claude/ and wires it into ~/.claude/settings.json.
# Usage: bash scripts/setup-claude-statusline.sh

set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_DIR="$HOME/.claude"
SETTINGS="$CLAUDE_DIR/settings.json"

command -v jq > /dev/null 2>&1 || { echo "jq is required (brew install jq)"; exit 1; }

mkdir -p "$CLAUDE_DIR"
cp "$REPO_DIR/claude-statusline.sh" "$CLAUDE_DIR/statusline.sh"
echo "Installed $CLAUDE_DIR/statusline.sh"

# Merge statusLine into settings.json, preserving existing settings
if [ -f "$SETTINGS" ]; then
  cp "$SETTINGS" "$SETTINGS.bak"
  echo "Backed up settings to $SETTINGS.bak"
else
  echo '{}' > "$SETTINGS"
fi

tmp=$(mktemp)
jq '.statusLine = {"type": "command", "command": ("bash " + env.HOME + "/.claude/statusline.sh")}' \
  "$SETTINGS" > "$tmp" && mv "$tmp" "$SETTINGS"

echo "Wired statusLine into $SETTINGS"
echo "Done — restart Claude Code (or start a new session) to see it."
