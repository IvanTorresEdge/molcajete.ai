# Requirements: BDD Scenario Generator

**Feature ID:** 20260223-1600-bdd_scenario_generator
**Status:** Draft
**Created:** 2026-02-23
**Last Updated:** 2026-02-23

---

## 1. Overview

### Feature Description

The BDD Scenario Generator is a Claude Code skill (`/m:stories`) that generates Gherkin `.feature.md` files and corresponding step definitions for E2E testing. Given a feature name, use case ID, or natural language description, it produces well-structured BDD scenarios following the project's established testing architecture, folder conventions, and domain organization.

The skill maintains two index files (features index and step definitions index) that serve as an LLM-readable catalog of all existing BDD artifacts. This enables the skill to avoid duplicating scenarios, reuse existing step definitions, and orient itself within the test suite without scanning every file. The indexes act as the "memory" layer for agentic BDD authoring.

The BDD scaffold lives at the repository root (`bdd/`) and is organized by business domain. The skill auto-detects two conventions from existing files: **feature file format** (standard `.feature` by default, or `.feature.md` MDG if already in use) and **step definition language** (Python, Go, or TypeScript, defaulting to Python). Once a convention is established in the project, the skill matches it consistently and never mixes formats or languages.

### Strategic Alignment

| Aspect | Alignment |
|--------|-----------|
| Mission | Enables systematic verification of application behaviors through executable specifications, extending Molcajete's structured workflow to testing |
| Roadmap | Supports the "BDD Self-Testing" priority on the current roadmap; provides the authoring tool for generating and maintaining BDD test suites |
| Success Metrics | Reduces time to write BDD scenarios from manual authoring to a single command invocation; increases test coverage per feature |

### User Value

| User Type | Value Delivered |
|-----------|-----------------|
| Developer (using Claude Code) | Generate BDD scenarios for any feature with a single `/m:stories` command, with correct folder placement, step reuse, and index updates |
| AI Agent (Molcajete) | Autonomously author and maintain BDD test suites by reading index files for orientation, then invoking the skill to add scenarios |
| QA / Reviewer | Browse `bdd/features/INDEX.md` for a complete catalog of all specified behaviors, organized by business domain |

### Success Criteria

| Criterion | Target | Measurement |
|-----------|--------|-------------|
| Scenario generation accuracy | Generated `.feature.md` files parse without Gherkin syntax errors | Run Gherkin linter on all generated files |
| Step definition reuse rate | At least 30% of steps in new scenarios reuse existing definitions | Count reused vs. new steps in generation output |
| Index file consistency | INDEX.md files always reflect the actual file system contents | Diff index entries against glob of actual files |
| Skill invocation success | `/m:stories <arg>` produces a complete scenario with step definitions on first invocation | Manual verification per invocation |

---

## 2. Use Cases

### UC-0KTg-001: Initialize BDD Scaffold

Create the initial BDD directory structure, empty index files, and world/context module when the `bdd/` directory does not yet exist.

**Primary Actor:** Developer
**Preconditions:** Repository exists; `bdd/` directory does not exist
**Postconditions:** `bdd/` directory created with domain folders, empty INDEX.md files, and a world/context module; step definition language detected or defaulted to Python

### UC-0KTg-002: Generate Scenarios for a Feature

Given a feature name, use case ID (e.g., `UC-XXXX-001`), or natural language description, generate Gherkin scenarios in the appropriate `.feature.md` file and create any missing step definitions.

**Primary Actor:** Developer or AI Agent
**Preconditions:** `bdd/` scaffold exists (or is auto-created via UC-0KTg-001); PRD specs exist for the referenced feature
**Postconditions:** Feature file created or updated with new scenarios; step definitions created for missing patterns; both INDEX.md files updated

### UC-0KTg-003: Add Scenario to Existing Feature

Add one or more scenarios to an already-existing feature file without duplicating existing scenarios or step definitions.

**Primary Actor:** Developer or AI Agent
**Preconditions:** Target feature file already exists in `bdd/features/`; `bdd/features/INDEX.md` lists the feature
**Postconditions:** New scenario appended to existing feature file; INDEX.md updated with new scenario entries; only genuinely new step definitions created

### UC-0KTg-004: Maintain Index Files

Ensure INDEX.md files stay synchronized with the actual file system contents. Detect and fix drift (missing entries, stale entries, incorrect summaries).

