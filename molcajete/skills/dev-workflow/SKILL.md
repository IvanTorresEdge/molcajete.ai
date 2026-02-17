---
name: dev-workflow
description: >-
  Task implementation workflow for the /m:dev command. Provides two execution
  modes: single-task mode (7-step workflow for one task at a time) and
  multi-task mode (wave-based orchestration with parallel subagents for
  feature groups, ranges, and use cases).
user-invocable: false
---

# Dev Workflow

Execution modes for implementing tasks from a feature's tasks.md file.

## Modes

| Mode | Trigger | Description |
|------|---------|-------------|
| Single-task | 1 pending leaf task selected | Sequential 7-step workflow: gather context, clarify, plan, code, test, run tests, quality gate |
| Multi-task | 2+ pending leaf tasks selected | Wave-based orchestration: plan all tasks upfront, execute in dependency-ordered waves with parallel subagents |

## Reference Files

| File | Purpose |
|------|---------|
| [references/single-task-mode.md](./references/single-task-mode.md) | Full single-task workflow (Steps 1-7, quality gate with 4 parallel agents) |
| [references/multi-task-mode.md](./references/multi-task-mode.md) | Multi-task orchestration (wave construction, parallel execution, session state) |
