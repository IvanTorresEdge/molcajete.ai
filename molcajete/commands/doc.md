---
description: Generate documentation for code
model: claude-sonnet-4-5
allowed-tools: Read, Write, Edit, Glob, Grep, Bash(*), Task, AskUserQuestion
argument-hint: <file path, directory, or module name>
---

# Generate Documentation

You are generating or updating documentation for code in this project. You follow existing documentation conventions and adapt to the target language (Go or TypeScript/React).

**Target:** $ARGUMENTS

## Step 1: Identify Target

If `$ARGUMENTS` is provided, resolve it:
- **File path** — document that specific file (inline comments/docstrings)
- **Directory path** — generate/update README.md for that directory
- **Module name** — search for the matching directory in the codebase

If `$ARGUMENTS` is empty, use AskUserQuestion to ask what to document. Offer options:
- A specific file (add inline documentation)
- A directory (generate/update README.md)
- A module or package (find and document it)

## Step 2: Detect Stack and Load Context via Sub-Agents

Examine the target to determine the project type:

| Indicator | Stack |
|-----------|-------|
| `.go` files, `go.mod` | Go |
| `.ts`/`.tsx` files, `package.json` | TypeScript/React |
| Mixed | Document each file type with its conventions |

Launch 2 parallel sub-agents using the Task tool in a single message:

**Agent 1 — Skills and Templates** (subagent_type: `Explore`, thoroughness: "very thorough"):
- Prompt: Read the code-documentation skill and the relevant coding skill based on the detected stack:
  - `${CLAUDE_PLUGIN_ROOT}/skills/code-documentation/SKILL.md`
  - `${CLAUDE_PLUGIN_ROOT}/skills/code-documentation/references/readme-template.md`
  - `${CLAUDE_PLUGIN_ROOT}/skills/code-documentation/references/readme-example.md`
  - For Go: `${CLAUDE_PLUGIN_ROOT}/skills/go-writing-code/SKILL.md` (godoc conventions section)
  - For TypeScript: `${CLAUDE_PLUGIN_ROOT}/skills/typescript-writing-code/SKILL.md` (TSDoc conventions section)
  - For React: `${CLAUDE_PLUGIN_ROOT}/skills/react-writing-code/SKILL.md` (component documentation section)
  Return:
  ```
  DOC_CONVENTIONS:
  {README conventions from code-documentation skill — frontmatter format, file listing tables, Mermaid diagrams, notes section}

  TEMPLATE:
  {Full README template content}

  EXAMPLE:
  {Full README example content}

  INLINE_DOC_CONVENTIONS:
  {Inline documentation conventions for the detected stack — godoc or TSDoc rules}
  ```

**Agent 2 — Code Analysis** (subagent_type: `general-purpose`):
- Prompt: Analyze the target code at `{target path}`:
  - Read all files in the target scope
  - Identify the public API surface: exported functions, types, interfaces, components
  - Identify key patterns: design patterns, data flow, state management
  - Identify dependencies: what this module depends on and what depends on it
  - Identify entry points: main files, index files, route handlers
  - Check if a README.md already exists in the target directory (read it if so)
  Return:
  ```
  CODE_ANALYSIS:
  - Public API: {list of exported symbols with brief descriptions}
  - Patterns: {design patterns and data flow}
  - Dependencies: {inbound and outbound dependencies}
  - Entry points: {main files}
  - Existing README: {exists and needs update / does not exist}

  SUGGESTED_DOCS:
  {For files: list of exported symbols that need documentation with suggested descriptions}
  {For directories: suggested README structure with file descriptions}
  ```

Use the returned context for all subsequent steps. Do NOT read these files again yourself.

## Step 3: Generate Documentation

### For a File (inline docs)

Add documentation comments to the public API using the inline doc conventions from Agent 1:

**Go:**
```go
// FunctionName does X given Y, returning Z.
// It returns an error if the input is invalid.
func FunctionName(input Type) (Result, error) {
```

- Use godoc conventions: start with the identifier name, use complete sentences
- Document exported functions, types, interfaces, and package-level variables
- Do NOT document unexported identifiers or obvious getters/setters

**TypeScript:**
```typescript
/**
 * Brief description of what this function does.
 *
 * @param input - Description of the parameter
 * @returns Description of the return value
 */
export function functionName(input: Type): Result {
```

- Use TSDoc conventions for exported functions, interfaces, and types
- Do NOT document internal helpers or self-evident code

### For a Directory (README.md)

Follow the code-documentation skill conventions from Agent 1, using the code analysis from Agent 2:

1. If `README.md` exists, read it and update:
   - Add/remove files from the listing table
   - Update diagrams if the module structure changed
   - Update the `last-updated` date in frontmatter
2. If `README.md` does not exist, create one using the template:
   - YAML frontmatter (module, purpose, last-updated)
   - Overview paragraph (2-4 sentences)
   - Files table (every file with one-sentence description)
   - Mermaid diagrams (as many as needed to explain the module)
   - Notes section (if there are non-obvious conventions)

## Step 4: Format

Run the appropriate formatter on changed files:
- **Go**: `gofmt` or `go fmt`
- **TypeScript/React**: Biome via the project's format command

## Step 5: Report

Tell the user:
- What files were documented or updated
- Summary of what was added (number of functions documented, README created/updated, diagrams added)
- Any files that were skipped and why

## Rules

- Use AskUserQuestion for ALL user interaction. Never ask questions as plain text.
- Follow the code-documentation skill conventions for README.md files.
- Do NOT add documentation to code you haven't read.
- Do NOT over-document: skip obvious code, internal helpers, and generated files.
- Do not use the word "comprehensive" in any documentation.
- Never stage files or create commits — the user manages git.
