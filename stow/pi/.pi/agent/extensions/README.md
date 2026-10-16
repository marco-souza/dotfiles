# @marco-souza/pi-extensions

<div align="center">

[![Bun](https://img.shields.io/badge/Bun-1.0+-ffcd1a?style=for-the-badge&logo=bun&logoColor=white)](https://bun.sh)
[![TypeScript](https://img.shields.io/badge/TypeScript-5.x-3178c6?style=for-the-badge&logo=typescript&logoColor=white)](https://typescriptlang.org)
[![Pi Agent](https://img.shields.io/badge/Pi_Coding_Agent-Extension-ff6b9d?style=for-the-badge)](https://github.com/earendil-works/pi-coding-agent)
[![License](https://img.shields.io/github/license/marco-souza/pi-extensions?style=for-the-badge)](LICENSE)

**Custom extensions for the [Pi AI Coding Agent](https://github.com/earendil-works/pi-coding-agent)**

</div>

---

## 🚀 What's Inside

A collection of extensions to supercharge your Pi AI coding agent experience.

### Extensions

| Extension             | Description                                                        |
| --------------------- | ------------------------------------------------------------------ |
| **API Key Rotation**  | Automatically rotates OpenCode API keys when credit limits are hit |
| **Example Extension** | Starter template demonstrating Pi's extension API                  |

---

## 📦 Installation

```bash
# Clone the repo
git clone https://github.com/marco-souza/pi-extensions.git
cd pi-extensions

# Install dependencies
bun install
```

---

## 🔧 Usage

### Running the Extension

```bash
bun run src/rotate-opencode-keys.ts
```

### Configuration

Set your API keys in environment variables:

```bash
export OPENCODE_KEYS="key1,key2,key3"
```

---

## 🧪 Development

### Prerequisites

- [Bun](https://bun.sh) v1.0+
- [Pi Coding Agent](https://github.com/earendil-works/pi-coding-agent)

### Testing

```bash
bun test
```

### Adding a New Extension

1. Create a new file in `src/`
2. Export a default function that receives the `ExtensionAPI`
3. Register tools, commands, or event listeners

```typescript
import type { ExtensionAPI } from "@earendil-works/pi-coding-agent";

export default function (pi: ExtensionAPI) {
  pi.on("session_start", async (_event, ctx) => {
    ctx.ui.notify("My extension loaded!", "info");
  });
}
```

---

## 📚 Resources

- [Pi Agent Documentation](https://github.com/earendil-works/pi-coding-agent)
- [Bun Documentation](https://bun.sh/docs)
- [TypeScript Handbook](https://typescriptlang.org/docs)

---

<div align="center">

**Built with 💜 by [@marco-souza](https://github.com/marco-souza)**

</div>
