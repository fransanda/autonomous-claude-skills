# 🤖 Autonomous Claude Code Skills

**Four slash commands that turn Claude Code into a fully autonomous developer.**

Claude Code is powerful, but by default it stops after every task to ask "what next?" and pauses mid-work to ask "is this plan okay?" These skills eliminate both problems. Claude works continuously through a backlog, makes all technical decisions itself, and only stops when it genuinely needs human input (API keys, paid services, etc.).

> 💡 **Want a full QA team reviewing the code Claude writes?** Pair this with [autonomous-claude-itagents](https://github.com/fransanda/autonomous-claude-itagents) — an 11-agent review pipeline (security, bugs, performance, dependencies, tests, architecture, PR merge) plus a live-browser UI testing army (`/uitest`) that clicks through every page/role on desktop + mobile. Runs every task before it ships. Auto-detected when both repos are installed.

---

## What You Get

| Command | Purpose | When to use |
|---|---|---|
| `/kickoff [description]` | Start a **new project** from an empty folder | You have an idea, no code yet |
| `/autonomy` | Add autonomous mode to an **existing project** | You have code, want Claude to keep building |
| `/improve` | **Autonomous improvement loop** — fixes bugs & gaps on main, proposes new features via PRs | You want to push toward production or maintain a live project |
| `/ship` or `/ship [minutes]` | Wrap up, make sure it runs, prepare for testing | You want to test what Claude built |

Every new project kicked off with `/kickoff` or adopted via `/autonomy` automatically gets:
- A private GitHub repo (via `gh` CLI)
- `CLAUDE.md`, `BACKLOG.md`, `PROGRESS.md`, `LESSONS.md`, `VISION.md`, `WIREFRAME.yaml` setup
- A baked-in **🔒 Security Defaults** block (private by default, env vars for secrets, auth on every endpoint, parameterized queries, input validation, hashed passwords, HTTPS, least-privilege access) that Claude follows throughout development
- **`VISION.md`** — project goals, user workflows, and production-readiness criteria. Used by `/improve` to know what to fix vs. what to propose.
- **`WIREFRAME.yaml`** — the UI source of truth (pages, nav, flows, components, states with auth/roles and each CTA's expected destination). `/uitest` and `/improve` check the running app against it to catch broken flows, missing-login gaps, dead drag/back affordances, and missing empty/error states.
- **`LESSONS.md` auto-improving memory** — Claude appends learnings, future sessions read them. Per-project, no extra cost.
- **`AUDIT.md`** — tracks every `/improve` session: what was scanned, fixed, and proposed.
- If [autonomous-claude-itagents](https://github.com/fransanda/autonomous-claude-itagents) is also installed → full multi-agent QA pipeline activates automatically

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
curl -fsSL https://raw.githubusercontent.com/fransanda/autonomous-claude-itagents/main/install.sh | bash
```

```powershell
# Windows
irm https://raw.githubusercontent.com/fransanda/autonomous-claude-itagents/main/install.ps1 | iex
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

These skills create project files:

| File | Purpose |
|---|---|
| `CLAUDE.md` | Project description + explicit rules: *"never ask, never stop, never present plans — just execute and keep going"* + security defaults |
| `BACKLOG.md` | A checkboxed task list. Claude picks the next unchecked item, builds it, checks it off, moves to the next. |
| `PROGRESS.md` | State file so Claude can resume where it left off if the session restarts. |
| `LESSONS.md` | Auto-improving memory — Claude appends learnings, future sessions read them. |
| `VISION.md` | Project goals, user workflows, and production-readiness criteria. `/improve` uses this to decide what to fix vs. propose. |
| `WIREFRAME.yaml` | The **UI source of truth** — a machine-readable map of the app's pages, navigation, flows, components, and states (auth/roles per page, each CTA's expected destination, modal/sheet interactions, form success/error outcomes). `/uitest` and `/improve` check the running app against it to catch broken flows, missing-login gaps, dead affordances, and missing empty/error states. Always created (a stub for non-UI projects); committed; Claude keeps it in sync as the UI changes. |
| `AUDIT.md` | Log of every `/improve` session — what was scanned, fixed, and proposed. |
| `IMPROVE_CONFIG.md` | Configurable schedule for fix and improvement cycles. Gitignored (machine-local); a committed `IMPROVE_CONFIG.example.md` placeholder gives collaborators the defaults. See [`templates/IMPROVE_CONFIG.md`](templates/IMPROVE_CONFIG.md) for all options. |

If autonomous-claude-itagents is also installed, additional files appear: `BACKLOG_FUTURE.md`, `BACKLOG_BLOCKED.md`, `REVIEW_QUEUE.md`, and the `.agents/` folder with all specialist agent definitions.

Claude reads these files, follows the rules, and works through the backlog continuously — like having a developer who never takes breaks.

---

## Detailed Usage Guide

### 🆕 `/kickoff` — Starting a New Project

**What happens:**
1. You describe what you want to build
2. Claude silently checks your system for required tools — only tells you about **missing** ones
3. Claude asks up to 26 comprehensive discovery questions in ONE message — covering features, platform, auth, data, APIs, design, budget, constraints, and vision
4. You answer everything in one go
5. Claude **never asks another question** — it installs missing tools, generates project files, creates a private GitHub repo, and starts coding autonomously

If autonomous-claude-itagents is detected, the project is set up with the full multi-agent file structure and Builder pushes finished tasks to `REVIEW_QUEUE.md` instead of `PROGRESS.md` directly.

---

### 🔧 `/autonomy` — Existing Project

**What happens:**
1. Claude reads your entire codebase
2. Claude audits your tooling — only shows **missing** tools and credentials needed
3. Claude creates a private GitHub repo if none exists
4. Claude prepends autonomous rules + security defaults to CLAUDE.md (preserves everything else)
5. Claude generates BACKLOG.md by scanning for bugs, missing features, test gaps — and flags security violations (hardcoded secrets, missing auth, SQL injection risks) as P1
6. Claude creates PROGRESS.md and LESSONS.md and starts working

If autonomous-claude-itagents is detected, the existing project is retrofitted with the agent system files.

---

### 🔄 `/improve` — Autonomous Improvement Loop

**What happens:**
1. Claude reads `VISION.md` (creates it if missing — asks 5 questions once, then never again)
2. Scans the entire project against VISION.md: workflows, bugs, security, performance, UI consistency, backend robustness
3. Categorizes findings into **fixes** (autonomous) and **improvements** (needs approval):
   - 🔧 **Fixes** — anything VISION.md says should work but doesn't → committed directly to `main`
   - 💡 **Improvements** — new features or changes not in VISION.md → created on branches as PR drafts for human review
4. Fixes are applied, tests run, regressions caught via convergence re-scans
5. Everything is logged to `AUDIT.md`
6. Cycle repeats on a configurable schedule

**Configurable timing:**
```
/improve                                        # defaults: fixes every 4h, improvements every 24h
/improve fixes every 12h                        # more frequent fix scans
/improve improvements every 3d                  # more frequent improvement proposals
/improve fixes every 6h improvements every 1d   # aggressive (active development)
```

Edit `IMPROVE_CONFIG.md` at any time to change the schedule.

**Controls:**
- Create `PAUSE.md` to pause (write a reason inside) — delete it to resume
- Close the Claude Code session to stop entirely
- Use `/loop /improve` for continuous operation within a session

If autonomous-claude-itagents is detected, `/improve` leverages the specialist agents (security-analyzer, bug-finder, etc.) for deeper scanning.

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
| Pause Claude | `"Stop working. Wait for me."` or create `PAUSE.md` |
| Resume | `"Resume the backlog."` or delete `PAUSE.md` |
| Check status | `"What are you working on? What's left?"` |
| Free up memory | `/compact` |
| Improve the project | `/improve` (scan, fix, propose improvements) |
| Change improve frequency | `/improve fixes every 12h improvements every 3d` |
| Wrap up for testing | `/ship` |
| Run multi-agent review | `/itagentsreview` (requires autonomous-claude-itagents) |

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
| `/improve` finds nothing to fix | Check `VISION.md` — it may be missing workflows. Add the user flows you expect and run `/improve` again |
| `/improve` keeps proposing the same PRs | Close the existing PR (or merge it). `/improve` skips improvements that already have an open branch |
| Want to change improve schedule | Edit `IMPROVE_CONFIG.md` in your project, or run `/improve fixes every Xh improvements every Xd` |
| Want the multi-agent review pipeline | Install [autonomous-claude-itagents](https://github.com/fransanda/autonomous-claude-itagents), then re-run `/autonomy` in your project |

---

## Uninstall

### Windows
```powershell
foreach ($d in @("$env:USERPROFILE\.claude\skills","$env:USERPROFILE\.agents\skills")) { foreach ($s in @("kickoff","autonomy","ship","improve")) { Remove-Item "$d\$s" -Recurse -Force -ErrorAction SilentlyContinue } }
```

### Mac / Linux
```bash
for d in ~/.claude/skills ~/.agents/skills; do rm -rf "$d/kickoff" "$d/autonomy" "$d/ship" "$d/improve"; done
```

---

## License

MIT — use however you want.

## Contributing

Ideas, improvements, and new skills welcome. Open an issue or PR.

## Full project lifecycle

```
/kickoff [idea]     → Build from scratch (questions → backlog → autonomous build)
        ↓
/improve            → Push to production (fix bugs/gaps → propose enhancements via PRs)
        ↓
/itagentsreview     → Deep multi-agent QA review (optional, requires itagents)
        ↓
/mergeprs           → Autonomous PR review + merge (optional, requires itagents)
        ↓
/ship               → Wrap up, verify, test report
        ↓
/improve            → Maintain (periodic scans, fixes, improvement PRs)
```

## Sister project

[autonomous-claude-itagents](https://github.com/fransanda/autonomous-claude-itagents) — adds an 11-agent QA pipeline (Coordinator, Builder, Code Reviewer, Bug Finder, Security Analyzer, Performance Optimizer, Dependency Auditor, Tester, Task Checker, PR Merger, UI Tester) on top of these skills, plus the `/uitest` live-browser UI testing army. Auto-detected. `/improve` leverages these agents for deeper scanning when installed, and optional Phase 5.5 can auto-merge pending improvement PRs via `/mergeprs`.
