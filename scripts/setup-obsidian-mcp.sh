#!/usr/bin/env bash
# Install Obsidian Local REST API + MCP Tools into the digi-twin vault.
# Run from repo root: ./scripts/setup-obsidian-mcp.sh

set -euo pipefail

VAULT_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
PLUGINS_DIR="$VAULT_ROOT/.obsidian/plugins"
MCP_TOOLS_VERSION="0.2.33"
REST_API_VERSION="4.0.2"

mkdir -p "$PLUGINS_DIR/obsidian-local-rest-api" "$PLUGINS_DIR/mcp-tools/bin"

arch="$(uname -m)"
case "$arch" in
  arm64) MCP_SERVER_ASSET="mcp-server-macos-arm64" ;;
  x86_64) MCP_SERVER_ASSET="mcp-server-macos-x64" ;;
  *)
    echo "Unsupported architecture: $arch" >&2
    exit 1
    ;;
esac

download() {
  local url="$1" dest="$2"
  echo "Downloading $(basename "$dest")..."
  curl -fsSL "$url" -o "$dest"
}

REST_BASE="https://github.com/coddingtonbear/obsidian-local-rest-api/releases/download/${REST_API_VERSION}"
download "$REST_BASE/main.js" "$PLUGINS_DIR/obsidian-local-rest-api/main.js"
download "$REST_BASE/manifest.json" "$PLUGINS_DIR/obsidian-local-rest-api/manifest.json"
download "$REST_BASE/styles.css" "$PLUGINS_DIR/obsidian-local-rest-api/styles.css"

MCP_BASE="https://github.com/jacksteamdev/obsidian-mcp-tools/releases/download/${MCP_TOOLS_VERSION}"
download "$MCP_BASE/main.js" "$PLUGINS_DIR/mcp-tools/main.js"
download "$MCP_BASE/manifest.json" "$PLUGINS_DIR/mcp-tools/manifest.json"
download "$MCP_BASE/${MCP_SERVER_ASSET}" "$PLUGINS_DIR/mcp-tools/bin/mcp-server"
chmod +x "$PLUGINS_DIR/mcp-tools/bin/mcp-server"

# Enable plugins in Obsidian
mkdir -p "$VAULT_ROOT/.obsidian"
if [[ -f "$VAULT_ROOT/.obsidian/community-plugins.json" ]]; then
  python3 - <<'PY' "$VAULT_ROOT/.obsidian/community-plugins.json"
import json, sys
path = sys.argv[1]
with open(path) as f:
    data = json.load(f)
for plugin in ("obsidian-local-rest-api", "mcp-tools"):
    if plugin not in data:
        data.append(plugin)
with open(path, "w") as f:
    json.dump(data, f, indent=2)
    f.write("\n")
PY
else
  printf '%s\n' '["obsidian-local-rest-api","mcp-tools"]' > "$VAULT_ROOT/.obsidian/community-plugins.json"
fi

if [[ ! -f "$VAULT_ROOT/.obsidian/plugins.json" ]]; then
  printf '%s\n' '{"obsidian-local-rest-api":true,"mcp-tools":true}' > "$VAULT_ROOT/.obsidian/plugins.json"
else
  python3 - <<'PY' "$VAULT_ROOT/.obsidian/plugins.json"
import json, sys
path = sys.argv[1]
with open(path) as f:
    data = json.load(f)
data["obsidian-local-rest-api"] = True
data["mcp-tools"] = True
with open(path, "w") as f:
    json.dump(data, f, indent=2)
    f.write("\n")
PY
fi

echo ""
echo "Installed plugins into $PLUGINS_DIR"
echo "MCP server binary: $PLUGINS_DIR/mcp-tools/bin/mcp-server"
echo ""
echo "Next steps:"
echo "  1. Open Obsidian → digi-twin vault"
echo "  2. Settings → Community plugins → enable Local REST API and MCP Tools"
echo "  3. Local REST API → copy API key into ~/.cursor/mcp.json (see .cursor/mcp.json.example)"
echo "  4. Restart MCP in Cursor Settings"
echo "  5. Keep digi-twin open in Obsidian while coding in other repos"
