/**
 * Office UI Server
 *
 * Serves the Phaser app and bridges agent events from the filesystem to
 * WebSocket clients. Watches /tmp/the-order-events/ for JSONL event files
 * written by the emit-event.sh hook.
 */

import express from "express";
import { WebSocketServer } from "ws";
import { createServer } from "http";
import { watch, readFileSync, existsSync, mkdirSync, readdirSync } from "fs";
import { join, dirname } from "path";
import { fileURLToPath } from "url";

const __dirname = dirname(fileURLToPath(import.meta.url));
const PORT = parseInt(process.env.ORDER_UI_PORT || "3742", 10);
const EVENT_DIR = process.env.EVENT_DIR || "/tmp/the-order-events";

// Ensure event directory exists
if (!existsSync(EVENT_DIR)) {
  mkdirSync(EVENT_DIR, { recursive: true });
}

// Track file sizes to only read new lines
const fileCursors = new Map();

const app = express();
app.use(express.static(join(__dirname, "public")));

const server = createServer(app);
const wss = new WebSocketServer({ server });

// Read new events from a JSONL file since last cursor position
function readNewEvents(filePath) {
  if (!existsSync(filePath)) return [];

  const content = readFileSync(filePath, "utf-8");
  const cursor = fileCursors.get(filePath) || 0;
  const newContent = content.slice(cursor);
  fileCursors.set(filePath, content.length);

  return newContent
    .split("\n")
    .filter((line) => line.trim())
    .map((line) => {
      try {
        return JSON.parse(line);
      } catch {
        return null;
      }
    })
    .filter(Boolean);
}

// Broadcast an event to all connected WebSocket clients
function broadcast(data) {
  const message = JSON.stringify(data);
  wss.clients.forEach((client) => {
    if (client.readyState === 1) {
      client.send(message);
    }
  });
}

// Watch the event directory for changes
watch(EVENT_DIR, (eventType, filename) => {
  if (!filename || !filename.endsWith(".jsonl")) return;

  const filePath = join(EVENT_DIR, filename);
  const events = readNewEvents(filePath);

  for (const event of events) {
    broadcast({ type: "agent-activity", ...event });
  }
});

// On new WebSocket connection, send current state of all agents
wss.on("connection", (ws) => {
  // Read all existing event files and send the latest event per agent
  const latestByAgent = new Map();

  if (existsSync(EVENT_DIR)) {
    const files = readdirSync(EVENT_DIR).filter((f) => f.endsWith(".jsonl"));
    for (const file of files) {
      const filePath = join(EVENT_DIR, file);
      const content = readFileSync(filePath, "utf-8");
      const lines = content.split("\n").filter((l) => l.trim());

      if (lines.length > 0) {
        try {
          const lastEvent = JSON.parse(lines[lines.length - 1]);
          latestByAgent.set(lastEvent.agent, lastEvent);
          // Set cursor to end so we don't re-broadcast old events
          fileCursors.set(filePath, content.length);
        } catch {
          // skip malformed lines
        }
      }
    }
  }

  // Send initial state
  ws.send(
    JSON.stringify({
      type: "init",
      agents: Object.fromEntries(latestByAgent),
    })
  );
});

server.listen(PORT, () => {
  console.log(`Office UI running at http://localhost:${PORT}`);
});
