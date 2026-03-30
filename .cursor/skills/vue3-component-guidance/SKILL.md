---
name: vue3-component-guidance
description: Vue 3 component creation and layout guidance for TypeScript + reusable modules. Trigger this when the user asks about structuring Vue 3 files, decomposing UIs into reusable pieces, or keeping each component as small as possible while working inside Cursor’s frontend modules.
---

# Vue 3 Component Guidance

Whenever you are editing Cursor’s Vue 3 files, apply the following conventions so the code stays modular, typed, and easy to reuse.

## 1. Prefer `<script setup lang="ts">`
- Always write scripts with `lang="ts"` and the `<script setup>` sugar; it keeps props and emits typed and eliminates boilerplate factories.
- Export props and emits via `defineProps`/`defineEmits` and keep the logic in short helper functions (no class-style components).
- Keep type definitions near the component (use `defineProps<{ ... }>()` or imported interfaces when shared across components).

## 2. Keep components tiny and purpose-driven
- If the markup describes more than one visual chunk or responsibility, split it into multiple components with descriptive names (e.g., `ApprovalsBadge`, `ModuleListItem`).
- Each component file should export a single Vue component (plus optional helper types) and rarely exceed ~120 lines.
- Favor composition via `props` and `slots` rather than embedding large `if/else` blocks inside template sections.

## 3. Organize modules into folders
- For each feature area (module), create a dedicated directory under the appropriate `modules/` folder.
- Place related components, composables, and types inside that directory; use `index.ts` to re-export the public entry points for the module.
- Name files by responsibility (e.g., `ModuleHeader.vue`, `moduleItems.ts`, `useModuleState.ts`).

## 4. Make reusable helpers explicit
- If you find yourself repeating layout, event handling, or data transformation, abstract it into a stand-alone component (in `components/` or the current module) or a composable in `composables/*.ts`.
- Use `props` to parametrize UI fragments and `emits` for callbacks instead of poking global stores directly.
- Document the component’s intent with a short comment at the top of the file if behavior is not obvious.

## 5. Templates and styling
- Keep templates focused: place logic-heavy expressions into computed properties or helper functions so the markup remains readable.
- Prefer `style scoped` in each component file, and use utility classes or shared CSS modules for consistent spacing.

## 6. When in doubt, ask the user for structure
- If the user does not specify what module the component lives in or how it fits, ask them which feature folder it should belong to, whether it should expose props or slots, and whether it can reuse existing patterns.
