# Subtitle Workflow

## Core Pipeline

```
Cut video → Cloud ASR (with custom dictionary) → Agent line-by-line proofreading → Manual review → FFmpeg subtitle burn → Output _sub.mp4
```

## Step 0: Locate video

**Priority** (high to low):
1. User-provided video path
2. Current output dir `cut/3_review/*_cut.mp4`
3. Original video

```bash
OUTPUT_DIR="output/YYYY-MM-DD_video-name"
CUT_VIDEO=$(find "$OUTPUT_DIR/cut/3_review" -name "*_cut.mp4" -type f 2>/dev/null | head -1)

if [ -n "$CUT_VIDEO" ]; then
  VIDEO_PATH="$CUT_VIDEO"
else
  VIDEO_PATH="$ARGUMENTS"
fi
```

**Critical**: Subtitles must be based on **the cut video**, original timestamps don't match.

## Step 1-2: Extract audio + transcribe

Same as cut workflow. Transcribe script auto-loads `config/dictionary.txt` as hot-words.

## Step 3: Agent proofreading

**Core principle: fix only, never add**

### Common misrecognition rules

| Misrecognized | Correct | Type |
|---------------|---------|------|
| 成风 | 成峰 | Homophone |
| 正特/整特 | Agent | Misrecognition |
| IT就 | Agent就 | Similar pronunciation |
| cloud code | Claude Code | Similar pronunciation |
| Schill/skill | skills | Similar pronunciation |
| 剪口拨/剪口波 | 剪口播 | Homophone |
| 自净化/资金化 | 自进化 | Homophone |
| 减口播 | 剪口播 | Homophone |
| 录剪 | 漏剪 | Homophone |

### Common missing-word issues

| Original | Fix | Note |
|----------|-----|------|
| 步呢是配置 | 第二步呢是配置 | Missing "第二" |
| 4步就是 | 第4步就是 | Missing "第" |
| 别省时间 | 特别省时间 | Missing "特" |

### Script proofreading rules

- **Not in script = must delete**
- **Never "fill in" from script into subtitles**
- **Proofreading direction is one-way**
- **Product names follow script**

## Step 4: Start subtitle review server

```bash
node "$SCRIPT_DIR/scripts/subtitle_server.js" 8898 "$VIDEO_PATH"
# Auto-detects port if occupied
# Visit http://localhost:8898
```

Features:
- Video player on left, subtitle list on right
- Auto-highlight current subtitle during playback
- Double-click subtitle text to edit (timestamp unchanged)
- Playback speed (1x/1.5x/2x/3x)
- Save subtitles / Export SRT / Burn subtitles

## Step 5: Burn subtitles

Script auto-detects available fonts. Default style:
- 22pt golden bold, 2px black stroke, bottom-center

```bash
ffmpeg -i "video.mp4" \
  -vf "subtitles='video.srt':force_style='FontSize=22,FontName={font},Bold=1,PrimaryColour=&H0000deff,OutlineColour=&H00000000,Outline=2,Alignment=2,MarginV=30'" \
  -c:a copy -y "video_sub.mp4"
```

## Subtitle Style Rules

| Rule | Description |
|------|-------------|
| One line per screen | No wrapping, no stacking |
| No end punctuation | `你好` not `你好。` |
| Keep mid-sentence punctuation | `先点这里，再点那里` |
