#!/bin/bash
# install.sh — Install autonomous Claude Code skills
# Or:  ./install.sh (after cloning)

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

echo ""
echo "Installing autonomous Claude Code skills..."
echo ""

# Install to BOTH possible skill directories (Claude Code reads from one or the other)
for SKILLS_DIR in "$HOME/.claude/skills" "$HOME/.agents/skills"; do
    for skill in kickoff autonomy ship; do
        mkdir -p "$SKILLS_DIR/$skill"
        if [ -f "$SCRIPT_DIR/skills/$skill/SKILL.md" ]; then
            cp "$SCRIPT_DIR/skills/$skill/SKILL.md" "$SKILLS_DIR/$skill/SKILL.md"
        fi
    done
done

echo "  ✅ Installed /kickoff"
echo "  ✅ Installed /autonomy"
echo "  ✅ Installed /ship"
echo ""
echo "Done! Restart Claude Code, then use:"
echo "  /kickoff [description]  — start a new project"
echo "  /autonomy               — add autonomy to existing project"
echo "  /ship                    — wrap up and prepare for testing"
echo ""
