# 🤖 Autonomous Claude Code Skills

**Three slash commands that turn Claude Code into a fully autonomous developer.**

Claude Code is powerful, but by default it stops after every task to ask "what next?" and pauses mid-work to ask "is this plan okay?" These skills eliminate both problems. Claude works continuously through a backlog of tasks, makes all technical decisions itself, and only stops when it genuinely needs human input (API keys, paid services, etc.).

---

## What You Get

| Command | Purpose | When to use |
|---|---|---|
| `/kickoff [description]` | Start a **new project** from an empty folder | You have an idea, no code yet |
| `/autonomy` | Add autonomous mode to an **existing project** | You have code, want Claude to keep building |
| `/ship` or `/ship [minutes]` | Wrap up, make sure it runs, prepare for testing | You want to test what Claude built |

---

## Install

### Prerequisites
- [Claude Code](https://docs.anthropic.com/en/docs/claude-code/overview) installed and authenticated
- [GitHub CLI](https://cli.github.com/) (`gh`) installed and authenticated — needed for `/kickoff` to auto-create repos
- Git installed
- A Claude Pro, Max, or API subscription

### Windows (PowerShell)
```powershell
git clone https://github.com/fransanda/autonomous-claude-skills.git "$env:TEMP\_acs"
foreach ($s in @("kickoff","autonomy","ship")) { foreach ($d in @("$env:USERPROFILE\.claude\skills","$env:USERPROFILE\.agents\skills")) { New-Item "$d\$s" -ItemType Directory -Force | Out-Null; Copy-Item "$env:TEMP\_acs\skills\$s\SKILL.md" "$d\$s\SKILL.md" -Force } }
Remove-Item "$env:TEMP\_acs" -Recurse -Force
```

### Mac / Linux
```bash
git clone https://github.com/fransanda/autonomous-claude-skills.git /tmp/_acs
for d in ~/.claude/skills ~/.agents/skills; do for s in kickoff autonomy ship; do mkdir -p "$d/$s" && cp "/tmp/_acs/skills/$s/SKILL.md" "$d/$s/SKILL.md"; done; done
rm -rf /tmp/_acs
```

### Using the install script (alternative)
```bash
git clone https://github.com/fransanda/autonomous-claude-skills.git
cd autonomous-claude-skills

# Windows:
powershell -ExecutionPolicy Bypass -File install.ps1

# Mac/Linux:
bash install.sh
```

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
Claude scans the codebase and starts working. No questions asked.

### Ready to test:
```
/ship
```
Claude wraps up, makes the app run, and tells you exactly how to test it.

---

## How It Works

### The Problem

By default, Claude Code has behaviors that prevent truly autonomous work:

1. **Task completion stops** — Claude finishes a task and says *"Done! What would you like me to work on next?"* You have to babysit the terminal every 10 minutes.

2. **Plan confirmation requests** — Claude generates a plan and asks *"Does this look correct before I proceed?"* More waiting.

3. **Decision paralysis** — Claude asks *"Should I use React or Vue?"* instead of just picking one and building.

### The Solution

These skills create three files in every project:

| File | Purpose |
|---|---|
| `CLAUDE.md` | Project description + explicit rules: *"never ask, never stop, never present plans — just execute and keep going"* |
| `BACKLOG.md` | A checkboxed task list. Claude picks the next unchecked item, builds it, checks it off, moves to the next. |
| `PROGRESS.md` | State file so Claude can resume where it left off if the session restarts. |

Claude reads these files, follows the rules, and works through the backlog continuously — like having a developer who never takes breaks.

---

## Detailed Usage Guide

### 🆕 `/kickoff` — Starting a New Project

**What happens:**
1. You describe what you want to build
2. Claude checks your system for required tools — only tells you about **missing** ones (won't list what's already installed)
3. Claude asks up to 20 comprehensive discovery questions in ONE message — covering features, platform, auth, data, APIs, design, budget, and constraints
4. You answer everything in one go
5. Claude **never asks another question** — it installs missing tools, creates a private GitHub repo, generates all three files, and starts coding autonomously

---

### 🔧 `/autonomy` — Existing Project

**What happens:**
1. Claude reads your entire codebase
2. Claude audits your tooling — only shows **missing** tools and credentials needed
3. Claude creates a private GitHub repo if none exists
4. If CLAUDE.md exists, Claude prepends the autonomous rules (keeps everything else)
5. Claude generates BACKLOG.md by scanning for bugs, missing features, test gaps, improvements
6. Claude creates PROGRESS.md
7. Claude starts working immediately

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

## Daily Workflow

```
MORNING (5 min)
├── Open BACKLOG.md → add/reorder today's priorities
├── Terminal tab per project → claude --dangerously-skip-permissions
├── Paste: "Read CLAUDE.md and BACKLOG.md. Work continuously. Start now."
└── Walk away

DURING THE DAY
├── Glance at terminal tabs to see progress
├── Type instructions to redirect if needed
├── Check git log to see commits
└── Check PROGRESS.md for status

WHEN READY TO TEST
├── Type: /ship
├── Read the test report
├── Run the app, test it
└── Type: "Resume the backlog. Also: [feedback]"

EVENING (2 min)
├── Review BACKLOG.md — see what's done
├── Review PROGRESS.md — check for blocked items
└── Reorder tasks for tomorrow
```

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
| Still not found after restart | Re-run the install command — skills go in both `~/.claude/skills/` and `~/.agents/skills/` |
| Claude stops after 1 task | Start with: *"Read CLAUDE.md. Work through BACKLOG.md continuously. Never stop between tasks."* |
| Claude asks "is this plan okay?" | Type: *"Don't ask. Just execute. Continue."* |
| Claude's responses get short/slow | Type `/compact` to free up context |
| Session dies completely | Relaunch Claude, type: *"Read PROGRESS.md and BACKLOG.md. Continue where you left off."* |
| Claude asks about tech choices | Make sure CLAUDE.md has the autonomous rules at the top |
| GitHub repo not created | Install GitHub CLI: `winget install GitHub.cli` then `gh auth login` |

---

## Tips

- **`BACKLOG.md` is your steering wheel.** Reorder tasks to change priorities. Add or remove items anytime.
- **`PROGRESS.md` is your dashboard.** Check it to see status, blocked items, and what Claude did.
- **Ship early, ship often.** Don't wait for the entire backlog. Use `/ship` after a few tasks, test, give feedback, resume.
- **Always use `--dangerously-skip-permissions` inside a git repo.** If Claude breaks something: `git reset --hard`.
- **Use `/compact` in long sessions.** It frees context space so Claude can keep working longer.
- **`/kickoff` auto-creates a private GitHub repo** using the folder name. Make sure `gh` CLI is installed and authenticated.

---

## How It's Built

Each skill is a single `SKILL.md` file. The installer copies to both possible locations:

```
~/.claude/skills/          ~/.agents/skills/
├── kickoff/SKILL.md       ├── kickoff/SKILL.md
├── autonomy/SKILL.md      ├── autonomy/SKILL.md
└── ship/SKILL.md          └── ship/SKILL.md
```

Skills are global — they work in any project directory.

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