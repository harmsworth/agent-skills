# Cut Workflow

## Full Steps

### Step 0: Create output directory

```bash
VIDEO_PATH="/path/to/video.mp4"
VIDEO_NAME=$(basename "$VIDEO_PATH" .mp4)
DATE=$(date +%Y-%m-%d)
BASE_DIR="output/${DATE}_${VIDEO_NAME}/cut"
mkdir -p "$BASE_DIR/1_transcribe" "$BASE_DIR/2_analyze" "$BASE_DIR/3_review"
cd "$BASE_DIR"
```

### Step 1: Extract audio

```bash
cd 1_transcribe
ffmpeg -i "file:$VIDEO_PATH" -vn -acodec libmp3lame -y audio.mp3
```

### Step 2: Cloud ASR transcription (local file upload)

```bash
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
bash "$SCRIPT_DIR/scripts/transcribe.sh" audio.mp3
# Output: asr_result.json
```

### Step 3: Generate word-level subtitles

```bash
node "$SCRIPT_DIR/scripts/generate_subtitles.js" asr_result.json
# Output: subtitle_words.json
```

### Step 4: AI mistake analysis

1. Generate readable format `readable.txt`
2. Segment by silence into `sentences.txt`
3. Auto-mark silence → `auto_selected.json`
4. **AI segment-by-segment analysis** (loop, 300 lines per batch) append mistake idx
5. Log to `mistake_analysis.md`

**Critical: line number ≠ idx**

```
readable.txt format: idx|content|time
                     ↑ use this value

Line 1500 → "1568|[silence 1.02s]|..."  ← idx is 1568, not 1500!
```

### Step 5: Generate review page

```bash
cd ../3_review
node "$SCRIPT_DIR/scripts/generate_review.js" ../1_transcribe/subtitle_words.json ../2_analyze/auto_selected.json "$VIDEO_PATH"
# Output: review.html, video.mp4 (symlink)
```

### Step 6: Start review server

```bash
node "$SCRIPT_DIR/scripts/review_server.js" 8899 "$VIDEO_PATH"
# Open http://localhost:8899
# Auto-detects next available port if occupied
```

User actions in browser:
- Play video to verify
- Check/uncheck deletion items
- Click "Execute Cut"

### Step 7: Execute cut

After clicking "Execute Cut" in browser, server auto-calls:

```bash
bash "$SCRIPT_DIR/scripts/cut_video.sh" "$VIDEO_PATH" "delete_segments.json"
# Output: *_cut.mp4
```

## Data Formats

### subtitle_words.json

```json
[
  {"text": "大", "start": 0.12, "end": 0.2, "isGap": false},
  {"text": "", "start": 6.78, "end": 7.48, "isGap": true}
]
```

### auto_selected.json

```json
[72, 85, 120]
```

## Cut Encoding Rules

- Match source parameters for re-encoding
- Use `filter_complex + trim` for frame-accurate cutting
- `-profile:v high -b:v {source_bitrate} -pix_fmt yuv420p`
