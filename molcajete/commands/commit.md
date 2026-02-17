---
description: Create a well-formatted commit from staged changes
model: claude-sonnet-4-5
allowed-tools: Bash, Write, Task, AskUserQuestion
argument-hint: <optional: issue number or context hint>
---

# Commit

You orchestrate a git commit workflow using a sub-agent to analyze changes and draft the message, then execute the commit after user confirmation.

**Context hint:** $ARGUMENTS

## Mandatory Requirements

**NEVER STAGE FILES.** Do not run `git add`, `git reset`, or `git restore --staged`. Only commit what is already staged. If nothing is staged, stop with an error.

**NEVER ADD AI ATTRIBUTION.** No "Generated with Claude Code", no "Co-Authored-By: Claude", no AI emoji, no tool mentions. Commits must look like normal human development.

**USE AskUserQuestion FOR ALL CONFIRMATIONS.** Never ask questions as plain text. Never end your response with a question. The only way to ask for confirmation is the AskUserQuestion tool.

## Step 1: Verify Staged Changes

Run `git diff --staged --stat` using Bash.

If no staged changes exist, show this error and stop:

```
No staged changes found.

Stage your changes first:
  git add <files>
```

Do not offer to stage files. Do not run `git add`. Stop immediately.

## Step 2: Draft Commit Message (Sub-Agent)

Launch a Task with `subagent_type="general-purpose"` and the following prompt:

```
Analyze the staged changes and draft a commit message. Do NOT execute any commit.

Read the commit standards skill first:
- ${CLAUDE_PLUGIN_ROOT}/skills/git-committing/SKILL.md
- ${CLAUDE_PLUGIN_ROOT}/skills/git-committing/references/message-format.md
- ${CLAUDE_PLUGIN_ROOT}/skills/git-committing/references/examples.md

Then:
1. Run `git diff --staged` to see full changes
2. Run `git diff --staged --stat` for file summary
3. For each changed file, read the full file to understand the context of the changes (not just the diff hunks)
4. Run `git log --oneline -10` to match project commit style (conventional prefixes or not)
5. Draft a commit message following the skill's rules:
   - Imperative verb (Adds, Fixes, Updates, Removes, Refactors, Improves, etc.)
   - First line under 50 characters
   - Body bullet points only when the change is non-trivial
   - Match project convention for prefixes
   - NEVER mention AI, Claude, or tools
   {context_hint}

Return ONLY the commit message text, nothing else. No explanation, no preamble. Just the message.
```

Replace `{context_hint}` with:
- If `$ARGUMENTS` is not empty: `6. Incorporate this context: $ARGUMENTS`
- If `$ARGUMENTS` is empty: remove the line

## Step 3: Get Confirmation

Take the message returned by the sub-agent and use AskUserQuestion:
- **Question:** "Commit with this message?\n\n```\n{message from sub-agent}\n```"
- **Header:** "Commit"
- **Options:** ["Yes, commit" — Commit with this message]
- **multiSelect:** false

The tool automatically provides an "Other" option. If the user types in Other:
- Treat their input as instructions to modify the message
- Update the message accordingly
- Invoke AskUserQuestion again with the updated message
- Repeat until the user selects "Yes, commit"

## Step 4: Execute Commit

After confirmation, write the commit message file using the **Write tool**, then commit using Bash. Do NOT use heredocs — zsh's internal heredoc temp file creation is blocked by the sandbox.

1. Use the **Write tool** to create `/tmp/claude/commit-msg.txt` with the confirmed message
2. Then run in a **single Bash call**:

```bash
git commit -F /tmp/claude/commit-msg.txt && rm /tmp/claude/commit-msg.txt && git log --oneline -1
```

**Do NOT use heredocs (`<< 'EOF'`) in Bash** — zsh creates an internal temp file for heredoc processing in a location the sandbox blocks, even if the output targets `/tmp/claude/`.

Report the result: show the commit hash and message.

## Rules

- Use AskUserQuestion for ALL user interaction. Never ask questions as plain text.
- Never stage or unstage files. The user manages staging.
- Never add AI or tool attribution to commit messages.
- Do not use the word "comprehensive" in any output.
- If `git commit` fails (e.g., pre-commit hook), report the error. Do not retry automatically.
- Show the complete message in the confirmation prompt, never a summary.
- The sub-agent drafts the message. You handle confirmation and execution.
