# 🤖 Autonomous Claude Code Skills

**Three slash commands that turn Claude Code into a fully autonomous developer.**

Claude Code is powerful, but by default it stops after every task to ask "what next?" and pauses mid-work to ask "is this plan okay?" These skills eliminate both problems. Claude works continuously through a backlog, makes all technical decisions itself, and only stops when it genuinely needs human input (API keys, paid services, etc.).

> 💡 **Want a full QA team reviewing the code Claude writes?** Pair this with [autonomous-ai-itagents](https://github.com/fransanda/autonomous-ai-itagents) — a 9-agent review pipeline (security, bugs, performance, dependencies, tests, architecture) that runs every task before it ships. Auto-detected when both repos are installed.

---

## What You Get

| Command | Purpose | When to use |
|---|---|---|
| `/kickoff [description]` | Start a **new project** from an empty folder | You have an idea, no code yet |
| `/autonomy` | Add autonomous mode to an **existing project** | You have code, want Claude to keep building |
| `/ship` or `/ship [minutes]` | Wrap up, make sure it runs, prepare for testing | You want to test what Claude built |

Every new project kicked off with `/kickoff` or adopted via `/autonomy` automatically gets:
- A private GitHub repo (via `gh` CLI)
- `CLAUDE.md`, `BACKLOG.md`, `PROGRESS.md`, `LESSONS.md` setup
- A baked-in **🔒 Security Defaults** block (private by default, env vars for secrets, auth on every endpoint, parameterized queries, input validation, hashed passwords, HTTPS, least-privilege access) that Claude follows throughout development
- **`LESSONS.md` auto-improving memory** — Claude appends learnings, future sessions read them. Per-project, no extra cost.
- If [autonomous-ai-itagents](https://github.com/fransanda/autonomous-ai-itagents) is also installed → full multi-agent QA pipeline activates automatically

---

## Install

### Prerequisites
- [Claude Code](https://docs.anthropic.com/en/docs/claude-code/overview) installed and authenticated
- [GitHub CLI](https://cli.github.com/) (`gh`) installed and authenticated — needed for auto-creating repos
- Git installed
- A Claude Pro, Max, or API subscription

### Windows (PowerShell) — one-liner
```powershell
irm https://raw.githubusercontent.com/fransanda/autonomous-claude-skills/main/install.ps1 | iex
```

### Mac / Linux — one-liner
```bash
curl -fsSL https://raw.githubusercontent.com/fransanda/autonomous-claude-skills/main/install.sh | bash
```

Both installers automatically copy skills to **both** `~/.claude/skills/` and `~/.agents/skills/` — Claude Code reads from one or the other depending on your setup.

### Optional: also install the multi-agent QA pipeline

After installing this repo, optionally install the companion:

```bash
# Mac/Linux
curl -fsSL https://raw.githubusercontent.com/fransanda/autonomous-ai-itagents/main/install.sh | bash
```

```powershell
# Windows
irm https://raw.githubusercontent.com/fransanda/autonomous-ai-itagents/main/install.ps1 | iex
```

`/kickoff` and `/autonomy` will detect it automatically and activate the agent pipeline on every new project.

> **⚠️ Restart Claude Code after installing.** Skills are loaded at startup — they won't appear until you start a new session.

---

## Quick Start (2 minutes)

### New project:
```bash
mkdir my-app && cd my-app
claude --dangerously-skip-permissions
```
```
/kickoff I want to build a recipe sharing app where users upload recipes with photos and rate each other's dishes
```
Answer Claude's questions → Claude creates a private GitHub repo → starts building → walk away.

### Existing project:
```bash
cd my-existing-project
claude --dangerously-skip-permissions
```
```
/autonomy
```
Claude scans the codebase, flags any missing tools or security issues, and starts working.

### Ready to test:
```
/ship
```
Claude wraps up, makes the app run, and tells you exactly how to test it.

### With itagents installed:
After `/kickoff` builds your project to a checkpoint, run `/itagentsreview` to push everything through the multi-agent QA pipeline. Reviewers catch bugs, security holes, performance issues, and dependency risks before code reaches `PROGRESS.md`.

---

## How It Works

### The Problem

By default, Claude Code has behaviors that prevent truly autonomous work:

1. **Task completion stops** — Claude finishes a task and says *"Done! What would you like me to work on next?"* You have to babysit the terminal every 10 minutes.
2. **Plan confirmation requests** — Claude generates a plan and asks *"Does this look correct before I proceed?"* More waiting.
3. **Decision paralysis** — Claude asks *"Should I use React or Vue?"* instead of just picking one and building.

### The Solution

These skills create four files in every project:

| File | Purpose |
|---|---|
| `CLAUDE.md` | Project description + explicit rules: *"never ask, never stop, never present plans — just execute and keep going"* + security defaults |
| `BACKLOG.md` | A checkboxed task list. Claude picks the next unchecked item, builds it, checks it off, moves to the next. |
| `PROGRESS.md` | State file so Claude can resume where it left off if the session restarts. |
| `LESSONS.md` | Auto-improving memory — Claude appends learnings, future sessions read them. |

If autonomous-ai-itagents is also installed, additional files appear: `BACKLOG_FUTURE.md`, `BACKLOG_BLOCKED.md`, `REVIEW_QUEUE.md`, and the `.agents/` folder with all specialist agent definitions.

Claude reads these files, follows the rules, and works through the backlog continuously — like having a developer who never takes breaks.

---

## Detailed Usage Guide

### 🆕 `/kickoff` — Starting a New Project

**What happens:**
1. You describe what you want to build
2. Claude silently checks your system for required tools — only tells you about **missing** ones
3. Claude asks up to 20 comprehensive discovery questions in ONE message — covering features, platform, auth, data, APIs, design, budget, and constraints
4. You answer everything in one go
5. Claude **never asks another question** — it installs missing tools, generates project files, creates a private GitHub repo, and starts coding autonomously

If autonomous-ai-itagents is detected, the project is set up with the full multi-agent file structure and Builder pushes finished tasks to `REVIEW_QUEUE.md` instead of `PROGRESS.md` directly.

---

### 🔧 `/autonomy` — Existing Project

**What happens:**
1. Claude reads your entire codebase
2. Claude audits your tooling — only shows **missing** tools and credentials needed
3. Claude creates a private GitHub repo if none exists
4. Claude prepends autonomous rules + security defaults to CLAUDE.md (preserves everything else)
5. Claude generates BACKLOG.md by scanning for bugs, missing features, test gaps — and flags security violations (hardcoded secrets, missing auth, SQL injection risks) as P1
6. Claude creates PROGRESS.md and LESSONS.md and starts working

If autonomous-ai-itagents is detected, the existing project is retrofitted with the agent system files.

---

### 🚀 `/ship` — Wrap Up for Testing

**What happens:**
1. Claude stops picking up new tasks
2. Finishes only what it's currently doing
3. Makes sure the app starts without errors
4. Runs tests and fixes any failures
5. Commits everything
6. Prints a clear test report with the exact command to run

You can specify how many minutes Claude has to wrap up:
```
/ship 5
```

---

### ▶️ Resuming After Testing

Type in the same terminal:
```
Resume working through the backlog.
```

Or give feedback:
```
Resume the backlog. Also: the login page has a bug — it doesn't redirect
after successful login. Fix that first.
```

---

## Controlling Claude While It Works

You're always in control. Just type in the terminal at any moment — Claude pauses, reads your input, adjusts, and continues.

| What you want | What to type |
|---|---|
| Redirect Claude | `"Use PostgreSQL instead of SQLite"` |
| Skip a task | `"Skip the email feature, we don't need it"` |
| Add a task | `"Add to the backlog: implement dark mode"` |
| Fix something NOW | `"Stop. Fix this bug first: signup crashes when email is empty"` |
| Pause Claude | `"Stop working. Wait for me."` |
| Resume | `"Resume the backlog."` |
| Check status | `"What are you working on? What's left?"` |
| Free up memory | `/compact` |
| Wrap up for testing | `/ship` |
| Run multi-agent review | `/itagentsreview` (requires autonomous-ai-itagents) |

---

## 🔒 Security Defaults (baked into every project)

Every `CLAUDE.md` generated by `/kickoff` or `/autonomy` includes this block, which Claude re-reads at every session start:

- Private repo always (unless told otherwise)
- Every endpoint/script requires auth (unless explicitly marked public)
- Secrets in env vars only — never hardcode, never commit
- `.env`, `*.key`, `*.pem` in `.gitignore` before first commit
- Parameterized queries only — no string-concat SQL
- Validate/sanitize all user input server-side
- Hash passwords (bcrypt/argon2), never log secrets or PII
- HTTPS only in production, CORS restricted to known origins
- Least-privilege by default — users access only their own data

Nine lines. Minimal context cost. Claude applies them to every decision.

---

## 📚 Auto-improving memory (LESSONS.md)

Every project gets a `LESSONS.md` file. Claude (and any specialist agents from itagents) append findings worth remembering:

```markdown
## 2026-04-20 — Builder [security] [auth]
- Tried to use jsonwebtoken v8 — has CVE
- LESSON: Use jose library for JWT in this project

## 2026-04-21 — Builder [performance] [database]
- N+1 query in the user list endpoint took 200ms+ per user
- LESSON: Always eager-load relationships on list endpoints
```

At the start of every session, Claude reads `LESSONS.md`. Over time, the project gets smarter — same bugs don't get reintroduced, same patterns get applied automatically. Per-project, no extra infrastructure.

---

## Running Multiple Projects Simultaneously

Open multiple terminal tabs:

```
Tab 1:  cd ~/project-alpha && claude --dangerously-skip-permissions
Tab 2:  cd ~/project-beta  && claude --dangerously-skip-permissions
Tab 3:  cd ~/project-gamma && claude --dangerously-skip-permissions
```

Each session works independently through its own BACKLOG.md.

---

## What Claude Decides vs. What It Asks You

### ✅ Claude decides autonomously (never asks):
- Programming language, framework, libraries
- Architecture, design patterns, folder structure
- Database schema, API design
- UI/UX, colors, fonts, layouts
- Testing strategy, build tools
- Git branching, commit messages
- Error handling, performance approach

### 🛑 Claude stops and asks (as it should):
- API keys or secrets it can't find
- Paid services requiring a subscription
- External account creation or registration
- OAuth setup with third-party services
- Errors it can't fix after 3 attempts

---

## Troubleshooting

| Problem | Fix |
|---|---|
| `/kickoff` not found | Restart Claude Code — skills load at startup |
| Still not found after restart | Re-run the install — skills go in both `~/.claude/skills/` and `~/.agents/skills/` |
| Claude stops after 1 task | Start with: *"Read CLAUDE.md. Work through BACKLOG.md continuously. Never stop between tasks."* |
| Claude asks "is this plan okay?" | Type: *"Don't ask. Just execute. Continue."* |
| Claude's responses get short/slow | Type `/compact` to free up context |
| Session dies completely | Relaunch Claude, type: *"Read PROGRESS.md and BACKLOG.md. Continue where you left off."* |
| GitHub repo not created | Install GitHub CLI: `winget install GitHub.cli` (Windows) or `brew install gh` (Mac), then `gh auth login` |
| `gh` installed but repo still not created | Run `gh auth login` — CLI is installed but not authenticated |
| Want the multi-agent review pipeline | Install [autonomous-ai-itagents](https://github.com/fransanda/autonomous-ai-itagents), then re-run `/autonomy` in your project |

---

## Uninstall

### Windows
```powershell
foreach ($d in @("$env:USERPROFILE\.claude\skills","$env:USERPROFILE\.agents\skills")) { foreach ($s in @("kickoff","autonomy","ship")) { Remove-Item "$d\$s" -Recurse -Force -ErrorAction SilentlyContinue } }
```

### Mac / Linux
```bash
for d in ~/.claude/skills ~/.agents/skills; do rm -rf "$d/kickoff" "$d/autonomy" "$d/ship"; done
```

---

## License

MIT — use however you want.

## Contributing

Ideas, improvements, and new skills welcome. Open an issue or PR.

## Sister project

[autonomous-ai-itagents](https://github.com/fransanda/autonomous-ai-itagents) — adds a 9-agent QA pipeline (Coordinator, Builder, Code Reviewer, Bug Finder, Security Analyzer, Performance Optimizer, Dependency Auditor, Tester, Task Checker) on top of these skills. Auto-detected.