**Primary Actor:** Developer or AI Agent
**Preconditions:** `bdd/` scaffold exists with at least one feature or step definition file
**Postconditions:** Both INDEX.md files accurately reflect all features, scenarios, and step definitions present in the file system

### UC-0KTg-005: Resolve Generic Feature Name via Codebase Exploration

When the argument is a generic name (e.g., "user authentication", "invoice processing") rather than a spec ID or exact feature file name, the skill explores the codebase to understand what that concept means in this project, which modules it touches, and what behaviors are worth testing.

**Primary Actor:** Developer or AI Agent
**Preconditions:** `bdd/` scaffold exists (or is auto-created); the argument does not match a use case ID pattern (e.g., `UC-XXXX-NNN`) and does not match an existing feature file name
**Postconditions:** The skill has resolved the generic name to a concrete understanding of what the feature involves, which PRD spec(s) it maps to (if any), which codebase modules implement it, and what scenarios are worth generating. The skill then proceeds to generate scenarios as in UC-0KTg-002.

---

## 3. User Stories

### Developer Stories

| ID | As a | I want | So that | Priority |
|----|------|--------|---------|----------|
| US-0KTg-001 | developer | to run `/m:stories user-authentication` and get a complete BDD scenario with step definitions | I don't have to manually author Gherkin and wire up step definitions | Critical |
| US-0KTg-002 | developer | the skill to detect my existing step definition language and match it | I don't end up with mixed Python/Go/TS step files | High |
| US-0KTg-003 | developer | to see a summary of what was created, reused, and updated after each invocation | I can review the changes before committing | High |
| US-0KTg-004 | developer | the BDD scaffold to auto-initialize on first use | I don't need a separate setup command | Medium |
| US-0KTg-005 | developer | feature files to use Markdown with Gherkin (.feature.md) | scenarios render as readable documentation on GitHub | High |
| US-0KTg-009 | developer | to run `/m:stories user authentication` with a generic name and have the skill figure out what that means in my project | I don't have to look up the exact spec ID or feature file name | Critical |
| US-0KTg-010 | developer | the skill to explore my codebase (changelogs, READMEs, spec folders) when I give it a vague name | the generated scenarios reflect the actual implementation, not generic guesses | High |

### AI Agent Stories

| ID | As a | I want | So that | Priority |
|----|------|--------|---------|----------|
| US-0KTg-006 | AI agent | to read INDEX.md files to understand what features and steps exist | I can orient myself without scanning every file in the BDD directory | Critical |
| US-0KTg-007 | AI agent | the skill to never duplicate existing scenarios | I don't create redundant tests when iterating on features | Critical |
| US-0KTg-008 | AI agent | step definitions to include docstrings with parameter descriptions | I can understand what each step does and reuse it correctly | High |

### Acceptance Criteria

#### US-0KTg-001: Generate scenario via /m:stories

- [ ] Running `/m:stories user-authentication` creates `bdd/features/auth/user-authentication.feature`
- [ ] The generated feature file contains at least one tagged scenario with Given/When/Then steps
- [ ] Step definitions are created for any patterns not found in `bdd/steps/INDEX.md`
- [ ] Both INDEX.md files are updated with the new entries
- [ ] A summary is displayed showing files created, steps reused, and steps created

#### US-0KTg-002: Language detection

- [ ] If `bdd/steps/` contains `.py` files, new step definitions are written in Python
- [ ] If `bdd/steps/` contains `.go` files, new step definitions are written in Go
- [ ] If `bdd/steps/` contains `.ts` files, new step definitions are written in TypeScript
- [ ] If `bdd/steps/` is empty or doesn't exist, Python is used as the default

#### US-0KTg-005: Feature file format detection and defaults

- [ ] If `bdd/features/` contains `.feature.md` files, new features use `.feature.md`
- [ ] If `bdd/features/` contains `.feature` files, new features use `.feature`
- [ ] If `bdd/features/` is empty or doesn't exist, `.feature` (standard Gherkin) is used as the default
- [ ] The skill never mixes formats within the same `bdd/features/` directory
- [ ] Standard `.feature` files use plain Gherkin syntax without Markdown formatting
- [ ] If the project uses `.feature.md`, MDG files render correctly as Markdown on GitHub

#### US-0KTg-006: Index files as LLM orientation

