# Changelog

## 0.3.2 — PotatoVoxel startup confirmation

Sound Effect Replacer now recognizes an active [PotatoVoxel](https://github.com/ShaneMcGovernIE/potato_voxel) installation through its optional `potato_voxel` dependency and plays one short startup confirmation sound only when that mod is installed and enabled. PotatoVoxel is not required; when it is absent, disabled, or fails to load, Sound Effect Replacer remains silent and behaves normally.

The confirmation cue is an original, file-free Lua chip SFX assembled through Gen1Recomp’s supported `src.audio.ChipAsm` API. Its square-wave program rises from approximately 728 Hz to 904 Hz with a fast decay across seven chip frames (about 117 ms). No WAV, generated audio file, copied game audio, or other external audio asset is included for this integration.

The README documents the optional integration and its original Lua-authored cue.
