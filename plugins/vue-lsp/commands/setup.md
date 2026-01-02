---
description: Interactive setup for Vue.js LSP development environment
---

# Vue.js LSP Setup

This command will configure your Vue.js development environment with vue-language-server (Volar) LSP and essential tools.

## Prerequisites Check

First, verify Node.js is installed:

```bash
node --version
npm --version
```

## Installation Steps

### 1. Install vue-language-server (Volar)

```bash
npm install -g @vue/language-server typescript
```

### 2. Install Development Tools

**Quick install (all recommended tools):**

```bash
npm install -g eslint prettier
```

### 3. Verify Installation

```bash
# Check vue-language-server
vue-language-server --version

# Check TypeScript
tsc --version

# Check ESLint
eslint --version

# Check Prettier
prettier --version
```

### 4. Create Project Configuration (Optional)

**package.json** (if starting fresh):

```json
{
  "name": "my-vue-project",
  "version": "0.1.0",
  "type": "module",
  "scripts": {
    "dev": "vite",
    "build": "vue-tsc && vite build",
    "lint": "eslint . --ext .vue,.js,.jsx,.ts,.tsx"
  },
  "dependencies": {
    "vue": "^3.4.0"
  },
  "devDependencies": {
    "@vitejs/plugin-vue": "^5.0.0",
    "eslint": "^8.57.0",
    "eslint-plugin-vue": "^9.19.0",
    "prettier": "^3.1.0",
    "typescript": "^5.3.0",
    "vite": "^5.0.0",
    "vue-tsc": "^1.8.0"
  }
}
```

**tsconfig.json:**

```json
{
  "compilerOptions": {
    "target": "ES2022",
    "module": "ESNext",
    "moduleResolution": "bundler",
    "jsx": "preserve",
    "strict": true,
    "esModuleInterop": true,
    "skipLibCheck": true,
    "resolveJsonModule": true,
    "isolatedModules": true
  },
  "include": ["src/**/*.ts", "src/**/*.vue"],
  "exclude": ["node_modules"],
  "vueCompilerOptions": {
    "target": 3
  }
}
```

**.eslintrc.json:**

```json
{
  "root": true,
  "env": {
    "browser": true,
    "es2022": true,
    "node": true
  },
  "extends": [
    "eslint:recommended",
    "plugin:vue/vue3-recommended"
  ],
  "parserOptions": {
    "ecmaVersion": "latest",
    "sourceType": "module"
  }
}
```

**.prettierrc:**

```json
{
  "semi": false,
  "singleQuote": true,
  "tabWidth": 2,
  "trailingComma": "es5"
}
```

### 5. Enable LSP in Claude Code

```bash
export ENABLE_LSP_TOOL=1
```

## Verification

Test the LSP integration:

```bash
# Create a test Vue component
cat > TestComponent.vue << 'EOF'
<template>
  <div>{{ greeting }}</div>
</template>

<script setup lang="ts">
import { ref } from 'vue'

const greeting = ref<string>('Hello, Vue!')
</script>
EOF

# Run type check (if vue-tsc is installed)
npx vue-tsc --noEmit TestComponent.vue

# Clean up
rm TestComponent.vue
```

## Project-Level Dependencies

For full Vue 3 development experience, install these in your project:

```bash
# In your project directory
npm install -D eslint-plugin-vue vue-tsc @vitejs/plugin-vue
```

## Next Steps

1. Create a Vue 3 project with Vite: `npm create vite@latest my-vue-app -- --template vue-ts`
2. Open a `.vue` file in Claude Code to test LSP features
3. Try editing the sample file at `tests/Sample.vue`
