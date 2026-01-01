# Code Quality Enforcement - Requirements

**Created:** 2025-12-31
**Last Updated:** 2025-12-31
**Status:** Draft

## Overview

Code Quality Enforcement establishes a standardized Post-Change Verification Protocol that ensures all code-modifying agents in the Molcajete.ai plugin ecosystem consistently enforce formatting, linting, type-checking, and testing after every code change. Currently, agents across 6 tech stacks (Go, JS Common, Node, React, React Native, Solidity) have inconsistent quality enforcement - some mention running checks but lack a mandatory, structured workflow. This feature creates stack-specific verification skills within each tech stack, ensuring agents only see commands relevant to their stack while following a consistent protocol structure.

This feature directly supports Molcajete.ai's mission of delivering "consistent, opinionated, and battle-tested workflows" by eliminating the variability in code quality enforcement across agents. When agents consistently verify their work, users get reliable, production-ready code output every time.

## User Stories

### Primary User Story
**As a** Molcajete.ai user (developer)
**I want** all code-modifying agents to automatically verify code quality after making changes
**So that** I receive production-ready code without manual cleanup or debugging of linting/type errors

**Acceptance Criteria:**
- Every code-modifying agent runs format, lint, type-check, and test commands after changes
- Agents report verification results clearly in their completion output
- Zero errors and zero warnings in verification output (with documented exceptions for pre-existing issues)
- Pre-existing issues not caused by current changes are documented rather than blocking the task

### Secondary User Story
**As a** Molcajete.ai plugin creator
**I want** a Post-Change Verification Protocol skill for my stack
**So that** I can ensure my agents follow the same quality standards as core plugins

**Acceptance Criteria:**
- Post-Change Verification Protocol skill exists in each tech stack
- Each skill includes only the commands relevant to that stack
- Skills provide clear guidance on exception handling
- New agents can reference their stack's skill with minimal integration effort

### Additional User Story
**As a** Molcajete.ai user working on a codebase with pre-existing issues
**I want** agents to distinguish between issues they caused and pre-existing issues
**So that** my current task is not blocked by unrelated technical debt

**Acceptance Criteria:**
- Agents identify whether issues existed before current changes
- Small pre-existing issues (less than 10 lines to fix) are fixed as part of current work
- Large pre-existing issues are documented and reported separately
- Users receive clear recommendations for addressing pre-existing issues

## Functional Requirements

### Core Functionality

1. **Post-Change Verification Protocol Skills:** Create stack-specific skills that define the mandatory verification steps code-modifying agents must follow
   - `/tech-stacks/js/common/skills/post-change-verification/SKILL.md` - JavaScript/TypeScript commands
   - `/tech-stacks/go/skills/post-change-verification/SKILL.md` - Go commands
   - `/tech-stacks/solidity/skills/post-change-verification/SKILL.md` - Solidity commands (Foundry/Hardhat)
   - Document the 5-step verification protocol (format, lint, type-check, test, verify)
   - Each skill includes only commands relevant to its stack
   - Define exception handling rules for pre-existing issues
   - Provide integration instructions for agent workflows

2. **Advisory Enforcement Mode:** Verification results are reported but do not block task completion
   - Agents report all verification results (pass/fail) in completion output
   - Users can see exactly what passed and what failed
   - Tasks complete even if verification finds issues
   - Clear distinction between issues caused by changes vs pre-existing issues

3. **Stack-Specific Verification Commands:** Define the correct commands for each tech stack
   - Go: `make fmt`, `make lint`, `make build`, `make test`
   - JavaScript/TypeScript: `npm run format`, `npm run lint`, `npm run type-check`, `npm test`
   - Solidity: `forge fmt` (Foundry) or `npx prettier` (Hardhat), `solhint`, `forge build`/`npx hardhat compile`, `forge test`/`npx hardhat test`

4. **Pre-Existing Issue Handling:** Apply the 10-line threshold rule
   - Issues in files not modified by current changes are documented only
   - Issues in modified files that are small (less than 10 lines) are fixed
   - Issues in modified files that are large (10+ lines or structural) are documented
   - Clear reporting format for pre-existing issues

5. **Agent Workflow Updates:** Update code-modifying agents to reference the skill
   - Add skill reference to Required Skills section
   - Replace or update workflow pattern to include verification step
   - Ensure verification step is clearly marked as MANDATORY
   - Include verification results in completion output format

### Edge Cases

- **Missing Quality Commands:** If a project lacks expected npm scripts (e.g., no `npm run lint`), agent should note the missing command and skip that verification step rather than failing
- **CI Environment Differences:** Some commands may behave differently in CI vs local; agents should document any environment-specific considerations
- **Monorepo Projects:** For monorepos, verification should focus on affected packages, not the entire repository
- **Generated Code:** Some generated code (e.g., from code generators) may have intentional style differences; agents should respect `.prettierignore`, `.eslintignore`, etc.

### Business Rules

- **Zero Tolerance Standard:** The target is zero errors and zero warnings; any issues found should be reported even if not blocking
- **Fix Forward, Not Back:** Agents fix issues they cause and small pre-existing issues; they do not embark on large cleanup efforts mid-task
- **Transparency Over Silence:** Always report verification results, even when all checks pass
- **Stack-Appropriate Tools:** Use the documented tools for each stack; do not substitute alternatives without explicit user request

## Non-Functional Requirements

### Performance

- **Verification Overhead:** Verification steps should add no more than 30 seconds to typical agent workflows
- **Incremental Testing:** Where possible, run only tests related to modified files (e.g., `npm test -- --changed`)
- **Command Timeout:** If a verification command takes longer than 5 minutes, agent should note this and proceed

