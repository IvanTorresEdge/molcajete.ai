---
name: git-committing
description: >-
  This skill should be used when creating git commits, amending commits, or
  reviewing commit messages. It defines commit message standards: imperative verbs,
  50-character limit, conventional commit prefixes adapted to the project's
  existing style, and absolutely no AI or tool attribution.
---

# Git Committing Standards

Standards for writing clear, concise git commit messages that communicate changes effectively.

## Commit Message Format

### Structure

```
<Verb> <what changed>

- <why detail 1>
- <why detail 2>
- <why detail 3>
```

The first line is the subject. The body (bullet points) is optional but recommended for non-trivial changes. Separate the subject from the body with a blank line.

### First Line Rules

1. **Start with an imperative verb** (capitalize the first letter):
   - **Adds** — New files, features, or functionality
   - **Fixes** — Bug fixes or corrections
   - **Updates** — Changes to existing features
   - **Removes** — Deletion of features, files, or code
   - **Refactors** — Code restructuring without changing behavior
   - **Improves** — Performance or quality enhancements
   - **Moves** — File or code relocation
   - **Renames** — Renaming files, variables, or functions
   - **Replaces** — Swapping one implementation for another
   - **Simplifies** — Reducing complexity

2. **Maximum 50 characters** for the first line. If it exceeds 50 characters, it is too long — move details to the body.

3. **Describe what changed**, not what was wrong:
   - Good: "Fixes login redirect after authentication"
   - Bad: "Fixes bug where users were stuck on login page"

4. **Use simple language** — Avoid jargon when plain words work:
   - Good: "Adds user search feature"
   - Bad: "Implements user discovery mechanism"

5. **Conventional commit prefixes** (`feat:`, `fix:`, `test:`, `chore:`, `docs:`, `refactor:`, `perf:`) — Use the appropriate prefix based on the staged changes. Check `git log --oneline -20` to adapt to the project's style — if the history does not use prefixes, skip them and use the verb-only format instead.
   - Project uses prefixes: `feat: Add user dashboard`
   - Project does not use prefixes: `Adds user dashboard`

### Body (Optional)

Use bullet points (hyphens, not paragraphs) to explain **why** when:
- The change affects multiple files or areas
- The reasoning is not obvious from the diff
- Multiple steps or trade-offs were involved

```
Refactors authentication flow

- Separates login and registration logic
- Makes code easier to test independently
- Removes duplicate token validation
- Prepares for OAuth integration
```

For simple, obvious changes, a single subject line is enough:

```
Fixes typo in README
```

```
Updates dependencies to latest versions
```

### Issue References

Place issue references at the end of the subject line in parentheses:

```
Fixes payment processing error (#123)
```

Do not use issue tracker language as the subject — "Resolves #123" says nothing about what changed.

See [references/message-format.md](./references/message-format.md) for detailed format rules.
See [references/examples.md](./references/examples.md) for good and bad examples.

## No AI Attribution (CRITICAL)

**THIS IS MANDATORY — NO EXCEPTIONS.**

When creating commit messages:
- NEVER add "Generated with Claude Code" or similar
- NEVER add "Co-Authored-By: Claude" or any AI co-author line
- NEVER add "In collaboration with Claude AI" or similar
- NEVER add any AI emoji (no robot emoji, no sparkles, no similar)
- NEVER add "AI-assisted" or similar phrases
- NEVER add "Created using Copilot" or any tool mentions
- NEVER add attribution links to Claude or AI tools

Commits must look like normal human development:
- Bad: "Refactors authentication logic with help from Claude"
- Bad: "AI-assisted refactoring of auth module"
- Good: "Refactors authentication logic"

**Focus on what changed, not how it was produced.** The process of creating code is irrelevant to the commit message. Only describe the change itself.

## Commit Best Practices

### Make Atomic Commits

Each commit represents one logical change:
- One bug fix per commit
- One feature per commit
- One refactoring per commit

Do not mix unrelated changes:
- Bad: Fixing a bug AND adding a feature in one commit
- Bad: Updating dependencies AND refactoring code in one commit

Small, frequent commits are better than large, infrequent ones: easier to review, easier to revert if needed, better git history, clearer project progression.

### Review the Diff Before Committing

Use `git diff --staged` to check:
- No debug code included (`console.log`, print statements)
- No commented-out code
- No temporary changes
- No unintended file changes

### Stage Specific Files

Only stage files related to the change:

```bash
# GOOD: Stage specific files
git add src/auth.js tests/auth.test.js

# AVOID: Staging everything blindly
git add .
```

### Test Changes Before Committing

- Run tests if available
- Test manually if needed
- Fix errors or warnings before committing

### Never Commit Secrets

Do not commit: API keys, passwords, private keys, access tokens, `.env` files with secrets.

### Never Commit Debug Code

Remove before committing: `console.log()` statements, commented-out code blocks, temporary test data, debug flags.

### Write for Future Readers

Commit messages should help understand the change months from now:
- What changed?
- Why did it change?
- What was the context?

Good commit history makes `git log --oneline` a useful project timeline:

```
a1b2c3d Adds user authentication
b2c3d4e Fixes login redirect
c3d4e5f Updates password validation
d4e5f6g Refactors token handling
```

### Emergency: Committed a Secret

1. Do not just delete the file — the secret is in git history
2. Rotate or invalidate the secret immediately
3. Use tools like `git-filter-repo` to remove from history

### Emergency: Committed to Wrong Branch

```bash
git reset HEAD~1    # Undo commit, keep changes
git stash           # Stash changes
git checkout correct-branch
git stash pop       # Apply changes
git add .
git commit
```

## Amend Safety

### When to Amend

Use `git commit --amend` only for minor corrections to the last commit:
- Typos in the commit message
- Forgotten files
- Small code fixes

### Amend Rules

1. **Only amend unpushed commits** — Never amend commits that have been pushed to a shared remote. Amending rewrites history and causes problems for other contributors.
2. **Check authorship first** — Verify with `git log -1 --format='%an %ae'` that the commit is yours before amending.
3. **Use a new commit for significant changes** — If the fix is more than trivial, create a new commit instead of amending.

## Reference Files

| File | Description |
|---|---|
| [references/message-format.md](./references/message-format.md) | Detailed commit message format rules, verb list, body guidelines |
| [references/examples.md](./references/examples.md) | Good and bad commit message examples for common scenarios |
