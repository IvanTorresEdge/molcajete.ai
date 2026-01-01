---
name: post-change-verification
description: Mandatory verification protocol after code changes for JavaScript/TypeScript projects. Use after any code modification to ensure quality.
---

# Post-Change Verification Protocol

This skill defines the mandatory verification steps that JavaScript/TypeScript agents must perform after modifying code files.

## When to Use

Use this skill ALWAYS when:
- Creating new code files
- Modifying existing code files
- Refactoring code
- Generating code

Do NOT use when:
- Only reading/analyzing code (no modifications)
- Generating documentation only
- Running diagnostics or audits

## Package Manager Detection

Before running any commands, detect the project's package manager:

| Lock File | Package Manager | Run Command |
|-----------|-----------------|-------------|
| `pnpm-lock.yaml` | pnpm | `pnpm run <script>` |
| `yarn.lock` | yarn | `yarn <script>` |
| `package-lock.json` | npm | `npm run <script>` |
| `bun.lockb` | bun | `bun run <script>` |

**Detection Order:** Check for lock files in the order above. Use the first match.

**If no lock file exists:** Default to `npm` or ask the user which package manager to use.

**Throughout this document:** Commands use `<pkg>` as placeholder. Replace with the detected package manager:
- `<pkg> run format` → `pnpm run format` or `yarn format` or `npm run format`
- `<pkg> test` → `pnpm test` or `yarn test` or `npm test`

## Protocol Steps

After completing code changes, agents MUST execute these steps IN ORDER:

### Step 1: Format Code

```bash
<pkg> run format
# or
npx biome format --write .
```

**Purpose:** Ensure consistent code style across the project.

### Step 2: Run Linter

```bash
<pkg> run lint
# or
npx biome check .
```

**Purpose:** Detect code quality issues, unused variables, and potential bugs.

### Step 3: Run Type Checker

```bash
<pkg> run type-check
# or
npx tsc --noEmit
```

**Purpose:** Verify type safety and catch type errors.

### Step 4: Run Related Tests

```bash
<pkg> test -- --changed
# or
npx vitest related
# or
<pkg> test
```

**Purpose:** Verify code changes do not break existing functionality.

### Step 5: Verify Zero Issues

**TARGET:** All steps must complete with ZERO errors and ZERO warnings.

If any step reports errors or warnings, proceed to Exception Handling.

## Exception Handling

When verification finds issues, follow this decision tree:

```
Issue Found During Verification
            |
            v
    Was this issue caused
    by current changes?
            |
     +------+------+
     |             |
    YES           NO
     |             |
     v             v
  Fix it      Is it in a file
  now         you modified?
                   |
            +------+------+
            |             |
           YES           NO
            |             |
            v             v
      Is it a         Document and
      small fix?      report only
      (< 10 lines)         |
            |              |
     +------+------+       v
     |             |    DONE
    YES           NO    (proceed with
     |             |     task)
    v             v
  Fix it      Document,
  now         report,
              recommend
              separate task
```

### Decision Rules

1. **Issue caused by your changes:** Fix immediately before completing task
2. **Pre-existing issue in modified file, small fix (< 10 lines):** Fix as part of current work
3. **Pre-existing issue in modified file, large fix (>= 10 lines):** Document and report, recommend separate cleanup task
4. **Pre-existing issue in unmodified file:** Document and report only, do not fix

### Example Scenarios

**Scenario 1:** You add a new function and the linter reports an unused variable in your new code.
- **Action:** Fix it immediately (issue caused by your changes)

**Scenario 2:** You modify a file and discover a pre-existing type error (3 lines to fix) in a function you touched.
- **Action:** Fix it as part of your work (small fix in modified file)

**Scenario 3:** You modify a file and discover 50+ lines of type errors throughout the file.
- **Action:** Document the issues, complete your task, recommend separate cleanup task

**Scenario 4:** Lint reports warnings in a file you did not modify.
- **Action:** Document the issues in output, proceed with task completion

## Verification Output Format

Report verification results using this consistent format:

```
=== POST-CHANGE VERIFICATION ===

Format:     [PASSED | FAILED | SKIPPED (reason)]
Lint:       [PASSED | FAILED] ([X] errors, [Y] warnings)
Type-check: [PASSED | FAILED] ([X] errors)
Tests:      [PASSED | FAILED] ([X]/[Y] passed)

Pre-existing issues: [NONE | count listed below]
[If issues exist, list them here]

=== [TASK COMPLETE | VERIFICATION FAILED] ===
```

### Example: All Checks Passed

```
=== POST-CHANGE VERIFICATION ===

Format:     PASSED
Lint:       PASSED (0 errors, 0 warnings)
Type-check: PASSED (0 errors)
Tests:      PASSED (12/12)

Pre-existing issues: NONE

=== TASK COMPLETE ===
```

### Example: Pre-existing Issues Found

```
=== POST-CHANGE VERIFICATION ===

Format:     PASSED
Lint:       FAILED (0 errors caused by this change)
Type-check: PASSED (0 errors)
Tests:      PASSED (12/12)

Pre-existing issues (not caused by this change):
- src/utils/legacy.ts: Line 45 - 'data' has implicit 'any' type
- src/api/client.ts: Lines 78-92 - Missing error handling

These issues require structural changes beyond the scope of this task.
Recommend creating a separate cleanup task.

=== TASK COMPLETE ===
```

### Example: Issues Caused by Changes

```
=== POST-CHANGE VERIFICATION ===

Format:     PASSED
Lint:       FAILED (2 errors, 1 warning)
Type-check: FAILED (1 error)
Tests:      FAILED (10/12)

Issues to fix:
- src/features/new.ts: Line 23 - Unused variable 'temp'
- src/features/new.ts: Line 45 - Missing return type
- src/features/new.ts: Line 67 - Type 'string' not assignable to 'number'

=== VERIFICATION FAILED - FIX ISSUES BEFORE COMPLETING ===
```

## Graceful Degradation

Handle missing or failing commands gracefully:

| Situation | Status | Action |
|-----------|--------|--------|
| Command not found | `SKIPPED (command not found)` | Note and proceed to next step |
| Command timeout (> 5 min) | `SKIPPED (timeout)` | Note and proceed to next step |
| Execution error | `SKIPPED (execution error: [reason])` | Note and proceed to next step |

### Example: Missing Command

```
=== POST-CHANGE VERIFICATION ===

Format:     PASSED
Lint:       SKIPPED (command not found - no 'lint' script in package.json)
Type-check: PASSED (0 errors)
Tests:      PASSED (8/8)

Pre-existing issues: NONE

Note: Consider adding a 'lint' script to package.json for full quality verification.

=== TASK COMPLETE ===
```

## Best Practices

1. **Run all steps in order** - Each step may reveal different issues
2. **Fix your own issues first** - Never leave broken code from your changes
3. **Document pre-existing issues clearly** - Help future cleanup efforts
4. **Use the 10-line rule consistently** - Small fixes improve code health, large fixes need dedicated tasks
5. **Report honestly** - Verification results are informational, not judgmental

## Code Review Checklist

Before completing any code-modifying task:

- [ ] Format check passed
- [ ] Lint check passed (or pre-existing issues documented)
- [ ] Type check passed (or pre-existing issues documented)
- [ ] Tests passed (or pre-existing issues documented)
- [ ] All issues caused by changes are fixed
- [ ] Pre-existing issues clearly documented
- [ ] Verification output included in task completion
