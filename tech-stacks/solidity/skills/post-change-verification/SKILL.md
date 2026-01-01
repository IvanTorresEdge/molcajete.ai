---
name: post-change-verification
description: Mandatory verification protocol after code changes for Solidity projects. Use after any code modification to ensure quality.
---

# Post-Change Verification Protocol

This skill defines the mandatory verification steps that Solidity agents must perform after modifying code files.

## When to Use

Use this skill ALWAYS when:
- Creating new contract files
- Modifying existing contracts
- Refactoring code
- Generating code

Do NOT use when:
- Only reading/analyzing code (no modifications)
- Generating documentation only
- Running security audits (read-only)

## Framework Detection

Before running commands, detect the project's framework:

| Indicator | Framework | Tools |
|-----------|-----------|-------|
| `foundry.toml` | Foundry | `forge fmt`, `forge build`, `forge test` |
| `hardhat.config.js/ts` | Hardhat | `npx prettier`, `npx hardhat compile`, `npx hardhat test` |
| Both files exist | Hybrid | Use Foundry for contracts, Hardhat for deployment |

**Detection Order:** Check for `foundry.toml` first, then `hardhat.config.*`.

## Protocol Steps

After completing code changes, agents MUST execute these steps IN ORDER:

### Step 1: Format Code

**Foundry:**
```bash
forge fmt
```

**Hardhat:**
```bash
npx prettier --write "contracts/**/*.sol"
```

**Purpose:** Ensure consistent code formatting across contracts.

### Step 2: Run Linter

```bash
solhint "src/**/*.sol"
# or for Hardhat projects
solhint "contracts/**/*.sol"
```

**Purpose:** Detect code quality issues, potential vulnerabilities, and style violations.

### Step 3: Compile (Type Check)

**Foundry:**
```bash
forge build
```

**Hardhat:**
```bash
npx hardhat compile
```

**Purpose:** Verify contracts compile without errors. Catches type errors and syntax issues.

### Step 4: Run Related Tests

**Foundry:**
```bash
forge test --match-path "test/ModifiedContract.t.sol"
# or run all tests
forge test
```

**Hardhat:**
```bash
npx hardhat test test/ModifiedContract.test.ts
# or run all tests
npx hardhat test
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

**Scenario 1:** You add a new function and the linter reports a visibility issue in your new code.
- **Action:** Fix it immediately (issue caused by your changes)

**Scenario 2:** You modify a contract and discover a pre-existing lint warning (3 lines to fix) in a function you touched.
- **Action:** Fix it as part of your work (small fix in modified file)

**Scenario 3:** You modify a contract and discover 50+ lines of lint warnings throughout the file.
- **Action:** Document the issues, complete your task, recommend separate cleanup task

**Scenario 4:** Lint reports warnings in a contract you did not modify.
- **Action:** Document the issues in output, proceed with task completion

## Verification Output Format

Report verification results using this consistent format:

```
=== POST-CHANGE VERIFICATION ===

Format:     [PASSED | FAILED | SKIPPED (reason)]
Lint:       [PASSED | FAILED] ([X] errors, [Y] warnings)
Compile:    [PASSED | FAILED] ([X] errors)
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
Compile:    PASSED (0 errors)
Tests:      PASSED (15/15)

Pre-existing issues: NONE

=== TASK COMPLETE ===
```

### Example: Pre-existing Issues Found

```
=== POST-CHANGE VERIFICATION ===

Format:     PASSED
Lint:       FAILED (0 errors caused by this change)
Compile:    PASSED (0 errors)
Tests:      PASSED (15/15)

Pre-existing issues (not caused by this change):
- src/legacy/OldToken.sol: Line 45 - func-visibility: Consider adding visibility specifier
- src/utils/Helper.sol: Lines 78-92 - reason-string: Missing error message

These issues require structural changes beyond the scope of this task.
Recommend creating a separate cleanup task.

=== TASK COMPLETE ===
```

### Example: Issues Caused by Changes

```
=== POST-CHANGE VERIFICATION ===

Format:     PASSED
Lint:       FAILED (2 errors, 1 warning)
Compile:    FAILED (1 error)
Tests:      FAILED (13/15)

Issues to fix:
- src/Token.sol: Line 23 - ParserError: Expected ';' but got '{'
- src/Token.sol: Line 45 - not-rely-on-time: Avoid using block.timestamp
- src/Token.sol: Line 67 - Missing NatSpec documentation

=== VERIFICATION FAILED - FIX ISSUES BEFORE COMPLETING ===
```

## Graceful Degradation

Handle missing or failing commands gracefully:

| Situation | Status | Action |
|-----------|--------|--------|
| Command not found | `SKIPPED (command not found)` | Note and proceed to next step |
| Command timeout (> 5 min) | `SKIPPED (timeout)` | Note and proceed to next step |
| Execution error | `SKIPPED (execution error: [reason])` | Note and proceed to next step |

### Example: Missing Linter

```
=== POST-CHANGE VERIFICATION ===

Format:     PASSED
Lint:       SKIPPED (command not found - solhint not installed)
Compile:    PASSED (0 errors)
Tests:      PASSED (15/15)

Pre-existing issues: NONE

Note: Consider installing solhint for full quality verification.

=== TASK COMPLETE ===
```

## Makefile Integration (Foundry)

Foundry projects SHOULD use Makefile for build operations. Ensure these targets exist:

```makefile
.PHONY: fmt lint build test verify

fmt:
	forge fmt

lint:
	solhint "src/**/*.sol"

build:
	forge build

test:
	forge test

# Combined verification target
verify: fmt lint build test
```

If Makefile targets are missing, fall back to direct commands but note in output.

## Best Practices

1. **Run all steps in order** - Each step may reveal different issues
2. **Fix your own issues first** - Never leave broken code from your changes
3. **Document pre-existing issues clearly** - Help future cleanup efforts
4. **Use the 10-line rule consistently** - Small fixes improve code health, large fixes need dedicated tasks
5. **Report honestly** - Verification results are informational, not judgmental
6. **Security before optimization** - Never skip verification for speed

## Code Review Checklist

Before completing any code-modifying task:

- [ ] Format check passed (`forge fmt` or `npx prettier`)
- [ ] Lint check passed (or pre-existing issues documented)
- [ ] Compile check passed (or pre-existing issues documented)
- [ ] Tests passed (or pre-existing issues documented)
- [ ] All issues caused by changes are fixed
- [ ] Pre-existing issues clearly documented
- [ ] Verification output included in task completion
