# Code Quality Enforcement Audit

**Date:** 2025-12-31
**Scope:** All tech stacks (Go, JS Common, Node, React, React Native, Solidity)
**Purpose:** Ensure all agents that modify code enforce proper formatting, linting, type-checking, and testing

---

## Executive Summary

This audit reviewed all 6 tech stacks and 35 agents in the molcajete.ai project to assess code quality enforcement. The goal is to ensure that every agent that touches code:

1. Formats code using the stack-specific formatter
2. Runs type checking and linting after changes
3. Runs tests related to modified files
4. Leaves no errors or warnings (with documented exceptions)

### Key Findings

| Stack | Formatter | Linter | Type Check | Test Enforcement | Post-Change Protocol |
|-------|-----------|--------|------------|------------------|---------------------|
| Go | Documented | Documented | Built-in | Partial | Missing |
| JS Common | Documented | Documented | Documented | Partial | Missing |
| Node | Inherited | Inherited | Inherited | Partial | Missing |
| React | Inherited | Inherited | Inherited | Partial | Missing |
| React Native | Inherited | Inherited | Inherited | Partial | Missing |
| Solidity | Missing | Missing | Compiler only | Documented | Missing |

### Critical Gaps

1. **No standardized Post-Change Verification Protocol** - Agents mention running checks but lack a mandatory, structured workflow
2. **No explicit zero-tolerance enforcement** - Warnings are mentioned but not strictly enforced
3. **No guidance on pre-existing issues** - No documented exception for issues not caused by current changes
4. **Solidity stack missing formatter/linter** - `forge fmt` and `solhint` not documented
5. **Test scope not defined** - No requirement to run tests related to modified files specifically

---

## Current State Analysis

### 1. Go Stack

**Location:** `/tech-stacks/go/`

#### Tools Documented

| Tool | Command | Status |
|------|---------|--------|
| Formatter | `go fmt ./...` or `make fmt` | Documented in developer agent |
| Linter | `golangci-lint run` or `make lint` | Documented in lint command |
| Type Checker | Built into `go build` | Implicit |
| Test Runner | `go test ./...` or `make test` | Documented in tester agent |

#### Current Agent Instructions

**developer.md** (lines 6-7):
```markdown
6. **Format code** - **ALWAYS run `go fmt` or `make fmt` after file changes**
7. **Build with Makefile** - **ALWAYS use `make build`, NEVER `go build` directly**
```

**Workflow Pattern** (lines 45-52):
```markdown
1. Analyze project structure
2. Understand current requirements (apply YAGNI - no future speculation)
3. Implement simple, readable solution (apply KISS)
4. Run `go fmt ./...` or `make fmt` to format code
5. Use Makefile to build (e.g., `make build`)
6. Verify binary is in `./bin/` directory
7. Run tests with `make test`
8. Document with godoc comments
```

#### Gaps Identified

1. **Linting not in workflow** - `make lint` not included in developer workflow
2. **No explicit verification step** - No step to verify zero errors/warnings
3. **No guidance on pre-existing issues** - What if `golangci-lint` reports issues from other files?
4. **Test scope unclear** - Says "run tests" but not "run tests for modified files"

---

### 2. JS Common Stack

**Location:** `/tech-stacks/js/common/`

#### Tools Documented

| Tool | Command | Status |
|------|---------|--------|
| Formatter | `npm run format` (Biome or Prettier) | Documented |
| Linter | `npm run lint` (Biome or ESLint) | Documented |
| Type Checker | `npm run type-check` (tsc --noEmit) | Documented |
| Test Runner | `npm test` (Vitest) | Documented |
| Full Validation | `npm run validate` | Documented |

#### Current Agent Instructions

**developer.md** Workflow Pattern:
```markdown
1. Analyze requirements (ask for clarification if needed)
2. Design types first (interfaces, types, generics)
3. Implement logic with strict typing
4. Run type-checker: `npm run type-check`
5. Run linter: `npm run lint`
6. Run formatter: `npm run format`
7. Run tests: `npm test`
8. Verify zero errors/warnings
```

