# mirror-asciinema

OCX mirror for [asciinema](https://github.com/asciinema/asciinema). One
repository, one spec directory per package.

| Package | Spec | Publishes to | Announced as | Upstream SPDX |
|---|---|---|---|---|
| [asciinema](https://github.com/asciinema/asciinema) | [`asciinema/mirror.yml`](asciinema/mirror.yml) | `ghcr.io/ocx-contrib/asciinema/asciinema` | `ocx.sh/asciinema/asciinema` | `GPL-3.0-or-later` |

Each upstream release is discovered, re-bundled, smoke-tested per
`(version, platform)` and only then pushed with cascade tags, after which the
result is announced into the OCX index.

The namespace is the upstream org because the org *is* the project's own brand
— and it also publishes `agg`, `asciinema-player` and `asciinema-server`, any
of which would land here as a new sibling directory with nothing else moving.

## Layout

```
mirror-base.yml         repo-wide policy every spec inherits via `extends:`
asciinema/
├── mirror.yml          the spec — never at the repo root
├── metadata.json       bundle interface
├── CATALOG.md          → ocx package describe
├── logo.svg / logo.png describe assets, 512px PNG
└── tests/smoke.star    Starlark smoke test
```

`LICENSE` and `NOTICE.md` are shared at the root. Logos are **not** — each
package carries its own, because a repo-root `logo.*` sits in no workflow's
`paths:` filter, so replacing it would publish nothing until some unrelated
edit happened to fire.

⚠️ `extends:` is a **shallow** merge of top-level keys. A spec that restates
`platforms:` to change one runner drops every `containers:` entry with it, and
nothing reds — the legs simply stop existing, and every `os.features` claim
goes back to being asserted rather than verified. Restate a block in full or
not at all. `platforms:` is kept out of `mirror-base.yml` for exactly this
reason: it is downstream of a per-package libc measurement.

## Platforms

Five platform entries: three Linux keys and both macOS arches. Upstream
publishes no Windows build (asciinema drives a pty) and no linux/arm64 musl
build.

`os.features` states what an artifact requires *of the host*, so the key is
decided by **linkage**, not by the asset name:

| Key | Asset | Measured |
|---|---|---|
| `linux/amd64` | `asciinema-x86_64-unknown-linux-musl` | `static-pie linked` — no `PT_INTERP`, requires nothing → **bare** |
| `linux/amd64+libc.glibc` | `asciinema-x86_64-unknown-linux-gnu` | `interpreter /lib64/ld-linux-x86-64.so.2`, `GLIBC_2.34` |
| `linux/arm64+libc.glibc` | `asciinema-aarch64-unknown-linux-gnu` | `interpreter /lib/ld-linux-aarch64.so.1`, `GLIBC_2.18` |

Both amd64 keys ship side by side: matching is subset-based and scored by
specificity, so a glibc host takes `+libc.glibc` and a musl host takes the bare
static build — deterministically, never `Ambiguous`. The second key earns
itself because asciinema is a *network* tool (`upload`, `stream`, `auth`), and
a static musl build resolves DNS through musl's own resolver, which ignores
`nsswitch.conf` and loads no NSS modules.

The `alpine:3.20` container leg on the bare key is what turns its universality
claim into evidence; the glibc keys get `ubuntu:24.04` + `fedora:40`. The full
measurement is recorded above the `assets:` block in `asciinema/mirror.yml`.

The version floor is `3.0.0` — the first stable release of the Rust rewrite and
the first to ship binaries at all. asciinema 2.x was a Python package
distributed through PyPI.

## Editing

| File | Edit | Regenerate after |
|------|------|------------------|
| `mirror-base.yml`, `asciinema/mirror.yml` | hand | yes — see below |
| `asciinema/{metadata.json,CATALOG.md,logo.*}` | hand | — |
| `asciinema/tests/smoke.star` | hand | — |
| `.github/workflows/*.yml` | **generated — never hand-edit** | re-run when a spec changes |

```bash
ocx-mirror package pipeline generate ci --spec asciinema/mirror.yml
```

**Name every spec.** `--spec` *appends* rather than replaces, so a command
naming a subset silently stops rendering the rest while staying green — and the
drift guard reds on a generated workflow the current spec set no longer
produces.

`verify-generated.yml` exits 65 on drift. If a generated workflow is wrong, the
spec or the renderer template is wrong — fix it there and regenerate.

Run `direnv allow` once to put the pinned toolchain on `PATH`, and invoke
`ocx-mirror` directly — never `ocx run -- ocx-mirror`, which pins
`OCX_BINARY_PIN` to the bootstrap `ocx` and false-reds the nested push.

## The binaries claim

asciinema ships as a raw binary, so the bundle's only PATH entry is a bare
`${installPath}` — the executable *is* the content root. `bin_scan` only looks
*below* an `${installPath}/<dir>` entry, so `auto`/`verify` is rejected at spec
load with exit 65. `mirror-base.yml` therefore sets `bin_scan: off` and
`asciinema/metadata.json` hand-lists `binaries: ["asciinema"]` — the blessed
shape for this asset type.

## Required secrets

| Secret | Use |
|--------|-----|
| `OCX_ANNOUNCE_TOKEN` | opens the index pull request from the `ocx-contrib/index` fork |
| `OCX_MIRROR_DISCORD_HOOK` | notify-stage Discord webhook URL |

(Inherited from the `ocx-contrib` org with visibility ALL. GHCR pushes use the
run's own `GITHUB_TOKEN` — no registry secret needed.)

## License

Apache-2.0 — see [`LICENSE`](LICENSE). Upstream assets are out of scope;
`asciinema` is redistributed under **GPL-3.0-or-later** and its Corresponding
Source pointer is recorded in [`NOTICE.md`](NOTICE.md).
