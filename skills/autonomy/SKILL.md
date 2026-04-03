---
name: autonomy
description: "Add autonomous development to an existing project. Scans the codebase, adds autonomous rules to CLAUDE.md, generates BACKLOG.md and PROGRESS.md, then starts working continuously. Use with: /autonomy"
allowed-tools: Read, Write, Edit, Bash, Glob, Grep
---

You are adding autonomous development capabilities to an EXISTING project.

## Step 1: Analyze the project

Read the entire codebase structure. If a CLAUDE.md already exists, read it.
Understand: the tech stack, architecture, current state, what's built, what's missing.

## Step 2: Update or create CLAUDE.md

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

---
```

## Step 3: Generate BACKLOG.md

Scan the entire codebase and create BACKLOG.md with checkboxed tasks organized by priority:
- P1 (critical): Bugs, broken functionality, blocking issues
- P2 (important): Missing features based on CLAUDE.md goals vs what's built
- P3 (nice-to-have): Test coverage gaps, code quality, refactoring
- P4 (improvements): Dependency updates, performance, documentation
- Ongoing: Always-do items (fix bugs found while working, increase coverage, clean up)

Each task must be specific and actionable with file references where possible.

## Step 4: Create PROGRESS.md

```markdown
# Progress Log

## Current State
- Status: EXISTING PROJECT — autonomous mode activated
- Current branch: [detect current git branch]

## Blocked (needs human)
- (nothing yet)

## Completed Tasks

## Session Notes
- Autonomous mode activated on existing codebase
- Starting from BACKLOG.md Priority 1
```

## Step 5: Commit

```bash
git add CLAUDE.md BACKLOG.md PROGRESS.md
git commit -m "chore: add autonomous development workflow files"
```

## Step 6: Start building

Say ONLY: "✅ Autonomous mode activated. Starting work on the first backlog item."

Then immediately read CLAUDE.md, read BACKLOG.md, and start working through tasks continuously. Do not ask any questions. Do not present plans. Just build.