**quality-guardian.md** Core Responsibilities:
```markdown
1. **Run type-checker** - Zero TypeScript errors allowed
2. **Enforce linting** - Zero warnings policy
3. **Validate formatting** - Consistent code style
4. **Configure pre-commit** - Quality gates before commits
5. **Block bad code** - Reject code that doesn't meet standards
```

#### Gaps Identified

1. **Developer workflow mentions steps but no enforcement** - Step 8 says "Verify zero errors/warnings" but no instruction on what to do if there are errors
2. **quality-guardian is separate agent** - Developers should enforce quality themselves, not rely on another agent
3. **No guidance on pre-existing issues** - What if linter reports issues in files not modified?
4. **Test scope unclear** - Should run tests for modified files, not full suite every time

---

### 3. Node Stack

**Location:** `/tech-stacks/js/node/`

#### Inheritance

Inherits from `js/common`:
- All tools (Biome/ESLint, Prettier, TSC, Vitest)
- All quality standards
- Quality Guardian agent

#### Current Agent Instructions

**api-builder.md** Workflow Pattern:
```markdown
1. Gather requirements (use AskUserQuestion tool)
2. Design API schema with Zod
3. Implement routes with type-safe handlers
4. Add middleware (auth, validation, logging)
5. Write integration tests
6. Run validation: `npm run type-check && npm run lint && npm test`
```

#### Gaps Identified

1. **Formatting step missing** - Step 6 doesn't include `npm run format`
2. **No enforcement instruction** - Doesn't specify what to do if validation fails
3. **No guidance on pre-existing issues**

---

### 4. React Stack

**Location:** `/tech-stacks/js/react/`

#### Inheritance

Inherits from `js/common`:
- All tools
- All quality standards

#### Current Agent Instructions

**component-builder.md** Workflow Pattern:
```markdown
1. Analyze component requirements
2. Design props interface with TypeScript
3. **Determine atomic level** using classification criteria above
4. Determine Server vs Client Component (if Next.js)
5. Implement component in correct atomic directory
6. Add accessibility attributes
7. **Generate Storybook story** (if Atom, Molecule, or Organism)
8. Create unit tests
9. **Update barrel export** at the atomic level (e.g., `atoms/index.ts`)
10. Run type-check and lint
11. Verify tests pass
```

**refactor-atomic-design.md** Phase 6 - Verification:
```markdown
1. Run type-check:
   npm run type-check   # or tsc --noEmit

2. Run lint:
   npm run lint

3. Run tests:
   npm test

4. Display completion summary
```

#### Gaps Identified

1. **Formatting step missing from workflow** - Step 10 says "type-check and lint" but not format
2. **No enforcement instruction** - Phase 6 runs checks but doesn't require zero errors
3. **Refactor command doesn't stop on errors** - Shows results but continues regardless
4. **No guidance on pre-existing issues**

---

### 5. React Native Stack

**Location:** `/tech-stacks/js/react-native/`

#### Inheritance

Inherits from `js/common`:
- Biome (preferred over ESLint for React Native)
- TSC
- Jest (not Vitest, due to React Native)

#### Current Agent Instructions

**component-builder.md** Workflow Pattern:
```markdown
1. Analyze component requirements
2. Design props interface with TypeScript
3. **Determine atomic level** using mobile classification criteria above
4. Implement component in correct atomic directory
5. **Ensure accessibility** (44pt touch targets, accessibility props)
6. Add platform-specific handling if needed
7. **Generate Storybook story** (if Atom, Molecule, or Organism)
8. Create unit tests with accessibility assertions
9. **Update barrel export** at the atomic level
10. Run type-check and lint
11. Verify tests pass
```

#### Gaps Identified

1. **Same issues as React stack** - Formatting missing, no enforcement
2. **Jest vs Vitest discrepancy** - PLUGIN.md mentions Vitest but React Native uses Jest

---

### 6. Solidity Stack

**Location:** `/tech-stacks/solidity/`

#### Tools Documented

| Tool | Command | Status |
|------|---------|--------|
| Formatter | Not documented | **MISSING** |
| Linter | Not documented | **MISSING** |
| Type Checker | Built into compiler | Implicit |
| Test Runner | `forge test` or `npx hardhat test` | Documented |

#### Current Agent Instructions

