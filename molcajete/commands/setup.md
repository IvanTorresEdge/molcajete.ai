---
description: Interactive plugin configuration to streamline Molcajete.ai onboarding
---

Execute the setup workflow to configure Molcajete plugins in Claude settings:

1. **Read Existing Settings**
   - Use the `molcajete:setup-utils` skill to read ~/.claude/settings.local.json
   - Identify currently configured plugins
   - Handle missing file gracefully (will create new)

2. **Present Plugin Selection**
   - Use AskUserQuestion tool to let user select plugins:
     - Question: "Select Molcajete plugins to install:"
     - Header: "Plugins"
     - Options:
       - "defaults" - Core development principles and patterns
       - "git" - Git workflow automation and commit generation
       - "prd" - Product planning and requirements management
       - "research" - Research and analysis workflows
       - "go" - Go development patterns and standards
       - "sol" - Solidity smart contract development
     - multiSelect: true
   - Pre-select any currently configured plugins

3. **Merge and Write Settings**
   - Use the `molcajete:setup-utils` skill to:
     - Merge selected plugins with existing settings
     - Preserve all non-plugin configurations
     - Validate JSON structure
     - Write atomically to ~/.claude/settings.local.json

4. **Confirm Success**
   - Display success message with count of configured plugins
   - List which plugins were added/updated
   - Remind user to restart Claude Code if needed

**Error Handling:**
- Invalid JSON: Show error with line number, offer to backup and recreate
- Permission denied: Provide chmod command to fix permissions
- Missing directory: Automatically create ~/.claude directory
