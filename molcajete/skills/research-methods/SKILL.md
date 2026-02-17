---
name: research-methods
description: Standards and methods for conducting research, gathering information, and presenting findings with proper source attribution. Use when researching topics, analyzing documentation, or synthesizing information from multiple sources.
---

# Research Methods

Standards for conducting research, evaluating sources, and presenting information in clear, well-formatted responses.

## When to Use This Skill

Use this skill when:
- Researching documentation for tools, frameworks, or APIs
- Gathering information from multiple sources
- Synthesizing findings into coherent responses
- Creating reference materials
- Answering questions requiring external information
- Building knowledge bases

## Key Principles

1. **Ask before researching** - Clarify ambiguous queries before starting
2. **Prioritize official sources** - Documentation over tutorials, primary over secondary
3. **Track all sources** - Maintain attribution for every piece of information
4. **Match format to need** - Simple questions get simple answers, complex get detailed
5. **Accuracy over speed** - Cross-reference critical information
6. **User-focused presentation** - Scannable, organized, actionable

## Response Type Selection

### Simple Response

**Use when:**
- Single, specific question
- How-to query with clear scope
- Quick reference lookup
- Command syntax or parameter info
- Definition or concept explanation
- User wants fast answer

**Template:**
```markdown
# [Concise Title]

[Direct answer to the question]

[Code example if applicable]

## Sources
- [URL] - [Description]
```

**Example questions:**
- "How do I amend a git commit?"
- "What is the Stop hook in Claude Code?"
- "How to use WebFetch tool?"

### Detailed Response

**Use when:**
- Broad, exploratory question
- Request mentions "all", "detailed", "in-depth"
- Time estimate provided ("5 min intro", "quick overview")
- Multiple related concepts
- Comparative analysis
- Building reference material

**Template:**
```markdown
# [Descriptive Title]

[Executive summary - 2-3 sentences providing overview]

## Overview
[Context and background]

## [Topic Section 1]
[Detailed information]

## [Topic Section 2]
[Detailed information]

## Key Takeaways
- [Point 1]
- [Point 2]
- [Point 3]

## Sources
- [URL] - [Description]
```

## Research Document Format

For deep research, produce a long-form document with the following structure:

```markdown
---
date: YYYY-MM-DD
query: <original research input>
stack: <detected tech stack>
---

# Research: <Topic>

## Summary
{3-5 sentence answer — what this is, why it matters, what to use}

## Tech Stack Context
{Detected stack and how it affects the recommendations below}

## Key Findings
{Bulleted findings with source tier labels: [Tier 1], [Tier 2], [Tier 3], [Tier 4]}

## Library / Tool Comparison
{Table: name | what it does | stars/downloads | license | when to use}

## How-To: Implementation Guide
{Step by step, as if teaching someone from scratch}
### Step 1: ...
### Step 2: ...
{Code examples in the project's detected language at every step}

## Scenarios
{Table or subsections covering: basic case, edge cases, production considerations}

## Diagrams
{Mermaid flowcharts, sequence diagrams, or architecture diagrams as applicable}

## Knowledge Gaps
{What this research didn't cover, where to look next}

## Sources
{Tiered list: Tier 1 (Authoritative) > Tier 2 (Secondary) > Tier 3 (Community) > Tier 4 (Unverified)}
```

## Tech Stack Detection

Scan the project root for these indicators to determine the tech stack. Multiple matches are additive.

| File | Stack |
|------|-------|
| `README.md` | Project documentation (read for context) |
| `go.mod` | Go |
| `Cargo.toml` | Rust |
| `pyproject.toml` / `setup.py` | Python |
| `package.json` + `tsconfig.json` | TypeScript/Node |
| `package.json` (no tsconfig) | JavaScript/Node |
| `next.config.*` | Next.js (React) |
| `vite.config.*` | Vite (React/Vue/Svelte) |
| `Makefile` only | C/C++ or mixed |
| none found | Language-agnostic |

Use the detected stack to:
- Provide code examples in the correct language
- Search the appropriate package registry (npm, pkg.go.dev, PyPI, crates.io)
- Reference stack-specific conventions and patterns

## Research Process

### 1. Clarification Phase

Before starting research:
- Identify ambiguities in the query
- Ask specific clarifying questions
- Don't assume user intent
- Use AskUserQuestion tool for multiple clarifications

### 2. Source Selection

**Priority order:**

**Tier 1: Authoritative Primary Sources**
- Official documentation from tool/framework creators
- Published specifications and standards
- Official repositories and codebases
- First-party blog posts and announcements

**Tier 2: Authoritative Secondary Sources**
- Well-known educators and tutorial sites
- Official community resources
- Verified contributor blogs
- Respected technical publications

**Tier 3: Community Sources**
- Stack Overflow answers
- GitHub issues and discussions
- Developer blogs
- Tutorial websites

**Tier 4: Unverified Sources**
- Content farms, unattributed tutorials, outdated resources
- Use with extreme caution, always verify against higher-tier sources

### 3. Information Gathering

**For each source:**
1. Read thoroughly
2. Extract relevant information
3. Note source URL and description
4. Identify key points
5. Check publication date/relevance

**Cross-referencing:**
- Verify critical facts across 2+ sources
- Note version-specific information
- Flag contradictions for investigation
- Prefer recent over outdated

### 4. Synthesis

**Organize information:**
- Group related concepts
- Order from general to specific
- Identify patterns and relationships
- Extract key takeaways

**Quality checks:**
- Is it accurate?
- Is it complete for the query?
- Is it clearly presented?
- Are sources properly attributed?

## Formatting Standards

### Markdown Structure

**Headers:**
- H1 (`#`) - Title only
- H2 (`##`) - Major sections
- H3 (`###`) - Subsections if needed
- Keep hierarchy shallow (max 3 levels)

**Code blocks:**
```language
# Always specify language
# Include comments for clarity
```

**Lists:**
- Use bullets for unordered items
- Use numbers for sequential steps
- Keep items parallel in structure
- One idea per bullet point

**Emphasis:**
- **Bold** for key terms and important points
- *Italic* sparingly for subtle emphasis
- `Code font` for technical terms, commands, file names

### Source Attribution

**Format:**
```markdown
## Sources
- [URL] - [Brief description of what info came from this source]
```

**Best practices:**
- List in order of importance/relevance
- Keep descriptions concise (5-10 words)
- Include official docs first
- Don't duplicate similar sources

## Quality Standards

### Accuracy
- Cross-reference critical information
- Note version-specific details
- Flag assumptions or uncertainties
- Prefer official sources

### Completeness
- Answer the actual question asked
- Include necessary context
- Provide examples when helpful
- Cover edge cases if relevant

### Clarity
- Use simple, direct language
- Define technical terms
- Organize information logically
- Make content scannable

### Attribution
- Cite every source used
- Track where information came from
- Describe what each source contributed
- Link to original documentation

## Error Handling

### Insufficient Information
```
I found limited information about [topic]. Based on available sources:
[Present what was found]

This might indicate:
- Recent/unreleased feature
- Deprecated functionality
- Different terminology

Would you like me to search with alternative terms?
```

### Contradictory Sources
```
I found conflicting information:
- Source A: [X]
- Source B: [Y]

This appears to be due to [version/context/timing].
The most current information suggests: [recommendation]
```

### No Results
```
I couldn't find reliable sources for [topic].

Could you:
- Verify the terminology?
- Provide more context?
- Specify the tool/version?
```

## Related Files

- `references/templates.md` - Detailed template examples with full samples
- `references/search-strategies.md` - Advanced search techniques per domain
- `references/source-evaluation.md` - Criteria for assessing source quality
