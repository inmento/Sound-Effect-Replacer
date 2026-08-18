# Changelog

## 0.3.2 — PotatoVoxel startup confirmation

Sound Effect Replacer now recognizes an active [PotatoVoxel](https://github.com/ShaneMcGovernIE/potato_voxel) installation through its optional `potato_voxel` dependency and plays one short startup confirmation sound only when that mod is installed and enabled. PotatoVoxel is not required; when it is absent, disabled, or fails to load, Sound Effect Replacer remains silent and behaves normally.

The supplied `assets/Supplied Sounds/potato_voxel_detected.wav` is an original 110 ms retro-style two-part confirmation cue. It is 44,100 Hz, mono, and 16-bit PCM WAV. Its deterministic generation source is included at `tools/generate_potato_voxel_detected.py`; the script regenerates the exact supplied WAV without using any extracted or copied game audio.

The README now documents the integration, supplied asset, and reproducible generator.
