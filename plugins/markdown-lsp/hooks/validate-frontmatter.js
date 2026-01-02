#!/usr/bin/env node
/**
 * Validates YAML frontmatter in markdown files.
 * Checks for proper structure and common field types.
 *
 * Claude Code PostToolUse hook - receives tool input via stdin.
 */

const fs = require('fs');

// Read stdin for Claude Code hook input
let stdinData = '';
try {
  stdinData = fs.readFileSync(0, 'utf8');
} catch (e) {
  // No stdin available
}

let filePath;
if (stdinData) {
  try {
    const input = JSON.parse(stdinData);
    filePath = input.tool_input?.file_path;
  } catch (e) {
    // Invalid JSON, try command line
  }
}

// Fallback to command line argument
if (!filePath) {
  filePath = process.argv[2];
}

if (!filePath) {
  console.error('Usage: validate-frontmatter.js <file>');
  process.exit(1);
}

// Only validate markdown files
if (!filePath.endsWith('.md')) {
  console.log(JSON.stringify({ diagnostics: [] }));
  process.exit(0);
}

const content = fs.readFileSync(filePath, 'utf8');
const lines = content.split('\n');
const diagnostics = [];

// Check if file starts with frontmatter
if (!lines[0] || lines[0].trim() !== '---') {
  // No frontmatter - that's okay, not required
  console.log(JSON.stringify({ diagnostics }));
  process.exit(0);
}

// Find frontmatter end
let frontmatterEnd = -1;
for (let i = 1; i < lines.length; i++) {
  if (lines[i].trim() === '---') {
    frontmatterEnd = i;
    break;
  }
}

if (frontmatterEnd === -1) {
  diagnostics.push({
    line: 1,
    column: 1,
    severity: 'error',
    message: 'Unclosed frontmatter block - missing closing ---',
    source: 'validate-frontmatter'
  });
  console.log(JSON.stringify({ diagnostics }));
  process.exit(0);
}

// Validate YAML structure (basic validation)
const frontmatterLines = lines.slice(1, frontmatterEnd);

for (let i = 0; i < frontmatterLines.length; i++) {
  const line = frontmatterLines[i];
  const lineNum = i + 2; // +2 for 1-indexed and skipping first ---

  // Skip empty lines
  if (line.trim() === '') continue;

  // Check for tabs (YAML prefers spaces)
  if (line.includes('\t')) {
    diagnostics.push({
      line: lineNum,
      column: line.indexOf('\t') + 1,
      severity: 'warning',
      message: 'YAML frontmatter should use spaces, not tabs',
      source: 'validate-frontmatter'
    });
  }

  // Check for key-value format
  const keyValueMatch = line.match(/^(\s*)([^:]+):\s*(.*)$/);
  const listItemMatch = line.match(/^(\s*)-\s*(.*)$/);

  if (!keyValueMatch && !listItemMatch && line.trim()) {
    // Not a valid YAML line
    diagnostics.push({
      line: lineNum,
      column: 1,
      severity: 'warning',
      message: 'Invalid YAML syntax - expected key: value or list item',
      source: 'validate-frontmatter'
    });
  }

  // Check for common date format issues
  if (keyValueMatch && keyValueMatch[2].trim().toLowerCase() === 'date') {
    const dateValue = keyValueMatch[3].trim();
    if (dateValue && !/^\d{4}-\d{2}-\d{2}/.test(dateValue)) {
      diagnostics.push({
        line: lineNum,
        column: 1,
        severity: 'info',
        message: 'Consider using ISO date format: YYYY-MM-DD',
        source: 'validate-frontmatter'
      });
    }
  }
}

console.log(JSON.stringify({ diagnostics }));