**developer.md** Workflow Pattern:
```markdown
1. Detect framework (Foundry/Hardhat/Hybrid)
2. Read specification if provided by orchestrator
3. Implement contract following all security and quality standards
4. Apply gas optimization techniques
5. Add comprehensive NatSpec documentation
6. Compile and verify (no errors/warnings)
```

#### Gaps Identified

1. **Formatter not documented** - Should use `forge fmt` (Foundry) or Prettier Solidity plugin
2. **Linter not documented** - Should use `solhint` for Solidity linting
3. **No explicit linting step** - Step 6 only mentions compile
4. **Test step missing** - Workflow ends at compile, no test verification

---

## Recommended Changes

### 1. Create Post-Change Verification Protocol Skill

Create a new skill that all code-modifying agents must reference.

**File:** `/tech-stacks/common/skills/post-change-verification/SKILL.md`

```markdown
---
name: post-change-verification
description: Mandatory verification protocol after code changes. All code-modifying agents MUST reference this skill.
---

# Post-Change Verification Protocol

This skill defines the mandatory verification steps that ALL agents must perform after modifying code files.

## When to Use

Use this skill ALWAYS when:
- Creating new code files
- Modifying existing code files
- Refactoring code
- Generating code

## Protocol Steps

After completing code changes, agents MUST execute these steps IN ORDER:

### Step 1: Format Code

Run the stack-specific formatter on modified files:

| Stack | Command |
|-------|---------|
| Go | `go fmt ./...` or `make fmt` |
| JavaScript/TypeScript | `npm run format` or `npx biome format --write .` |
| Solidity | `forge fmt` or `npx prettier --write "**/*.sol"` |

### Step 2: Run Linter

Run the stack-specific linter:

| Stack | Command |
|-------|---------|
| Go | `golangci-lint run` or `make lint` |
| JavaScript/TypeScript | `npm run lint` or `npx biome check .` |
| Solidity | `solhint "contracts/**/*.sol"` |

### Step 3: Run Type Checker

Run the stack-specific type checker:

| Stack | Command |
|-------|---------|
| Go | Built into `go build` |
| JavaScript/TypeScript | `npm run type-check` or `npx tsc --noEmit` |
| Solidity | Built into `forge build` or `npx hardhat compile` |

### Step 4: Run Related Tests

Run tests specifically for modified files:

| Stack | Command |
|-------|---------|
| Go | `go test ./path/to/modified/...` |
| JavaScript/TypeScript | `npm test -- --changed` or `npx vitest related` |
| Solidity | `forge test --match-path "test/ModifiedContract.t.sol"` |

### Step 5: Verify Zero Issues

**CRITICAL:** All steps must complete with ZERO errors and ZERO warnings.

If issues are found:
1. Fix all issues caused by current changes
2. For pre-existing issues, see Exception Handling below

## Exception Handling

### Pre-Existing Issues Not Caused by Current Changes

If verification reveals errors or warnings that:
- Existed before the current changes
- Are in files not modified by current changes
- Would require significant structural changes to fix

Then the agent MUST:

1. **Document the issue** - Note the specific error/warning
2. **Assess scope** - Determine if fixing would be a small or large change
3. **Small fixes (< 10 lines)** - Fix them as part of current work
4. **Large fixes (> 10 lines or structural)** - Do NOT fix. Instead:
   - Complete current task
   - Report the pre-existing issues to the user
   - Suggest creating a separate task to address them

**Example Report:**
```
TASK COMPLETED with pre-existing issues noted:

The following issues existed before this change and require separate attention:
- src/utils/legacy.ts: Line 45 - 'data' has implicit 'any' type
- src/api/client.ts: Lines 78-92 - Missing error handling

These issues require structural changes beyond the scope of this task.
Recommend creating a separate cleanup task.
```

## Verification Checklist

Before marking a task complete, verify:

- [ ] Code is formatted (formatter ran without changes needed)
- [ ] Linter passes with zero errors and zero warnings
- [ ] Type checker passes with zero errors
- [ ] Related tests pass (100% of affected tests)
- [ ] Any pre-existing issues are documented (if applicable)

## Integration with Agent Workflows

All code-modifying agents must include this in their workflow:

```markdown
## Workflow Pattern

