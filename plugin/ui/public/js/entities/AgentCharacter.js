/**
 * AgentCharacter — A procedurally drawn pixel-art character.
 *
 * Habbo Hotel style: simple isometric bobble-head figure with
 * a coloured body and accent highlights. No external sprites needed.
 */

export class AgentCharacter {
  constructor(scene, x, y, colors) {
    this.scene = scene;
    this.colors = colors;

    // Create the character as a graphics object
    this.sprite = scene.add.graphics();
    this.sprite.setPosition(x, y);
    this.drawCharacter();

    // Depth sort by y position
    this.sprite.setDepth(y);
  }

  drawCharacter() {
    const g = this.sprite;
    g.clear();

    const { body, accent } = this.colors;

    // Shadow
    g.fillStyle(0x000000, 0.15);
    g.fillEllipse(0, 18, 20, 8);

    // Legs
    g.fillStyle(0x2d3748, 1);
    g.fillRect(-5, 8, 4, 10);
    g.fillRect(1, 8, 4, 10);

    // Body
    g.fillStyle(body, 1);
    g.fillRect(-7, -4, 14, 14);

    // Accent stripe (tie / badge)
    g.fillStyle(accent, 1);
    g.fillRect(-1, -2, 2, 10);

    // Head
    g.fillStyle(0xfbd38d, 1); // skin tone
    g.fillCircle(0, -10, 7);

    // Hair
    g.fillStyle(0x2d3748, 1);
    g.fillRect(-7, -17, 14, 5);

    // Eyes
    g.fillStyle(0x1a202c, 1);
    g.fillRect(-3, -11, 2, 2);
    g.fillRect(1, -11, 2, 2);
  }

  walkTo(targetX, targetY, onComplete) {
    const startX = this.sprite.x;
    const startY = this.sprite.y;
    const dist = Phaser.Math.Distance.Between(startX, startY, targetX, targetY);
    const duration = Math.max(600, dist * 3);

    // Walking animation — bob up and down
    const bobTween = this.scene.tweens.add({
      targets: this.sprite,
      y: { value: targetY, ease: "Linear" },
      x: { value: targetX, ease: "Linear" },
      duration,
      onUpdate: () => {
        // Update depth for sorting
        this.sprite.setDepth(this.sprite.y);
      },
      onComplete: () => {
        bobTween.stop();
        if (onComplete) onComplete();
      },
    });

    // Bob effect during walk
    this.scene.tweens.add({
      targets: this.sprite,
      scaleY: { from: 1, to: 0.95 },
      duration: 150,
      yoyo: true,
      repeat: Math.floor(duration / 300),
    });
  }

  emote() {
    // Quick hop animation for collaboration/talking
    this.scene.tweens.add({
      targets: this.sprite,
      y: this.sprite.y - 6,
      duration: 150,
      yoyo: true,
      ease: "Quad.easeOut",
    });
  }

  destroy() {
    // Fade out then remove
    this.scene.tweens.add({
      targets: this.sprite,
      alpha: 0,
      duration: 400,
      onComplete: () => {
        this.sprite.destroy();
      },
    });
  }
}
