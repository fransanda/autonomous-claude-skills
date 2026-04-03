---
name: ship
description: "Stop working on new tasks, wrap up current work, make sure the app runs, commit everything, and print a test report. Use with: /ship or /ship 10 (minutes to wrap up)"
allowed-tools: Read, Write, Edit, Bash, Glob, Grep
argument-hint: [optional: minutes to wrap up, default 10]
---

## STOP picking up new tasks. Wrap up and prepare for testing.

The user wants to test the project. You have $ARGUMENTS minutes to wrap up.
If no time was specified, take up to 10 minutes.

Follow these steps IN ORDER. Do NOT start any new backlog items.

### Step 1: Finish current work (max 50% of your time)
- If you are in the middle of implementing something, finish ONLY what you started
- If the current task is too big to finish quickly, get it to a non-broken state
- Do NOT start any new features or backlog items

### Step 2: Make it run (mandatory)
- Install all dependencies (npm install, pip install -r requirements.txt, etc.)
- Fix any import errors, syntax errors, or crashes
- Make sure the app starts without errors:
  - Web apps: ensure dev server starts successfully
  - Python apps: ensure the main script runs
  - iOS: ensure it builds without errors
- If there are build errors, fix them. This is your top priority.

### Step 3: Run tests
- Run the full test suite
- If tests fail, fix ONLY the failing tests (don't add new ones right now)
- If no test suite exists yet, skip this step

### Step 4: Commit everything
```bash
git add -A
git commit -m "chore: wrap up for testing — [brief summary of current state]"
```

### Step 5: Update PROGRESS.md
Add a clear testing section at the top:

```markdown
## 🧪 READY TO TEST — [current date/time]
- **How to run**: [exact command, e.g. "npm run dev → open localhost:3000"]
- **What works**: [list features that are functional]
- **What's NOT ready yet**: [list features still incomplete]
- **Known issues**: [any bugs or limitations you're aware of]
- **Remaining backlog items**: [count of unchecked items in BACKLOG.md]
```

### Step 6: Report to the user

Print a clear summary in the terminal:

```
════════════════════════════════════════════
  🚀 READY TO TEST
════════════════════════════════════════════

  How to run:  [exact command]

  ✅ Working:
     • [feature 1]
     • [feature 2]
     • [feature 3]

  🚧 Not ready yet:
     • [incomplete feature 1]
     • [incomplete feature 2]

  ⚠️  Known issues:
     • [issue 1]

  📊 Progress: [X] of [Y] backlog items complete

════════════════════════════════════════════
```

After printing this summary, STOP. Do not continue working.
Wait for the user to either give feedback or tell you to resume.