1. [Agent-specific steps...]
2. ...
3. **Post-Change Verification** (MANDATORY - reference post-change-verification skill)
   - Format code
   - Run linter (zero warnings required)
   - Run type checker (zero errors required)
   - Run related tests (all must pass)
   - Document any pre-existing issues
4. Report completion status
```
```

---

### 2. Update Go Developer Agent

**File:** `/tech-stacks/go/agents/developer.md`

Add to Required Skills section:
```markdown
**post-change-verification skill:**
- Mandatory verification protocol after code changes
- Format, lint, type-check, test sequence
- Zero tolerance for errors/warnings
- Exception handling for pre-existing issues
```

Replace Workflow Pattern:
```markdown
## Workflow Pattern

1. Analyze project structure
2. Understand current requirements (apply YAGNI - no future speculation)
3. Implement simple, readable solution (apply KISS)
4. **Post-Change Verification** (MANDATORY - reference post-change-verification skill):
   a. Run `make fmt` to format code
   b. Run `make lint` to lint code (ZERO warnings required)
   c. Run `make build` to verify compilation
   d. Run `make test` for affected packages
   e. Verify ZERO errors and ZERO warnings
   f. Document any pre-existing issues not caused by this change
5. Document with godoc comments
6. Report completion status with verification results
```

---

### 3. Update JS Common Developer Agent

**File:** `/tech-stacks/js/common/agents/developer.md`

Add to Required Skills section:
```markdown
**post-change-verification skill:**
- Mandatory verification protocol after code changes
- Format, lint, type-check, test sequence
- Zero tolerance for errors/warnings
- Exception handling for pre-existing issues
```

Replace Workflow Pattern:
```markdown
## Workflow Pattern

1. Analyze requirements (ask for clarification if needed)
2. Design types first (interfaces, types, generics)
3. Implement logic with strict typing
4. **Post-Change Verification** (MANDATORY - reference post-change-verification skill):
   a. Run `npm run format` to format code
   b. Run `npm run lint` to lint code (ZERO warnings required)
   c. Run `npm run type-check` for type verification (ZERO errors required)
   d. Run `npm test -- --changed` for affected tests
   e. Verify ZERO errors and ZERO warnings
   f. Document any pre-existing issues not caused by this change
5. Report completion status with verification results
```

---

### 4. Update Node API Builder Agent

**File:** `/tech-stacks/js/node/agents/api-builder.md`

Replace step 6 in Workflow Pattern:
```markdown
## Workflow Pattern

1. Gather requirements (use AskUserQuestion tool)
2. Design API schema with Zod
3. Implement routes with type-safe handlers
4. Add middleware (auth, validation, logging)
5. Write integration tests
6. **Post-Change Verification** (MANDATORY - reference post-change-verification skill):
   a. Run `npm run format` to format code
   b. Run `npm run lint` to lint code (ZERO warnings required)
   c. Run `npm run type-check` for type verification (ZERO errors required)
   d. Run `npm test -- --changed` for affected tests
   e. Run `npm run test:integration` if integration tests exist
   f. Verify ZERO errors and ZERO warnings
   g. Document any pre-existing issues not caused by this change
7. Report completion status with verification results
```

---

### 5. Update React Component Builder Agent

**File:** `/tech-stacks/js/react/agents/component-builder.md`

Replace workflow steps 10-11:
```markdown
## Workflow Pattern

1. Analyze component requirements
2. Design props interface with TypeScript
3. **Determine atomic level** using classification criteria above
4. Determine Server vs Client Component (if Next.js)
5. Implement component in correct atomic directory
6. Add accessibility attributes
7. **Generate Storybook story** (if Atom, Molecule, or Organism)
8. Create unit tests
9. **Update barrel export** at the atomic level (e.g., `atoms/index.ts`)
10. **Post-Change Verification** (MANDATORY - reference post-change-verification skill):
    a. Run `npm run format` to format code
    b. Run `npm run lint` to lint code (ZERO warnings required)
    c. Run `npm run type-check` for type verification (ZERO errors required)
    d. Run `npm test -- --changed` for affected tests
    e. Verify ZERO errors and ZERO warnings
    f. Document any pre-existing issues not caused by this change
11. Report completion status with verification results
```

