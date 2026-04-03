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
git clone https://github.com/fransanda/autonomous-claude-skills.git "$env:USERPROFILE\.claude\skills\_autonomous-tmp"
Copy-Item "$env:USERPROFILE\.claude\skills\_autonomous-tmp\skills\kickoff" "$env:USERPROFILE\.claude\skills\kickoff" -Recurse -Force
Copy-Item "$env:USERPROFILE\.claude\skills\_autonomous-tmp\skills\autonomy" "$env:USERPROFILE\.claude\skills\autonomy" -Recurse -Force
Copy-Item "$env:USERPROFILE\.claude\skills\_autonomous-tmp\skills\ship" "$env:USERPROFILE\.claude\skills\ship" -Recurse -Force
Remove-Item "$env:USERPROFILE\.claude\skills\_autonomous-tmp" -Recurse -Force
```

### Mac / Linux
```bash
git clone https://github.com/fransanda/autonomous-claude-skills.git ~/.claude/skills/_autonomous-tmp
cp -r ~/.claude/skills/_autonomous-tmp/skills/kickoff ~/.claude/skills/kickoff
cp -r ~/.claude/skills/_autonomous-tmp/skills/autonomy ~/.claude/skills/autonomy
cp -r ~/.claude/skills/_autonomous-tmp/skills/ship ~/.claude/skills/ship
rm -rf ~/.claude/skills/_autonomous-tmp
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
2. Claude asks up to 20 comprehensive discovery questions in ONE message — covering features, platform, auth, data, APIs, design, budget, and constraints
3. You answer everything in one go
4. Claude **never asks another question** — it creates a private GitHub repo, generates all three files, and starts coding autonomously

The discovery covers 7 categories: core product, platform & access, users & auth, data & backend, integrations & APIs, design & UX, and constraints. Questions you already answered in your description are skipped automatically.

**Example:**
```
You:    /kickoff I want a personal budget tracker that categorizes expenses

Claude: This is my only chance to ask questions — after this I build silently.

        Core Product:
        1. What are the top 3-5 features for the MVP?
        2. Just for you, or will others use it too?
        3. What's the main daily workflow?

        Platform:
        4. Web app, mobile, or desktop?
        5. Need offline support?

        Data & Auth:
        6. Need user accounts?
        7. Where should data live — local or cloud?
        8. What entities? (transactions, categories, budgets?)

        Integrations:
        9. Connect to a bank API or manual entry?
        10. Need charts/visualizations?

        Design:
        11. Dark mode, light, or specific style?
        12. Any apps that feel like what you want?

        Constraints:
        13. Free-only or paid services OK?
        14. Anything that should NOT be included?

You:    1. Add expenses, categorize, monthly charts  2. Just me  3. Open app,
        add expense, check monthly summary  4. Web app  5. No  6. No  
        7. Local  8. Yes those  9. Manual  10. Yes  11. Dark  12. Like Mint 
        but simpler  13. Free only  14. No social features. Build it.

Claude: ✅ Project initialized. Private GitHub repo created. Starting now.
        [begins coding without stopping]
```

---

### 🔧 `/autonomy` — Existing Project

**What happens:**
1. Claude reads your entire codebase
2. If CLAUDE.md exists, Claude prepends the autonomous rules (keeps everything else)
3. Claude generates BACKLOG.md by scanning for bugs, missing features, test gaps, improvements
4. Claude creates PROGRESS.md
5. Claude starts working immediately — no questions

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

Each skill is a single `SKILL.md` file in `~/.claude/skills/[name]/SKILL.md`:

```
~/.claude/skills/
├── kickoff/SKILL.md     ← /kickoff command
├── autonomy/SKILL.md    ← /autonomy command
└── ship/SKILL.md        ← /ship command
```

Skills are global — they work in any project directory.

---

## Uninstall

### Windows
```powershell
Remove-Item "$env:USERPROFILE\.claude\skills\kickoff" -Recurse -Force
Remove-Item "$env:USERPROFILE\.claude\skills\autonomy" -Recurse -Force
Remove-Item "$env:USERPROFILE\.claude\skills\ship" -Recurse -Force
```

### Mac / Linux
```bash
rm -rf ~/.claude/skills/kickoff ~/.claude/skills/autonomy ~/.claude/skills/ship
```

---

## License

MIT — use however you want.

## Contributing

Ideas, improvements, and new skills welcome. Open an issue or PR.