#!/usr/bin/env bash
# Get the research plugin installation directory
# Usage: get-plugin-dir.sh
# Output: Prints the absolute path to the plugin directory on stdout

set -e

PLUGINS_CACHE="$HOME/.claude/plugins/cache"

if [ ! -d "$PLUGINS_CACHE" ]; then
    echo "ERROR: Claude plugins cache not found" >&2
    exit 1
fi

# Find the res plugin skills directory and get its parent
SKILLS_DIR=$(find "$PLUGINS_CACHE" -type d -path "*/res/*/skills" 2>/dev/null | head -1)

if [ -z "$SKILLS_DIR" ]; then
    echo "ERROR: Research plugin not found" >&2
    exit 1
fi

# Output plugin dir (parent of skills)
echo "${SKILLS_DIR%/skills}"
