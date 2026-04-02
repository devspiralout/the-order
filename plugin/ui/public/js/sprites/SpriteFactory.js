/**
 * SpriteFactory — Generates procedural pixel-art textures at runtime.
 *
 * All visuals are drawn via Phaser Graphics — no external asset files needed.
 * This keeps the plugin self-contained and lightweight.
 */

export class SpriteFactory {
  constructor(scene) {
    this.scene = scene;
  }

  // Reserved for future use — texture atlas generation for
  // furniture, plants, coffee cups, etc. Currently all drawing
  // is done inline in OfficeScene and AgentCharacter.
}
