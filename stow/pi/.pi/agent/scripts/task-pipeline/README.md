# task-pipeline

A **production-grade Bun CLI** for managing DAG-based task execution with the [pi](https://pi.ai) agent.
Provides validation, status tracking, prompt generation, and tmux-based wave spawning for `tasks.json` plans.

## Quick Start

```bash
cd /path/to/your/project   # where tasks.json lives

# Via the unified CLI
bun /path/to/task-pipeline/src/cli.ts validate --topo
bun /path/to/task-pipeline/src/cli.ts status --compact
bun /path/to/task-pipeline/src/cli.ts prompts
bun /path/to/task-pipeline/src/cli.ts spawn --all

# Or via npm scripts (when in the package directory)
bun run validate -- --topo
bun run status -- --compact
```

## Structure

```
task-pipeline/
├── package.json               # Bun package with bin + scripts
├── tsconfig.json              # Strict TypeScript config
├── bun.lock
├── README.md
└── src/
    ├── cli.ts                 # CLI entry point (#!/usr/bin/env bun)
    ├── commands/
    │   ├── validate.ts        # Validate tasks.json schema and DAG
    │   ├── status.ts          # Show task execution status
    │   ├── prompts.ts         # Generate prompt files from tasks.json
    │   └── spawn.ts           # Spawn tmux sub-agents
    └── lib/
        ├── tasks-lib.ts       # Domain logic (types, DAG, waves, stats)
        └── cli-utils.ts       # CLI utilities (arg parsing, ANSI, tables)
```

## Commands

### `validate`

Validate a `tasks.json` file against the PRD-to-Tasks schema.

```bash
task-pipeline validate [path] [options]

Options:
  -q, --quiet      Exit code only, no output
      --summary    Show phase & agent breakdown
      --topo       Print topological execution order
      --waves      Print parallel execution waves
      --json       Machine-readable JSON output
  -h, --help       Show this help
```

### `status`

Show task execution status from `tasks/` directory markers (`.done`, `.out`).

```bash
task-pipeline status [options]

Options:
  -c, --compact    One-line summary only
  -j, --json       Machine-readable JSON output
      --pending    Only pending tasks (deps met, not started)
      --ready      Only tasks ready to spawn (same as --pending)
      --running    Only running tasks
      --done       Only completed tasks
      --blocked    Only blocked tasks
  -h, --help       Show this help
```

### `prompts`

Generate self-contained prompt files from `tasks.json`, one per task in topological order.

```bash
task-pipeline prompts [path] [options]

Options:
      --dry-run        Preview without writing files
      --no-validate    Skip validation step
      --prd <path>     Path to PRD.md for extra context
  -h, --help           Show this help
```

### `spawn`

Spawn tmux sub-agents that execute tasks using the pi CLI. Respects the DAG and supports wave-based parallel execution.

```bash
task-pipeline spawn [task-ids...] [options]

Options:
      --all                    Spawn all waves sequentially
      --dry-run                Show what would spawn
      --session-prefix <name>  Custom tmux session prefix (default: "task")
  -h, --help                   Show this help
```

Pass specific task IDs to spawn individually:
```bash
task-pipeline spawn T001 T003
```

## Library: `src/lib/tasks-lib.ts`

Pure domain logic with no presentation concerns. Import from any TypeScript/Bun project:

```typescript
import {
  loadTasks,         // Load & parse tasks.json
  topologicalSort,   // Kahn's algorithm
  computeWaves,      // Parallel execution groups
  criticalPath,      // Longest dependency chain
  computeStats,      // Aggregate summary
  scanTaskStatus,    // Read .done/.out markers
  generateRunnerScript, // Create tmux runner scripts
} from "./lib/tasks-lib.ts";
```

## Requirements

- [Bun](https://bun.sh) >= 1.0
- [tmux](https://github.com/tmux/tmux) (for `spawn` command)
- [pi](https://pi.ai) CLI (for spawned task execution)

## Development

```bash
# Install dependencies
bun install

# Type-check
bunx tsc --noEmit

# Use the CLI
bun src/cli.ts validate --topo
```