---

### 6. Update React Native Component Builder Agent

**File:** `/tech-stacks/js/react-native/agents/component-builder.md`

Replace workflow steps 10-11:
```markdown
## Workflow Pattern

1. Analyze component requirements
2. Design props interface with TypeScript
3. **Determine atomic level** using mobile classification criteria above
4. Implement component in correct atomic directory
5. **Ensure accessibility** (44pt touch targets, accessibility props)
6. Add platform-specific handling if needed
7. **Generate Storybook story** (if Atom, Molecule, or Organism)
8. Create unit tests with accessibility assertions
9. **Update barrel export** at the atomic level
10. **Post-Change Verification** (MANDATORY - reference post-change-verification skill):
    a. Run `npm run format` to format code
    b. Run `npm run lint` to lint code (ZERO warnings required)
    c. Run `npm run type-check` for type verification (ZERO errors required)
    d. Run `npm test -- --changed` for affected tests
    e. Verify ZERO errors and ZERO warnings
    f. Document any pre-existing issues not caused by this change
11. Report completion status with verification results
```

---

### 7. Update Solidity Developer Agent

**File:** `/tech-stacks/solidity/agents/developer.md`

Add to Required Skills section:
```markdown
**post-change-verification skill:**
- Mandatory verification protocol after code changes
- Format, lint, compile, test sequence
- Zero tolerance for errors/warnings
- Exception handling for pre-existing issues
```

Replace Workflow Pattern:
```markdown
## Workflow Pattern

1. Detect framework (Foundry/Hardhat/Hybrid)
2. Read specification if provided by orchestrator
3. Implement contract following all security and quality standards
4. Apply gas optimization techniques
5. Add comprehensive NatSpec documentation
6. **Post-Change Verification** (MANDATORY - reference post-change-verification skill):
   a. Run formatter:
      - Foundry: `forge fmt`
      - Hardhat: `npx prettier --write "contracts/**/*.sol"`
   b. Run linter:
      - `solhint "contracts/**/*.sol"` (ZERO warnings required)
   c. Run compiler:
      - Foundry: `forge build`
      - Hardhat: `npx hardhat compile`
   d. Run related tests:
      - Foundry: `forge test --match-contract ModifiedContract`
      - Hardhat: `npx hardhat test test/ModifiedContract.test.ts`
   e. Verify ZERO errors and ZERO warnings
   f. Document any pre-existing issues not caused by this change
7. Report completion status with verification results
```

---

### 8. Add Solidity Formatter/Linter Documentation

**File:** `/tech-stacks/solidity/PLUGIN.md`

Add new section after "Commands":
```markdown
## Code Quality Tools

### Formatter

**Foundry (forge fmt):**
```bash
# Format all contracts
forge fmt

# Check formatting without changes
forge fmt --check
```

**Prettier (for Hardhat or hybrid projects):**
```bash
# Install
npm install --save-dev prettier prettier-plugin-solidity

# Format
npx prettier --write "contracts/**/*.sol"

# Check
npx prettier --check "contracts/**/*.sol"
```

### Linter

**Solhint:**
```bash
# Install
npm install --save-dev solhint

# Initialize config
npx solhint --init

# Run linter
solhint "contracts/**/*.sol"
```

**Recommended .solhint.json:**
```json
{
  "extends": "solhint:recommended",
  "rules": {
    "compiler-version": ["error", "^0.8.0"],
    "func-visibility": ["warn", {"ignoreConstructors": true}],
    "not-rely-on-time": "warn",
    "reason-string": ["warn", {"maxLength": 64}]
  }
}
```

### Quality Commands

Add to package.json or Makefile:

**Foundry (Makefile):**
```makefile
fmt:
	forge fmt

lint:
	solhint "src/**/*.sol"

check:
	forge fmt --check
	solhint "src/**/*.sol"
	forge build
	forge test
