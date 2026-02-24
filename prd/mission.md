# Molcajete.ai Mission

## Vision Statement

Every developer using agentic coding gets the same high-quality, structured output — regardless of the project, the prompt, or the session. Molcajete.ai makes disciplined software development the default mode for LLM-assisted coding, not an afterthought.

## Problem Statement

LLMs produce inconsistent output when coding. Without structure, they skip steps, forget context, and vary wildly between sessions. This gap exists because:

1. **No enforced process** — LLMs respond to whatever prompt they receive; there is no built-in workflow for requirements, specs, implementation, or validation.
2. **Per-project configuration** — CLAUDE.md files and rules must be written from scratch for each project, leading to drift and inconsistency.
3. **No portability** — Good workflows discovered in one project don't transfer to the next without manual effort.
4. **No self-validation** — There is no mechanism to verify that the LLM followed the intended process or produced the expected artifacts.

## Target Users

### Primary: Individual Developer

- **Demographics**: Software developers using Claude Code as their primary agentic coding tool
- **Pain Points**:
  - Output quality varies between sessions even with the same instructions
  - Re-inventing prompts and workflows for every new project
  - No structured path from idea to tested, documented code
- **Technical Profile**: Comfortable with terminal, CLI tools, and Markdown
- **Platforms**: macOS, Linux (terminal-based)

### Primary: Team Lead

- **Demographics**: Engineering leads managing teams that use Claude Code
- **Pain Points**:
  - No shared workflow across team members
  - Inconsistent artifacts (specs, code, tests) from developer to developer
  - Difficult to establish and enforce development standards with LLM tools
- **Technical Profile**: Technical, manages process and code quality
- **Platforms**: macOS, Linux (terminal-based)

## Key Differentiators

| Molcajete.ai | CLAUDE.md / Rules | Generic Prompt Libraries |
|--------------|-------------------|--------------------------|
| Portable across projects — install once | Per-project, must recreate | Copy-paste, no integration |
| Enforces a full lifecycle (scope to review) | Ad-hoc instructions, no sequence | Isolated prompts, no workflow |
| Commands produce consistent artifacts | Output depends on how rules are written | No structured output |
| Self-documenting — artifacts are the docs | Documentation is separate effort | No documentation output |
| Complements CLAUDE.md, not replaces it | Standalone | Standalone |

## Success Metrics

### Primary Metrics (North Stars)

| Metric | Target | Measurement |
|--------|--------|-------------|
| Output consistency | Same command produces same artifact structure across projects | Manual review of outputs across 5+ projects |
| Workflow coverage | Full lifecycle from feature scoping to code review | Count of lifecycle stages with dedicated commands |
| Adoption | Active installs via Claude Code plugin system | Plugin install count |

### Secondary Metrics

| Metric | Target | Measurement |
|--------|--------|-------------|
| Command count | Cover all major development activities | Count of commands in `molcajete/commands/` |
| Skill coverage | Domain knowledge for common stacks and patterns | Count of skills in `molcajete/skills/` |

### Business Metrics

| Metric | Target | Measurement |
|--------|--------|-------------|
| Community contributions | External skill/command contributions | Pull requests from non-maintainers |
| Marketplace presence | Listed and discoverable in Claude Code | Plugin marketplace listing |

## What Molcajete.ai Will NOT Do

- **Not a code generator** — It structures the process; the LLM writes the code. Molcajete defines the workflow, not the implementation.
- **Not a replacement for CLAUDE.md** — It complements project-level instructions. CLAUDE.md handles project-specific conventions; Molcajete handles portable workflows.
- **Not an IDE or editor** — It runs inside Claude Code's CLI. It does not provide a GUI, editor, or standalone application.
- **Not opinionated about your stack** — Commands are stack-agnostic. Skills provide stack-specific knowledge, but the workflow works with any technology.
