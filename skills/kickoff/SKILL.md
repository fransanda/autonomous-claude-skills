---
name: kickoff
description: "Start a new project from an empty folder. Asks comprehensive discovery questions (up to 20), checks required tooling (CLI/API/MCP), generates CLAUDE.md, BACKLOG.md, PROGRESS.md, creates a private GitHub repo, and starts fully autonomous development. Use with: /kickoff [project description]"
allowed-tools: Read, Write, Edit, Bash, Glob, Grep
argument-hint: [brief project description]
---

You are starting a NEW PROJECT from scratch. The user has just described what they want to build: $ARGUMENTS

## Phase 1: Comprehensive Discovery (THIS IS YOUR ONLY CHANCE TO ASK QUESTIONS)

This is the ONLY time you are allowed to ask the user anything. After this phase, you will NEVER ask another question — you will make all decisions autonomously. So be thorough now.

### Part A: Project Questions

Ask up to 20 questions in ONE message to fully understand the project. Cover ALL of these categories. Skip questions only if the user's description already clearly answers them:

**Core Product:**
1. What are the 3-5 most important features? What should the MVP include?
2. Who will use this? (personal use, public users, specific audience?)
3. What problem does this solve? What's the main user workflow?

**Platform & Access:**
4. What platform? (web app, mobile app, desktop, browser extension, API, CLI?)
5. Does it need to work offline?
6. Does it need to be responsive / mobile-friendly?
7. Any specific device or browser requirements?

**Users & Auth:**
8. Does it need user accounts / authentication? What kind? (email, Google, SSO?)
9. Are there different user roles? (admin, regular user, viewer?)
10. Is there user-generated content? What kind?

**Data & Backend:**
11. What data does it store? Describe the main entities.
12. Where should data live? (local only, cloud database, API-backed?)
13. Does it need real-time features? (live updates, chat, notifications?)
14. Any specific data privacy requirements? (GDPR, encryption, etc.)

**Integrations & APIs:**
15. Any external APIs or services needed? (payments, maps, email, AI, etc.)
16. Does it need to connect to any existing tools? (Google, Slack, etc.)
17. Any credentials or API keys you already have that I should use?

**Design & UX:**
18. Any design preferences? (dark mode, minimal, colorful, specific brand?)
19. Any existing designs, mockups, Figma files, or screenshots?
20. Any reference apps or websites that feel like what you want?

**Constraints:**
21. Budget for services? (free-only, or some paid APIs acceptable?)
22. Any hard deadlines or priority features that need to ship first?
23. Anything that should explicitly NOT be included?

### Part B: Tooling Requirements

Based on the project description, think about EVERY tool, service, and integration you will need to build this project. For each one, determine if there is a CLI, API, or MCP server available.

Before presenting questions, silently run checks to detect what's installed:
- `git --version`, `node --version`, `npm --version`, `gh --version`, `python --version`, `docker --version`
- And any other tools relevant to the project description

**ONLY show tools that are MISSING or need user action.** Do NOT list tools that are already installed — the user doesn't need to know about those. Only bother the user with things that require their action.

After your project questions, add a **Tooling section** in the SAME message. Only include this section if there ARE missing tools or credentials needed. If everything is installed, skip this section entirely.

```
📦 TOOLING — Before I start, you need to set up:

MISSING (required to build this project):
  ❌ [tool] — not installed. Run: [exact install command]

CREDENTIALS NEEDED:
  🔑 [service] — I need [specific key/token]. Do you have one?

MCP SERVERS (optional, would help):
  🔌 [server] — available for [task]. Want me to use it?

Should I install the missing tools? Provide any credentials you have.
```

If ALL tools are installed and no credentials are needed, do NOT show a tooling section at all — just ask the project questions.

Present everything in ONE single message. The user answers all at once.
Wait for the user to answer before proceeding.

**CRITICAL RULE:** After the user answers, DO NOT ask follow-up questions. DO NOT ask for clarification. If the user confirmed a tool should be installed, just install it silently in Phase 2. If anything is unclear, make your best judgment and note assumptions in CLAUDE.md. This is your ONE AND ONLY opportunity to ask questions.

## Phase 2: Setup Tooling & Generate Project Files

After the user answers, do the following WITHOUT asking for further confirmation:

### Step 0: Install and configure any missing tools the user approved

For each tool the user confirmed should be installed:
- Run the install command
- Verify it installed correctly
- Run any necessary auth/login steps if possible
- If installation fails, note it in PROGRESS.md under "Blocked" and continue

