# Molcajete.ai Changelog

Chronological record of implemented changes. Each entry links to its plan file and per-task changelog file for detailed context.

## How to Use This Document

- **Organized chronologically** — newest entries first within each date group.
- **Entries link to detail files**: plan files describe what was planned, per-task changelog files describe what was implemented.
- **Update after each task**: add a dated entry when a task or fix is completed.
- Per-task changelog files live in `prd/specs/{feature}/plans/changelog-*.md`.

---

## 2026-02-23

- [--:--] Product documentation initialized
  Created `prd/` directory with mission, tech-stack, roadmap, and changelog documents.

## 2026-02 (Pre-PRD)

The following features were built before product documentation was established. Entries are derived from git history.

- Clipboard skill and command integration (d6be7d8)
  Added clipboard skill and updated commands to use it.

- v2 workflow redesign (c0a9ee2)
  Redesigned Molcajete.ai with v2 workflow — new command structure, skill organization, and plugin format.

- Command updates for Bash allowed-tools (249e05c)
  Updated commands to use `Bash(*)` allowed-tools format.

- Heredoc removal from commit commands (9bc633d)
  Removed heredoc usage from commit commands for compatibility.

- Loop command removal (fe6fc67)
  Removed the loop command from the command set.
