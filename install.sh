#!/bin/bash
# install.sh — Install autonomous Claude Code skills
# Run: curl -fsSL https://raw.githubusercontent.com/fransanda/autonomous-claude-skills/main/install.sh | bash
# Or:  ./install.sh (after cloning)

SKILLS_DIR="$HOME/.claude/skills"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo ""
echo "Installing autonomous Claude Code skills..."
echo ""

for skill in kickoff autonomy ship; do
    mkdir -p "$SKILLS_DIR/$skill"
    if [ -f "$SCRIPT_DIR/skills/$skill/SKILL.md" ]; then
        cp "$SCRIPT_DIR/skills/$skill/SKILL.md" "$SKILLS_DIR/$skill/SKILL.md"
        echo "  ✅ Installed /$skill"
    else
        echo "  ⚠️  Skipped /$skill (source not found)"
    fi
done

echo ""
echo "Done! Restart Claude Code, then use:"
echo "  /kickoff [description]  — start a new project"
echo "  /autonomy               — add autonomy to existing project"
echo "  /ship                    — wrap up and prepare for testing"
echo ""
