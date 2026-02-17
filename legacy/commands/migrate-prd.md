---
description: Migrate deprecated .molcajete/prd/ files to the current prd/ format
model: claude-opus-4-6
allowed-tools: Bash, Glob, Task, AskUserQuestion
argument-hint: (no arguments)
---

# Migrate Legacy PRD

You are an orchestrator that migrates files from the deprecated `.molcajete/prd/` directory to the current `prd/` format. You **never read file contents directly** — all file reading and writing is delegated to sub-agents via the Task tool.

## Critical Directives

1. **Non-destructive.** Copy files to new locations. Never delete or modify originals under `.molcajete/prd/`.
2. **Delegate everything.** Never use the Read, Write, or Edit tools yourself. All file I/O happens inside sub-agents.
3. **Protect main context.** The orchestrator only holds folder names, timestamps, tags, and sub-agent summaries — never full file contents.

## Step 1: Discovery

Use Bash to verify `.molcajete/prd/` exists and list its contents:

```bash
ls -1 .molcajete/prd/
```

Identify:
- **Foundation files:** Top-level `.md` files (e.g., `PRD.md`, `mission.md`, `roadmap.md`, `tech-stack.md`, `changelog.md`)
- **Feature folders:** Directories matching the old format `{YYYYMMDD}-{feature_name}` (e.g., `20260115-user_authentication`)

If `.molcajete/prd/` does not exist, tell the user there is nothing to migrate and stop.

If `prd/` already exists at the project root, use AskUserQuestion to warn the user:
- **Question:** "A `prd/` directory already exists at the project root. Migrating will add files to it. Proceed?"
- **Header:** "Overwrite"
- **Options:**
  1. "Proceed" — Continue with migration, merging into existing `prd/`
  2. "Cancel" — Stop the migration
- **multiSelect:** false

## Step 2: Compute Feature Tags

For each feature folder, compute the new folder name and base-62 tag.

Use Bash to run this Python snippet for each feature folder. Pass all folders at once:

```bash
python3 -c "
import os, sys

CHARSET = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz'
EPOCH_MINUTES = (2026 - 1970) * 365.25 * 24 * 60  # 2026-01-01 00:00 in minutes from Unix epoch

def to_base62(n):
    if n == 0:
        return '0000'
    digits = []
    while n > 0:
        digits.append(CHARSET[n % 62])
        n //= 62
    result = ''.join(reversed(digits))
    return result.zfill(4)

def parse_old_folder(name):
    # Old format: YYYYMMDD-feature_name
    parts = name.split('-', 1)
    date_str = parts[0]
    slug = parts[1] if len(parts) > 1 else 'unnamed'

    year = int(date_str[0:4])
    month = int(date_str[4:6])
    day = int(date_str[6:8])

    # Try to get file creation time for HHmm
    folder_path = f'.molcajete/prd/{name}'
    try:
        stat = os.stat(folder_path)
        # Use birth time (st_birthtime on macOS)
        import datetime
        ctime = datetime.datetime.fromtimestamp(stat.st_birthtime)
        hour = ctime.hour
        minute = ctime.minute
    except (AttributeError, OSError):
        hour = 0
        minute = 0

    # Compute minutes since 2026-01-01 00:00
    import datetime
    folder_dt = datetime.datetime(year, month, day, hour, minute)
    epoch_dt = datetime.datetime(2026, 1, 1, 0, 0)
    total_minutes = int((folder_dt - epoch_dt).total_seconds() / 60)

    # Handle pre-epoch dates (negative minutes) — use absolute value
    tag = to_base62(abs(total_minutes))

    new_name = f'{date_str}-{hour:02d}{minute:02d}-{slug}'
    return new_name, tag, slug

folders = sys.argv[1:]
for f in folders:
    new_name, tag, slug = parse_old_folder(f)
    print(f'{f}|{new_name}|{tag}|{slug}')
" FOLDER_NAMES_HERE
```

Replace `FOLDER_NAMES_HERE` with the actual folder names from Step 1, space-separated.

