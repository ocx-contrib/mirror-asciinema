# agg/tests/smoke.star — Tier 1+2 liveness/shape, then Tier 3 real render.
#
# agg needs a monospace font to render at all: it fails hard with "no faces
# matching font family options" on a font-less host. The three Linux
# container legs provision one via `setup:` in mirror.yml (measured against
# the real published v1.9.0 binaries before this spec was written:
# `apt-get install fonts-dejavu-core` on ubuntu:24.04, `dnf install
# dejavu-sans-mono-fonts` on fedora:40, `apk add ttf-dejavu` on alpine:3.20 —
# each verified with `docker run`, exit 0, real GIF produced). No override
# needed on darwin (Menlo) or windows (Consolas): both are in agg's built-in
# `--text-font-family` fallback chain and ship on the GitHub-hosted runner
# images by default. "DejaVu Sans Mono" is *also* in that same default
# chain, so the Linux legs need no `--font-family` flag either — installing
# the font is enough for agg's own fallback to find it.
AGG = "agg.exe" if ocx.target_platform.os == ocx.os.Windows else "agg"

# Tier 1 + 2: liveness, and version SHAPE (never the exact version — churns
# every release).
r_version = ocx.run(AGG, "--version")
expect.ok(r_version)
expect.matches(r_version.stdout, r"agg \d+\.\d+\.\d+")

# Tier 3: real computation. A minimal two-event asciicast v2 recording (the
# header line plus two "o" output events) is enough for agg to run its whole
# pipeline: parse the cast, render every frame against the resolved font,
# encode through gifski, and write a real GIF.
#
# `ocx.read_file` requires UTF-8 and caps at 1 MB; a GIF is binary, so its
# bytes are not asserted here directly. `agg` exits non-zero on any pipeline
# failure — unresolved font, malformed cast, encoder error — so `expect.ok`
# plus the output file materializing is the strongest check this host API
# can make without a byte-level read primitive.
ocx.write_file(
    "demo.cast",
    """{"version": 2, "width": 20, "height": 5, "timestamp": 1700000000}
[0.1, "o", "ocx\\r\\n"]
[0.5, "o", "smoke test\\r\\n"]
""",
)
r_render = ocx.run(AGG, "--quiet", "demo.cast", "demo.gif")
expect.ok(r_render)
expect.true(ocx.exists("demo.gif"))
