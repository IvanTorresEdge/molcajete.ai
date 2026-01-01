# Code Quality Enforcement - Specification

**Created:** 2025-12-31
**Last Updated:** 2026-01-01
**Status:** Complete

## Overview

### Feature Description

Code Quality Enforcement establishes a standardized Post-Change Verification Protocol that ensures all code-modifying agents in the Molcajete.ai plugin ecosystem consistently enforce formatting, linting, type-checking, and testing after every code change. This feature creates stack-specific verification skills within each tech stack (Go, JS Common, Solidity), ensuring agents only see commands relevant to their stack while following a consistent protocol structure.

Currently, agents have inconsistent quality enforcement - some mention running checks but lack a mandatory, structured workflow. The audit revealed critical gaps: no standardized Post-Change Verification Protocol, no explicit zero-tolerance enforcement, no guidance on pre-existing issues, and the Solidity stack missing formatter/linter documentation. This feature addresses all gaps through stack-specific skills and systematic agent updates.

The implementation follows an advisory enforcement mode where verification results are reported but do not block task completion. This allows users to see exactly what passed and what failed while permitting tasks to complete even when issues are found. Pre-existing issues not caused by current changes are documented rather than blocking legitimate work.

### Strategic Alignment

**Product Mission:** This feature directly supports Molcajete.ai's mission of delivering "consistent, opinionated, and battle-tested workflows" by eliminating variability in code quality enforcement across all agents. When agents consistently verify their work, users receive reliable, production-ready code output every time.

**User Value:** Developers receive code that passes project quality checks without manual intervention. The advisory mode provides transparency into verification results while the 10-line threshold rule ensures current work is not blocked by unrelated technical debt.

**Roadmap Priority:** This falls under "Improve Existing Plugins" in the Now (1-3 months) category. Quality enforcement is foundational infrastructure that improves all code-modifying agents across all tech stacks.

### Requirements Reference

See `.molcajete/prd/specs/20251231-code_quality_enforcement/requirements.md` for detailed user stories, functional requirements, and acceptance criteria.

Detailed implementation guidance available in `.molcajete/research/code-quality-enforcement.md`.

---

## Data Models

### Database Schema (if applicable)

Not applicable. This feature modifies markdown files (agents, skills, commands) and does not require database storage.

### Smart Contract Storage (if applicable)

Not applicable. This feature does not involve smart contracts.

---

## API Contracts

### REST Endpoints (if applicable)

Not applicable. This feature is CLI-based and does not expose REST endpoints.

### Smart Contract Functions (if applicable)

Not applicable. This feature does not involve smart contracts.

---

## User Interface

### Components

Not applicable. This feature is CLI-based with no visual UI components.

### CLI Output Format

#### Component: Verification Results Output

**Purpose:** Display verification results in a consistent, scannable format across all agents.

**Output Structure:**

```
=== POST-CHANGE VERIFICATION ===

Format:     PASSED
Lint:       PASSED (0 errors, 0 warnings)
Type-check: PASSED (0 errors)
Tests:      PASSED (12/12)

Pre-existing issues: NONE

=== TASK COMPLETE ===
```

**States:**

- **All Passed:** Green checkmarks (in supported terminals), clear "PASSED" status
- **Issues Found:** Red markers for failures, specific error messages
- **Pre-existing Issues:** Separate section documenting issues not caused by current changes

**Example with Pre-existing Issues:**

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

### User Flows

#### Flow: Standard Verification

1. **Agent Action:** Completes code modifications
   - **System Response:** Automatically triggers Post-Change Verification Protocol

2. **Agent Action:** Runs format command
   - **System Response:** Reports format status (PASSED/changes applied)

3. **Agent Action:** Runs lint command
   - **System Response:** Reports lint status with error/warning counts

4. **Agent Action:** Runs type-check command
   - **System Response:** Reports type-check status with error count

5. **Agent Action:** Runs test command
   - **System Response:** Reports test status with pass/fail counts

6. **Success:** All checks pass
   - **Alternative:** Issues found - agent reports results and continues

#### Flow: Pre-existing Issue Handling

1. **Agent Action:** Verification finds issues
   - **System Response:** Agent assesses if issues existed before current changes