```

**Hardhat (package.json):**
```json
{
  "scripts": {
    "format": "prettier --write \"contracts/**/*.sol\"",
    "format:check": "prettier --check \"contracts/**/*.sol\"",
    "lint": "solhint \"contracts/**/*.sol\"",
    "compile": "hardhat compile",
    "test": "hardhat test",
    "validate": "npm run format:check && npm run lint && npm run compile && npm run test"
  }
}
```
```

---

### 9. Update Refactor Commands

**File:** `/tech-stacks/js/react/commands/refactor-atomic-design.md`

Update Phase 6 - Verification:
```markdown
### Phase 6: Verification (MANDATORY - Must Pass)

1. Run type-check:
   ```bash
   npm run type-check   # or tsc --noEmit
   ```
   **REQUIRED:** Zero errors. If errors exist, fix them before proceeding.

2. Run lint:
   ```bash
   npm run lint
   ```
   **REQUIRED:** Zero errors and zero warnings. If issues exist, fix them before proceeding.

3. Run formatter:
   ```bash
   npm run format
   ```

4. Run tests:
   ```bash
   npm test
   ```
   **REQUIRED:** All tests must pass.

5. **If any check fails:**
   - Stop execution
   - Report specific failures
   - Provide fix suggestions
   - Ask user how to proceed (fix issues or abort)

6. **If pre-existing issues found** (not caused by refactoring):
   - Document them clearly
   - Assess if they are small (< 10 lines) or large fixes
   - Small fixes: Include in refactoring
   - Large fixes: Report separately, recommend follow-up task

7. Display completion summary:
   ```
   === REFACTORING COMPLETE ===

   Files changed: 47
   Components moved: 24
   Stories created: 19
   Barrel exports updated: 5

   Quality Checks:
   - Type-check: PASSED (0 errors)
   - Lint: PASSED (0 errors, 0 warnings)
   - Format: PASSED (all files formatted)
   - Tests: PASSED (24/24)

   Pre-existing issues (not caused by this refactoring): NONE

   Next steps:
   1. Run `npm run storybook` to verify stories
   2. Review the changes in your git diff
   3. Commit when satisfied
   ```
```

---

## Implementation Guidelines

### Phase 1: Create Core Skill (Priority: High)

1. Create `/tech-stacks/common/` directory structure
2. Create `post-change-verification` skill with full documentation
3. Test skill integration with one agent (recommend: JS Common developer)

### Phase 2: Update JavaScript Stacks (Priority: High)

1. Update JS Common developer agent
2. Update JS Common tester agent
3. Update Node API builder agent
4. Update React component builder agent
5. Update React Native component builder agent
6. Update all JS refactor commands

### Phase 3: Update Go Stack (Priority: Medium)

1. Update Go developer agent
2. Update Go tester agent
3. Update Go API builder agent
4. Ensure Makefile targets exist for all quality checks

### Phase 4: Update Solidity Stack (Priority: Medium)

1. Add formatter/linter documentation to PLUGIN.md
2. Update Solidity developer agent
3. Update Solidity tester agent
4. Create new lint and format commands

### Phase 5: Verification (Priority: High)

1. Audit all 35 agents for compliance
2. Create checklist for future agent development
3. Add CI check for agent compliance (optional)

---

## Files to Create/Modify

### New Files

| File | Description |
|------|-------------|
| `/tech-stacks/common/skills/post-change-verification/SKILL.md` | Core verification protocol skill |
| `/tech-stacks/solidity/commands/fmt.md` | Solidity format command |
| `/tech-stacks/solidity/commands/solhint.md` | Solidity lint command |

### Files to Modify

| File | Changes Required |
|------|------------------|
| `/tech-stacks/go/agents/developer.md` | Add skill reference, update workflow |
| `/tech-stacks/go/agents/api-builder.md` | Add skill reference, update workflow |
| `/tech-stacks/go/agents/tester.md` | Add verification step |
| `/tech-stacks/js/common/agents/developer.md` | Add skill reference, update workflow |
| `/tech-stacks/js/common/agents/tester.md` | Add verification step |
| `/tech-stacks/js/node/agents/api-builder.md` | Add skill reference, update workflow |
| `/tech-stacks/js/node/agents/database-architect.md` | Add skill reference, update workflow |
| `/tech-stacks/js/react/agents/component-builder.md` | Add skill reference, update workflow |
| `/tech-stacks/js/react/agents/state-architect.md` | Add skill reference, update workflow |
| `/tech-stacks/js/react/commands/refactor-atomic-design.md` | Update verification phase |
| `/tech-stacks/js/react-native/agents/component-builder.md` | Add skill reference, update workflow |
| `/tech-stacks/js/react-native/commands/refactor-atomic-design.md` | Update verification phase |
| `/tech-stacks/solidity/PLUGIN.md` | Add formatter/linter documentation |
| `/tech-stacks/solidity/agents/developer.md` | Add skill reference, update workflow |
| `/tech-stacks/solidity/agents/tester.md` | Add verification step |

