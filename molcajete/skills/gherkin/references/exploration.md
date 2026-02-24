# Exploration Procedure

This procedure runs **only** when the argument is a generic name (Step 1d path). It resolves the generic name to a concrete understanding of the feature by scanning project sources.

Consult all applicable sources in order (FR-0KTg-045); do not stop at the first match.

## 2-exp-a. Read Changelog

Read `prd/changelog.md` as the primary discovery source (FR-0KTg-039). The changelog contains a domain-organized summary of everything built in the system, mapped to requirement IDs.

1. Read `prd/changelog.md`.
2. Search for entries where the title, description, or linked spec name relates to the argument. Use keyword matching — split the argument into words and look for entries containing those words or close synonyms.
3. For each matching entry, extract:
   - The change title and description
   - Linked plan files and changelog files (these point to spec folders)
   - Requirement IDs mentioned (e.g., `FR-XXXX-NNN`)
   - The date heading (to understand recency)
4. Record all matches as `changelog_matches` — a list of `{title, description, spec_folder, requirement_ids}`.

## 2-exp-b. Scan Specs Directory

Scan `prd/specs/` directory names to find spec folders whose slug relates to the argument (FR-0KTg-040).

1. Glob `prd/specs/*/` to list all spec folder names.
2. For each folder, extract the slug portion of the directory name (the part after the timestamp prefix, e.g., `20260212-1456-console_authentication` → `console_authentication`).
3. Compare each slug against the argument: split both into words (using `_`, `-`, and spaces as delimiters) and check for word overlap. A slug matches if at least one significant word from the argument appears in the slug, or vice versa.
4. For each matching spec folder, read its `requirements.md` and/or `spec.md` (FR-0KTg-041) and extract:
   - **From requirements.md:** Use case titles, actors, preconditions, main flows, alternative flows, exception flows, acceptance criteria, validation rules, and data models
   - **From spec.md:** Architecture, API contracts, edge cases, security constraints, and integration points
5. Record all matches as `spec_matches` — a list of `{folder, slug, use_cases, actors, data_models, edge_cases}`.

## 2-exp-c. Scan README Files

Scan for `README.md` files in codebase directories related to the argument (FR-0KTg-042).

1. Glob `**/README.md` (excluding `node_modules/`, `prd/`, `bdd/`, `dist/`, `build/`, `vendor/`, `.git/`).
2. Filter results to directories whose path contains words from the argument. For example, if the argument is "user authentication", look for README files in directories containing "user", "auth", or "authentication" in their path segments.
3. For each matching README, read it and extract:
   - Module purpose and description
   - Key components, services, or handlers listed
   - Relationships to other modules (imports, dependencies)
   - Domain rules or business logic described
4. Record matches as `readme_matches` — a list of `{directory, purpose, components, relationships}`.

## 2-exp-d. Source Code Scanning (Last Resort)

If `changelog_matches`, `spec_matches`, and `readme_matches` are all empty — no prior source yielded any relevant information — scan source code directly as a last resort.

1. Use Grep to search for the argument's keywords across source files (`.go`, `.ts`, `.tsx`, `.py`, `.js`, `.jsx`). Search in function names, type definitions, route handlers, and file names.
2. Limit the search to the top 10 most relevant results to avoid excessive context.
3. For each match, read enough surrounding context (the enclosing function, type, or route handler) to understand what the code does.
4. Record matches as `code_matches` — a list of `{file, function_or_type, description}`.

If source code scanning also yields no matches, proceed to 2-exp-e with empty results — the disambiguation step will handle the "no matches" case.

## 2-exp-e. Synthesize and Disambiguate

Collect all matches from 2-exp-a through 2-exp-d (`changelog_matches`, `spec_matches`, `readme_matches`, `code_matches`). If 2-exp-d was skipped (because earlier sources yielded matches), treat `code_matches` as empty. Evaluate the combined results:

**No matches found (all lists empty):**

Inform the user: "No matching feature found in the codebase for '{argument}'." Use AskUserQuestion:
- Question: "No codebase match found for '{argument}'. How should I proceed?"
- Header: "No match"
- Options:
  - "Try a different name" — user provides a new name via the "Other" option; restart from Step 1d
  - "Generate skeleton scenarios" — proceed to Step 3 without exploration context; generated scenarios will use the argument as-is for the feature name and include `# TODO: replace with implementation-specific scenarios` comments to indicate they need manual refinement
  - "Cancel" — stop execution
- multiSelect: false

**Multiple unrelated matches (FR-0KTg-043):**

If matches point to two or more clearly unrelated features or modules (e.g., "notifications" matches both an email notification system and a UI toast component), present disambiguation via AskUserQuestion:
- Question: "'{argument}' matches multiple features. Which one should I generate scenarios for?"
- Header: "Disambiguate"
- Options: List up to 4 matched features, each with a label (feature/module name) and description (source and brief summary). If more than 4 matches exist, show the 4 most relevant (prioritizing changelog and spec matches over code matches).
- multiSelect: false

Use the selected match as the sole context for Step 3.

**Single match or related matches:**

If all matches point to the same feature or closely related aspects of one feature, synthesize them into a unified context:
1. Combine information from all sources — use spec data for use cases and acceptance criteria, changelog data for what's already built, README data for module structure, and code data for implementation details.
2. Determine the primary domain this feature belongs to (for domain folder placement in 3a).
3. Store the synthesized context — it will be used in Step 3 the same way UC-ID spec context is used: to drive implementation-specific scenarios rather than generic patterns.

After synthesis or disambiguation, proceed to Step 3.
