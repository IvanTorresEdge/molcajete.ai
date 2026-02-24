# Molcajete.ai — Product Documentation

## Product Overview

**Molcajete.ai** is a Claude Code plugin that provides opinionated commands and skills to guide agentic coding through structured steps — requirements, specs, plans, implementation, testing, and review — producing consistent, high-quality output across projects.

### Quick Facts

| Attribute | Value |
|-----------|-------|
| Target Market | Developers using Claude Code for agentic coding |
| Primary Users | Individual developers, team leads |
| Core Value | Consistent, structured output from LLMs across every project |
| Key Metric | Output consistency across projects using the same command |

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
| BDD Scenario Generator | [Req](./specs/20260223-1600-bdd_scenario_generator/requirements.md) | [Spec](./specs/20260223-1600-bdd_scenario_generator/spec.md) | [Tasks](./specs/20260223-1600-bdd_scenario_generator/tasks.md) | Tasks planned |

## Current Focus

Based on the [Roadmap](./roadmap.md), current priorities are:

1. **BDD Self-Testing** — Write `.feature` files to validate that commands and skills produce expected output
2. **Workflow Refinement** — Polish existing commands and skills based on real-world usage

## User Personas

### Dev — The Solo Builder
> "I spend more time fixing LLM output than I would writing it myself."

- **Role**: Individual developer using Claude Code daily
- **Device**: Terminal (macOS/Linux)
- **Goal**: Get reliable, structured output from agentic coding — specs, code, tests — without babysitting every step
- **Frustration**: Each project requires re-inventing prompts and workflows; output quality varies wildly between sessions

### Lead — The Process Owner
> "Every developer on my team uses Claude Code differently. There's no consistency."

- **Role**: Team lead or engineering manager
- **Device**: Terminal (macOS/Linux)
- **Goal**: Establish a shared development workflow so every team member produces consistent artifacts
- **Frustration**: CLAUDE.md files are per-project and per-developer; no portable, reusable process

## Design Principles

1. **Opinionated by default** — Every command prescribes a specific process. Users follow the path, not invent their own.
2. **Portable across projects** — Install once, use everywhere. Workflows are not tied to any specific codebase.
3. **Self-documenting** — The process generates its own documentation as a byproduct of following the workflow.

## Glossary

| Term | Definition |
|------|------------|
| Command | A Markdown file with YAML frontmatter that defines a reusable Claude Code slash command |
| Skill | A knowledge document (SKILL.md) that provides domain expertise, patterns, and templates |
| Plugin | A collection of commands and skills packaged for Claude Code's plugin system |
| PRD | Product Requirements Documentation — the `prd/` directory structure |
