#!/bin/bash
#
# Cloud ASR Transcription Service — Local file upload
#
# Usage: ./transcribe.sh <audio_file>
# Output: asr_result.json
#
# Supports Chinese (zh-CN) with custom hot-word dictionary.
# Requires ASR_API_KEY in config/.env
#

AUDIO_FILE="$1"

if [ -z "$AUDIO_FILE" ]; then
  echo "❌ Usage: ./transcribe.sh <audio_file>"
  exit 1
fi

if [ ! -f "$AUDIO_FILE" ]; then
  echo "❌ Audio file not found: $AUDIO_FILE"
  exit 1
fi

# Resolve skill root directory
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
SKILL_DIR="$(dirname "$SCRIPT_DIR")"
ENV_FILE="$SKILL_DIR/config/.env"

if [ ! -f "$ENV_FILE" ]; then
  echo "❌ Config file not found: $ENV_FILE"
  echo "Create one: cp $SKILL_DIR/config/.env.example $ENV_FILE"
  exit 1
fi

API_KEY=$(grep "^ASR_API_KEY=" "$ENV_FILE" | cut -d'=' -f2 | head -1)

if [ -z "$API_KEY" ] || [ "$API_KEY" = "your_api_key_here" ]; then
  echo "❌ ASR_API_KEY not configured"
  echo "Edit: $ENV_FILE"
  exit 1
fi

# Load custom dictionary
DICT_FILE="$SKILL_DIR/config/dictionary.txt"
HOT_WORDS=""
if [ -f "$DICT_FILE" ]; then
  HOT_WORDS=$(cat "$DICT_FILE" | grep -v '^$' | grep -v '^#' | while read word; do echo "\"$word\""; done | tr '\n' ',' | sed 's/,$//')
  DICT_COUNT=$(cat "$DICT_FILE" | grep -v '^$' | grep -v '^#' | wc -l | tr -d ' ')
  echo "📖 Loaded $DICT_COUNT hot-words"
fi

# Build request
REQUEST_PARAMS="language=zh-CN&use_itn=True&use_capitalize=True&max_lines=1&words_per_line=15"

ASR_SUBMIT_URL="${ASR_SUBMIT_URL:-https://openspeech.bytedance.com/api/v1/vc/submit}"
ASR_QUERY_URL="${ASR_QUERY_URL:-https://openspeech.bytedance.com/api/v1/vc/query}"

echo "🎤 Submitting transcription task..."
echo "Audio: $(basename "$AUDIO_FILE") ($(( $(stat -f%z "$AUDIO_FILE" 2>/dev/null || stat -c%s "$AUDIO_FILE") / 1024 / 1024 ))MB)"

# Step 1: Submit job
if [ -n "$HOT_WORDS" ]; then
  SUBMIT_RESPONSE=$(curl -s -L -X POST "$ASR_SUBMIT_URL?$REQUEST_PARAMS" \
    -H "Accept: */*" \
    -H "x-api-key: $API_KEY" \
    -H "Connection: keep-alive" \
    -F "file=@$AUDIO_FILE" \
    -F "hot_words=[$HOT_WORDS]")
else
  SUBMIT_RESPONSE=$(curl -s -L -X POST "$ASR_SUBMIT_URL?$REQUEST_PARAMS" \
    -H "Accept: */*" \
    -H "x-api-key: $API_KEY" \
    -H "Connection: keep-alive" \
    -F "file=@$AUDIO_FILE")
fi

# Extract job ID
JOB_ID=$(echo "$SUBMIT_RESPONSE" | grep -o '"id":"[^"]*"' | head -1 | cut -d'"' -f4)

if [ -z "$JOB_ID" ]; then
  echo "❌ Submission failed:"
  echo "$SUBMIT_RESPONSE"
  exit 1
fi

echo "✅ Job submitted, ID: $JOB_ID"
echo "⏳ Waiting for transcription..."

# Step 2: Poll for result
MAX_ATTEMPTS=120
ATTEMPT=0

while [ $ATTEMPT -lt $MAX_ATTEMPTS ]; do
  sleep 5
  ATTEMPT=$((ATTEMPT + 1))

  QUERY_RESPONSE=$(curl -s -L -X GET "$ASR_QUERY_URL?id=$JOB_ID" \
    -H "Accept: */*" \
    -H "x-api-key: $API_KEY" \
    -H "Connection: keep-alive")

  STATUS=$(echo "$QUERY_RESPONSE" | grep -o '"code":[0-9]*' | head -1 | cut -d':' -f2)

  if [ "$STATUS" = "0" ]; then
    echo "$QUERY_RESPONSE" > asr_result.json
    echo ""
    echo "✅ Transcription complete, saved asr_result.json"
    UTTERANCES=$(echo "$QUERY_RESPONSE" | grep -o '"text"' | wc -l | tr -d ' ')
    echo "📝 Detected $UTTERANCES utterances"
    exit 0
  elif [ "$STATUS" = "1000" ]; then
    echo -n "."
  else
    echo ""
    echo "❌ Transcription failed:"
    echo "$QUERY_RESPONSE"
    exit 1
  fi
done

echo ""
echo "❌ Timeout, job not completed"
exit 1
