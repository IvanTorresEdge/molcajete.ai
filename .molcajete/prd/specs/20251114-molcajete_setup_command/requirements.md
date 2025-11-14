# Molcajete Setup Command Requirements

## Overview

### Feature Description
The Molcajete Setup Command is a CLI plugin that automates the configuration of Claude settings to enable Molcajete marketplace plugins. It provides a streamlined setup experience that allows users to select and configure Molcajete plugins in their ~/.claude/settings.local.json file with proper validation and error handling.

### User Value
- **Eliminates manual configuration** - No need to manually edit JSON files or understand Claude's settings structure
- **Reduces setup errors** - Validates JSON and ensures proper formatting, preventing configuration mistakes
- **Speeds onboarding** - Get from zero to using Molcajete plugins in under a minute
- **Preserves existing settings** - Safely merges new plugin configurations without disrupting current setup

### Success Criteria
- [ ] Users can run `molcajete:setup` command from Claude Code
- [ ] Command presents interactive plugin selection interface
- [ ] Settings are properly merged without data loss
- [ ] JSON remains valid after modifications
- [ ] Clear success confirmation displayed on completion
- [ ] Works reliably on macOS and Linux systems

## User Stories

### Story 1: New User Setup
**As a** new Claude Code user
**I want to** quickly configure Molcajete plugins
**So that** I can start using specialized development workflows immediately

**Acceptance Criteria:**
- [ ] Command guides through plugin selection
- [ ] Settings file created if it doesn't exist
- [ ] Selected plugins added to configuration
- [ ] Success message confirms completion

### Story 2: Existing User Addition
**As an** existing Claude Code user with configured settings
**I want to** add Molcajete plugins to my setup
**So that** I can enhance my workflow without losing existing configurations

**Acceptance Criteria:**
- [ ] Existing settings preserved
- [ ] New plugins merged correctly
- [ ] No duplicate entries created
- [ ] Original formatting maintained where possible

### Story 3: Selective Plugin Installation
**As a** developer with specific needs
**I want to** choose which Molcajete plugins to enable
**So that** I only add tools relevant to my workflow

**Acceptance Criteria:**
- [ ] Interactive selection presents all available plugins
- [ ] Each plugin shows description
- [ ] Multiple plugins can be selected
- [ ] Only selected plugins added to configuration

## Functional Requirements

### Core Capabilities

1. **Settings File Management**
   - [ ] Read existing ~/.claude/settings.local.json if present
   - [ ] Create settings file if it doesn't exist
   - [ ] Parse JSON safely with error handling
   - [ ] Write valid JSON with proper formatting

2. **Plugin Selection Interface**
   - [ ] Display list of available Molcajete plugins
   - [ ] Show plugin name and description for each
   - [ ] Allow multiple selection
   - [ ] Include option to select all plugins

3. **Configuration Merging**
   - [ ] Preserve all existing settings
   - [ ] Add new plugins without duplicates
   - [ ] Maintain existing plugin configurations
   - [ ] Handle nested JSON structures correctly

4. **Validation**
   - [ ] Check file permissions before operations
   - [ ] Validate JSON syntax of existing settings
   - [ ] Ensure ~/.claude directory exists
   - [ ] Verify final JSON is valid before writing

5. **Error Handling**
   - [ ] Graceful handling of missing directories
   - [ ] Clear error messages for permission issues
   - [ ] JSON parsing error recovery
   - [ ] Partial completion with status report

### Plugin Configuration Format

Plugins should be added using marketplace format identifiers:
```json
{
  "plugins": {
    "molcajete/prd": "latest",
    "molcajete/git": "latest",
    "molcajete/research": "latest"
  }
}
```

### Available Plugins for Selection

Initial plugin set to offer:
- **molcajete/defaults** - Core development principles
- **molcajete/git** - Git workflow automation
- **molcajete/prd** - Product planning and requirements
- **molcajete/research** - Research and analysis workflows
- **molcajete/go** - Go development patterns
- **molcajete/sol** - Solidity smart contracts

## Technical Considerations

### Integration Points
- **Claude Settings System** - Must follow Claude's settings.local.json schema
- **File System** - Requires read/write access to ~/.claude directory
- **JSON Processing** - Safe parsing and generation of JSON configuration

### Platform Support
- **Primary:** macOS and Linux
- **File Paths:** Use home directory expansion (~/)
- **Permissions:** Standard user file permissions required
- **Future:** Windows support as enhancement

### Performance Requirements
- **Execution Time:** Complete setup in under 5 seconds
- **File Operations:** Minimize disk I/O with single read/write cycle
- **Memory Usage:** Handle large settings files efficiently

### Security Considerations
- **No Network Calls:** All operations local only
- **Permission Checks:** Verify file access before modifications
- **No Sensitive Data:** No credentials or keys handled
- **Safe JSON Parsing:** Protect against malformed input

## User Experience

### Command Flow
1. User runs `molcajete:setup` command
2. System checks for existing settings
3. Display plugin selection interface
4. User selects desired plugins
5. Validate and merge configurations
6. Write updated settings
7. Display success confirmation

### User Feedback
- **Summary Level Output:** Show major milestones only
  - "Checking existing settings..."
  - "Configuring selected plugins..."
  - "Settings updated successfully"
- **Error Messages:** Clear, actionable error descriptions
- **No Verbose Logging:** Unless explicitly requested

### Error Scenarios
- **Missing Directory:** Create ~/.claude if needed
- **Invalid JSON:** Report parsing error with line number
- **Permission Denied:** Explain permission requirements
- **Partial Failure:** Complete possible tasks, report failures

### Validation Messages
- **File Permissions:** "Cannot write to ~/.claude/settings.local.json"
- **JSON Errors:** "Invalid JSON at line X: [specific error]"
- **Directory Missing:** "Creating ~/.claude directory..."

## Scope Definition

### In Scope (MVP)
- [ ] Interactive plugin selection from predefined list
- [ ] Reading existing settings.local.json
- [ ] Merging new plugin configurations
- [ ] JSON validation and error handling
- [ ] macOS and Linux support
- [ ] Simple success confirmation
- [ ] Creating ~/.claude directory if missing

### Out of Scope (MVP)
- [ ] Windows support
- [ ] Custom plugin URL entry
- [ ] Plugin version selection (always use "latest")
- [ ] Settings backup creation
- [ ] Plugin dependency resolution
- [ ] Network plugin discovery
- [ ] Verbose progress logging
- [ ] Rollback functionality
- [ ] Plugin verification/testing

### Future Enhancements
1. **Windows Support** - Add Windows path handling and testing
2. **Plugin Verification** - Check if configured plugins are accessible
3. **Version Management** - Allow specific version selection
4. **Backup System** - Automatic backup before modifications
5. **Update Command** - Separate command to update existing plugins
6. **Remove Command** - Command to remove Molcajete plugins
7. **Plugin Dependencies** - Auto-add required dependencies
8. **Custom Sources** - Support for private plugin repositories

### MVP Boundaries
The MVP focuses on the essential setup flow: select plugins interactively, merge them into settings, confirm success. Advanced features like verification, versioning, and backup systems are intentionally deferred to keep the initial implementation simple and reliable.
