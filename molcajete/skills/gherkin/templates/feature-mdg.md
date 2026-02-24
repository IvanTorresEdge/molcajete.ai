# MDG Feature Template

Use this template for `.feature.md` files (Markdown-Gherkin format). Select this format when the project uses MDG. Never mix formats.

````markdown
# Feature: {Feature Name}

{1-2 sentence description of the feature}

**Tags:** `@{domain}` `@{priority-tag}`

## Background

- **Given** {shared precondition}

## Scenario: {Scenario Name}

**Tags:** `@{scenario-tag}`

- **Given** {declarative system state}
- **When** {user action}
- **Then** {exact assertion}

## Scenario Outline: {Parameterized Scenario Name}

**Tags:** `@{scenario-tag}`

- **Given** {state with `<param>`}
- **When** {action with `<param>`}
- **Then** {assertion with `<expected>`}

### Examples

| param   | expected |
|---------|----------|
| value1  | result1  |
| value2  | result2  |
````
