# particles_image

Interactive Flutter demo where images are sampled into particles and assemble from scatter. Hover or drag to push them apart — they spring back into place.

## Demo

[![Demo]()](https://github.com/user-attachments/assets/f227d6ce-132e-48f6-aa4d-009afc3d3a21)

## Pipeline

![Pipeline](./pipeline.png)

**rasterize** (`lib/utils/rasterize.dart`) — loads a bundled PNG, scales it to `imageSize`, samples opaque pixels on a grid, assigns each dot a rest position and a random scattered start.

**Reveal** (`ParticleCanvas`, `_revealed`) — activates more particles each frame (`revealed += revealPerFrame`) until the full list is live.

**Particle physics** (`ParticleCanvas._step`) — integrates velocity, applies pointer repulsion, damping, and spring-back each frame.

**ParticlePainter** (`lib/widgets/particle_painter.dart`) — draws revealed dots on the canvas.

## Run

```bash
flutter run -d chrome   # or macos / ios / android
```

Default tunables live in `Settings` (`lib/models/settings.dart`).

| Field | Default | Notes |
| --- | --- | --- |
| `dotRadius` | 1.6 | Draw radius |
| `hoverRadius` | 80 | Pointer influence radius |
| `hoverForce` | 6 | Repulsion strength |
| `damping` | 0.86 | Per-frame velocity decay |
| `assembleSpeed` | 0.06 | Pull toward rest |
| `fadeInStep` | 0.04 | Opacity ramp per frame |
| `revealPerFrame` | 40 | Particles activated per frame |
| `gap` | 4 | Sample grid spacing (re-rasterize on change) |
| `scatter` | 0.7 | Start offset scale (re-rasterize on change) |
| `imageSize` | 300 | Max raster width (re-rasterize on change) |
