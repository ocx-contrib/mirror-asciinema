# asciinema/tests/smoke.star — stable across upstream releases.
# Assert on the contract (exit code, version shape, computed result), never on
# help/version prose. asciinema's banner and command descriptions are
# upstream's to reword; the digits, the re-timed event stream and the rendered
# terminal text are the contract.
#
# No Windows branch: upstream publishes no Windows target (asciinema drives a
# pty), so the spec declares none and the binary is always `asciinema`.
ASC = "asciinema"

# Tier 1 + 2: liveness + version SHAPE. `--version` prints "asciinema X.Y.Z";
# only the digits are asserted, so a rebrand of the leading token cannot red
# this and a truncated binary cannot pass it.
r_version = ocx.run(ASC, "--version")
expect.ok(r_version)
expect.matches(r_version.stdout, r"\d+\.\d+\.\d+")

# Hermetic fixtures — two asciicast v2 recordings, written to scratch. No
# network, no pty, no upstream sample files.
ocx.write_file(
    "a.cast",
    '{"version":2,"width":80,"height":24}\n' +
    '[0.1,"o","OCX-ALPHA\\r\\n"]\n' +
    '[0.2,"o","done\\r\\n"]\n',
)
ocx.write_file(
    "b.cast",
    '{"version":2,"width":80,"height":24}\n' +
    '[0.1,"o","OCX-BETA\\r\\n"]\n',
)

# Tier 3a: `cat` concatenates and RE-TIMES. b's event is at 0.1 in its own
# file; after a (which ends at 0.2) it must land at 0.3. The anchored regex is
# the computed result — a pass-through concatenation would emit 0.1 and red.
r_cat = ocx.run(ASC, "cat", "a.cast", "b.cast")
expect.ok(r_cat)
expect.contains(r_cat.stdout, "OCX-ALPHA")
expect.matches(r_cat.stdout, r'\[0\.3, "o", "OCX-BETA')

# Tier 3b: `convert` runs the terminal emulator — the txt format is the
# RENDERED screen, not the raw event payload. Output format is inferred from
# the .txt extension. Asserting the exact rendering catches a vt regression
# (CRLF handling, line wrapping) that Tier 3a's event-stream check cannot see.
r_conv = ocx.run(ASC, "convert", "a.cast", "out.txt")
expect.ok(r_conv)
expect.matches(ocx.read_file("out.txt"), r"^OCX-ALPHA\ndone\n")

# Tier 4: the bundle declares PATH only (raw binary, bare ${installPath}), and
# Tier 1 already proves it resolves. No non-PATH env var to wire.
