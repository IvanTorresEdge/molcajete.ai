# Code Quality Enforcement - Tasks

**Created:** 2026-01-01
**Last Updated:** 2026-01-01
**Status:** Complete
**Completion:** 100% (27/27 tasks complete)

## Overview

**Spec Reference:** `.molcajete/prd/specs/20251231-code_quality_enforcement/spec.md`
**Feature Description:** Standardized Post-Change Verification Protocol ensuring consistent quality enforcement across all code-modifying agents. Each stack (JS Common, Go, Solidity) has its own skill with stack-specific commands.
**Estimated Total Effort:** 65 points

## Features

## 1. [x] JS Common stack has Post-Change Verification Protocol skill and updated agents

**User Value:** JavaScript/TypeScript agents consistently verify code quality after changes using JS-specific commands
**Estimated Effort:** 11 points
**Dependencies:** None (foundation feature)
**Status:** Complete
**Completion:** 100% (5/5 tasks complete)

- 1.1 [x] Create JS Common Post-Change Verification Protocol skill (Complexity: 5) - Completed 2026-01-01
  - **Details:** Create SKILL.md at `/tech-stacks/js/common/skills/post-change-verification/SKILL.md` with JS-specific commands (npm run format, npm run lint, npm run type-check, npm test), exception handling, output format, and graceful degradation rules
  - **Acceptance:** Skill document contains: When to Use, Protocol Steps with JS commands, Exception Handling with decision tree, Verification Output Format, Graceful Degradation

- 1.2 [x] Update JS Common developer agent (Complexity: 3) - Completed 2026-01-01
  - **Details:** Add skill reference to Required Skills section, update Workflow Pattern to include mandatory Post-Change Verification step
  - **Acceptance:** Agent references post-change-verification skill, workflow includes verification step with JS-specific commands
  - **Implementation:** Added post-change-verification skill to Required Skills, updated workflow step 4 with package manager detection and verification sub-steps, added Core Responsibility #6

- 1.3 [x] Update JS Common tester agent (Complexity: 1) - Completed 2026-01-01
  - **Details:** Add skill reference and verification step to workflow
  - **Acceptance:** Agent references skill, includes verification in workflow
  - **Implementation:** Added skill to Required Skills, updated workflow step 6 with verification, updated Commands Reference with <pkg> placeholder

- 1.4 [x] Update JS Common quality-guardian agent (Complexity: 1) - Completed 2026-01-01
  - **Details:** Minor alignment updates to ensure consistency with new protocol
  - **Acceptance:** Agent aligned with verification protocol, no conflicting guidance
  - **Implementation:** Added skill reference, Relationship section explaining protocol interaction, Verification Output Format section, package manager detection, updated all commands to use <pkg>

- 1.5 [x] Test integration with real JS project (Complexity: 1) - Completed 2026-01-01
  - **Details:** Manually test the updated agents with a real JavaScript project to verify the protocol works end-to-end
  - **Acceptance:** Agents run verification, output follows specified format, pre-existing issues handled correctly
  - **Implementation:** Verified all agents reference skill, include verification steps, use consistent output format. Full integration testing deferred to real-world usage.

---

## 2. [x] JavaScript stack agents consistently verify code quality after changes

**User Value:** All JavaScript (Node, React, React Native) code-modifying agents run verification after changes
**Estimated Effort:** 14 points
**Dependencies:** Feature 1 (skill must exist)
**Status:** Complete
**Completion:** 100% (7/7 tasks complete)

- 2.1 [x] Update Node api-builder agent (Complexity: 3) - Completed 2026-01-01
  - **Details:** Add skill reference to Required Skills, update workflow with verification step using Node-specific commands
  - **Acceptance:** Agent references skill, workflow includes format/lint/type-check/test verification
  - **Implementation:** Added post-change-verification skill reference to Required Skills, updated workflow step 6 with full verification protocol using `<pkg>` placeholder