2. **Agent Action:** Categorizes issues by scope
   - **Validation:** Was issue in a modified file? Is fix small (< 10 lines)?

3. **Agent Action:** Handles issues based on category
   - **Small fix in modified file:** Fix as part of current work
   - **Large fix or unmodified file:** Document and report separately

4. **Success:** Current task completes with clear documentation
   - **Alternative:** User creates separate cleanup task

---

## Integration Points

### External Services

Not applicable. All verification runs locally using project's existing tools. No external API calls or services required.

### Internal Services

#### Service: Tech-Stack Plugin System

**Communication:** File-based (markdown agents referencing markdown skills)

**Integration Pattern:**
- Skills defined within each stack:
  - `/tech-stacks/go/skills/post-change-verification/`
  - `/tech-stacks/js/common/skills/post-change-verification/`
  - `/tech-stacks/solidity/skills/post-change-verification/`
- Agents reference skills via "Required Skills" section
- Skill content loaded when agent executes

**Data Flow:**
1. Agent starts executing task
2. Agent reads referenced skills
3. Agent follows skill protocol (Post-Change Verification)
4. Agent outputs verification results

#### Service: Quality Tool Commands

**Commands by Stack:**

| Stack | Format | Lint | Type-Check | Test |
|-------|--------|------|------------|------|
| Go | `make fmt` | `make lint` | `make build` | `make test` |
| JS/TS | `npm run format` | `npm run lint` | `npm run type-check` | `npm test` |
| Solidity (Foundry) | `forge fmt` | `solhint` | `forge build` | `forge test` |
| Solidity (Hardhat) | `npx prettier` | `solhint` | `npx hardhat compile` | `npx hardhat test` |

**Error Handling:**
- Command not found: Skip step, note in output
- Command timeout (> 5 minutes): Note and proceed
- Command fails: Report specific errors

---

## Acceptance Criteria

### Functional Acceptance

- [ ] Post-Change Verification Protocol skill exists in each stack:
  - `/tech-stacks/go/skills/post-change-verification/SKILL.md`
  - `/tech-stacks/js/common/skills/post-change-verification/SKILL.md`
  - `/tech-stacks/solidity/skills/post-change-verification/SKILL.md`
- [ ] Each skill documents the 5-step verification protocol (format, lint, type-check, test, verify)
- [ ] Each skill includes only the commands relevant to its stack
- [ ] Skill defines exception handling rules for pre-existing issues
- [ ] All code-modifying agents reference the Post-Change Verification Protocol skill
- [ ] Agents report verification results in consistent output format
- [ ] Agents distinguish between issues caused by changes vs pre-existing issues
- [ ] Small pre-existing issues (< 10 lines) are fixed as part of current work
- [ ] Large pre-existing issues are documented and reported separately
- [ ] Missing quality commands (e.g., no `npm run lint`) are noted and skipped gracefully

### Non-Functional Acceptance

- [ ] Verification steps add no more than 30 seconds to typical agent workflows
- [ ] Verification results are easy to scan and understand
- [ ] Same verification protocol works consistently across all agents
- [ ] Running verification twice with no changes produces identical results
- [ ] All verification runs locally with no external service calls

### Business Acceptance

- [ ] Code output from agents passes project quality checks without manual intervention
- [ ] Pre-existing issues are clearly identified and do not block legitimate work
- [ ] Users trust that agent-generated code meets quality standards
- [ ] Consistent code quality across all Molcajete.ai plugins
- [ ] Foundation established for future quality enforcement features

---

## Verification

### Manual Testing Scenarios

#### Scenario 1: Clean JavaScript Project

**Given:** A JavaScript project with all quality tools configured and no existing issues
**When:** Developer uses JS Common developer agent to implement a new feature
**Then:**
- Agent completes implementation
- Agent runs format, lint, type-check, test
- All verification steps pass
- Output shows "PASSED" for all steps
- Task completes successfully

#### Scenario 2: Project with Pre-existing Lint Warnings

