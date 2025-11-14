---
name: setup-utils
description: TypeScript utilities for reading, merging, and writing Claude settings.local.json configuration
---

# Setup Utilities

TypeScript utilities for safely managing Claude Code settings.local.json files.

## Usage

These utilities are invoked from the `/molcajete:setup` command to handle file operations.

## TypeScript Implementation

```typescript
import * as fs from 'fs/promises';
import * as path from 'os';
import { homedir } from 'os';

interface SettingsObject {
  plugins?: Record<string, string>;
  [key: string]: any;
}

interface PluginMetadata {
  id: string;
  version: string;
}

/**
 * Validate plugin ID format
 * Ensures IDs follow namespace/name pattern with strict character rules
 * @throws Error if format is invalid
 */
function validatePluginId(pluginId: string): void {
  const pattern = /^[a-z0-9-]+\/[a-z0-9-]+$/;
  if (!pattern.test(pluginId)) {
    throw new Error(
      `Invalid plugin ID format: "${pluginId}". Expected format: namespace/name (lowercase, alphanumeric, and hyphens only)`
    );
  }
}

/**
 * Validate plugin version string
 * Ensures version is non-empty string
 * @throws Error if version is invalid
 */
function validatePluginVersion(version: any, pluginId: string): void {
  if (typeof version !== 'string' || version.trim().length === 0) {
    throw new Error(
      `Invalid version for plugin "${pluginId}": Version must be a non-empty string`
    );
  }
}

/**
 * Get the path to Claude settings file
 */
function getSettingsPath(): string {
  return path.join(homedir(), '.claude', 'settings.local.json');
}

/**
 * Get the path to Claude settings directory
 */
function getSettingsDir(): string {
  return path.join(homedir(), '.claude');
}

/**
 * Read existing settings file
 * Returns null if file doesn't exist
 * Throws error if file exists but contains invalid JSON
 */
async function readSettings(): Promise<SettingsObject | null> {
  const settingsPath = getSettingsPath();

  try {
    const content = await fs.readFile(settingsPath, 'utf-8');
    return JSON.parse(content);
  } catch (error: any) {
    if (error.code === 'ENOENT') {
      // File doesn't exist - this is OK, we'll create it
      return null;
    }

    if (error instanceof SyntaxError) {
      // Invalid JSON
      throw new Error(`Invalid JSON in settings file: ${error.message}`);
    }

    if (error.code === 'EACCES') {
      // Permission denied
      throw new Error(`Permission denied reading ${settingsPath}. Run: chmod 644 ${settingsPath}`);
    }

    throw error;
  }
}

/**
 * Merge selected plugins into existing settings
 * Preserves all non-plugin settings
 * Avoids duplicates
 * Validates plugin structure and handles edge cases
 */
function mergePlugins(
  existing: SettingsObject | null,
  selectedPlugins: PluginMetadata[]
): SettingsObject {
  // Start with existing settings or empty object
  const merged: SettingsObject = existing ? { ...existing } : {};

  // Handle edge case: existing plugins property is not an object
  if (merged.plugins !== undefined &&
      (typeof merged.plugins !== 'object' ||
       merged.plugins === null ||
       Array.isArray(merged.plugins))) {
    console.warn('Warning: Existing "plugins" property is not an object. Replacing with empty object.');
    merged.plugins = {};
  }

  // Ensure plugins object exists
  if (!merged.plugins) {
    merged.plugins = {};
  }

  // Add/update selected plugins with validation
  for (const plugin of selectedPlugins) {
    // Validate plugin ID format
    validatePluginId(plugin.id);

    // Validate version
    validatePluginVersion(plugin.version, plugin.id);

    // Add to merged settings
    merged.plugins[plugin.id] = plugin.version;
  }

  return merged;
}

/**
 * Write settings to file atomically
 * Creates directory if it doesn't exist
 * Validates JSON before writing
 */
async function writeSettings(settings: SettingsObject): Promise<void> {
  const settingsPath = getSettingsPath();
  const settingsDir = getSettingsDir();

  // Ensure directory exists
  try {
    await fs.mkdir(settingsDir, { recursive: true, mode: 0o755 });
  } catch (error: any) {
    if (error.code !== 'EEXIST') {
      throw new Error(`Failed to create directory ${settingsDir}: ${error.message}`);
    }
  }

  // Format JSON with 2-space indentation
  const content = JSON.stringify(settings, null, 2);

  // Validate by parsing
  try {
    JSON.parse(content);
  } catch (error: any) {
    throw new Error(`Generated invalid JSON: ${error.message}`);
  }

  // Write atomically using temp file + rename
  const tempPath = `${settingsPath}.tmp`;

  try {
    await fs.writeFile(tempPath, content, 'utf-8');
    await fs.rename(tempPath, settingsPath);
  } catch (error: any) {
    // Clean up temp file if it exists
    try {
      await fs.unlink(tempPath);
    } catch {}

    if (error.code === 'EACCES') {
      throw new Error(`Permission denied writing ${settingsPath}. Run: chmod 644 ${settingsPath}`);
    }

    throw error;
  }
}

/**
 * Main setup function - orchestrates the entire flow
 * Validates all inputs and handles errors gracefully
 */
async function setupPlugins(selectedPluginIds: string[]): Promise<{success: boolean; message: string}> {
  try {
    // Validate inputs
    if (!Array.isArray(selectedPluginIds)) {
      throw new Error('selectedPluginIds must be an array');
    }

    if (selectedPluginIds.length === 0) {
      return {
        success: false,
        message: 'No plugins selected. Please select at least one plugin.'
      };
    }

    // Read existing settings
    const existing = await readSettings();

    // Convert selected IDs to plugin metadata with validation
    const selectedPlugins: PluginMetadata[] = [];
    for (const id of selectedPluginIds) {
      // Validate each plugin ID before creating metadata
      const pluginId = `molcajete/${id}`;
      validatePluginId(pluginId);

      selectedPlugins.push({
        id: pluginId,
        version: 'latest'
      });
    }

    // Merge with existing
    const merged = mergePlugins(existing, selectedPlugins);

    // Write back
    await writeSettings(merged);

    return {
      success: true,
      message: `Successfully configured ${selectedPlugins.length} plugins: ${selectedPluginIds.join(', ')}`
    };
  } catch (error: any) {
    return {
      success: false,
      message: `Setup failed: ${error.message}`
    };
  }
}

// Export for use by command
export {
  readSettings,
  writeSettings,
  mergePlugins,
  setupPlugins,
  getSettingsPath,
  validatePluginId,
  validatePluginVersion
};
```

## Error Handling

The utilities handle common error scenarios:

- **ENOENT** (file not found): Returns null from readSettings, allows creation of new file
- **EACCES** (permission denied): Provides helpful chmod command
- **SyntaxError** (invalid JSON): Reports parsing error with message
- **Directory creation**: Automatically creates ~/.claude directory if missing
- **Invalid plugin ID format**: Validates namespace/name pattern with clear error message
- **Invalid version string**: Ensures version is non-empty string
- **Malformed plugins property**: Handles non-object plugins property gracefully
- **Empty selection**: Returns helpful message when no plugins selected

## Atomic Writes

The `writeSettings` function uses atomic write pattern:
1. Write to temporary file (.tmp)
2. Validate JSON
3. Rename temp file to actual file
4. Clean up temp file on error

This prevents corruption if write fails partway through.
