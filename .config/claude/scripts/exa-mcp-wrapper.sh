#!/bin/bash
# Wrapper for Exa MCP server
# Reads API key from secrets/ and sets EXA_API_KEY env var

set -euo pipefail

KEY_FILE="${HOME}/.config/claude/secrets/exa_token"

if [[ ! -f "$KEY_FILE" ]]; then
    echo "Error: API key file not found: $KEY_FILE" >&2
    echo "Get your key from dashboard.exa.ai/api-keys and save it there." >&2
    exit 1
fi

export EXA_API_KEY="$(cat "$KEY_FILE")"

exec npx -y exa-mcp-server tools=web_search_exa,crawling_exa "$@"
