---
title: asciinema
description: Terminal session recorder, streamer and player
keywords: asciinema,terminal,recorder,asciicast,screencast,streaming,tty,cli
---

# asciinema

asciinema records a terminal session into a plain-text
[asciicast](https://docs.asciinema.org/manual/asciicast/v3/) file — the exact
byte stream plus timing, not a video — so a recording stays small, greppable,
diffable and copy-pasteable. Recordings play back in the terminal, stream live
over a WebSocket to an asciinema server, and convert to raw terminal output or
plain text.

## What's included

- **asciinema** — the CLI: `record`, `stream`, `session`, `play`, `upload`,
  `auth`, `cat` and `convert`.

## Uploading and streaming

`upload`, `stream` and `auth` talk to an asciinema server —
[asciinema.org](https://asciinema.org) by default, or your own instance via
`ASCIINEMA_SERVER_URL` / `asciinema auth`. Recording, playback and conversion
are entirely local and need no account.

## Links

- [asciinema Documentation](https://docs.asciinema.org/)
- [asciinema on GitHub](https://github.com/asciinema/asciinema)
- [asciinema.org](https://asciinema.org)
