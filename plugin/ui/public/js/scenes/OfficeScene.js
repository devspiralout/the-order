/**
 * OfficeScene — The Severance MDR × Habbo Hotel isometric office.
 *
 * Generates all sprites procedurally (no external assets required).
 * Connects to the WebSocket event stream to animate agents in real-time.
 */

import { SpriteFactory } from "../sprites/SpriteFactory.js";
import { AgentCharacter } from "../entities/AgentCharacter.js";
import { SpeechBubble } from "../entities/SpeechBubble.js";

// Agent colour palette — Severance-inspired muted tones
const AGENT_COLORS = {
  orchestrator: { body: 0x4a5568, accent: 0xecc94b, label: "Orchestrator" },
  pm: { body: 0x744210, accent: 0xed8936, label: "PM" },
  qe: { body: 0x2c5282, accent: 0x63b3ed, label: "QE" },
  "fe-engineer": { body: 0x276749, accent: 0x68d391, label: "FE" },
  "be-engineer": { body: 0x553c9a, accent: 0xb794f4, label: "BE" },
  // Fallback for custom agents from .order.yml
  default: { body: 0x718096, accent: 0xcbd5e0, label: "Agent" },
};

// Desk positions in screen space (isometric-ish layout)
const DESK_POSITIONS = [
  { x: 280, y: 260 }, // orchestrator — centre back
  { x: 160, y: 320 }, // pm — left
  { x: 400, y: 320 }, // qe — right
  { x: 160, y: 420 }, // fe-engineer — front left
  { x: 400, y: 420 }, // be-engineer — front right
  { x: 280, y: 420 }, // extra agent 1
  { x: 520, y: 320 }, // extra agent 2
  { x: 520, y: 420 }, // extra agent 3
];

const DOOR_POSITION = { x: 280, y: 130 };
const WHITEBOARD_POSITION = { x: 600, y: 200 };

export class OfficeScene extends Phaser.Scene {
  constructor() {
    super("OfficeScene");
    this.agents = new Map();
    this.deskAssignments = new Map();
    this.nextDeskIndex = 0;
    this.ws = null;
  }

  preload() {
    // All sprites are generated procedurally — nothing to load
  }

  create() {
    this.spriteFactory = new SpriteFactory(this);

    this.drawOffice();
    this.drawDoor();
    this.drawWhiteboard();
    this.drawDesks();
    this.drawTitle();

    this.connectWebSocket();
  }

  // ── Office rendering ────────────────────────────────────────

  drawOffice() {
    const g = this.add.graphics();

    // Floor — warm grey Lumon-style
    g.fillStyle(0xddd8d0, 1);
    g.fillRect(60, 160, 640, 400);

    // Floor grid lines (subtle)
    g.lineStyle(1, 0xd0cbc3, 0.4);
    for (let y = 160; y <= 560; y += 40) {
      g.lineBetween(60, y, 700, y);
    }
    for (let x = 60; x <= 700; x += 40) {
      g.lineBetween(x, 160, x, 560);
    }

    // Walls
    g.lineStyle(3, 0x2d3748, 1);
    // Back wall
    g.lineBetween(60, 160, 700, 160);
    // Left wall
    g.lineBetween(60, 160, 60, 560);
    // Right wall
    g.lineBetween(700, 160, 700, 560);

    // Baseboard shadow
    g.lineStyle(2, 0xc4bfb7, 1);
    g.lineBetween(60, 162, 700, 162);

    // Harsh overhead light strip (Severance aesthetic)
    g.fillStyle(0xffffff, 0.15);
    g.fillRect(200, 160, 360, 400);
  }