Parse the output into a mapping:
- `old_name` → `new_name`, `tag`, `slug`

## Step 3: Migrate Foundation Files

Launch **1 sub-agent** (Task tool, subagent_type: `general-purpose`) to transform and migrate foundation files.

**Prompt for the sub-agent:**
````
You are migrating foundation PRD files from `.molcajete/prd/` to `prd/` at the project root.

The old format uses narrative bullet lists and flat structure. The new format uses table-centric organization, Mermaid diagrams, comparison tables, and structured sections. You must **transform** each document's structure — not just copy it.

## Instructions

1. Create the `prd/` directory if it doesn't exist.
2. Read each source file from `.molcajete/prd/` listed below (skip any that don't exist).
3. Transform each file according to its specific rules below, then Write to the destination.
4. Do not modify original files under `.molcajete/prd/`.
5. Read each source file, then Write to the destination. Do not use Bash cp.

## Feature folder mapping (for updating links):
{INSERT_FOLDER_MAPPING_HERE}

---

## Transformation Rules

### PRD.md → prd/README.md

**Source sections to extract from:**
- Product name and description → Product Overview + Quick Facts table
- Feature list or references → Feature Specifications table in Document Index
- Target users / audience → User Personas section
- Any guiding principles mentioned → Design Principles
- Domain-specific terms → Glossary

**Target structure:**

```markdown
# {Product Name} — Product Documentation

## Product Overview

**{Product Name}** is {one-sentence description extracted from PRD}.

### Quick Facts

| Attribute | Value |
|-----------|-------|
| Target Market | {extract from PRD or mission} |
| Primary Users | {extract user types} |
| Core Value | {extract value proposition} |
| Key Metric | {extract north star metric if present, otherwise "TBD"} |

## Document Index

### Strategic Documents

| Document | Purpose | Location |
|----------|---------|----------|
| [Mission](./mission.md) | Vision, users, differentiators, success metrics | `prd/mission.md` |
| [Roadmap](./roadmap.md) | Feature priorities (Now/Next/Later) | `prd/roadmap.md` |
| [Tech Stack](./tech-stack.md) | Technology choices and architecture | `prd/tech-stack.md` |
| [Changelog](./changelog.md) | What's been built, mapped to requirements | `prd/changelog.md` |

### Feature Specifications

| Feature | Requirements | Spec | Tasks | Status |
|---------|-------------|------|-------|--------|
| {Feature Name} | [Req](./specs/{new_folder}/requirements.md) | [Spec](./specs/{new_folder}/spec.md) | [Tasks](./specs/{new_folder}/tasks.md) | {status} |

(Build one row per feature folder from the mapping above. Use the NEW folder names for links.)

## Current Focus

Based on the [Roadmap](./roadmap.md), current priorities are:

1. **{Feature 1}** — {brief description}
2. **{Feature 2}** — {brief description}

(Extract from roadmap's "Now" items if present in PRD, otherwise use first 2 features.)

## User Personas

For each target user type found in the old PRD or mission:

### {Persona Name} — The {Role}
> "{Quote capturing their core frustration — infer from pain points}"

- **Goal**: {primary goal}
- **Frustration**: {main pain point}

(If the old PRD has minimal user info, create brief personas from whatever target user info exists.)

## Design Principles

1. **{Principle}** — {explanation}

(Extract from any guiding principles, design philosophy, or core values in the old PRD. If none exist, derive 2-3 from the product's mission and approach.)

## Glossary

| Term | Definition |
|------|------------|
| {term} | {definition} |

(Extract domain-specific terms from the old PRD. If none are obvious, include 2-3 key product terms.)
```

### mission.md → prd/mission.md

**Transformation rules:**
- Old "Vision" paragraph → "Vision Statement" (keep as-is, just rename heading)
- Old "Problem" or introductory text → "Problem Statement" with numbered root causes. If the old file just has a paragraph, break it into 2-4 root causes.
- Old "Target Users" bullet list → Structured subsections per user type, each with Demographics, Pain Points, Technical Profile, Platforms. Infer missing fields from context.
- Old "Differentiators" bullet list → Comparison table: `| {Product} | {Competitor Type 1} | {Competitor Type 2} |`. Map each differentiator to a row showing how competitors handle it differently (infer competitor approaches from the differentiator descriptions).
- Old "Success Metrics" flat list → Split into 3 tables: Primary Metrics (North Stars), Secondary Metrics, Business Metrics. Each table has columns: Metric | Target | Measurement. If the old list doesn't clearly categorize, put user-facing metrics in Primary, engagement metrics in Secondary, revenue/growth in Business.
- Add "What {Product Name} Will NOT Do" section at the end. Infer 2-3 items from the product's scope boundaries, or from what's conspicuously absent. Format as: `- **Not a {X}** — {explanation}`.

**Target structure:**

```markdown
# {Product Name} Mission

## Vision Statement
{paragraph}

## Problem Statement
{Brief description}. This gap exists because:
1. **{Root cause 1}** — {explanation}
2. **{Root cause 2}** — {explanation}

## Target Users

### Primary: {User Type}
- **Demographics**: {who they are}
- **Pain Points**:
  - {pain point}
- **Technical Profile**: {device usage, tech comfort}
- **Platforms**: {where they'll use the product}

## Key Differentiators

| {Product Name} | {Competitor Type 1} | {Competitor Type 2} |
|----------------|---------------------|---------------------|
| {differentiator 1} | {competitor approach} | {competitor approach} |

## Success Metrics

### Primary Metrics (North Stars)
| Metric | Target | Measurement |
|--------|--------|-------------|

### Secondary Metrics
| Metric | Target | Measurement |
|--------|--------|-------------|

### Business Metrics
| Metric | Target | Measurement |
|--------|--------|-------------|

## What {Product Name} Will NOT Do
- **Not a {X}** — {explanation}
```

### roadmap.md → prd/roadmap.md

**Transformation rules:**
- Add a "Roadmap Philosophy" paragraph at the top — synthesize from the product's approach to prioritization.
- Old flat feature listings under Now/Next/Later → Themed tables. Each time horizon gets a `**Theme: {name}**` header and a table with columns: Feature | Description | Priority | Dependencies | Spec | Tasks. For "Now" items, include Spec and Tasks links using the feature folder mapping. For "Next" and "Later", omit Spec/Tasks columns.
- Add `**Rationale**: {why}` after each themed table — infer from feature grouping.
- If the old roadmap has completed features, move them to a "Completed" table with columns: Feature | Description | Completed Date | Notes.
- Add "Roadmap Principles" section with 2-3 principles derived from the product approach.
- Add "Dependencies and Risks" table with columns: Risk | Impact | Mitigation. Infer 2-3 risks from the tech stack and feature scope.

**Target structure:**

```markdown
# {Product Name} Product Roadmap

## Roadmap Philosophy
{paragraph}

## Now (Current Sprint / Immediate Priority)

**Theme: {theme name}**

| Feature | Description | Priority | Dependencies | Spec | Tasks |
|---------|-------------|----------|--------------|------|-------|
| {feature} | {desc} | Critical/High | {deps} | [Spec](./specs/{folder}/spec.md) | [Tasks](./specs/{folder}/tasks.md) |

**Rationale**: {why these features are prioritized now}

## Next (Next 1-2 Sprints)

**Theme: {theme name}**

| Feature | Description | Priority | Dependencies |
|---------|-------------|----------|--------------|
| {feature} | {desc} | {priority} | {deps} |

**Rationale**: {why these features come next}

## Later (Future Sprints / Backlog)

**Theme: {theme name}**

| Feature | Description | Priority | Dependencies |
|---------|-------------|----------|--------------|

**Rationale**: {why these features are deferred}

## Completed

| Feature | Description | Completed Date | Notes |
|---------|-------------|----------------|-------|

## Roadmap Principles
1. **{Principle}** — {explanation}

## Dependencies and Risks

| Risk | Impact | Mitigation |
|------|--------|------------|
```

### tech-stack.md → prd/tech-stack.md

**Transformation rules:**
- Old hierarchical bullet lists of technologies → Component tables organized by Backend, Frontend, Infrastructure sections. Each table has columns appropriate to the subsection (see target structure).
- Add "Architecture" section with a Mermaid `graph TD` diagram. Infer the architecture from the technologies listed (e.g., if there's a React frontend and Express backend, show Client → API → DB flow).
- Add "Project Structure" section with a tree view of the project layout. Infer from the tech stack (e.g., if it's a Next.js app, show standard Next.js structure).
- Add "Development Commands" section with common commands for the stack.
- Add "Environment Variables" section with placeholder variables for the stack.
- Add "Standards and Conventions" section covering Code Style, API Design, Database, and Testing conventions inferred from the stack choices.

**Target structure:**

```markdown
# {Product Name} Technology Stack

## Overview
{paragraph about technology philosophy}

## Architecture

\```mermaid
graph TD
    subgraph Clients
        A["{Client}"]
    end
    subgraph API
        C["{API Layer}"]
    end
    subgraph Data
        D["{Database}"]
    end
    A --> C
    C --> D
\```

## Backend

### Language and Framework

| Component | Technology | Version | Purpose |
|-----------|------------|---------|---------|

### Key Dependencies
\```
{key backend deps}
\```

## Frontend

### Framework and Build

| Component | Technology | Version | Purpose |
|-----------|------------|---------|---------|

### UI and Styling

| Component | Technology | Purpose |
|-----------|------------|---------|

### State and Data

| Component | Technology | Purpose |
|-----------|------------|---------|

### Testing

| Component | Technology | Purpose |
|-----------|------------|---------|

### Code Quality

| Component | Technology | Purpose |
|-----------|------------|---------|

## Infrastructure

### Development

| Component | Technology | Purpose |
|-----------|------------|---------|

### Production

| Component | Technology | Purpose |
|-----------|------------|---------|

## Project Structure
\```
{project}/
├── {dir}/    # {description}
\```

## Development Commands

### {Subsystem}
\```bash
{command}    # {description}
\```

## Environment Variables

### {Subsystem}
\```bash
# {Category}
{VAR}={description}
\```

## Standards and Conventions

### Code Style
- **{Language}**: {convention}

### API Design
- {convention}

### Database
- {convention}

### Testing
- {convention}
```

(Note: In the actual output, use real triple backticks — the backslash-escaped backticks above are just to avoid breaking this prompt's formatting.)

### changelog.md → prd/changelog.md

**If the file exists:** Restructure into the chronological format below. Map any existing entries to dated entries with timestamps.

**If the file does NOT exist:** Create a new file with the template structure and a single initial entry noting the migration date.

**Target structure:**

```markdown
# {Product Name} Changelog

Chronological record of implemented changes. Each entry links to its plan file and per-task changelog file for detailed context.

## How to Use This Document

- **Organized chronologically** — newest entries first within each date group.
- **Entries link to detail files**: plan files describe what was planned, per-task changelog files describe what was implemented.
- **Update after each task**: add a dated entry when a task or fix is completed.
- Per-task changelog files live in `prd/specs/{feature}/plans/changelog-*.md`.

---

## {YYYY-MM-DD}

- [{HH:MM}] {Change title}
  {1-2 sentence description.}
```

---

## Rules
- Read each source file, then Write to the destination. Do not use Bash cp.
- Do not modify original files under `.molcajete/prd/`.
- When inferring content (personas, risks, principles, etc.), base it on what's actually in the source files — don't fabricate unrelated information.
- If a source file has sections that don't map to the new format, preserve the content in the most appropriate new section.
- Report back: which files were transformed, which were skipped (not found), and any sections where you had to infer significant content.
````

Replace `{INSERT_FOLDER_MAPPING_HERE}` with the old→new folder name mapping from Step 2, formatted as a markdown table.

## Step 4: Migrate Feature Folders

Launch **1 sub-agent per feature folder** (Task tool, subagent_type: `general-purpose`). Launch them in parallel batches — up to 4 at a time.

**Prompt template for each sub-agent:**
```
You are migrating a single feature folder from the deprecated `.molcajete/prd/` format to the current `prd/specs/` format.

## Source and Destination

- **Old folder:** `.molcajete/prd/{OLD_FOLDER_NAME}/`
- **New folder:** `prd/specs/{NEW_FOLDER_NAME}/`
- **Feature tag:** `{TAG}`

## Base-62 ID Scheme

All IDs in the new format use this pattern:
- `UC-{TAG}-NNN` — Use Case
- `US-{TAG}-NNN` — User Story
- `FR-{TAG}-NNN` — Functional Requirement
- `NFR-{TAG}-NNN` — Non-Functional Requirement

Tasks use dot notation: `UC-{TAG}-NNN/N.M`

## Instructions

1. Create the destination folder `prd/specs/{NEW_FOLDER_NAME}/`.
2. Read all `.md` files in `.molcajete/prd/{OLD_FOLDER_NAME}/`.
3. For each file, apply the following transformations:

### requirements.md transformation
- Find old-style numbered requirements (e.g., "Requirement 1", "User Story 1", plain numbered lists of requirements).
- Convert to structured UC/US/FR/NFR format:
  - Group related requirements under Use Cases (`UC-{TAG}-NNN`)
  - Each use case gets User Stories (`US-{TAG}-NNN`)
  - Each user story gets Functional Requirements (`FR-{TAG}-NNN`)
  - Add Non-Functional Requirements (`NFR-{TAG}-NNN`) for performance, security, etc.
- Number sequentially: UC-{TAG}-001, UC-{TAG}-002, etc.
- If the old format has no clear use-case grouping, create one UC per major feature area.

### spec.md transformation
- Update any references to old requirement IDs to use the new UC/US/FR/NFR IDs.
- Keep all other content (data models, API contracts, diagrams) as-is.

### tasks.md transformation
- Convert "Feature N" or numbered section headers to `UC-{TAG}-NNN` sections.
- Convert old task numbering `N.M` (e.g., `1.1`, `2.3`) to the new format: `UC-{TAG}-NNN/N.M`.
- Update story point scale: if old values used 1/3/5/8, keep 1/3/5/8. The new scale is 1/2/3/5/8 but do not change existing estimates — just note the scale difference.
- Preserve task descriptions, acceptance criteria, and dependencies.

### Other .md files
- Copy as-is to the new folder.

4. Write all transformed files to `prd/specs/{NEW_FOLDER_NAME}/`.

## Rules
- Read source files, transform in memory, Write to destination. Do not use Bash cp.
- Do not modify original files under `.molcajete/prd/`.
- If a file cannot be parsed or has unexpected format, copy it as-is and note the issue.
- Report back a summary:
  - Files migrated (with names)
  - ID mappings created (old → new, as a table)
  - Any issues encountered
```

Replace `{OLD_FOLDER_NAME}`, `{NEW_FOLDER_NAME}`, and `{TAG}` with values from Step 2.

## Step 5: Migration Report

After all sub-agents complete, collect their summaries and present a migration report using AskUserQuestion:

**Question:** "Migration complete. Review the summary below and confirm."
**Header:** "Results"
**Options:**
  1. "Done" — Accept the migration results
  2. "Show details" — Print the full sub-agent reports

**Report format:**
```
## Migration Summary

### Foundation Files
- {file}: .molcajete/prd/{name} → prd/{name} (or skipped)

### Feature Folders
| Old Folder | New Folder | Tag | Files | Issues |
|------------|-----------|-----|-------|--------|
| {old} | {new} | {tag} | {count} | {issues or "None"} |

### ID Mappings
{Combined ID mapping tables from sub-agents}
```

If the user selects "Show details", print each sub-agent's full report.

## Rules

- Use AskUserQuestion for ALL user interaction. Never ask questions as plain text.
- Never read file contents yourself — always delegate to sub-agents.
- Launch parallel sub-agents where possible (up to 4 at a time).
- If `.molcajete/prd/` does not exist, inform the user and stop immediately.
- Do not use the word "comprehensive" in any output.