- [ ] `bdd/features/INDEX.md` lists every feature with: name, 1-sentence summary, file location, and all scenario names
- [ ] `bdd/steps/INDEX.md` lists every step definition with: pattern text, description, parameter list with types, and source file
- [ ] Reading only the INDEX.md files is sufficient to determine what exists without reading other files

#### US-0KTg-009: Generic name resolution

- [ ] Running `/m:stories user authentication` resolves to the correct auth-related PRD spec and codebase modules
- [ ] The skill reads `prd/changelog.md` to understand what auth functionality has been built
- [ ] The skill scans `prd/specs/` folder names to find specs related to the argument
- [ ] The skill reads relevant `README.md` files in directories that implement the feature
- [ ] The generated scenarios reference actual module behaviors, not generic patterns
- [ ] If multiple specs or modules match, the skill asks the user to disambiguate using AskUserQuestion

#### US-0KTg-010: Codebase exploration for context

- [ ] The skill reads `prd/changelog.md` as the primary source for understanding what exists in the system
- [ ] The skill uses `prd/specs/` directory names and slugs to map the argument to known features
- [ ] The skill reads `README.md` files in relevant directories for module documentation
- [ ] The skill can optionally read `requirements.md` or `spec.md` from matched spec folders for deeper context
- [ ] Exploration results are used to inform scenario content (actors, data models, edge cases, validation rules)

#### US-0KTg-007: No duplicate scenarios

- [ ] Before creating a scenario, the skill checks INDEX.md for existing scenarios with similar names
- [ ] If an exact or near-duplicate is found, the skill informs the user and skips creation
- [ ] If the user explicitly requests an addition to an existing feature, it appends without duplicating

---

## 4. Functional Requirements

### BDD Scaffold Structure (maps to UC-0KTg-001)

| ID | Requirement | Priority |
|----|-------------|----------|
| FR-0KTg-001 | The BDD scaffold SHALL live at the repository root as `bdd/` | Critical |
| FR-0KTg-002 | Features SHALL be organized by business domain in subdirectories under `bdd/features/` | Critical |
| FR-0KTg-003 | Domain folders SHALL be auto-detected from the project's codebase structure, PRD specs, and changelog. Examples of typical domains: `auth/`, `billing/`, `notifications/`, `users/`, `admin/`. A `cross-domain/` folder MAY be created for features that span multiple domains. | High |
| FR-0KTg-004 | Additional domain folders MAY be created by the skill when a scenario doesn't fit existing domains | Medium |
| FR-0KTg-005 | `bdd/features/INDEX.md` SHALL be created as the master index of all feature files | Critical |
| FR-0KTg-006 | `bdd/steps/INDEX.md` SHALL be created as the master index of all step definitions | Critical |
| FR-0KTg-007 | Step definition files SHALL be organized in `bdd/steps/` with domain-based naming: `common_steps.[ext]`, `api_steps.[ext]`, `db_steps.[ext]`, and domain-specific files matching the feature domains (e.g., `auth_steps.[ext]`, `billing_steps.[ext]`) | High |
| FR-0KTg-008 | A world/context module SHALL be created at `bdd/steps/world.[ext]` containing the test context struct/class and lifecycle hooks | High |
| FR-0KTg-009 | If `bdd/` does not exist when `/m:stories` is invoked, the scaffold SHALL be auto-created before proceeding | Medium |

### Scenario Generation (maps to UC-0KTg-002, UC-0KTg-003)

