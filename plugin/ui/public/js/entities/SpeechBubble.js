/**
 * SpeechBubble — Pixel-art speech bubble with tail.
 *
 * Displays a short text string above an agent character.
 * Auto-wraps text and sizes the bubble to fit.
 */

export class SpeechBubble {
  constructor(scene, x, y, text, accentColor) {
    this.scene = scene;
    this.container = scene.add.container(x, y);
    this.container.setDepth(9999); // Always on top

    const maxWidth = 120;
    const padding = 6;
    const tailHeight = 6;

    // Text
    this.text = scene.add.text(0, 0, text.slice(0, 40), {
      fontSize: "8px",
      color: "#1a202c",
      fontFamily: "Courier New",
      wordWrap: { width: maxWidth - padding * 2 },
      lineSpacing: 1,
    });
    this.text.setOrigin(0.5);

    const textWidth = Math.min(this.text.width + padding * 2, maxWidth);
    const textHeight = this.text.height + padding * 2;

    // Bubble background
    this.bg = scene.add.graphics();
    this.bg.fillStyle(0xffffff, 0.95);
    this.bg.fillRoundedRect(
      -textWidth / 2,
      -textHeight / 2,
      textWidth,
      textHeight,
      4
    );

    // Border with accent colour
    this.bg.lineStyle(1, accentColor, 0.8);
    this.bg.strokeRoundedRect(
      -textWidth / 2,
      -textHeight / 2,
      textWidth,
      textHeight,
      4
    );

    // Tail triangle
    this.bg.fillStyle(0xffffff, 0.95);
    this.bg.fillTriangle(
      -4,
      textHeight / 2,
      4,
      textHeight / 2,
      0,
      textHeight / 2 + tailHeight
    );

    this.container.add([this.bg, this.text]);

    // Slide in from above
    this.container.setAlpha(0);
    this.container.y -= 10;
    scene.tweens.add({
      targets: this.container,
      alpha: 1,
      y: y,
      duration: 200,
      ease: "Back.easeOut",
    });
  }

  fadeOut() {
    this.scene.tweens.add({
      targets: this.container,
      alpha: 0,
      y: this.container.y - 8,
      duration: 300,
      ease: "Quad.easeIn",
      onComplete: () => {
        this.destroy();
      },
    });
  }

  destroy() {
    if (this.container) {
      this.container.destroy(true);
      this.container = null;
    }
  }
}