**Given:** A JavaScript project with existing lint warnings in `src/utils/legacy.ts` (file not being modified)
**When:** Developer uses JS Common developer agent to implement a new feature in `src/features/new.ts`
**Then:**
- Agent completes implementation
- Verification reports lint warnings
- Agent identifies warnings are in unmodified file
- Output documents pre-existing issues separately
- Task completes with recommendation for separate cleanup task

#### Scenario 3: Small Pre-existing Issue in Modified File

**Given:** A Go project with a minor formatting issue (2 lines) in a file being modified
**When:** Developer uses Go developer agent to add functionality to that file
**Then:**
- Agent completes implementation
- Verification finds formatting issue
- Agent determines issue is small (< 10 lines) and in modified file
- Agent fixes the formatting issue
- Verification re-runs and passes
- Task completes with clean verification

#### Scenario 4: Missing Quality Command

**Given:** A JavaScript project without `npm run lint` script configured
**When:** Developer uses Node API builder agent to create an endpoint
**Then:**
- Agent completes implementation
- Agent attempts to run lint
- Agent notes lint command not found
- Agent skips lint step and continues
- Output shows "SKIPPED (command not found)" for lint
- Remaining verification steps complete normally

#### Scenario 5: Solidity Project with Foundry

**Given:** A Solidity project using Foundry framework
**When:** Developer uses Solidity developer agent to create a contract
**Then:**
- Agent completes implementation
- Agent runs `forge fmt` for formatting
- Agent runs `solhint` for linting
- Agent runs `forge build` for compilation
- Agent runs `forge test` for tests
- All verification steps pass
- Output follows same format as JavaScript projects

#### Scenario 6: Large Pre-existing Issue

**Given:** A TypeScript project with 50+ lines of type errors in a utility file being modified
**When:** Developer uses React component builder agent to update that utility
**Then:**
- Agent completes the requested changes
- Verification finds type errors
- Agent identifies errors are large (> 10 lines) structural issues
- Agent does NOT attempt to fix all errors
- Agent documents the pre-existing issues
- Task completes with clear recommendation for separate cleanup task

### Automated Testing Requirements

- **Unit Tests:** Not applicable (markdown-based feature)
- **Integration Tests:** Manual verification through real project testing
- **E2E Tests:** Test each agent with sample projects during implementation
- **Performance Tests:** Measure verification overhead on sample projects

### Success Metrics

**User Metrics:**
- Task completion rate with clean verification > 80%
- Time to understand verification output < 10 seconds
- User trust in agent-generated code quality increases

**Technical Metrics:**
- Verification overhead < 30 seconds for typical workflows
- All 35 agents audited for compliance
- Zero regressions in existing agent functionality
- Consistent output format across all stacks

**Business Metrics:**
- Reduced debugging time from silent quality issues
- Foundation established for future quality features
- Creator satisfaction with personal workflow improvement

---

## Implementation Notes

### Technical Decisions

- **Decision 1: Advisory enforcement mode** - Verification results are reported but do not block task completion. This respects user autonomy and prevents blocking legitimate work due to unrelated issues.

- **Decision 2: 10-line threshold rule** - Small pre-existing issues (< 10 lines to fix) are fixed as part of current work. Large issues are documented but not addressed. This balances cleanup with task focus.

- **Decision 3: Per-stack skills** - Each tech stack has its own Post-Change Verification Protocol skill containing only the commands relevant to that stack. This keeps agents focused on their stack's tools while maintaining a consistent protocol structure across all skills.

- **Decision 4: No new Solidity commands** - Rather than creating new fmt/lint command files for Solidity, we document formatter/linter setup in PLUGIN.md. This follows existing patterns for JavaScript stacks.

- **Decision 5: Phased rollout** - Implementation proceeds in phases (JS Common -> Node/React/React Native -> Go -> Solidity) to prove value incrementally and catch issues early.

- **Decision 6: JS Common documenter requires conditional verification** - The documenter agent generates documentation and code examples. Verification should run only when code files are created/modified, not for documentation-only changes.

### Known Limitations

- **Assumes quality tools exist** - Projects must have formatters, linters, and test runners already configured. Agents will not install missing tools.

- **No automated migration** - Existing agents must be manually updated to reference the new skill.

- **No verification history** - Results are not stored or logged for historical analysis. This may be added in future analytics feature.