| ID | Requirement | Priority |
|----|-------------|----------|
| FR-0KTg-010 | The `/m:stories` skill SHALL accept a single argument that can be one of three types: (a) a use case ID matching pattern `UC-XXXX-NNN` — direct spec lookup, (b) an existing feature name matching an entry in `bdd/features/INDEX.md` — add to existing feature, or (c) a generic name/description (e.g., "user authentication", "invoice processing") — triggers codebase exploration per UC-0KTg-005 | Critical |
| FR-0KTg-011 | The skill SHALL read `bdd/features/INDEX.md` to check for existing related features before creating new ones | Critical |
| FR-0KTg-012 | The skill SHALL read `bdd/steps/INDEX.md` to identify reusable step definitions before creating new ones | Critical |
| FR-0KTg-013 | If the argument matches an existing feature, the skill SHALL add scenarios to the existing file rather than creating a new one | High |
| FR-0KTg-014 | If the argument references a PRD spec (e.g., `UC-XXXX-001`), the skill SHALL read the corresponding requirements and spec files to inform scenario generation | High |
| FR-0KTg-015 | The skill SHALL detect the feature file format by scanning existing files in `bdd/features/`: if `.feature.md` files exist, use `.feature.md`; if `.feature` files exist, use `.feature`; if no feature files exist, default to `.feature` (standard Gherkin) | Critical |
| FR-0KTg-015a | The skill SHALL NOT mix feature file formats within the same `bdd/features/` directory | Critical |
| FR-0KTg-015b | When using `.feature.md` format, Gherkin keywords (Feature, Scenario, Given, When, Then, And, But) SHALL be rendered as Markdown headings and bold text per the MDG specification | High |
| FR-0KTg-015c | When using `.feature` format, standard Gherkin syntax SHALL be used without Markdown formatting | High |
| FR-0KTg-015d | The skill file SHALL include templates for both `.feature.md` (MDG) and `.feature` (standard Gherkin) formats | High |
| FR-0KTg-016 | Feature file names SHALL use kebab-case (e.g., `user-authentication.feature`) | High |
| FR-0KTg-017 | Every scenario SHALL have at least one tag (`@smoke`, `@regression`, `@critical`, `@backend`, `@fullstack`, or a domain tag) | High |
| FR-0KTg-018 | Given steps SHALL use declarative language describing system state (e.g., "user alice is logged in") | High |
| FR-0KTg-019 | Then steps SHALL use exact value assertions, not ranges or approximations (e.g., "balance is exactly $94.00") | High |
| FR-0KTg-020 | Step definitions SHALL include docstrings describing what the step does and listing all parameters with their types | High |

### Generic Name Resolution and Codebase Exploration (maps to UC-0KTg-005)

| ID | Requirement | Priority |
|----|-------------|----------|
| FR-0KTg-038 | When the argument does not match a use case ID pattern (`UC-XXXX-NNN`) and does not match an existing feature file in INDEX.md, the skill SHALL treat it as a generic feature name and trigger the exploration workflow | Critical |
| FR-0KTg-039 | The exploration workflow SHALL read `prd/changelog.md` as the primary discovery source, since it contains a domain-organized summary of everything built in the system mapped to requirement IDs | Critical |
| FR-0KTg-040 | The exploration workflow SHALL scan `prd/specs/` directory names (slugs) to find spec folders whose name relates to the argument (e.g., argument "user authentication" matches folder `*auth*` or `*login*`) | High |
| FR-0KTg-041 | When a matching spec folder is found, the skill SHALL read its `requirements.md` and/or `spec.md` to extract use cases, actors, data models, validation rules, and edge cases relevant to scenario generation | High |
| FR-0KTg-042 | The exploration workflow SHALL scan for `README.md` files in directories related to the argument to understand module structure, actors, relationships, and domain rules | High |
| FR-0KTg-043 | If the argument matches multiple unrelated features or modules, the skill SHALL present the options to the user via AskUserQuestion and ask them to select which one(s) to generate scenarios for | High |
| FR-0KTg-044 | The exploration results (matched specs, module documentation, changelog entries) SHALL be used to generate scenarios that reflect actual implementation details rather than generic patterns | Critical |
| FR-0KTg-045 | The skill SHALL prioritize exploration sources in this order: (1) `prd/changelog.md`, (2) `prd/specs/` directory scan + `requirements.md`/`spec.md`, (3) `README.md` files in codebase directories, (4) source code scanning as a last resort | High |

### Full Gherkin Support (maps to UC-0KTg-002, UC-0KTg-003)

| ID | Requirement | Priority |
|----|-------------|----------|
| FR-0KTg-046 | The skill SHALL generate Scenario Outlines with Examples tables when testing variations of the same behavior (e.g., different inputs, user roles, edge cases) | Critical |
| FR-0KTg-047 | The skill SHALL generate Background sections when multiple scenarios in a feature share common preconditions | High |
| FR-0KTg-048 | The skill SHALL generate data tables in Given/When/Then steps when structured input or assertion data is needed | High |
| FR-0KTg-049 | The skill SHALL use the most appropriate Gherkin construct for each situation: simple Scenario for unique flows, Scenario Outline for parameterized variations, Background for shared setup | High |

### Feature File Splitting (maps to UC-0KTg-003, UC-0KTg-004)

