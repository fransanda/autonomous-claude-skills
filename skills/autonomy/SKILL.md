---
name: autonomy
description: "Add autonomous development to an existing project. Scans the codebase, checks required tooling (CLI/API/MCP), creates a private GitHub repo if needed, adds autonomous rules to CLAUDE.md, generates BACKLOG.md and PROGRESS.md, then starts working continuously. Use with: /autonomy"
allowed-tools: Read, Write, Edit, Bash, Glob, Grep
---

You are adding autonomous development capabilities to an EXISTING project.

## Step 1: Analyze the project

Read the entire codebase structure. If a CLAUDE.md already exists, read it.
Understand: the tech stack, architecture, current state, what's built, what's missing.

## Step 2: Tooling audit

Based on the codebase analysis, determine EVERY tool, service, and integration needed to continue developing this project.

Silently run checks to detect what's installed:
- `git --version`, `node --version`, `npm --version`, `gh --version`, `python --version`, `docker --version`
- Check package managers, build tools, and test runners used in the project
- Check for required API keys or credentials referenced in the code (look in .env, .env.example, config files, environment variable references)
- Check if any MCP servers could help (Playwright, Google APIs, databases, etc.)
- Check if a git remote exists: `git remote -v`

**ONLY show tools that are MISSING or need user action.** Do NOT list tools that are already installed and working — the user doesn't need to know about those.

If there are missing tools, credentials, or no GitHub repo, present this to the user:

```
📦 TOOLING AUDIT — Before I start, you need to set up:

MISSING (required to continue development):
  ❌ [tool] — not installed. Run: [exact install command]

CREDENTIALS NEEDED:
  🔑 [service] — .env references [VAR_NAME] but no value found. Do you have this?

GITHUB:
  ❌ No remote repo found. I'll create a private GitHub repo for this project.
     (or skip this line entirely if remote already exists)

MCP SERVERS (optional, would help):
  🔌 [server] — available for [task]. Want me to use it?

Should I install the missing tools and create the GitHub repo? Provide any credentials you have.
After this, I won't ask anything else — I'll start building.
```

If EVERYTHING is already set up (all tools installed, credentials present, remote exists), skip the tooling report entirely and go straight to Step 4. Only bother the user if something needs their action.

Wait for the user to respond if you showed a tooling report.

**CRITICAL:** This is the ONLY question you ask. After the user responds, never ask anything again.

## Step 3: Install approved tools & create GitHub repo

For each tool the user approved:
- Run the install command
- Verify it installed
- If installation fails, note it in PROGRESS.md and continue

Create a private GitHub repo if one doesn't already exist as the remote:

```bash
REPO_NAME=$(basename "$PWD")
REMOTE=$(git remote get-url origin 2>/dev/null || true)

if [ -z "$REMOTE" ]; then
    if command -v gh >/dev/null 2>&1; then
        GH_USER=$(gh api user -q .login 2>/dev/null || true)
        if [ -n "$GH_USER" ]; then
            # Make sure there is at least one commit before pushing
            if ! git rev-parse HEAD >/dev/null 2>&1; then
                git add -A && git commit -m "chore: initial commit" --allow-empty
            fi
            git branch -M main 2>/dev/null || true
            
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
fi
```

Replace `PROJECT_DESCRIPTION_HERE` with a real one-line description from the codebase analysis.

If gh isn't installed or authenticated, note it in PROGRESS.md under "Blocked".

Also verify the .gitignore includes `.env`, `*.key`, `*.pem`, `credentials.json`, and other secret-bearing files. Add them if missing.

## Step 4: Update or create CLAUDE.md

If CLAUDE.md exists, PREPEND the autonomous rules block to the very top (keep everything else intact). If it doesn't exist, create one with both the rules and a project description based on your codebase analysis.

Prepend this EXACTLY at the top of the file:

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

Also add a **Tooling** section to CLAUDE.md listing all available tools, CLIs, MCP servers, and credentials so future sessions know what's available.

## Step 5: Generate BACKLOG.md

Scan the entire codebase and create BACKLOG.md with checkboxed tasks organized by priority:
- P1 (critical): Bugs, broken functionality, blocking issues, security holes
- P2 (important): Missing features based on CLAUDE.md goals vs what's built
- P3 (nice-to-have): Test coverage gaps, code quality, refactoring
- P4 (improvements): Dependency updates, performance, documentation
- Ongoing: Always-do items (fix bugs found while working, increase coverage, clean up)

Each task must be specific and actionable with file references where possible. During the codebase scan, flag any violations of the Security Defaults (hardcoded secrets, missing auth, SQL concatenation, etc.) as P1 items.

## Step 6: Create PROGRESS.md

```markdown
# Progress Log

## Current State
- Status: EXISTING PROJECT — autonomous mode activated
- Current branch: [detect current git branch]

## Blocked (needs human)
- (list any missing credentials or tools that couldn't be installed)

## Completed Tasks

## Session Notes
- Autonomous mode activated on existing codebase
- Starting from BACKLOG.md Priority 1
```

## Step 7: Commit and push

```bash
git add CLAUDE.md BACKLOG.md PROGRESS.md .gitignore
git commit -m "chore: add autonomous development workflow files"
git push 2>/dev/null || true
```

## Step 8: Start building

Say ONLY: "✅ Autonomous mode activated. Starting work on the first backlog item."

Then immediately read CLAUDE.md, read BACKLOG.md, and start working through tasks continuously. Do not ask any questions. Do not present plans. Just build.

**Push to GitHub periodically.** After every 3-5 commits, run `git push`. Do not ask before pushing.
