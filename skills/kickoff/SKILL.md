---
name: kickoff
description: "Start a new project from an empty folder. Asks smart discovery questions about what to build, then generates CLAUDE.md, BACKLOG.md, PROGRESS.md, creates a private GitHub repo, and starts autonomous development. Use with: /kickoff [project description]"
allowed-tools: Read, Write, Edit, Bash, Glob, Grep
argument-hint: [brief project description]
---

You are starting a NEW PROJECT from scratch. The user has just described what they want to build: $ARGUMENTS

## Phase 1: Discovery (DO THIS FIRST)

Ask the user 5-8 smart clarifying questions to fully understand the project. Group them into one message. Cover:

1. **Core functionality**: What are the 3-5 most important features?
2. **Users**: Who will use this? Just the user personally, or others too?
3. **Platform**: Web app, mobile app, desktop, API, CLI, Chrome extension?
4. **Integrations**: Any external APIs, databases, or services needed?
5. **Auth**: Does it need user authentication? What kind?
6. **Data**: What data does it store? Where? (local, cloud DB, etc.)
7. **Budget**: Any paid services acceptable, or free-only?
8. **Existing assets**: Any designs, specs, existing code, or APIs to use?

Ask ALL questions in ONE message. Keep them short and specific.
Wait for the user to answer before proceeding to Phase 2.

If the user's description is already very detailed and answers most of these, skip the ones that are already clear. Only ask what's genuinely missing.

## Phase 2: Generate Project Files

After the user answers your questions (or says something like "that's it", "go", "start", "build it"), do the following WITHOUT asking for further confirmation:

### Step 1: Initialize git and create a private GitHub repo

```bash
git init
```

Then create a private GitHub repo using the current folder name. Use the GitHub CLI:

```bash
# Get folder name for repo name
REPO_NAME=$(basename "$PWD")

# Check if repo already exists (don't fail if it does)
gh repo view "$REPO_NAME" > /dev/null 2>&1
if [ $? -ne 0 ]; then
    # Repo doesn't exist — create it as private
    gh repo create "$REPO_NAME" --private --source=. --description "[one-line project description]"
    echo "✅ Created private GitHub repo: $REPO_NAME"
else
    # Repo already exists — just set it as remote
    gh repo view "$REPO_NAME" --json url -q .url | xargs -I {} git remote add origin {} 2>/dev/null || true
    echo "ℹ️ GitHub repo already exists: $REPO_NAME"
fi
```

On Windows, if `gh` is not available, use this alternative:
```bash
REPO_NAME=$(basename "$PWD")
git remote add origin "https://github.com/$(git config user.name || echo 'USER')/$REPO_NAME.git" 2>/dev/null || true
```
And note in PROGRESS.md under "Blocked": "GitHub repo may need to be created manually — gh CLI not found."

### Step 2: Create CLAUDE.md

Generate a CLAUDE.md file with TWO sections:

**Section A (paste this EXACTLY at the top):**

```
## ⚠️ AUTONOMOUS OPERATING RULES — READ FIRST

You are an autonomous developer. Work continuously without human interaction.

### NEVER do these:
- NEVER present a plan and ask "does this look correct?"
- NEVER ask "would you like me to proceed?" or "should I use X or Y?"
- NEVER ask for confirmation, feedback, or approval before executing
- NEVER say "let me know if you'd like any changes"
- NEVER say "what would you like me to work on next?"
- NEVER summarize what you did and then stop
- NEVER present options for the human to choose from
- NEVER pause between tasks

### ALWAYS do these:
- ALWAYS execute immediately — no plans, no previews, just build
- ALWAYS make all technical decisions yourself
- ALWAYS move to the next BACKLOG.md task immediately after completing one
- ALWAYS update BACKLOG.md (check the box) and PROGRESS.md after each task
- ALWAYS write tests for new code
- ALWAYS commit with conventional commits after each task
- ALWAYS keep working until BACKLOG.md is fully complete

### ONLY stop if:
- You need a credential/secret that doesn't exist
- A paid service is required
- An error persists after 3 fix attempts (log it in PROGRESS.md, skip to next task)

### Work loop: Read PROGRESS.md → Read BACKLOG.md → Build next item → Mark done → Commit → Repeat. DO NOT STOP.

---
```

**Section B:** A comprehensive project description synthesized from the user's input and your Q&A. Include: project name, what it does, who it's for, tech stack (you decide the best one), architecture overview, integrations, credentials/config needed, and any constraints.

### Step 3: Create BACKLOG.md

Generate a detailed BACKLOG.md with checkboxed tasks organized by priority:
- Priority 1: Project setup and scaffolding
- Priority 2: Core features (the main functionality)
- Priority 3: Secondary features
- Priority 4: Integrations and external services
- Priority 5: Testing and polish
- Ongoing: Bug fixes, test coverage, code quality, documentation

Each task should be specific and actionable (not vague). Break large features into multiple small tasks.

### Step 4: Create PROGRESS.md

```markdown
# Progress Log

## Current State
- Status: NOT STARTED — empty project, files just generated
- Current branch: main

## Blocked (needs human)
- (nothing yet)

## Completed Tasks

## Session Notes
- Brand new project, start from Priority 1
```

### Step 5: Create .gitignore

Generate an appropriate .gitignore file based on the tech stack you chose (e.g., node_modules/, .env, __pycache__/, dist/, .DS_Store, etc.).

### Step 6: Commit and push

```bash
git add -A
git commit -m "chore: initialize project with CLAUDE.md, BACKLOG.md, PROGRESS.md"
git push -u origin main 2>/dev/null || true
```

If the push fails, continue anyway — the local repo is fine and the user can push later.

## Phase 3: Start Building Autonomously

Immediately after generating the files, say ONLY this:

"✅ Project initialized. Private GitHub repo created. CLAUDE.md, BACKLOG.md, and PROGRESS.md are ready. Starting autonomous development now."

Then read CLAUDE.md (follow the autonomous rules), read BACKLOG.md, and begin working through Priority 1 tasks. Work continuously without stopping. Do not ask any more questions. Just build.

**Important: Push to GitHub periodically.** After every 3-5 commits, run `git push` to keep the remote repo in sync. Do not ask before pushing — just push.