| ID | Requirement | Priority |
|----|-------------|----------|
| FR-0KTg-050 | A single feature file SHALL contain no more than 10-15 scenarios | High |
| FR-0KTg-051 | When a feature exceeds the scenario limit, the skill SHALL promote the single file into a feature directory: e.g., `user-authentication.feature` becomes `user-authentication/` containing files named by logical grouping (e.g., `login.feature`, `password-reset.feature`, `session-management.feature`) | High |
| FR-0KTg-052 | When a feature is promoted to a directory, the skill SHALL update `bdd/features/INDEX.md` to reflect the new directory structure with per-file scenario listings | Critical |
| FR-0KTg-053 | File names within a feature directory SHALL describe the logical grouping or subdomain, not numeric ranges (e.g., `login.feature` not `scenarios-1-to-7.feature`) | High |

### Domain Detection and Rules (maps to UC-0KTg-005)

| ID | Requirement | Priority |
|----|-------------|----------|
| FR-0KTg-054 | The skill SHALL check for `.claude/rules/` files inside the `bdd/` directory (e.g., `bdd/.claude/rules/*.md`) for user-defined domain mappings, naming conventions, and generation rules | High |
| FR-0KTg-055 | The skill SHALL check for a `CLAUDE.md` file in the `bdd/` directory for project-specific BDD conventions and overrides | High |
| FR-0KTg-056 | If domain rules files exist, the skill SHALL follow them when determining feature placement, step organization, and naming conventions | High |
| FR-0KTg-057 | If no domain rules exist, the skill SHALL infer the domain from the argument, changelog entries, and codebase README.md files | High |

### BDD Directory Ownership (maps to all UCs)

| ID | Requirement | Priority |
|----|-------------|----------|
| FR-0KTg-058 | The `/m:stories` skill SHALL own everything inside the `bdd/` directory: scaffold creation, feature files, step definitions, index files, world/context module, and directory structure | Critical |
| FR-0KTg-059 | On first scaffold creation, the skill SHALL set up the world/context module with framework-appropriate boilerplate based on the detected language: Python/behave (`environment.py` + `world.py`), Go/godog (`world.go` with `TestWorld` struct), or TypeScript (`world.ts` with fixtures) | High |
| FR-0KTg-060 | The world/context module boilerplate SHALL include lifecycle hooks (`BeforeScenario`/`AfterScenario` or equivalent), a test context object for sharing state between steps, and placeholders for project-specific setup (DB connection string, API base URL, auth token helpers) | High |
| FR-0KTg-061 | If the world/context module already exists, the skill SHALL NOT modify it | High |
| FR-0KTg-062 | When creating step definition files for the first time in a language, the skill SHALL also verify the world/context module exists and create it if missing | High |

### Step Definition Language Detection (maps to UC-0KTg-002)

| ID | Requirement | Priority |
|----|-------------|----------|
| FR-0KTg-021 | The skill SHALL detect the step definition language by scanning file extensions in `bdd/steps/` | Critical |
| FR-0KTg-022 | If `.py` files are detected, step definitions SHALL be written in Python using `behave` or `pytest-bdd` decorators | High |
| FR-0KTg-023 | If `.go` files are detected, step definitions SHALL be written in Go using `godog` step registration | High |
| FR-0KTg-024 | If `.ts` files are detected, step definitions SHALL be written in TypeScript using `playwright-bdd` or `cucumber-js` | High |
| FR-0KTg-025 | If no step files exist, Python SHALL be used as the default language | High |
| FR-0KTg-026 | The skill SHALL NOT mix languages within the same `bdd/steps/` directory | Critical |

### Index File Management (maps to UC-0KTg-004)

| ID | Requirement | Priority |
|----|-------------|----------|
| FR-0KTg-027 | `bdd/features/INDEX.md` SHALL list each feature with: feature name, 1-sentence summary, file path, and a list of all scenario names with brief descriptions | Critical |
| FR-0KTg-028 | `bdd/steps/INDEX.md` SHALL list each step definition grouped by domain, with: step pattern text, description, parameter names and types, and source file reference | Critical |
| FR-0KTg-029 | Both INDEX.md files SHALL be updated atomically whenever the skill creates or modifies feature or step files | Critical |
| FR-0KTg-030 | Step definitions in INDEX.md SHALL be grouped by category: Common, API, Database, and domain-specific sections | High |
| FR-0KTg-031 | The features INDEX.md SHALL group features by their domain folder | High |

