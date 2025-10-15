<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
  <title>Happy Diwali 🎆</title>
  <style>
    body {
      margin: 0;
      padding: 0;
      background: radial-gradient(ellipse at bottom, #000 0%, #110011 100%);
      overflow: hidden;
      color: white;
      font-family: 'Segoe UI', sans-serif;
    }

    .lights {
      position: absolute;
      width: 100%;
      top: 0;
      display: flex;
      justify-content: center;
      padding: 20px 0;
      z-index: 5;
    }

    .light {
      width: 20px;
      height: 20px;
      border-radius: 50%;
      margin: 0 10px;
      background: red;
      box-shadow: 0 0 10px red;
      animation: blink 1.5s infinite alternate;
    }

    .light:nth-child(2) {
      background: orange;
      box-shadow: 0 0 10px orange;
      animation-delay: 0.2s;
    }

    .light:nth-child(3) {
      background: yellow;
      box-shadow: 0 0 10px yellow;
      animation-delay: 0.4s;
    }

    .light:nth-child(4) {
      background: green;
      box-shadow: 0 0 10px green;
      animation-delay: 0.6s;
    }

    .light:nth-child(5) {
      background: blue;
      box-shadow: 0 0 10px blue;
      animation-delay: 0.8s;
    }

    .light:nth-child(6) {
      background: violet;
      box-shadow: 0 0 10px violet;
      animation-delay: 1s;
    }

    @keyframes blink {
      0%   { opacity: 0.3; transform: scale(0.9); }
      100% { opacity: 1; transform: scale(1.2); }
    }

    h1 {
      position: absolute;
      top: 40%;
      left: 50%;
      transform: translate(-50%, -50%);
      font-size: 3em;
      text-align: center;
      color: #fff;
      text-shadow: 0 0 10px #ffcc00, 0 0 20px #ff6600;
      animation: glow 2s infinite alternate;
      z-index: 10;
    }

    @keyframes glow {
      from {
        text-shadow: 0 0 10px #ffcc00, 0 0 20px #ff6600;
      }
      to {
        text-shadow: 0 0 20px #ffcc00, 0 0 40px #ff6600;
      }
    }

    canvas {
      position: absolute;
      top: 0;
      left: 0;
    }
  </style>
</head>
<body>

  <!-- Fairy Lights -->
  <div class="lights">
    <div class="light"></div>
    <div class="light"></div>
    <div class="light"></div>
    <div class="light"></div>
    <div class="light"></div>
    <div class="light"></div>
  </div>

  <!-- Greeting -->
  <h1>🎇 Happy Diwali 🎇</h1>

  <!-- Fireworks Canvas -->
  <canvas id="fireworks"></canvas>

  <script>
    const canvas = document.getElementById("fireworks");
    const ctx = canvas.getContext("2d");
    let cw, ch;
    const fireworks = [];
    const particles = [];

    function resizeCanvas() {
      cw = canvas.width = window.innerWidth;
      ch = canvas.height = window.innerHeight;
    }

    window.addEventListener("resize", resizeCanvas);
    resizeCanvas();

    class Firework {
      constructor() {
        this.x = Math.random() * cw;
        this.y = ch;
        this.targetY = Math.random() * (ch / 2);
        this.speed = 4 + Math.random() * 2;
        this.color = `hsl(${Math.floor(Math.random() * 360)}, 100%, 50%)`;
        this.exploded = false;
      }

      update() {
        this.y -= this.speed;
        if (this.y <= this.targe
