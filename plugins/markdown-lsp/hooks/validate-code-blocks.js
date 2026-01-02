#!/usr/bin/env node
/**
 * Validates markdown code blocks for syntax and language identifiers.
 * Outputs diagnostics for code blocks missing language specifiers.
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
  console.error('Usage: validate-code-blocks.js <file>');
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

let inCodeBlock = false;
let codeBlockStart = -1;
let hasLanguage = false;

for (let i = 0; i < lines.length; i++) {
  const line = lines[i];
  const lineNum = i + 1;

  // Check for code block start
  const startMatch = line.match(/^(\s*)```(\w*)/);
  if (startMatch && !inCodeBlock) {
    inCodeBlock = true;
    codeBlockStart = lineNum;
    hasLanguage = startMatch[2].length > 0;
    continue;
  }

  // Check for code block end
  if (inCodeBlock && line.match(/^(\s*)```\s*$/)) {
    if (!hasLanguage) {
      diagnostics.push({
        line: codeBlockStart,
        column: 1,
        severity: 'warning',
        message: 'Code block missing language identifier',
        source: 'validate-code-blocks'
      });
    }
    inCodeBlock = false;
    codeBlockStart = -1;
    hasLanguage = false;
  }
}

// Unclosed code block
if (inCodeBlock) {
  diagnostics.push({
    line: codeBlockStart,
    column: 1,
    severity: 'error',
    message: 'Unclosed code block',
    source: 'validate-code-blocks'
  });
}

console.log(JSON.stringify({ diagnostics }));