### Skill File (maps to all UCs)

| ID | Requirement | Priority |
|----|-------------|----------|
| FR-0KTg-032 | The skill SHALL be implemented as a Molcajete skill file (`.md`) that can be invoked as `/m:stories` | Critical |
| FR-0KTg-033 | The skill file SHALL contain the complete prompt, templates, and rules needed for scenario generation without external dependencies | Critical |
| FR-0KTg-034 | The skill file SHALL include feature file templates for both `.feature.md` (MDG) and `.feature` (standard Gherkin) formats | High |
| FR-0KTg-035 | The skill file SHALL include the INDEX.md template for both features and steps | High |
| FR-0KTg-036 | The skill file SHALL include step definition templates for Python, Go, and TypeScript | High |
| FR-0KTg-037 | The skill SHALL output a structured summary after each invocation showing: feature file location, action taken (created/updated), steps reused, steps created, index files updated, and the command to run the generated tests | High |

---

## 5. Non-Functional Requirements

| ID | Requirement | Target |
|----|-------------|--------|
| NFR-0KTg-001 | The skill SHALL complete scenario generation in a single invocation without requiring follow-up commands | Single-pass execution |
| NFR-0KTg-002 | INDEX.md files SHALL be readable by an LLM in a single context window read (no pagination needed) | Under 500 lines per index file |
| NFR-0KTg-003 | Generated Gherkin SHALL be syntactically valid and parseable by standard Gherkin parsers | Zero parse errors |
| NFR-0KTg-004 | The skill file SHALL be self-contained, requiring no external file reads beyond the BDD directory and PRD specs | Single file deployment |
| NFR-0KTg-005 | Feature files SHALL render correctly as Markdown in GitHub, VS Code, and standard Markdown viewers | Visual verification |
| NFR-0KTg-006 | Step definitions SHALL never reference production databases, credentials, or non-test environments | Security review |

---

## 6. Technical Considerations

### Integration Points

| System | Integration |
|--------|-------------|
| Molcajete plugin | Skill file registered as `/m:stories` via Molcajete's skill discovery mechanism |
| PRD specs | Skill reads `prd/specs/*/requirements.md` and `prd/specs/*/spec.md` when a use case ID is provided |
| BDD test runner | Generated feature files must be compatible with the project's chosen BDD framework (godog for Go, behave/pytest-bdd for Python, playwright-bdd/cucumber-js for TypeScript) |

### Database Changes

No database changes required. This feature generates test specification files only.

### Performance Requirements

| Metric | Target | Rationale |
|--------|--------|-----------|
| INDEX.md scan time | < 2 seconds for LLM to read and parse | Index files must be concise enough for fast orientation |
| Scaffold creation | Single command creates all directories and files | First-use experience must be frictionless |

### Security Considerations

- [ ] Generated step definitions must never contain hardcoded credentials, API keys, or production URLs
- [ ] Feature files must not reference production database names or connection strings
- [ ] The world/context module must enforce ENV=test guards in any database or API setup hooks

---

## 7. User Experience

### User Flows

**Flow 1: First-time use (scaffold + scenario)**

1. Developer runs `/m:stories user-registration`
2. Skill detects `bdd/` does not exist
3. Skill creates the full scaffold (directories, INDEX.md files, world module)
4. Skill reads PRD specs to understand user registration requirements
5. Skill generates `bdd/features/users/user-registration.feature` with scenarios
6. Skill generates step definitions in `bdd/steps/user_steps.py`
7. Skill updates both INDEX.md files
8. Skill displays summary of all created files

**Flow 2: Generating from a use case ID**

1. Developer runs `/m:stories UC-0ABC-001` (references a scoped use case)
2. Skill reads `bdd/features/INDEX.md` and finds no matching feature
3. Skill reads `prd/specs/20260220-1400-payment_processing/requirements.md` for context
4. Skill determines this belongs in `bdd/features/billing/` based on the use case domain
5. Skill generates feature file and step definitions
6. Skill updates INDEX.md files
7. Skill displays summary

**Flow 3: Adding scenario to existing feature**

1. Developer runs `/m:stories add password reset scenario to user authentication`
2. Skill reads `bdd/features/INDEX.md` and finds "User Authentication" feature exists
3. Skill reads the existing feature file to understand current scenarios
4. Skill reads `bdd/steps/INDEX.md` to identify reusable steps
5. Skill appends the new password reset scenario to the existing feature file
6. Skill creates only the new step definitions not already available
7. Skill updates both INDEX.md files with the new scenario and step entries
8. Skill displays summary highlighting reused vs. new steps

