import * as path from "node:path";
import type { UserMessage } from "@earendil-works/pi-ai";
import type {
  ExtensionAPI,
  ExtensionContext,
} from "@earendil-works/pi-coding-agent";

const authTokensRaw = Bun.env.OPENCODE_KEYS ?? "";
const authTokens = authTokensRaw.split(",");

let seqErrorCounter = 0;
let prevMessageContent: UserMessage["content"] | null = null;

export default function (pi: ExtensionAPI) {
  pi.on("message_end", async (event, ctx: ExtensionContext) => {
    if (event.message.role === "user") {
      prevMessageContent = event.message.content;
      seqErrorCounter = 0;
    }

    if (event.message.role !== "assistant") {
      return;
    }

    const { stopReason = "", errorMessage = "" } = event.message;
    if (stopReason !== "error") {
      seqErrorCounter = 0;
      return;
    }

    const isCreditsError =
      errorMessage.includes("server_error") ||
      errorMessage.includes("CreditsError") ||
      errorMessage.includes("GoUsageLimitError");

    if (!isCreditsError) {
      seqErrorCounter = 0;
      return;
    }

    const nextAuthToken = await rotateOpencodeKeys();

    ctx.ui.notify(
      `Sessiom Auth Token rotated: ${nextAuthToken.slice(0, 6)}******, errorCounter=${seqErrorCounter}`,
      "info",
    );

    // INFO: resend message
    if (!prevMessageContent) {
      return;
    }

    seqErrorCounter++;

    if (seqErrorCounter >= authTokens.length) {
      ctx.ui.notify(
        `All tokens rotated and none is working, errorCounter=${seqErrorCounter}`,
        "warning",
      );
      return;
    }

    pi.sendMessage({
      customType: "rotate-opencode-keys",
      content: prevMessageContent,
      display: true,
    });
  });
}

async function rotateOpencodeKeys() {
  const homedir = Bun.env.HOME ?? "~";
  const filepath = path.join(homedir, `.pi/agent/auth.json`);
  const file = Bun.file(filepath);

  const {
    "opencode-go": { key: currentAuthKey },
  } = await file.json();

  const currentIdx =
    authTokens.findIndex((token) => token === currentAuthKey) ??
    raise("couldn't find current auth");

  const nextIdx = (currentIdx + 1) % authTokens.length;
  const nextAuthToken =
    authTokens[nextIdx] ?? raise("next token not accessible");

  // Write to auth.json
  const textContent = await file.text();
  await file.write(textContent.replaceAll(currentAuthKey, nextAuthToken));

  return nextAuthToken;
}

function raise(message: string): never {
  throw new Error(message);
}
