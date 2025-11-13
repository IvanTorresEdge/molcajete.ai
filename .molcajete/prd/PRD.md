# Molcajete.ai - Product Requirements Document

**Product:** Molcajete.ai
**Last Updated:** 2025-11-13
**Status:** Active Development

---

## Overview

Molcajete.ai is a curated plugin marketplace for Claude Code that provides specialized agents, commands, and workflows for modern software development. It eliminates "AI multiple-personality disorder" by delivering consistent, opinionated, and battle-tested workflows from product planning through deployment.

**Key Value Proposition:** Consistency, quality, and reliability in AI-assisted development through curated plugins.

---

## Product Context

This directory contains all strategic and planning documents for Molcajete.ai. These documents establish the product vision, roadmap, and technical foundation.

### Strategic Documents

1. **[mission.md](mission.md)**
   - Product vision and long-term goals
   - Target users and their pain points
   - Key differentiators and competitive advantages
   - Success metrics and definition of success
   - What we won't do (strategic constraints)

2. **[roadmap.md](roadmap.md)**
   - Feature prioritization (Now/Next/Later)
   - Rationale for each feature and timing
   - Completed features and milestones
   - Roadmap philosophy and principles

3. **[tech-stack.md](tech-stack.md)**
   - Technology decisions and architecture
   - Integration requirements and constraints
   - Development tools and standards
   - Security, privacy, and scalability considerations
   - Decided, deferred, and rejected technical choices

4. **[PRD.md](PRD.md)** (this file)
   - Master index linking all product context
   - Quick reference for product overview
   - Document purpose and usage guide

---

## Current Plugin Collection

### Core Plugins

1. **defaults** - Core software principles and patterns that all plugins follow
2. **git** - Commit message generation and Git workflow automation
3. **prd** - Product requirements and strategic planning (this plugin!)
4. **res** - Research workflows and information synthesis
5. **go** - Go development standards, patterns, and best practices
6. **sol** - Solidity smart contract development and security

### Plugin Structure

Each plugin provides:
- **Commands** - User-facing CLI entry points (e.g., `/prd`, `/go-web-api`)
- **Agents** - Specialized AI personas with domain expertise
- **Skills** - Reusable knowledge modules for consistent guidance

### Output Structure

All plugins generate artifacts in `.molcajete/<plugin-namespace>/` directories:
- `.molcajete/prd/` - Product documents (mission, roadmap, tech-stack)
- `.molcajete/go/` - Go application artifacts
- `.molcajete/sol/` - Solidity contracts and tests
- `.molcajete/research/` - Research reports and findings

---

## Quick Reference

### Target Users
- Individual developers (solo projects)
- Development teams (2-10 people)
- Plugin creators (future)

### Core Problems Solved
1. Inconsistent AI outputs across sessions
2. Lack of specialized domain expertise
3. No reusable workflows for teams

### Key Differentiators
1. Curated quality over quantity
2. End-to-end workflow coverage
3. Consistency and reliability

### Success Definition
Primary: Personal satisfaction and utility for creator
Secondary: Community adoption and engagement (bonus)

---

## Usage Guide

### For Contributors

When contributing to Molcajete.ai or creating new plugins:

1. **Read mission.md first** - Understand the vision, values, and what we won't do
2. **Check roadmap.md** - See where the product is headed and what's prioritized
3. **Review tech-stack.md** - Follow technical standards and integration requirements
4. **Reference this PRD** - Quick overview and links to detailed context

### For Plugin Creators

When creating new plugins for the marketplace:

1. Follow the patterns established in existing plugins (defaults, git, prd, res, go, sol)
2. Ensure your plugin provides commands, agents, and skills
3. Use `.molcajete/<your-namespace>/` for all generated artifacts
4. Document thoroughly - README, examples, and inline documentation
5. Test with real-world workflows before publishing

### For Users

When using Molcajete.ai plugins:

1. Install via `/plugin marketplace add` command or config file
2. Invoke commands (e.g., `/prd`, `/go-web-api`, `/sol-contract`)
3. Review generated artifacts in `.molcajete/` directories
4. Provide feedback through GitHub issues
5. Fork and customize plugins for your specific needs

---

## Document Maintenance

### When to Update

- **mission.md** - When vision, target users, or strategy changes
- **roadmap.md** - After completing features; when priorities shift
- **tech-stack.md** - When making significant technical decisions
- **PRD.md** - When adding new documents or changing structure

### Update Process

1. Make changes in relevant document(s)
2. Update "Last Updated" date at the top of PRD.md
3. Commit with clear message explaining what changed and why
4. Ensure all cross-references remain accurate

---

## Additional Resources

### Repository
- **GitHub:** [molcajete.ai-marketplace](https://github.com/ivan/molcajete.ai-marketplace)
- **Issues:** Report bugs or request features
- **Discussions:** Ask questions or share ideas

### Documentation
- **README.md** - Project overview and installation
- **Plugin READMEs** - Specific plugin documentation
- **EXAMPLES.md** - Real-world usage examples (future)

### Community
- GitHub Discussions for Q&A and ideas
- GitHub Issues for bugs and feature requests
- Pull requests for contributions

---

## Version History

- **2025-11-13** - Initial PRD created during product planning workflow
  - Established mission, roadmap, and tech-stack documents
  - Defined target users, problems, and differentiators
  - Set personal-need-driven prioritization philosophy