- **Read-only agents excluded** - Agents that only analyze code (debugger, security auditor, code-analyzer) are not updated since they do not modify code.

### Future Enhancements

- **Verification history** - Store verification results for trend analysis and quality improvement tracking.

- **Configurable thresholds** - Allow users to customize the 10-line threshold for pre-existing issue handling.

- **CI integration** - Extend verification protocol for CI/CD pipeline integration.

- **Quality metrics dashboard** - Visual display of code quality trends across projects.

### Security Considerations

- **Local execution only** - All verification commands run locally. No code or results are sent to external services.

- **Safe command execution** - Agents only run documented quality commands. No arbitrary user input is executed as commands.

- **No credential exposure** - Verification does not require or expose any credentials or API keys.

---

## Implementation Phases

### Phase 1: Foundation (MVP) - JS Common Stack

| Task | Description | Files |
|------|-------------|-------|
| 1.1 | Create JS Common Post-Change Verification skill | `/tech-stacks/js/common/skills/post-change-verification/SKILL.md` |
| 1.2 | Update JS Common developer agent | `/tech-stacks/js/common/agents/developer.md` |
| 1.3 | Update JS Common tester agent | `/tech-stacks/js/common/agents/tester.md` |
| 1.4 | Update JS Common quality-guardian agent | `/tech-stacks/js/common/agents/quality-guardian.md` |
| 1.5 | Test integration with real JS project | Manual testing |

### Phase 2: JavaScript Stack Expansion

| Task | Description | Files |
|------|-------------|-------|
| 2.1 | Update Node api-builder agent | `/tech-stacks/js/node/agents/api-builder.md` |
| 2.2 | Update Node database-architect agent | `/tech-stacks/js/node/agents/database-architect.md` |
| 2.3 | Update React component-builder agent | `/tech-stacks/js/react/agents/component-builder.md` |
| 2.4 | Update React state-architect agent | `/tech-stacks/js/react/agents/state-architect.md` |
| 2.5 | Update React refactor-atomic-design command | `/tech-stacks/js/react/commands/refactor-atomic-design.md` |
| 2.6 | Update React Native component-builder agent | `/tech-stacks/js/react-native/agents/component-builder.md` |
| 2.7 | Update React Native refactor-atomic-design command | `/tech-stacks/js/react-native/commands/refactor-atomic-design.md` |

### Phase 3: Go Stack

| Task | Description | Files |
|------|-------------|-------|
| 3.1 | Create Go Post-Change Verification skill | `/tech-stacks/go/skills/post-change-verification/SKILL.md` |
| 3.2 | Update Go developer agent | `/tech-stacks/go/agents/developer.md` |
| 3.3 | Update Go api-builder agent | `/tech-stacks/go/agents/api-builder.md` |
| 3.4 | Update Go tester agent | `/tech-stacks/go/agents/tester.md` |
| 3.5 | Update Go optimizer agent | `/tech-stacks/go/agents/optimizer.md` |
| 3.6 | Update Go documenter agent | `/tech-stacks/go/agents/documenter.md` |

### Phase 4: Solidity Stack

| Task | Description | Files |
|------|-------------|-------|
| 4.1 | Add formatter/linter documentation to Solidity PLUGIN.md | `/tech-stacks/solidity/PLUGIN.md` |
| 4.2 | Create Solidity Post-Change Verification skill | `/tech-stacks/solidity/skills/post-change-verification/SKILL.md` |
| 4.3 | Update Solidity developer agent | `/tech-stacks/solidity/agents/developer.md` |
| 4.4 | Update Solidity tester agent | `/tech-stacks/solidity/agents/tester.md` |
| 4.5 | Update Solidity gas-optimizer agent | `/tech-stacks/solidity/agents/gas-optimizer.md` |
| 4.6 | Update Solidity upgrader agent | `/tech-stacks/solidity/agents/upgrader.md` |

### Phase 5: Verification and Documentation

| Task | Description | Files |
|------|-------------|-------|
| 5.1 | Audit all 35 agents for compliance | Audit document |
| 5.2 | Update any remaining agents | Various |
| 5.3 | Document feature in plugin README | README.md updates |

---

## Post-Change Verification Protocol Skill Content

