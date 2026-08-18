#!/usr/bin/env python3
"""Generate an original 110 ms retro-style confirmation sound.

The sound uses two separately decaying additive waveforms.  Each waveform
blends a band-limited square-inspired odd-harmonic series with a
triangle-inspired odd-harmonic series.  It is an original synthesis recipe,
not a recording or transcription of any existing game sound.
"""

from __future__ import annotations

import math
import struct
import wave
from pathlib import Path

SAMPLE_RATE = 44_100
CHANNELS = 1
SAMPLE_WIDTH_BYTES = 2
DURATION_SECONDS = 0.110
REPOSITORY_ROOT = Path(__file__).resolve().parents[1]
OUTPUT = REPOSITORY_ROOT / "assets" / "Supplied Sounds" / "potato_voxel_detected.wav"

# Two rapid, upward confirmation components.
FIRST_START = 0.000
FIRST_DURATION = 0.047
FIRST_FREQUENCY = 728.0
FIRST_GAIN = 0.56
FIRST_DECAY_SECONDS = 0.012

SECOND_START = 0.045
SECOND_DURATION = 0.065
SECOND_FREQUENCY = 902.0
SECOND_GAIN = 0.70
SECOND_DECAY_SECONDS = 0.017

ATTACK_SECONDS = 0.00065
RELEASE_SECONDS = 0.0015


def smoothstep01(x: float) -> float:
    """Smooth 0..1 transition without clicks at a note boundary."""
    x = max(0.0, min(1.0, x))
    return x * x * (3.0 - 2.0 * x)


def envelope(local_time: float, duration: float, decay_seconds: float) -> float:
    """Near-instant attack, exponential decay, and a tiny anti-click release."""
    if local_time < 0.0 or local_time >= duration:
        return 0.0
    attack = smoothstep01(local_time / ATTACK_SECONDS)
    release_start = duration - RELEASE_SECONDS
    release = 1.0 if local_time <= release_start else 1.0 - smoothstep01(
        (local_time - release_start) / RELEASE_SECONDS
    )
    return attack * math.exp(-local_time / decay_seconds) * release


def retro_timbre(phase: float) -> float:
    """Bright, handheld-like timbre using only safe low-order odd harmonics.

    The square-inspired component weights odd harmonics as 1/n.  The
    triangle-inspired component weights them as alternating 1/n^2.  Blending
    them gives a crisp, compact UI timbre without copying an existing sample.
    """
    square_like = (
        math.sin(phase)
        + math.sin(3.0 * phase) / 3.0
        + math.sin(5.0 * phase) / 5.0
        + math.sin(7.0 * phase) / 7.0
    )
    triangle_like = (
        math.sin(phase)
        - math.sin(3.0 * phase) / 9.0
        + math.sin(5.0 * phase) / 25.0
        - math.sin(7.0 * phase) / 49.0
    )
    # Normalize the individual series approximately before the blend.
    return 0.42 * square_like + 0.67 * triangle_like


def component(time_seconds: float, start: float, duration: float,
              frequency: float, gain: float, decay_seconds: float) -> float:
    local_time = time_seconds - start
    phase = 2.0 * math.pi * frequency * local_time
    return gain * envelope(local_time, duration, decay_seconds) * retro_timbre(phase)


def main() -> None:
    frame_count = round(DURATION_SECONDS * SAMPLE_RATE)
    samples: list[float] = []

    for index in range(frame_count):
        time_seconds = index / SAMPLE_RATE
        value = component(
            time_seconds,
            FIRST_START,
            FIRST_DURATION,
            FIRST_FREQUENCY,
            FIRST_GAIN,
            FIRST_DECAY_SECONDS,
        )
        value += component(
            time_seconds,
            SECOND_START,
            SECOND_DURATION,
            SECOND_FREQUENCY,
            SECOND_GAIN,
            SECOND_DECAY_SECONDS,
        )
        samples.append(value)

    # Preserve the deliberately short dynamics while leaving anti-clipping headroom.
    peak = max(abs(sample) for sample in samples) or 1.0
    scale = 0.82 / peak
    pcm = bytearray()
    for sample in samples:
        integer = round(max(-1.0, min(1.0, sample * scale)) * 32767.0)
        pcm.extend(struct.pack("<h", integer))

    with wave.open(str(OUTPUT), "wb") as wav:
        wav.setnchannels(CHANNELS)
        wav.setsampwidth(SAMPLE_WIDTH_BYTES)
        wav.setframerate(SAMPLE_RATE)
        wav.writeframes(bytes(pcm))

    print(f"Wrote {OUTPUT} ({frame_count} mono samples, {DURATION_SECONDS * 1000:.0f} ms)")


if __name__ == "__main__":
    main()
