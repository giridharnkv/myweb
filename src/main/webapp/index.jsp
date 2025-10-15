<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8" />
<meta name="viewport" content="width=device-width,initial-scale=1" />
<title>Diwali Cracker Blast ✨</title>
<style>
  :root{
    --bg:#07020a;
    --ground:#0d0b11;
    --accent:#ffcf33;
    --panel-bg: rgba(255,255,255,0.06);
  }
  html,body { height:100%; margin:0; font-family: Inter, system-ui, Arial; background: radial-gradient(ellipse at 20% 10%, rgba(255,180,80,0.06) 0%, transparent 20%),
               radial-gradient(ellipse at 90% 80%, rgba(150,100,255,0.04) 0%, transparent 15%),
               var(--bg); color:#fff; -webkit-font-smoothing:antialiased; -moz-osx-font-smoothing:grayscale;}
  header {
    display:flex; gap:12px; align-items:center; padding:14px 18px;
    position: absolute; left: 12px; top: 12px; z-index: 30;
    background: var(--panel-bg); border-radius:10px; backdrop-filter: blur(6px);
    box-shadow: 0 6px 18px rgba(6,4,10,0.6);
  }
  header h1 { font-size:16px; margin:0; letter-spacing:0.6px; color:#fff; }
  .controls { display:flex; gap:8px; align-items:center; }
  button, .toggle {
    background:linear-gradient(180deg, rgba(255,255,255,0.04), rgba(255,255,255,0.01));
    color:#fff; border:1px solid rgba(255,255,255,0.06); padding:8px 12px; border-radius:8px;
    cursor:pointer; font-size:14px;
  }
  button:active { transform: translateY(1px); }
  .small { padding:6px 10px; font-size:13px; }
  #badge { background: #111; padding:6px 8px; border-radius:6px; font-weight:600; font-size:13px; color:var(--accent); border:1px solid rgba(255,200,80,0.08);}
  main { height:100vh; display:flex; align-items:center; justify-content:center; }
  canvas { width:100%; height:100%; display:block; }
  footer {
    position: absolute; right: 12px; bottom: 12px; z-index: 30;
    background: var(--panel-bg); padding:10px 14px; border-radius:10px; color:#ddd; font-size:13px;
  }
  .legend { opacity:0.9; }
  .muted { opacity:0.75; font-size:13px; }
  @media (max-width:600px){
    header { left:8px; right:8px; top:8px; flex-wrap:wrap; gap:6px; }
    footer { left:8px; right:8px; }
  }
</style>
</head>
<body>

<header role="banner" aria-label="Diwali controls">
  <div id="badge">Diwali Cracker Blast</div>
  <div style="width:8px"></div>
  <div class="controls">
    <button id="clearBtn" class="small" title="Clear all fireworks">Clear</button>
    <button id="autoBtn" class="small" title="Toggle automatic crackers">Auto: off</button>
    <button id="soundBtn" class="small" title="Toggle sound">Sound: on</button>
  </div>
</header>

<main>
  <canvas id="canvas" aria-label="Diwali fireworks canvas"></canvas>
</main>

<footer>
  <div class="legend">Click or tap anywhere to light a cracker — sparks will fly! ✨</div>
  <div class="muted">Tip: enable sound for a richer experience (Web Audio used; no external audio files).</div>
</footer>

<script>
/* ====== Diwali Cracker Blast - single-file interactive page ======
   - Click / tap canvas to create a cracker.
   - Uses canvas particle system for explosions.
   - Uses Web Audio API to synthesize pop/sizzle sounds (no external audio).
   - Controls: Clear, Auto spawn, Sound toggle.
   ================================================================== */

const canvas = document.getElementById('canvas');
const ctx = canvas.getContext('2d', { alpha: true });
let DPR = Math.max(1, window.devicePixelRatio || 1);
let W = 0, H = 0;

function resize(){
  DPR = Math.max(1, window.devicePixelRatio || 1);
  W = Math.floor(window.innerWidth);
  H = Math.floor(window.innerHeight);
  canvas.width = Math.floor(W * DPR);
  canvas.height = Math.floor(H * DPR);
  canvas.style.width = W + 'px';
  canvas.style.height = H + 'px';
  ctx.setTransform(DPR,0,0,DPR,0,0);
}
window.addEventListener('resize', resize);
resize();

/* ---------- particle system ---------- */

const crackers = []; // active crackers (rockets going up then explode)
const particles = []; // particles after explosion

// Utility
function rand(min, max){ return Math.random() * (max - min) + min; }
function hueToColor(h, a=1){ return `hsla(${h}, 90%, 60%, ${a})`; }

class Cracker {
  constructor(x,y){
    this.x = x; this.y = y;
    this.vx = rand(-10,10) * 0.03; // slight horizontal
    this.vy = rand(-8,-12) * 0.5; // shoot up
    this.life = 0;
    this.maxLife = rand(900, 1300); // ms until explosion
    this.color = rand(0,360);
    this.trail = [];
  }
  update(dt){
    this.life += dt;
    // physics
    this.vy += 0.0025 * dt; // gravity (small)
    this.x += this.vx * dt * 0.06;
    this.y += this.vy * dt * 0.06;
    // store trail points
    this.trail.push({x:this.x, y:this.y, t: performance.now()});
    if(this.trail.length > 12) this.trail.shift();
    // explosion condition: either life