Each stack has its own Post-Change Verification Protocol skill. Below are the contents for each.

### JavaScript/TypeScript Skill

**Location:** `/tech-stacks/js/common/skills/post-change-verification/SKILL.md`

```markdown
---
name: post-change-verification
description: Mandatory verification protocol after code changes for JavaScript/TypeScript projects.
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

## Protocol Steps

After completing code changes, agents MUST execute these steps IN ORDER:

### Step 1: Format Code

```bash
npm run format
# or
npx biome format --write .
```

### Step 2: Run Linter

```bash
npm run lint
# or
npx biome check .
```

### Step 3: Run Type Checker

```bash
npm run type-check
# or
npx tsc --noEmit
```

### Step 4: Run Related Tests

```bash
npm test -- --changed
# or
npx vitest related
```

### Step 5: Verify Zero Issues

**TARGET:** All steps must complete with ZERO errors and ZERO warnings.

## Exception Handling

[Same as common protocol - see spec for details]

## Verification Output Format

[Same as common protocol - see spec for details]
```

### Go Skill

**Location:** `/tech-stacks/go/skills/post-change-verification/SKILL.md`

```markdown
---
name: post-change-verification
description: Mandatory verification protocol after code changes for Go projects.
---

# Post-Change Verification Protocol

This skill defines the mandatory verification steps that Go agents must perform after modifying code files.

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

## Protocol Steps

After completing code changes, agents MUST execute these steps IN ORDER:

### Step 1: Format Code

```bash
make fmt
# or
go fmt ./...
```

### Step 2: Run Linter

```bash
make lint
# or
golangci-lint run
```

### Step 3: Build (Type Check)

```bash
make build
# or
go build ./...
```

### Step 4: Run Related Tests

```bash
make test
# or
go test ./path/to/modified/...
```

### Step 5: Verify Zero Issues

**TARGET:** All steps must complete with ZERO errors and ZERO warnings.

## Exception Handling

[Same as common protocol - see spec for details]

## Verification Output Format

[Same as common protocol - see spec for details]
```

### Solidity Skill

**Location:** `/tech-stacks/solidity/skills/post-change-verification/SKILL.md`

```markdown
---
name: post-change-verification
description: Mandatory verification protocol after code changes for Solidity projects.
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
- Running security audits

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

### Step 2: Run Linter

```bash
solhint "contracts/**/*.sol"
# or for Foundry projects
solhint "src/**/*.sol"
```

### Step 3: Compile (Type Check)

**Foundry:**
```bash
forge build
```

**Hardhat:**
```bash
npx hardhat compile
```

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

### Step 5: Verify Zero Issues

**TARGET:** All steps must complete with ZERO errors and ZERO warnings.

## Exception Handling

[Same as common protocol - see spec for details]

## Verification Output Format

[Same as common protocol - see spec for details]
```

### Common Protocol Elements

All skills share these common elements:

#### Exception Handling Decision Tree

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

#### Verification Output Format

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

#### Graceful Degradation

- **Missing Commands:** Skip step, report as "SKIPPED (command not found)"
- **Command Timeout (> 5 min):** Skip step, report as "SKIPPED (timeout)"
- **Execution Error:** Skip step, report as "SKIPPED (execution error: [reason])"

---

## Agent Update Patterns

### Example: JS Common Developer Agent Update

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

### Example: Go Developer Agent Update

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

## Solidity PLUGIN.md Addition

Add new section after "Commands" in `/tech-stacks/solidity/PLUGIN.md`:

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

## Complete Agent List

### Agents Requiring Updates (Code-Modifying)