  drawDoor() {
    const { x, y } = DOOR_POSITION;
    const g = this.add.graphics();

    // Door frame
    g.fillStyle(0x4a5568, 1);
    g.fillRect(x - 22, y - 5, 44, 50);

    // Door
    g.fillStyle(0x2d3748, 1);
    g.fillRect(x - 18, y, 36, 42);

    // Door handle
    g.fillStyle(0xecc94b, 1);
    g.fillCircle(x + 10, y + 22, 3);

    // Label
    this.add
      .text(x, y - 15, "ENTRANCE", {
        fontSize: "8px",
        color: "#a0aec0",
        fontFamily: "Courier New",
      })
      .setOrigin(0.5);

    this.doorPosition = { x, y: y + 45 };
  }

  drawWhiteboard() {
    const { x, y } = WHITEBOARD_POSITION;
    const g = this.add.graphics();

    // Board
    g.fillStyle(0xffffff, 1);
    g.fillRect(x - 50, y, 100, 70);
    g.lineStyle(2, 0x4a5568, 1);
    g.strokeRect(x - 50, y, 100, 70);

    // "WHITEBOARD" label
    this.add
      .text(x, y - 8, "BOARD", {
        fontSize: "8px",
        color: "#a0aec0",
        fontFamily: "Courier New",
      })
      .setOrigin(0.5);

    // Dynamic text area for task status
    this.whiteboardText = this.add
      .text(x - 42, y + 8, "Waiting for\nagents...", {
        fontSize: "8px",
        color: "#4a5568",
        fontFamily: "Courier New",
        wordWrap: { width: 84 },
        lineSpacing: 2,
      })
      .setAlpha(0.7);
  }

  drawDesks() {
    this.deskGraphics = [];

    for (let i = 0; i < DESK_POSITIONS.length; i++) {
      const { x, y } = DESK_POSITIONS[i];
      const g = this.add.graphics();

      // Desk surface
      g.fillStyle(0xc4bfb7, 1);
      g.fillRect(x - 24, y, 48, 28);
      g.lineStyle(1, 0xa0aec0, 1);
      g.strokeRect(x - 24, y, 48, 28);

      // Monitor on desk
      g.fillStyle(0x2d3748, 1);
      g.fillRect(x - 8, y + 2, 16, 12);
      g.fillStyle(0x1a202c, 1);
      g.fillRect(x - 2, y + 14, 4, 4);

      // Monitor screen (off by default)
      g.fillStyle(0x4a5568, 0.3);
      g.fillRect(x - 6, y + 3, 12, 9);

      this.deskGraphics.push(g);
    }
  }

  drawTitle() {
    // Title bar at top
    this.add
      .text(480, 20, "THE ORDER — OFFICE", {
        fontSize: "14px",
        color: "#4a5568",
        fontFamily: "Courier New",
        fontStyle: "bold",
      })
      .setOrigin(0.5);

    // Status text
    this.statusText = this.add
      .text(480, 42, "Connecting...", {
        fontSize: "10px",
        color: "#a0aec0",
        fontFamily: "Courier New",
      })
      .setOrigin(0.5);

    // Lumon-style department label
    this.add
      .text(480, 580, "MACRODATA REFINEMENT", {
        fontSize: "9px",
        color: "#cbd5e0",
        fontFamily: "Courier New",
        letterSpacing: 4,
      })
      .setOrigin(0.5)
      .setAlpha(0.5);
  }

  // ── Agent management ────────────────────────────────────────