---

## Appendix A: Complete Agent List Requiring Updates

### Go Stack (8 agents)
1. `go:developer` - Needs post-change verification
2. `go:tester` - Needs verification step
3. `go:optimizer` - Needs verification step
4. `go:api-builder` - Needs post-change verification
5. `go:debugger` - Read-only, no changes needed
6. `go:documenter` - Needs verification step
7. `go:deployer` - No code changes, no updates needed
8. `go:security` - Read-only, no changes needed

### JS Common Stack (5 agents)
1. `developer` - Needs post-change verification
2. `tester` - Needs verification step
3. `quality-guardian` - Already focused on quality, minor updates
4. `documenter` - Needs verification step
5. `security` - Read-only, no changes needed

### Node Stack (3 agents)
1. `node:api-builder` - Needs post-change verification
2. `node:database-architect` - Needs post-change verification
3. `node:deployer` - No code changes, no updates needed

### React Stack (5 agents)
1. `react:component-builder` - Needs post-change verification
2. `react:state-architect` - Needs post-change verification
3. `react:ui-designer` - Needs post-change verification
4. `react:performance-optimizer` - Needs verification step
5. `react:e2e-tester` - Needs verification step

### React Native Stack (6 agents)
1. `react-native:component-builder` - Needs post-change verification
2. `react-native:ui-designer` - Needs post-change verification
3. `react-native:navigation-architect` - Needs post-change verification
4. `react-native:performance-optimizer` - Needs verification step
5. `react-native:e2e-tester` - Needs verification step
6. `react-native:code-analyzer` - Read-only, no changes needed

### Solidity Stack (7 agents)
1. `sol:developer` - Needs post-change verification + formatter/linter
2. `sol:tester` - Needs verification step
3. `sol:auditor` - Read-only, no changes needed
4. `sol:gas-optimizer` - Needs verification step
5. `sol:deployer` - No code changes, no updates needed
6. `sol:upgrader` - Needs post-change verification
7. `sol:debugger` - Read-only, no changes needed

---

## Appendix B: Quality Check Commands by Stack

### Go

```bash
# Format
make fmt
# or
go fmt ./...

# Lint
make lint
# or
golangci-lint run

# Build (includes type check)
make build

# Test
make test
# or
go test ./...

# Test specific package
go test ./pkg/mypackage/...

# Full validation
make fmt && make lint && make build && make test
```

### JavaScript/TypeScript (All JS Stacks)

```bash
# Format
npm run format
# or
npx biome format --write .

# Lint
npm run lint
# or
npx biome check .

# Type check
npm run type-check
# or
npx tsc --noEmit

# Test
npm test
# or
npx vitest run

# Test changed files only
npm test -- --changed
# or
npx vitest related

# Full validation
npm run validate
# or
npm run type-check && npm run lint && npm run format:check && npm test
```

### Solidity (Foundry)

```bash
# Format
forge fmt

# Lint
solhint "src/**/*.sol"

# Compile (includes type check)
forge build

# Test
forge test

# Test specific contract
forge test --match-contract MyContract

# Full validation
forge fmt --check && solhint "src/**/*.sol" && forge build && forge test
```

### Solidity (Hardhat)

```bash
# Format
npx prettier --write "contracts/**/*.sol"

# Lint
solhint "contracts/**/*.sol"

# Compile
npx hardhat compile

# Test
npx hardhat test

# Test specific file
npx hardhat test test/MyContract.test.ts

# Full validation
npm run validate
```

---

## Appendix C: Exception Handling Decision Tree

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
