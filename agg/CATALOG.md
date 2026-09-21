---
title: agg
description: Generate animated GIFs from asciinema terminal session recordings
keywords: agg,asciinema,gif,terminal,recording,animation,gifski
---

# agg

**agg** (asciinema gif generator) is a command-line tool that converts
[asciicast](https://docs.asciinema.org/manual/asciicast/v3/) terminal session
recordings — v1, v2, and v3 — into animated GIF files. It uses the
[gifski](https://github.com/ImageOptim/gifski) encoder for optimized,
high-quality output with accurate frame timing.

## What's included

- **agg** — the single static binary. No runtime dependencies beyond a
  monospace font for rendering. Reads a local asciicast file, stdin, or an
  HTTP(S) URL (e.g. an [asciinema.org](https://asciinema.org) recording
  link) and writes a GIF.

## Links

- [agg on GitHub](https://github.com/asciinema/agg)
- [asciicast format docs](https://docs.asciinema.org/manual/asciicast/v3/)
- [asciinema](https://asciinema.org)
