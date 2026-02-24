---
name: gherkin
description: >-
  Conventions and rules for BDD scenario generation. Use this skill when
  creating Gherkin feature files, step definitions, or managing the bdd/
  scaffold. It defines language/format detection, domain detection, file naming,
  tagging, step writing rules, and index maintenance.
---

# Gherkin BDD Conventions

Standards for generating BDD scenarios, step definitions, and maintaining the `bdd/` scaffold.

## Scaffold Structure

The canonical `bdd/` directory tree:

```
bdd/
├── features/
│   ├── INDEX.md
│   ├── cross-domain/
│   └── {domain}/
│       └── {feature-name}.feature
├── steps/
│   ├── INDEX.md
│   ├── world.[ext]
│   ├── common_steps.[ext]
│   ├── api_steps.[ext]
│   ├── db_steps.[ext]
│   └── {domain}_steps.[ext]
```

Note: `bdd/.claude/rules/` is user-created when needed for custom domain mappings — it is not part of the auto-generated scaffold.

## Language Detection Rules

Scan existing step files to determine the language:

1. Glob `bdd/steps/*.*` and count file extensions: `.py`, `.go`, `.ts`.
2. If no step files exist → default to **Python** (behave).
3. If one language detected → use that language.
4. If multiple languages detected → use the majority language and warn: "Mixed languages detected in `bdd/steps/`: {list}. Using majority language: {language}."
5. **Never** create step files in a different language than detected.

### Language-to-Framework Mapping

| Extension | Language | Framework | Step syntax |
|-----------|----------|-----------|-------------|
| `.py` | Python | behave | `@given`, `@when`, `@then` decorators |
| `.go` | Go | godog | `ctx.Step` registration in `InitializeScenario` |
| `.ts` | TypeScript | cucumber-js | `Given`, `When`, `Then` from `@cucumber/cucumber` |

## Format Detection Rules

1. Glob `bdd/features/**/*.feature.md`.
2. Glob `bdd/features/**/*.feature` (excluding `.feature.md` matches).
3. If `.feature.md` files exist → use **MDG format** (Markdown-Gherkin).
4. Else if `.feature` files exist → use **standard Gherkin**.
5. Else → default to **standard Gherkin** (`.feature`).
6. **Never** mix formats within `bdd/features/`.

## Domain Detection Priority

Determine domain subdirectories under `bdd/features/` using this priority — stop at the first source that yields names:

1. **User-defined rules:** Glob `bdd/.claude/rules/*.md` for explicit domain mappings.
2. **BDD conventions file:** Read `bdd/CLAUDE.md` for domain conventions.
3. **Existing domain folders:** Glob `bdd/features/*/` — preserve existing domains.
4. **Changelog:** Read `prd/changelog.md` for domain-organized sections.
5. **PRD specs:** Glob `prd/specs/*/` and group slugs into logical domains.
6. **Codebase structure:** Glob top-level and `server/`/`src/` subdirectories.

If no sources yield domains, create a single `general/` domain folder. Always ensure `cross-domain/` exists. Use kebab-case naming.

## File Naming Rules (FR-0KTg-016)

- Use kebab-case: `user-registration.feature`, not `userRegistration.feature` or `user_registration.feature`
- Name must describe the feature, not a scenario: `password-reset.feature`, not `forgot-password-click.feature`

## Tagging Rules (FR-0KTg-017)

Every scenario must have at least one tag. Choose from:

| Tag | When to use |
|-----|-------------|
| `@smoke` | Core happy-path scenarios that must always pass |
| `@regression` | Standard coverage scenarios |
| `@critical` | Scenarios testing security, data integrity, or financial correctness |
| `@backend` | Scenarios that test server-side behavior only |
| `@fullstack` | Scenarios requiring UI + backend interaction |
| `@{domain}` | Domain-specific tag matching the folder name (e.g., `@auth`, `@billing`) |

Scenarios may have multiple tags. Feature-level tags: `@{domain}` and one priority tag (`@smoke`, `@regression`, or `@critical`).

## Step Writing Rules

| Rule | Requirement | Good example | Bad example |
|------|-------------|--------------|-------------|
| Declarative Given (FR-0KTg-018) | Given steps describe state, not procedures | `Given user alice is logged in` | `Given I open the login page and type alice into the username field` |
| Exact Then (FR-0KTg-019) | Then steps make exact assertions | `Then the balance is exactly $94.00` | `Then the balance is around $94` |
| Reusable patterns | Use parameterized patterns for similar steps | `Given user {name} is logged in` | `Given user alice is logged in` + `Given user bob is logged in` as separate steps |

## Gherkin Construct Selection (FR-0KTg-046 through FR-0KTg-049)

| Situation | Construct | Example |
|-----------|-----------|---------|
| Unique flow with specific setup and assertion | `Scenario` | Login with valid credentials |
| Same flow tested with different inputs/outputs | `Scenario Outline` + `Examples` | Login with various invalid credentials |
| Multiple scenarios sharing the same preconditions | `Background` | All scenarios need a logged-in user |
| Structured input data in a step | Data table | Creating a user with multiple fields |

Prefer `Scenario Outline` over multiple near-identical `Scenario` blocks. Use `Background` sparingly — only for truly shared preconditions, not convenience.

## Step Reuse Policy (FR-0KTg-012)

Before creating any step definitions, read `bdd/steps/INDEX.md` to identify existing reusable patterns. For each step in the generated feature file:

1. Search INDEX.md for a matching pattern (exact or parameterized).
2. If match exists → reuse. Do not create a duplicate.
3. If no match → create a new step definition.

### Step File Placement

| Category | File | When to use |
|----------|------|-------------|
| Common | `common_steps.[ext]` | Generic steps reusable across domains: login, navigation, time manipulation, basic CRUD |
| API | `api_steps.[ext]` | HTTP request/response steps: sending requests, checking status codes, validating response bodies |
| Database | `db_steps.[ext]` | Database assertion steps: checking row counts, verifying column values, seeding test data |
| Domain-specific | `{domain}_steps.[ext]` | Steps unique to a business domain: billing calculations, notification rules, auth policies |

If the target step file exists, append new definitions. If not, create it using the matching template from `templates/`.

## Step Definition Rules (FR-0KTg-020)

Every new step definition must include:
- A docstring (Python) or doc comment (Go, TypeScript) describing what the step does
- Parameter descriptions with types in the docstring
- A `TODO: implement step` placeholder body (not an empty body)

## Index Maintenance Rules (FR-0KTg-029)

Both `bdd/features/INDEX.md` and `bdd/steps/INDEX.md` must be updated together after any generation. Never leave partial index state — updating one without the other could introduce drift.

## Reference Files

| File | Description |
|------|-------------|
| [references/scaffold.md](./references/scaffold.md) | Scaffold creation and index validation procedure (Steps 2a-2h) |
| [references/exploration.md](./references/exploration.md) | Codebase exploration for generic feature names (Steps 2-exp-a to 2-exp-e) |
| [references/generation.md](./references/generation.md) | Feature file and step definition generation (Steps 3-pre to 3d) |
| [templates/](./templates/) | Individual file templates (INDEX.md, world modules, features, steps) |
| [references/splitting.md](./references/splitting.md) | Feature file splitting when scenario count exceeds 15 (Step 3e) |
