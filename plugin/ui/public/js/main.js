import { OfficeScene } from "./scenes/OfficeScene.js";

const config = {
  type: Phaser.AUTO,
  parent: "game-container",
  width: 960,
  height: 640,
  pixelArt: true,
  backgroundColor: "#e8e4df",
  scale: {
    mode: Phaser.Scale.FIT,
    autoCenter: Phaser.Scale.CENTER_BOTH,
  },
  scene: [OfficeScene],
};

new Phaser.Game(config);