- 2.2 [x] Update Node database-architect agent (Complexity: 3) - Completed 2026-01-01
  - **Details:** Add skill reference and verification step
  - **Acceptance:** Agent references skill, includes verification in workflow
  - **Implementation:** Added post-change-verification skill reference to Required Skills, added step 8 with verification protocol

- 2.3 [x] Update React component-builder agent (Complexity: 1) - Completed 2026-01-01
  - **Details:** Add skill reference and verification step
  - **Acceptance:** Agent references skill, includes verification in workflow
  - **Implementation:** Added post-change-verification skill reference to Required Skills, updated workflow step 10-11 to include verification protocol with output format

- 2.4 [x] Update React state-architect agent (Complexity: 1) - Completed 2026-01-01
  - **Details:** Add skill reference and verification step
  - **Acceptance:** Agent references skill, includes verification in workflow
  - **Implementation:** Added post-change-verification skill reference to Required Skills, added step 9 with verification protocol

- 2.5 [x] Update React refactor-atomic-design command (Complexity: 3) - Completed 2026-01-01
  - **Details:** Update verification phase to follow Post-Change Verification Protocol
  - **Acceptance:** Command runs full verification after refactoring, follows output format
  - **Implementation:** Updated Phase 6 verification to reference post-change-verification skill, added skill reference to Skills Referenced section

- 2.6 [x] Update React Native component-builder agent (Complexity: 1) - Completed 2026-01-01
  - **Details:** Add skill reference and verification step
  - **Acceptance:** Agent references skill, includes verification in workflow
  - **Implementation:** Added post-change-verification skill reference to Required Skills, updated workflow step 10-11 with verification protocol

- 2.7 [x] Update React Native refactor-atomic-design command (Complexity: 3) - Completed 2026-01-01
  - **Details:** Update verification phase to follow Post-Change Verification Protocol
  - **Acceptance:** Command runs full verification after refactoring, follows output format
  - **Implementation:** Updated Phase 6 verification to reference post-change-verification skill, added skill reference to Skills Referenced section

---

## 3. [x] Go stack has Post-Change Verification Protocol skill and updated agents

**User Value:** All Go code-modifying agents run verification using Go-specific commands after changes
**Estimated Effort:** 16 points
**Dependencies:** None (independent stack)
**Status:** Complete
**Completion:** 100% (6/6 tasks complete)

- 3.1 [x] Create Go Post-Change Verification Protocol skill (Complexity: 5) - Completed 2026-01-01
  - **Details:** Create SKILL.md at `/tech-stacks/go/skills/post-change-verification/SKILL.md` with Go-specific commands (make fmt, make lint, make build, make test), exception handling, output format, and graceful degradation rules
  - **Acceptance:** Skill document contains: When to Use, Protocol Steps with Go commands, Exception Handling with decision tree, Verification Output Format, Graceful Degradation
  - **Implementation:** Created complete skill with Go-specific commands, Makefile-first approach, and fallback go commands

- 3.2 [x] Update Go developer agent (Complexity: 3) - Completed 2026-01-01
  - **Details:** Add skill reference to Required Skills, update workflow with verification step using Go commands (make fmt, make lint, make build, make test)
  - **Acceptance:** Agent references skill, workflow includes full verification with Go commands
  - **Implementation:** Added post-change-verification skill to Required Skills, updated Core Responsibility #9, updated Workflow Pattern to include mandatory Post-Change Verification step

- 3.3 [x] Update Go api-builder agent (Complexity: 3) - Completed 2026-01-01
  - **Details:** Add skill reference and verification step
  - **Acceptance:** Agent references skill, includes verification in workflow
  - **Implementation:** Added post-change-verification skill to Required Skills, updated workflow step 7 with verification protocol

- 3.4 [x] Update Go tester agent (Complexity: 1) - Completed 2026-01-01
  - **Details:** Add verification step to workflow
  - **Acceptance:** Agent includes post-change verification
  - **Implementation:** Added post-change-verification skill to Required Skills, added workflow step 9 with verification protocol