  getOrCreateAgent(agentName) {
    if (this.agents.has(agentName)) {
      return this.agents.get(agentName);
    }

    // Assign a desk
    const deskIndex = this.nextDeskIndex;
    this.nextDeskIndex = Math.min(
      this.nextDeskIndex + 1,
      DESK_POSITIONS.length - 1
    );
    const deskPos = DESK_POSITIONS[deskIndex];
    this.deskAssignments.set(agentName, deskIndex);

    // Get colour scheme
    const colors = AGENT_COLORS[agentName] || {
      ...AGENT_COLORS.default,
      label: agentName.replace(/-/g, " ").replace(/\b\w/g, (c) => c.toUpperCase()),
    };

    // Create character at door, then walk to desk
    const character = new AgentCharacter(this, this.doorPosition.x, this.doorPosition.y, colors);
    character.walkTo(deskPos.x, deskPos.y - 32);

    // Light up the monitor
    this.time.delayedCall(1500, () => {
      const g = this.add.graphics();
      g.fillStyle(colors.accent, 0.6);
      g.fillRect(deskPos.x - 6, deskPos.y + 3, 12, 9);
    });

    // Name label at desk
    this.add
      .text(deskPos.x, deskPos.y + 32, colors.label, {
        fontSize: "8px",
        color: "#" + colors.accent.toString(16).padStart(6, "0"),
        fontFamily: "Courier New",
        fontStyle: "bold",
      })
      .setOrigin(0.5);

    const agent = { character, colors, deskPos, bubble: null };
    this.agents.set(agentName, agent);

    this.updateStatus();
    return agent;
  }

  showBubble(agentName, text) {
    const agent = this.agents.get(agentName);
    if (!agent) return;

    // Remove existing bubble
    if (agent.bubble) {
      agent.bubble.destroy();
    }

    const bx = agent.character.sprite.x;
    const by = agent.character.sprite.y - 36;
    agent.bubble = new SpeechBubble(this, bx, by, text, agent.colors.accent);

    // Auto-dismiss after 4 seconds
    this.time.delayedCall(4000, () => {
      if (agent.bubble) {
        agent.bubble.fadeOut();
        agent.bubble = null;
      }
    });
  }

  dismissAgent(agentName) {
    const agent = this.agents.get(agentName);
    if (!agent) return;

    if (agent.bubble) {
      agent.bubble.destroy();
    }

    agent.character.walkTo(this.doorPosition.x, this.doorPosition.y, () => {
      agent.character.destroy();
      this.agents.delete(agentName);
      this.updateStatus();
    });
  }

  updateStatus() {
    const count = this.agents.size;
    if (count === 0) {
      this.statusText.setText("No agents active — run /team-setup to begin");
    } else {
      const names = Array.from(this.agents.keys()).join(", ");
      this.statusText.setText(`${count} agent${count > 1 ? "s" : ""} active: ${names}`);
    }
  }

  updateWhiteboard(action, detail) {
    const lines = this.whiteboardText.text.split("\n").slice(-5);
    lines.push(`• ${detail}`.slice(0, 20));
    this.whiteboardText.setText(lines.join("\n"));
  }

  // ── WebSocket connection ────────────────────────────────────

  connectWebSocket() {
    const protocol = window.location.protocol === "https:" ? "wss:" : "ws:";
    const wsUrl = `${protocol}//${window.location.host}`;

    this.ws = new WebSocket(wsUrl);

    this.ws.onopen = () => {
      this.statusText.setText("Connected — waiting for agents...");
    };

    this.ws.onmessage = (event) => {
      try {
        const data = JSON.parse(event.data);
        this.handleEvent(data);
      } catch {
        // ignore malformed messages
      }
    };

    this.ws.onclose = () => {
      this.statusText.setText("Disconnected — reconnecting...");
      this.time.delayedCall(2000, () => this.connectWebSocket());
    };
  }

  handleEvent(data) {
    if (data.type === "init") {
      // Restore agents from initial state
      for (const [name, event] of Object.entries(data.agents || {})) {
        this.getOrCreateAgent(name);
        this.showBubble(name, `${event.action} ${event.detail || ""}`.trim());
      }
      return;
    }

    if (data.type === "agent-activity") {
      const agent = this.getOrCreateAgent(data.agent);
      const text = `${data.action} ${data.detail || ""}`.trim();
      this.showBubble(data.agent, text);

      // If two agents touch the same area, show them "walking" to each other
      if (data.action === "talking" || data.action === "collaborating") {
        // Brief animation: character hops slightly
        agent.character.emote();
      }

      this.updateWhiteboard(data.action, data.detail || data.tool);
    }
  }
}