Do NOT ask for confirmation — the user already approved in Phase 1.

### Step 1: Initialize git

```bash
git init
```

The GitHub repo will be created in Step 6 after the initial commit exists — this avoids issues with empty repos and branch name mismatches.

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

### 🔒 SECURITY DEFAULTS
- Private repo always (unless told otherwise)
- Every endpoint/script requires auth (unless explicitly marked public)
- Secrets in env vars only — never hardcode, never commit
- .env, *.key, *.pem in .gitignore before first commit
- Parameterized queries only — no string-concat SQL
- Validate/sanitize all user input server-side
- Hash passwords (bcrypt/argon2), never log secrets or PII
- HTTPS only in production, CORS restricted to known origins
- Least-privilege by default — users access only their own data

---
```

**Section B:** A comprehensive project description synthesized from the user's input and Q&A. Include:
- Project name, what it does, who it's for
- Full tech stack (you decide the best one based on the answers)
- Architecture overview and data model
- All integrations, credentials, and config
- Available tooling and MCP servers
- Design direction and UX decisions
- Constraints, budget, and scope boundaries
- Any assumptions you made where answers were unclear

### Step 3: Create BACKLOG.md

Generate a detailed BACKLOG.md with checkboxed tasks organized by priority:
- Priority 1: Project setup and scaffolding
- Priority 2: Core features (the main functionality / MVP)
- Priority 3: Secondary features
- Priority 4: Integrations and external services
- Priority 5: Testing and polish
- Priority 6: Documentation, deployment, and launch prep
- Ongoing: Bug fixes, test coverage, code quality, dependency updates

Aim for 30-60 specific, actionable tasks.

### Step 4: Create PROGRESS.md

```markdown
# Progress Log

## Current State
- Status: NOT STARTED — empty project, files just generated
- Current branch: main

## Blocked (needs human)
- (list any tools that failed to install or credentials still needed)

## Completed Tasks

## Session Notes
- Brand new project, start from Priority 1
```

### Step 5: Create .gitignore

Generate an appropriate .gitignore file based on the tech stack. ALWAYS include these regardless of stack (security-critical):
```
.env
.env.*
!.env.example
*.key
*.pem
*.crt
credentials.json
secrets.json
.DS_Store
```
Plus the usual stack-specific entries (`node_modules/`, `__pycache__/`, `dist/`, `build/`, `.next/`, etc.).

### Step 6: Initial commit and create private GitHub repo

Commit the setup files first (this gives us a commit and a `main` branch to push):

```bash
git add -A
git commit -m "chore: initialize project with CLAUDE.md, BACKLOG.md, PROGRESS.md"
git branch -M main
```

Now create the private GitHub repo. Use a robust check that handles missing gh, unauthenticated gh, and existing repos correctly:

```bash
REPO_NAME=$(basename "$PWD")

if command -v gh >/dev/null 2>&1; then
    GH_USER=$(gh api user -q .login 2>/dev/null || true)
    if [ -n "$GH_USER" ]; then
        if gh repo view "$GH_USER/$REPO_NAME" >/dev/null 2>&1; then
            echo "ℹ️  Repo $GH_USER/$REPO_NAME already exists — adding as remote"
            REPO_URL=$(gh repo view "$GH_USER/$REPO_NAME" --json url -q .url)
            git remote add origin "$REPO_URL" 2>/dev/null || git remote set-url origin "$REPO_URL"
            git push -u origin main 2>/dev/null || true
        else
            gh repo create "$REPO_NAME" --private --source=. --push --description "PROJECT_DESCRIPTION_HERE"
            echo "✅ Created and pushed to private GitHub repo: $GH_USER/$REPO_NAME"
        fi
    else
        echo "⚠️  gh is installed but not authenticated. Run: gh auth login"
        echo "   Skipping GitHub repo creation — local commits will still work"
    fi
else
    echo "⚠️  GitHub CLI (gh) not found. Skipping repo creation."
    echo "   Install: winget install GitHub.cli (Windows) or brew install gh (Mac/Linux)"
fi
```

Replace `PROJECT_DESCRIPTION_HERE` with a real one-line description of the project.

If gh isn't installed or authenticated, note it in PROGRESS.md under "Blocked" so the user sees it.

## Phase 3: Start Building Autonomously

Say ONLY: "✅ Project initialized. Starting autonomous development now."

Then read CLAUDE.md, read BACKLOG.md, and begin working through Priority 1 tasks continuously. No more questions. Just build.

**Push to GitHub periodically.** After every 3-5 commits, run `git push`. Do not ask before pushing.