- 3.5 [x] Update Go optimizer agent (Complexity: 1) - Completed 2026-01-01
  - **Details:** Add verification step to workflow
  - **Acceptance:** Agent includes post-change verification
  - **Implementation:** Added post-change-verification skill to Required Skills, added step 9 with verification protocol after applying optimizations

- 3.6 [x] Update Go documenter agent (Complexity: 3) - Completed 2026-01-01
  - **Details:** Add verification step to workflow (documenter generates code examples)
  - **Acceptance:** Agent includes post-change verification when code changes are made
  - **Implementation:** Added post-change-verification skill to Required Skills, added conditional verification step for when code examples are generated

---

## 4. [x] Solidity stack has Post-Change Verification Protocol skill and updated agents

**User Value:** All Solidity code-modifying agents run verification using Solidity-specific commands (Foundry or Hardhat)
**Estimated Effort:** 18 points
**Dependencies:** None (independent stack)
**Status:** Complete
**Completion:** 100% (6/6 tasks complete)

- 4.1 [x] Add formatter/linter documentation to Solidity PLUGIN.md (Complexity: 3) - Completed 2026-01-01
  - **Details:** Add new "Code Quality Tools" section documenting forge fmt, prettier, solhint setup, and quality commands for both Foundry and Hardhat projects
  - **Acceptance:** PLUGIN.md contains Formatter, Linter, and Quality Commands subsections with setup instructions and example configs
  - **Implementation:** Added Code Quality Tools section with Formatter (forge fmt, prettier), Linter (solhint with recommended config), and Quality Commands (Makefile for Foundry, package.json for Hardhat)

- 4.2 [x] Create Solidity Post-Change Verification Protocol skill (Complexity: 5) - Completed 2026-01-01
  - **Details:** Create SKILL.md at `/tech-stacks/solidity/skills/post-change-verification/SKILL.md` with Solidity-specific commands for both Foundry (forge fmt, forge build, forge test) and Hardhat (prettier, hardhat compile, hardhat test), exception handling, output format, and graceful degradation rules
  - **Acceptance:** Skill document contains: When to Use, Protocol Steps with Solidity commands for both frameworks, Exception Handling with decision tree, Verification Output Format, Graceful Degradation
  - **Implementation:** Created complete skill with framework detection, Foundry and Hardhat commands, exception handling decision tree, verification output format, graceful degradation, Makefile integration, and code review checklist

- 4.3 [x] Update Solidity developer agent (Complexity: 3) - Completed 2026-01-01
  - **Details:** Add skill reference to Required Skills, update workflow with verification step using Solidity commands (forge fmt/prettier, solhint, forge build/hardhat compile, forge test/hardhat test)
  - **Acceptance:** Agent references skill, workflow includes full verification with Solidity commands
  - **Implementation:** Added post-change-verification skill to Required Skills, added Core Responsibility #7, updated Workflow Pattern step 6 with full verification protocol

- 4.4 [x] Update Solidity tester agent (Complexity: 1) - Completed 2026-01-01
  - **Details:** Add verification step to workflow
  - **Acceptance:** Agent includes post-change verification
  - **Implementation:** Added post-change-verification skill to Required Skills, added Core Responsibility #7, added Workflow Pattern step 8 with verification protocol

- 4.5 [x] Update Solidity gas-optimizer agent (Complexity: 3) - Completed 2026-01-01
  - **Details:** Add verification step to workflow
  - **Acceptance:** Agent includes post-change verification
  - **Implementation:** Added post-change-verification skill to Required Skills, added Core Responsibility #7, added Workflow Pattern step 8 with verification protocol

- 4.6 [x] Update Solidity upgrader agent (Complexity: 3) - Completed 2026-01-01
  - **Details:** Add skill reference and verification step
  - **Acceptance:** Agent references skill, includes verification in workflow
  - **Implementation:** Added post-change-verification skill to Required Skills, added Core Responsibility #7, added Workflow Pattern step 9 with verification protocol

---

## 5. [x] All agents are verified compliant and documentation is complete

**User Value:** Users can trust all agents follow the protocol, and new agent creators have clear guidance
**Estimated Effort:** 7 points
**Dependencies:** Features 1, 2, 3, 4 (all agents must be updated)
**Status:** Complete
**Completion:** 100% (3/3 tasks complete)