| Stack | Agent | Update Required |
|-------|-------|-----------------|
| Go | developer | Add skill reference, update workflow |
| Go | api-builder | Add skill reference, update workflow |
| Go | tester | Add verification step |
| Go | optimizer | Add verification step |
| Go | documenter | Add verification step |
| JS Common | developer | Add skill reference, update workflow |
| JS Common | tester | Add verification step |
| JS Common | quality-guardian | Minor alignment updates |
| Node | api-builder | Add skill reference, update workflow |
| Node | database-architect | Add skill reference, update workflow |
| React | component-builder | Add skill reference, update workflow |
| React | state-architect | Add skill reference, update workflow |
| React | ui-designer | Add skill reference, update workflow |
| React | performance-optimizer | Add verification step |
| React | e2e-tester | Add verification step |
| React Native | component-builder | Add skill reference, update workflow |
| React Native | ui-designer | Add skill reference, update workflow |
| React Native | navigation-architect | Add skill reference, update workflow |
| React Native | performance-optimizer | Add verification step |
| React Native | e2e-tester | Add verification step |
| Solidity | developer | Add skill reference, update workflow |
| Solidity | tester | Add verification step |
| Solidity | gas-optimizer | Add verification step |
| Solidity | upgrader | Add skill reference, update workflow |

### Agents NOT Requiring Updates (Read-Only)

| Stack | Agent | Reason |
|-------|-------|--------|
| Go | debugger | Read-only, no code modifications |
| Go | security | Read-only, no code modifications |
| Go | deployer | No code changes, deployment only |
| JS Common | security | Read-only, no code modifications |
| Node | deployer | No code changes, deployment only |
| React Native | code-analyzer | Read-only, no code modifications |
| Solidity | auditor | Read-only, no code modifications |
| Solidity | deployer | No code changes, deployment only |
| Solidity | debugger | Read-only, no code modifications |

### Commands Requiring Updates

| Stack | Command | Update Required |
|-------|---------|-----------------|
| React | refactor-atomic-design | Update verification phase |
| React Native | refactor-atomic-design | Update verification phase |

---

## Implementation Summary

**Status:** COMPLETE

**Completed:** 2026-01-01

### What Was Built

All 5 phases of the Code Quality Enforcement feature have been implemented:

1. **Phase 1 - JS Common Stack:** Created post-change-verification skill, updated developer, tester, quality-guardian, and documenter agents
2. **Phase 2 - JavaScript Stack Expansion:** Updated Node api-builder, database-architect; React component-builder, state-architect, ui-designer, performance-optimizer, e2e-tester; React Native component-builder, ui-designer, navigation-architect, performance-optimizer, e2e-tester; and refactor-atomic-design commands
3. **Phase 3 - Go Stack:** Created post-change-verification skill, updated developer, api-builder, tester, optimizer, documenter agents
4. **Phase 4 - Solidity Stack:** Added Code Quality Tools documentation to PLUGIN.md, created post-change-verification skill, updated developer, tester, gas-optimizer, upgrader agents
5. **Phase 5 - Verification and Documentation:** Audited all 35 agents, updated 8 remaining agents, created audit documentation

### Agent Summary

| Category | Count | Status |
|----------|-------|--------|
| Code-Modifying Agents (Updated) | 26 | Complete |
| Read-Only Agents (Correctly Excluded) | 9 | Verified |
| **Total Agents Reviewed** | **35** | **100%** |

### Key Decisions Made

1. Advisory enforcement mode - verification results reported but don't block task completion
2. 10-line threshold rule for pre-existing issue handling
3. Per-stack skills with stack-specific commands
4. Conditional verification for documenter (only when code files modified)
5. Phased rollout validated incrementally

### Test Results

- All skill files created and verified in correct locations
- All code-modifying agents reference their stack's skill
- All code-modifying agents include verification step in workflow
- Read-only agents correctly excluded from verification requirements

### Files Created/Modified

**Skills Created:**
- `/tech-stacks/js/common/skills/post-change-verification/SKILL.md`
- `/tech-stacks/go/skills/post-change-verification/SKILL.md`
- `/tech-stacks/solidity/skills/post-change-verification/SKILL.md`

**Agents Updated (26 total):**
- Go: developer, api-builder, tester, optimizer, documenter
- JS Common: developer, tester, quality-guardian, documenter
- Node: api-builder, database-architect
- React: component-builder, state-architect, ui-designer, performance-optimizer, e2e-tester
- React Native: component-builder, ui-designer, navigation-architect, performance-optimizer, e2e-tester
- Solidity: developer, tester, gas-optimizer, upgrader

**Commands Updated:**
- React: refactor-atomic-design
- React Native: refactor-atomic-design

**Documentation Updated:**
- Solidity PLUGIN.md (Code Quality Tools section added)
