#!/bin/bash
# install.sh — Install autonomous Claude Code skills
# Remote install: curl -fsSL https://raw.githubusercontent.com/fransanda/autonomous-claude-skills/main/install.sh | bash
# Local install:  ./install.sh (from inside a cloned repo)

set -e

# Determine source: use the script's folder if it contains the skills,
# otherwise clone to a temp folder (needed for curl | bash install).
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]:-$0}")" 2>/dev/null && pwd || true)"
TEMP_CLONE=""

if [ -n "$SCRIPT_DIR" ] && [ -f "$SCRIPT_DIR/skills/kickoff/SKILL.md" ]; then
    SOURCE_ROOT="$SCRIPT_DIR"
else
    if ! command -v git >/dev/null 2>&1; then
        echo "Error: git is required to install. Install git first."
        exit 1
    fi
    TEMP_CLONE="$(mktemp -d)/autonomous-claude-skills"
    echo "Fetching skills..."
    git clone --depth=1 --quiet https://github.com/fransanda/autonomous-claude-skills.git "$TEMP_CLONE"
    SOURCE_ROOT="$TEMP_CLONE"
fi

echo ""
echo "Installing autonomous Claude Code skills..."
echo ""

INSTALLED=0
for skill in kickoff autonomy ship; do
    SRC="$SOURCE_ROOT/skills/$skill/SKILL.md"
    if [ ! -f "$SRC" ]; then
        echo "  ⚠️  Source not found for /$skill — skipping"
        continue
    fi
    for d in "$HOME/.claude/skills" "$HOME/.agents/skills"; do
        mkdir -p "$d/$skill"
        cp "$SRC" "$d/$skill/SKILL.md"
    done
    echo "  ✅ Installed /$skill"
    INSTALLED=$((INSTALLED+1))
done

if [ -n "$TEMP_CLONE" ] && [ -d "$TEMP_CLONE" ]; then
    rm -rf "$(dirname "$TEMP_CLONE")"
fi

echo ""
if [ $INSTALLED -eq 3 ]; then
    echo "Done! Restart Claude Code, then use:"
    echo "  /kickoff [description]  — start a new project"
    echo "  /autonomy               — add autonomy to existing project"
    echo "  /ship                   — wrap up and prepare for testing"
    echo ""
    echo "Also make sure GitHub CLI is installed:"
    echo "  brew install gh   # Mac"
    echo "  gh auth login"
    echo ""
else
    echo "⚠️  Installation incomplete: $INSTALLED of 3 skills installed"
    echo ""
fi