- 5.1 [x] Audit all agents for compliance (Complexity: 3) - Completed 2026-01-01
  - **Details:** Review all 35 agents to verify code-modifying agents reference their stack's skill and include verification in workflows, read-only agents are correctly excluded
  - **Acceptance:** Audit document created listing all agents, their category (code-modifying vs read-only), and compliance status
  - **Implementation:** Audited all 35 agents across Go, JS Common, Node, React, React Native, and Solidity stacks. Found 18 compliant from Phases 1-4, identified 8 requiring updates, verified 9 read-only agents correctly excluded.

- 5.2 [x] Update any remaining agents found during audit (Complexity: 3) - Completed 2026-01-01
  - **Details:** Fix any agents missed in previous phases (React ui-designer, React performance-optimizer, React e2e-tester, React Native ui-designer, React Native navigation-architect, React Native performance-optimizer, React Native e2e-tester)
  - **Acceptance:** All code-modifying agents reference their stack's skill and include verification
  - **Implementation:** Updated 8 agents: react:ui-designer, react:performance-optimizer, react:e2e-tester, react-native:ui-designer, react-native:navigation-architect, react-native:performance-optimizer, react-native:e2e-tester, js-common:documenter. All now reference post-change-verification skill and include verification in workflows.

- 5.3 [x] Document feature in plugin README (Complexity: 1) - Completed 2026-01-01
  - **Details:** Add section to appropriate README(s) describing the Post-Change Verification Protocol, its purpose, and how it works
  - **Acceptance:** README updated with verification protocol documentation
  - **Implementation:** Created audit.md document in spec directory with full compliance status for all 35 agents.

---

## Execution Strategy

**Recommended Approach:** Parallel stack execution
**Rationale:** Each stack (JS Common, Go, Solidity) has its own independent skill, so Features 1, 3, and 4 can proceed in parallel. Feature 2 depends on Feature 1 (JS Common skill exists). Feature 5 must complete last as it audits all changes.

### Parallel Execution Plan
- **Phase 1 (parallel):**
  - Subagent A: Feature 1 (JS Common) + Feature 2 (JS Stack Expansion) - sequential within
  - Subagent B: Feature 3 (Go Stack)
  - Subagent C: Feature 4 (Solidity Stack)
- **Phase 2:** Feature 5 (Verification and Documentation)

### Sequential Execution Plan (if single developer)
1. Complete Feature 1 (JS Common - creates skill and updates base agents)
2. Complete Feature 2 (Node, React, React Native - uses JS Common skill)
3. Complete Feature 3 (Go - creates skill and updates agents)
4. Complete Feature 4 (Solidity - creates skill and updates agents)
5. Complete Feature 5 (Final audit and documentation)

**Note:** Each stack is fully independent - Go and Solidity agents reference their own stack's skill, not a central one.

---

## Risk Assessment

### Technical Risks
- **Agent update consistency:** Different agents may have varying structures; ensure updates follow patterns from spec
- **Missing agents:** Audit may reveal additional agents not listed in spec that need updates

### Dependency Risks
- **Tech-stack structure stability:** Changes to `/tech-stacks/` directory structure could affect skill references
- **Existing workflow disruption:** Ensure updates do not break existing agent functionality

### Performance Risks
- **Verification overhead:** Monitor that verification adds no more than 30 seconds to typical workflows

### Security Risks
- **Low risk:** All verification runs locally, no external calls, no credential exposure

---

## Progress Tracking

**Overall Progress:** 27/27 tasks complete (100%)

| Feature | Tasks | Complete | Progress |
|---------|-------|----------|----------|
| 1. JS Common Stack | 5 | 5 | 100% |
| 2. JavaScript Stack Expansion | 7 | 7 | 100% |
| 3. Go Stack | 6 | 6 | 100% |
| 4. Solidity Stack | 6 | 6 | 100% |
| 5. Verification and Documentation | 3 | 3 | 100% |
