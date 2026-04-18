---
name: auto-editor
description: Talking-head video auto-editor powered by FFmpeg and AI semantic analysis. Detects mistakes, repetitions, silence, and filler words, generates review UI, and exports with one-click cutting. Triggers: auto-editor, video cut, talking-head, subtitle, export hd
license: MIT
metadata:
  author: https://github.com/harmsworth
  version: "1.0.0"
  domain: video-editing
  triggers: auto-editor, video cut, talking-head, subtitle, export hd, speech editing
  role: specialist
  scope: implementation
  output-format: code
---

# Auto-Editor — AI-Powered Talking-Head Video Editor

An FFmpeg-based automated editing pipeline for talking-head videos, combining cloud ASR transcription with AI semantic analysis.

Addresses two major pain points of template-based editing tools:
1. **No semantic understanding**: They can only do pattern matching (silence, repeated words), missing natural corrections like "What I meant was..."
2. **Poor subtitle quality**: Technical terms (Claude Code, MCP, API) are frequently misrecognized

## Quick Start

```bash
# 1. Check/install environment (first time)
bash ~/.agents/skills/auto-editor/scripts/install.sh

# 2. Configure ASR API Key
cp ~/.agents/skills/auto-editor/config/.env.example ~/.agents/skills/auto-editor/config/.env
# Edit ~/.agents/skills/auto-editor/config/.env, add your ASR_API_KEY

# 3. Cut the video
/auto-editor cut video.mp4

# 4. Add subtitles (after cutting)
/auto-editor subtitle video.mp4

# 5. Export HD (optional)
/auto-editor export-hd video.mp4
```

## Core Workflows

### 1. Cut — Auto-detect mistakes and cut

```
Input video → Extract audio → Cloud ASR transcription → AI mistake analysis → Review page → Manual confirm → FFmpeg cut → Output _cut.mp4
```

Steps:
1. **Create output dir** — `output/YYYY-MM-DD_video-name/cut/`
2. **Extract audio** — `ffmpeg -i video.mp4 -vn audio.mp3`
3. **Cloud ASR** — Local file upload, no third-party hosting
4. **Generate word-level subtitle** — `subtitle_words.json`
5. **AI mistake analysis** — Silence / repeated sentences / intra-sentence repeats / filler words / self-corrections
6. **Generate review page** — `review.html`, open in browser to confirm
7. **Execute cut** — FFmpeg frame-accurate cutting

**Detection rules (by priority)**:

| Type | Detection | Deletion Range |
|------|-----------|----------------|
| Repeated sentence | Adjacent sentences share ≥5 leading chars | Delete the **shorter whole sentence** |
| Skip-one repeat | Compare sentences around fragment | Delete previous + fragment |
| Fragment | Half-spoken + silence | Delete **whole fragment** |
| Intra-sentence repeat | A + middle + A pattern | Delete the first part |
| Filler repeat | 那个那个、就是就是 | Delete the first occurrence |
| Self-correction | Partial repeat / negation correction | Delete the first part |
| Filler words | 嗯、啊、那个 | Mark but don't auto-delete |
| Silence | >0.3s blank | Auto-preselect |

**Core principles**: Sentence-segment first, then compare; delete whole sentences/segments (including gaps in between).

### 2. Subtitle — Generate and burn subtitles

```
Cut video → Cloud ASR (with custom dictionary) → Agent line-by-line proofreading → Manual review → FFmpeg subtitle burn → Output _sub.mp4
```

Subtitle style: 22pt golden bold, 2px black stroke, bottom-center.

**Proofreading principles (fix only, never add)**:
- Names must be checked (dictionary hints don't guarantee 100% accuracy)
- Merge fragments ("音画"+"同步"→"音画同步")
- No punctuation at sentence end, keep punctuation within sentence

### 3. Export-HD — 2-pass encoding with sharpening

```
Input video → Detect source params → Pass 1 complexity analysis → Pass 2 encode + sharpen → Output _hd.mp4
```

Default: 1.2x source bitrate, 2-pass, slight sharpening to compensate quantization noise.

## Rules

### MUST DO
- Subtitles must be based on **the cut video** (`*_cut.mp4`), never the original
- Proofreading can only fix recognition errors, never add words not in the video
- Content not in the script = already cut, must be deleted (never "fill in" from script)
- Analyze mistakes after sentence segmentation (sentences.txt)
- When marking mistakes, delete **whole segments** from startIdx to endIdx (including gaps)
- `readable.txt` line number ≠ idx, use the idx column value
- Use `review_server.js` instead of `python3 -m http.server` (needs HTTP Range support)

### MUST NOT DO
- Don't cherry-pick text idx while skipping gaps
- Don't "fill in" content from script into subtitles
- Don't decide keep/delete on your own (mark for manual review)
- Don't use script auto-matching for proofreading (text diff causes timestamp drift)

## References

| Topic | Document | Load When |
|-------|----------|-----------|
| Install Guide | `references/install-guide.md` | First use, environment errors |
| Cut Workflow | `references/cut-workflow.md` | When cutting |
| Subtitle Workflow | `references/subtitle-workflow.md` | When adding subtitles |
| HD Export | `references/hd-export.md` | When exporting HD |
| Mistake Analysis Prompt | `prompts/analyze_mistakes.md` | When AI analyzes mistakes |
| User Habits | `references/user-habits.md` | When adjusting rules |

## Troubleshooting

### ASR transcription fails
- Check `config/.env` for `ASR_API_KEY`
- Check if audio file was generated (`audio.mp3`)
- Check network access to ASR endpoint

### Review page won't open
- Port conflict: scripts auto-detect available ports
- Check video file path (symlinks supported)
- Must use `review_server.js`, cannot substitute with python simple server

### Audio/video out of sync after cutting
- Script uses `filter_complex + trim` instead of `concat demuxer`
- Check if source has variable frame rate (VFR), convert to CFR first if needed

### Subtitle font not found
- Linux/WSL2: `sudo apt install fonts-noto-cjk`
- macOS: Uses PingFang SC (pre-installed)
- Scripts auto-detect available fonts