**Flow 4: Generic name — codebase exploration**

1. Developer runs `/m:stories invoice processing`
2. Skill checks: not a UC-ID pattern, not an existing feature in INDEX.md — triggers exploration
3. Skill reads `prd/changelog.md` — finds entries about invoice generation, PDF export, payment reconciliation
4. Skill scans `prd/specs/` directories — finds `20260215-0900-invoicing/` which describes the invoicing workflow
5. Skill scans for `README.md` in relevant directories — reads module documentation about invoice lifecycle, line items, tax calculation, payment status
6. Skill synthesizes: "invoice processing" in this project involves invoice creation, line item management, tax rules, PDF generation, and payment status tracking
7. Skill determines domain folder: `bdd/features/billing/`
8. Skill generates `bdd/features/billing/invoice-processing.feature` with scenarios based on actual module behaviors (create invoice, add line items, calculate totals, generate PDF, mark as paid)
9. Skill creates step definitions referencing actual API endpoints and data models from the codebase
10. Skill updates both INDEX.md files
11. Skill displays summary showing exploration sources consulted and scenarios generated

**Flow 5: Generic name — ambiguous match**

1. Developer runs `/m:stories notifications`
2. Skill triggers exploration, finds multiple matches: email notification system, in-app notifications, push notifications
3. Skill asks user via AskUserQuestion: "I found multiple features related to 'notifications'. Which should I generate scenarios for?" with options listing each matched area
4. Developer selects "Email Notifications"
5. Skill proceeds with scenario generation for the selected feature

### Error States

| Scenario | Handling |
|----------|----------|
| Argument is empty or unclear | Skill asks user to clarify using AskUserQuestion: "What feature or use case should I generate scenarios for?" |
| Referenced use case ID not found in PRD specs | Skill warns user and offers to generate based on the argument as a feature name instead (triggers exploration) |
| Generic name matches nothing in changelog, specs, or READMEs | Skill informs user that no matching feature was found in the codebase; asks user to provide more context or a different name |
| Generic name matches multiple unrelated features | Skill presents disambiguation options via AskUserQuestion with matched features listed |
| Duplicate scenario detected | Skill informs user of the existing scenario location and skips creation |
| INDEX.md is out of sync with file system | Skill rebuilds the index from file system contents before proceeding |
| Step definition language conflict (mixed files) | Skill warns user and uses the majority language |

---

## 8. Scope Definition

### In Scope

- [ ] BDD directory scaffold creation at `bdd/`
- [ ] Feature file generation (`.feature` default, `.feature.md` if project uses it) with full Gherkin support (Scenarios, Scenario Outlines, Examples, Background, data tables)
- [ ] Step definition generation with language auto-detection (Python/behave default)
- [ ] World/context module creation with framework-appropriate boilerplate and lifecycle hooks
- [ ] Features INDEX.md creation and maintenance (including updates on feature splitting)
- [ ] Steps INDEX.md creation and maintenance
- [ ] `/m:stories` Molcajete skill file
- [ ] Feature file template, step definition templates (Python, Go, TypeScript)
- [ ] World/context module templates for each supported language
- [ ] INDEX.md templates for both features and steps
- [ ] Domain-based folder organization for features and steps
- [ ] Domain auto-detection from `.claude/rules/`, `CLAUDE.md`, changelog, and codebase READMEs
- [ ] Feature file splitting when scenarios exceed 10-15 per file (promote to directory with logical groupings)
- [ ] Integration with PRD specs for use case-driven scenario generation
- [ ] Codebase exploration for generic name resolution
- [ ] Output summary after each invocation
- [ ] Full ownership of everything inside `bdd/`

### Out of Scope

- Test runner configuration and framework setup (godog wiring, behave config, cucumber-js config) -- each project handles its own test infrastructure
- CI/CD pipeline integration for running BDD tests -- separate feature
- Browser-based E2E test infrastructure (Playwright config, webServer setup) -- separate feature
- Test database provisioning and migration -- handled by existing project infrastructure
- BDD test execution or debugging -- this feature generates files only
- Visual test reporting dashboards -- separate feature

### MVP Boundaries

