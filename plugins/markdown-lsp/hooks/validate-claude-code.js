#!/usr/bin/env node
/**
 * Validates Claude Code specific markdown syntax and command references.
 * Checks for proper slash command format and tool references.
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
  console.error('Usage: validate-claude-code.js <file>');
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

// Known Claude Code tool operations
const validLspOperations = [
  'goToDefinition',
  'findReferences',
  'hover',
  'documentSymbol',
  'workspaceSymbol',
  'goToImplementation'
];

// Common Claude Code slash commands pattern
const slashCommandPattern = /`?(\/[\w:-]+)`?/g;

for (let i = 0; i < lines.length; i++) {
  const line = lines[i];
  const lineNum = i + 1;

  // Check for potential typos in LSP operations
  const lspOpMatch = line.match(/operation[=:]\s*["']?(\w+)["']?/i);
  if (lspOpMatch) {
    const op = lspOpMatch[1];
    if (!validLspOperations.includes(op)) {
      // Check for close matches (case issues)
      const lowerOp = op.toLowerCase();
      const suggestion = validLspOperations.find(v => v.toLowerCase() === lowerOp);

      if (suggestion) {
        diagnostics.push({
          line: lineNum,
          column: line.indexOf(op) + 1,
          severity: 'warning',
          message: `LSP operation case mismatch: '${op}' should be '${suggestion}'`,
          source: 'validate-claude-code'
        });
      } else {
        diagnostics.push({
          line: lineNum,
          column: line.indexOf(op) + 1,
          severity: 'info',
          message: `Unknown LSP operation: '${op}'. Valid: ${validLspOperations.join(', ')}`,
          source: 'validate-claude-code'
        });
      }
    }
  }

  // Check for malformed slash commands (common patterns)
  let match;
  while ((match = slashCommandPattern.exec(line)) !== null) {
    const cmd = match[1];

    // Check for double slashes
    if (cmd.startsWith('//')) {
      diagnostics.push({
        line: lineNum,
        column: match.index + 1,
        severity: 'warning',
        message: `Malformed slash command: ${cmd} (double slash)`,
        source: 'validate-claude-code'
      });
    }

    // Check for trailing colon without subcommand
    if (cmd.endsWith(':')) {
      diagnostics.push({
        line: lineNum,
        column: match.index + 1,
        severity: 'info',
        message: `Incomplete slash command: ${cmd} (trailing colon)`,
        source: 'validate-claude-code'
      });
    }
  }
  slashCommandPattern.lastIndex = 0;

  // Check for common XML-style tool invocations that might be malformed
  if (line.includes('<invoke') && !line.includes('name=')) {
    diagnostics.push({
      line: lineNum,
      column: 1,
      severity: 'warning',
      message: 'Tool invocation missing name attribute',
      source: 'validate-claude-code'
    });
  }
}

console.log(JSON.stringify({ diagnostics }));