### Security

- **No External Calls:** Verification runs locally; no code or results sent to external services
- **Safe Command Execution:** Only run documented quality commands; never execute arbitrary user input as commands

### Usability

- **Clear Output Format:** Verification results should be easy to scan and understand
- **Actionable Recommendations:** When issues are found, provide specific guidance on how to fix them
- **Copy-Paste Commands:** Include exact commands users can run to reproduce verification locally

### Reliability

- **Graceful Degradation:** If a verification step fails to run (not fails with issues, but cannot execute), note it and continue with remaining steps
- **Consistent Behavior:** Same verification protocol across all agents referencing the skill
- **Deterministic Results:** Running verification twice with no changes should produce identical results

## Constraints

### Technical Constraints

- Must work within Claude Code plugin architecture (agents, skills, commands)
- Must integrate with existing tech-stack structure (`/tech-stacks/` directory)
- Must use existing quality tools (no new tool installations required)
- Each stack's skill must be referenceable from agents within that stack

### Business Constraints

- Creator-first: Feature must prove useful in creator's personal workflows before broader rollout
- Phased implementation: Start with JS Common stack before expanding to other stacks
- No breaking changes: Existing agent functionality must remain intact

### Resource Constraints

- Single developer implementing: Phased rollout allows incremental progress
- No infrastructure requirements: All changes are to markdown files (agents, skills, commands)

## Assumptions

- Projects using Molcajete.ai agents have quality tooling already configured (formatters, linters, type checkers, test runners)
- Standard npm scripts (`format`, `lint`, `type-check`, `test`) exist in JavaScript projects
- Go projects use Makefile with standard targets (`fmt`, `lint`, `build`, `test`)
- Solidity projects use either Foundry or Hardhat with standard configurations

## Out of Scope

Explicitly what this feature will NOT include:

- **Automated tool installation:** Agents will not install missing tools; they expect tools to be pre-configured
- **Custom quality rules:** Agents use project's existing configurations; they do not impose new lint rules
- **Pre-commit hook setup:** This is handled by the existing quality-guardian agent
- **CI/CD integration:** Verification runs during agent execution, not as part of CI pipeline
- **New Solidity commands:** Only documentation updates to PLUGIN.md; no new command files for fmt/lint
- **Read-only agent updates:** Agents that do not modify code (debugger, security auditor, code-analyzer) are not updated

## Open Questions

- **Question 1:** Should verification results be stored/logged for historical analysis?
  - **Status:** Deferred
  - **Answer:** Not in MVP; may consider for analytics feature in roadmap

- **Question 2:** Should there be a way to skip verification for quick iterations?
  - **Status:** Deferred
  - **Answer:** Advisory mode already allows proceeding despite issues; explicit skip not needed for MVP

## Visual References

- **Mockups:** N/A (CLI-based feature)
- **Wireframes:** N/A
- **Design System:** N/A
- **Similar Implementations:** The audit document at `.molcajete/research/code-quality-enforcement.md` contains detailed examples of updated workflow patterns and verification output formats

## Dependencies

### Technical Dependencies

- Existing tech-stack plugin structure must remain stable
- Agents must support referencing skills from their own tech stack
- Quality tooling must be available in target projects

### External Dependencies

- None (all verification runs locally using project's existing tools)

## Success Criteria

How will we know this feature is successful?

### User Success

- Code output from agents passes project quality checks without manual intervention
- Pre-existing issues are clearly identified and do not block legitimate work
- Users trust that agent-generated code meets quality standards

### Business Success

- Reduced debugging time from silent quality issues
- Consistent code quality across all Molcajete.ai plugins
- Foundation for future quality enforcement features

### Technical Success

- All code-modifying agents reference Post-Change Verification Protocol skill
- Verification results reported in consistent format across all agents
- Zero regressions in existing agent functionality
- Phased rollout completed: JS Common, then Node/React/React Native, then Go, then Solidity

## Implementation Phases

### Phase 1: JS Common Stack (MVP)

- [ ] Create JS Common Post-Change Verification skill at `/tech-stacks/js/common/skills/post-change-verification/SKILL.md`
- [ ] Update JS Common developer agent with skill reference and new workflow
- [ ] Update JS Common tester agent with verification step
- [ ] Update JS Common quality-guardian agent (minor alignment updates)
- [ ] Test integration with real JS project

### Phase 2: JavaScript Stack Expansion

- [ ] Update Node api-builder agent
- [ ] Update Node database-architect agent
- [ ] Update React component-builder agent
- [ ] Update React state-architect agent
- [ ] Update React refactor-atomic-design command
- [ ] Update React Native component-builder agent
- [ ] Update React Native refactor-atomic-design command

### Phase 3: Go Stack

- [ ] Create Go Post-Change Verification skill at `/tech-stacks/go/skills/post-change-verification/SKILL.md`
- [ ] Update Go developer agent
- [ ] Update Go api-builder agent
- [ ] Update Go tester agent
- [ ] Update Go optimizer agent
- [ ] Update Go documenter agent

### Phase 4: Solidity Stack

- [ ] Add formatter/linter documentation to Solidity PLUGIN.md
- [ ] Create Solidity Post-Change Verification skill at `/tech-stacks/solidity/skills/post-change-verification/SKILL.md`
- [ ] Update Solidity developer agent
- [ ] Update Solidity tester agent
- [ ] Update Solidity gas-optimizer agent
- [ ] Update Solidity upgrader agent

### Phase 5: Verification and Documentation

- [ ] Audit all 35 agents for compliance
- [ ] Update any remaining agents
- [ ] Document feature in plugin README