| Feature | MVP | Future |
|---------|-----|--------|
| Language support | Python default + detection of Go/TS | Multi-language step sharing, cross-language step bridges |
| Index management | Create and update on each invocation | Background index validation, drift detection CI check |
| Scenario generation | Full Gherkin: Scenarios, Scenario Outlines with Examples, Background, data tables | Batch generation from full spec, auto-split large features |
| PRD integration | Read requirements.md and changelog for context | Read spec.md data models, auto-generate data-driven scenarios |
| Skill invocation | `/m:stories <feature-or-UC>` | Interactive mode with domain selection, scenario refinement loop |

---

## 9. Dependencies

### Technical Dependencies

| Dependency | Version | Purpose |
|------------|---------|---------|
| Molcajete plugin | Current | Provides `/m:` skill registration and invocation infrastructure |
| Claude Code | Current | Runtime for skill execution (file read/write, glob, grep) |
| Gherkin parser (target framework) | Varies | Validates generated feature files (godog, behave, cucumber-js) |

### Blocked By

- None -- can proceed independently. The skill generates files; it does not require a running test framework.

---

## 10. Risks

| Risk | Impact | Likelihood | Mitigation |
|------|--------|------------|------------|
| INDEX.md files drift from actual file contents over time | Medium | Medium | Skill rebuilds index from file system when drift is detected; future CI check validates |
| Generated scenarios have incorrect Gherkin syntax | High | Low | Include Gherkin syntax rules in the skill prompt; validate with parser in post-generation step |
| Step definition language detection picks wrong language in mixed-language repos | Medium | Low | Majority-language heuristic; warn user on conflict; FR-0KTg-026 prevents mixing |
| PRD specs lack sufficient detail for meaningful scenario generation | Medium | Medium | Skill falls back to generating skeleton scenarios with TODO placeholders; asks user for details |
| Feature file format not supported by chosen test runner | Low | Low | Mitigated by defaulting to `.feature` (universally supported) and auto-detecting existing format (FR-0KTg-015). MDG (`.feature.md`) is only used if the project already has MDG files in place. |

---

## 11. Open Questions

| # | Question | Status | Answer |
|---|----------|--------|--------|
| 1 | Should the skill support generating Scenario Outlines with Examples tables, or only simple Scenarios in MVP? | Resolved | Yes. The skill generates full BDD Gherkin including Scenario Outlines with Examples tables, data tables, Background sections, and tags. Use the best Gherkin construct for each situation -- Scenario Outlines when testing variations of the same behavior, simple Scenarios for unique flows. |
| 2 | How should the skill handle the `.feature.md` vs `.feature` format mismatch with godog (which only supports `.feature`)? | Resolved | Default is `.feature` (standard Gherkin), which is universally supported by all BDD frameworks (godog, behave, cucumber-js, playwright-bdd). If the project already uses `.feature.md` (MDG), the skill detects and matches it. Format is never mixed. |
| 3 | Should the skill auto-detect the application domains from the argument, or ask the user? | Resolved | Auto-detect. The skill reads `.claude/rules/` files and any `CLAUDE.md` in the `bdd/` directory for user-defined domain mappings and rules. If those don't exist, the skill infers the domains from the repository structure — scanning the codebase, changelog, and README.md files. In a monorepo, it detects all domains within the repository. Only asks the user when ambiguous (multiple matches). |
| 4 | What is the maximum number of scenarios per feature file before it should be split? | Resolved | 10-15 scenarios per file. When a feature outgrows this limit, the skill promotes the single feature file into a feature directory: `user-authentication.feature` becomes `user-authentication/` containing files named by logical grouping (e.g., `login.feature`, `password-reset.feature`, `session-management.feature`). The INDEX.md must be updated to reflect the new directory structure. |
| 5 | Should the world/context module include database cleanup hooks (TRUNCATE) or defer that to the test runner configuration? | Resolved | Yes, include it. The skill owns everything inside `bdd/`. On first scaffold creation, the skill sets up the world/context module with framework-appropriate boilerplate: for Python/behave, `environment.py` + `world.py` with hooks; for Go/godog, `world.go` with `TestWorld` struct and `BeforeScenario`/`AfterScenario` hooks; for TypeScript, `world.ts` with fixtures. Templates are framework-aware but include placeholders for project-specific setup (DB connection, API base URL, auth tokens). If the world module already exists, the skill leaves it untouched. |
