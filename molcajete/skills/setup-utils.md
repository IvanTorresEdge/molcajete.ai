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
 */
function mergePlugins(
  existing: SettingsObject | null,
  selectedPlugins: PluginMetadata[]
): SettingsObject {
  // Start with existing settings or empty object
  const merged: SettingsObject = existing ? { ...existing } : {};

  // Ensure plugins object exists
  if (!merged.plugins) {
    merged.plugins = {};
  }

  // Add/update selected plugins
  for (const plugin of selectedPlugins) {
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
 */
async function setupPlugins(selectedPluginIds: string[]): Promise<{success: boolean; message: string}> {
  try {
    // Read existing settings
    const existing = await readSettings();

    // Convert selected IDs to plugin metadata
    const selectedPlugins: PluginMetadata[] = selectedPluginIds.map(id => ({
      id: `molcajete/${id}`,
      version: 'latest'
    }));

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
  getSettingsPath
};
```

## Error Handling

The utilities handle common error scenarios:

- **ENOENT** (file not found): Returns null from readSettings, allows creation of new file
- **EACCES** (permission denied): Provides helpful chmod command
- **SyntaxError** (invalid JSON): Reports parsing error with message
- **Directory creation**: Automatically creates ~/.claude directory if missing

## Atomic Writes

The `writeSettings` function uses atomic write pattern:
1. Write to temporary file (.tmp)
2. Validate JSON
3. Rename temp file to actual file
4. Clean up temp file on error

This prevents corruption if write fails partway through.
