---
description: Migrate deprecated .molcajete/research/ files to research/ at project root
model: claude-sonnet-4-5
allowed-tools: Bash, Glob, Task, AskUserQuestion
argument-hint: (no arguments)
---

# Migrate Legacy Research

You migrate research files from the deprecated `.molcajete/research/` directory to `research/` at the project root.

## Step 1: Verify Source Exists

Use Bash to check if `.molcajete/research/` exists:

```bash
ls -1 .molcajete/research/
```

If it does not exist, tell the user there is nothing to migrate and stop.

If `research/` already exists at the project root, use AskUserQuestion to warn:
- **Question:** "A `research/` directory already exists at the project root. Migrating will add files to it. Any files with the same name will be overwritten. Proceed?"
- **Header:** "Overwrite"
- **Options:**
  1. "Proceed" — Continue with migration
  2. "Cancel" — Stop the migration
- **multiSelect:** false

## Step 2: Migrate Files

Launch **1 sub-agent** (Task tool, subagent_type: `general-purpose`) to copy all research files:

**Prompt for the sub-agent:**
```
You are migrating research files from `.molcajete/research/` to `research/` at the project root.

## Instructions

1. Create the `research/` directory at the project root if it doesn't exist.
2. Use Glob to find all `.md` files in `.molcajete/research/`.
3. For each file:
   - Read the file from `.molcajete/research/`
   - Write it to `research/` with the same filename
4. Also check for and clean up session artifacts: files matching `.molcajete/tmp/claude-code-researcher-*`. If found, list them but do NOT delete them — just report their existence.

## Rules
- Read each source file, then Write to the destination.
- Do not modify original files under `.molcajete/research/`.
- Do not delete any files.
- Report back: list of files copied, and any session artifacts found.
```

## Step 3: Report Results

After the sub-agent completes, present results using AskUserQuestion:

- **Question:** "Research migration complete. {N} files copied from `.molcajete/research/` to `research/`. {Artifact note if any}. Done?"
- **Header:** "Results"
- **Options:**
  1. "Done" — Accept the migration
  2. "List files" — Show all copied file names
- **multiSelect:** false

If the user selects "List files", print the full file list from the sub-agent's report.

## Rules

- Use AskUserQuestion for ALL user interaction. Never ask questions as plain text.
- If `.molcajete/research/` does not exist, inform the user and stop immediately.
- Do not use the word "comprehensive" in any output.
