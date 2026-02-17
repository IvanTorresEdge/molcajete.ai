---
name: prompting
description: >-
  Skill for writing clear, effective LLM prompts. Covers structure,
  specificity, role-setting, examples, output format specification,
  and iterative refinement. Model-agnostic principles that work
  across Claude, GPT, and other language models.
---

# Prompting

Principles and techniques for writing clear, effective LLM prompts that produce consistent, high-quality output.

## Core Principles

1. **Be clear and specific** — Treat the model as a skilled worker with zero context. Spell out the task, audience, purpose, and what success looks like. Replace vague quantifiers ("keep it short") with concrete ones ("2-3 sentences").
2. **Say what TO do, not what NOT to do** — Positive instructions ("respond in formal tone") outperform negative ones ("don't be casual").
3. **Structure the prompt** — Use sections, headers, or delimiters to separate role, instructions, context, examples, and output format.
4. **Set a role** — A specific persona improves accuracy, tone, and depth. Be precise: "You are a senior backend engineer reviewing a pull request" beats "You are a developer."
5. **Specify the output format** — Never assume defaults. Define: format (bullets, JSON, prose), length, tone, structure.
6. **Provide examples** — 3-5 diverse examples dramatically improve output quality. Examples should be relevant, varied, and clearly delimited.
7. **Give context** — Who is the audience, what is the purpose, where does this fit in a larger workflow.
8. **Let it think** — For complex tasks, instruct step-by-step reasoning. Don't suppress the thinking.
9. **Permit uncertainty** — Let the model say "I don't know" rather than fabricate answers.

## Prompt Structure Template

```
# Role and Objective
[Who the model is and what it should accomplish]

## Instructions
[Numbered steps for the task]

## Context
[Background information, audience, purpose]

## Output Format
[Exact format, length, tone specifications]

## Examples (optional)
[3-5 input/output pairs wrapped in delimiters]
```

## Formatting Rules

- Use markdown headers (`##`) to separate sections
- Use XML tags (`<context>`, `<example>`, `<output>`) when nesting is needed
- Use numbered lists for sequential steps
- Use bullet points for parallel items
- Keep the prompt scannable — a human should be able to skim and understand the structure

## Common Mistakes to Avoid

- Vague instructions ("make it good") → be concrete about quality criteria
- Missing context → always state audience, purpose, constraints
- No output format → always specify format, length, tone
- Mixing instructions with data → use delimiters to separate
- Over-engineering → start simple, add complexity only when needed

## Quality Checklist

Apply before outputting the final prompt:

- [ ] Has a clear role or persona
- [ ] Instructions use action verbs (Write, Classify, Summarize, Analyze)
- [ ] Output format is explicitly defined
- [ ] Audience and purpose are stated
- [ ] Examples are included if the task involves specific formatting
- [ ] No vague quantifiers remain
- [ ] No negative instructions where positive ones would work
