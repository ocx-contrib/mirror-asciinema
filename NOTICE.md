# NOTICE

This repository packages and redistributes upstream software published by the
[asciinema project](https://github.com/asciinema). The Apache-2.0 license in
[`LICENSE`](LICENSE) covers the OCX pipeline files authored here. It does
**not** cover any upstream-derived asset — each package's redistributed bytes
carry their own license, recorded below.

Each package's logo is reproduced for catalog identification only, under
nominative fair use. The marks remain the property of their respective owners
and no endorsement is implied.

| Package | GHCR path | Upstream SPDX |
|---|---|---|
| `asciinema` | `ghcr.io/ocx-contrib/asciinema/asciinema` | `GPL-3.0-or-later` |

---

## `asciinema`

Upstream: <https://github.com/asciinema/asciinema>
Published to `ghcr.io/ocx-contrib/asciinema/asciinema`.

| Component | SPDX | Holder |
|---|---|---|
| asciinema (`asciinema`) | **GPL-3.0-or-later** | © 2011 Marcin Kulik and contributors |

`gh api repos/asciinema/asciinema/license` reports the deprecated umbrella id
`GPL-3.0`; upstream disambiguates it itself — `Cargo.toml` declares
`license = "GPL-3.0-or-later"` and the README reads "All code is licensed under
the GPL, v3 or later" — so the precise expression is **GPL-3.0-or-later**.

Strong copyleft. Redistribution of the compiled binary is granted provided the
Corresponding Source is conveyed (below). Upstream ships bare binaries with no
bundled license file, so the full license text is the one at
<https://github.com/asciinema/asciinema/blob/main/LICENSE> (GNU GPL version 3,
29 June 2007) and is reproduced by reference here; it accompanies every
mirrored version through this notice.

The published binaries statically link third-party Rust crates under permissive
licenses, enumerated in upstream's `Cargo.toml` / `Cargo.lock`.

### Corresponding Source (GPLv3 §6)

The complete Corresponding Source — the exact source *and* build scripts — for
every mirrored version is the upstream tagged tree, offered from the same place
as the binaries under **GPLv3 §6(d)**. This option is available because the
licence is GPL-3.0-**or-later**, not GPLv2-only:

- Version `X.Y.Z` → tag `vX.Y.Z` →
  <https://github.com/asciinema/asciinema/releases/tag/vX.Y.Z>
- Or clone and check out the exact tag:

  ```bash
  git clone https://github.com/asciinema/asciinema
  git -C asciinema checkout vX.Y.Z   # X.Y.Z = the mirrored package version
  ```

Every version this mirror publishes is built by upstream from that tag and
republished byte-for-byte, so the tag *is* the Corresponding Source for the
mirrored binary. No additional restrictions are imposed beyond
GPL-3.0-or-later, and no fee is charged.

The asciinema name is used for catalog identification under nominative fair
use. The logo shipped with this package is the official asciinema mark, taken
from `asciinema/asciinema-server`
(`priv/static/images/logo-red.svg`), and remains the property of the upstream
project.

No modifications are made to any upstream artifact in this repository; they are
republished byte-for-byte inside an OCX bundle.
