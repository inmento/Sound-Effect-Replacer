# Changelog

## 0.3.1 — Expanded runtime audio-format support

Sound Effect Replacer now accepts every audio extension decoded by the LÖVE 11.5 runtime bundled with [Gen1Recomp 0.2.3](https://github.com/bryanthaboi/gen1recomp/releases/tag/v0.2.3). In addition to `.mp3`, `.wav`, `.flac`, and Ogg Vorbis, this adds Ogg Vorbis aliases `.oga` and `.ogv` plus the runtime’s tracker/module formats: `.699`, `.abc`, `.amf`, `.ams`, `.dbm`, `.dmf`, `.dsm`, `.far`, `.it`, `.j2b`, `.mdl`, `.med`, `.mid`, `.mod`, `.mt2`, `.mtm`, `.okt`, `.pat`, `.psm`, `.s3m`, `.stm`, `.ult`, `.umx`, and `.xm`.

Ogg Opus remains unsupported by this runtime. The mod now applies its actionable Opus detection to `.ogg`, `.oga`, and `.ogv`, so an incompatible stream is logged and skipped instead of failing silently. The README and coverage map now list the full accepted extension set.

This remains a WIP/testing release. In addition to the existing routing tests, please try at least one newly accepted tracker/module file in a simple General Sound Effects folder and report the exact filename, game, and any **MOD ERRORS** text.
