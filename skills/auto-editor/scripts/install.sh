#!/bin/bash
#
# Auto-Editor Environment Check & Installer
# Supports: macOS, Linux (Ubuntu/Debian/CentOS/Arch), WSL2
#

set -euo pipefail

GREEN='\033[32m'
YELLOW='\033[33m'
RED='\033[31m'
BLUE='\033[34m'
NC='\033[0m'

log_info() { echo -e "${BLUE}[INFO]${NC}  $1"; }
log_ok()   { echo -e "${GREEN}[OK]${NC}   $1"; }
log_warn() { echo -e "${YELLOW}[WARN]${NC}  $1"; }
log_err()  { echo -e "${RED}[ERR]${NC}  $1"; }

detect_os() {
    case "$(uname -s)" in
        Darwin*) echo "macos" ;;
        Linux*)
            if grep -qi microsoft /proc/version 2>/dev/null; then
                echo "wsl2"
            else
                echo "linux"
            fi
            ;;
        CYGWIN*|MINGW*|MSYS*) echo "windows" ;;
        *) echo "unknown" ;;
    esac
}

check_command() {
    command -v "$1" >/dev/null 2>&1
}

echo "================================================"
echo "   Auto-Editor Environment Check"
echo "================================================"

OS=$(detect_os)
log_info "Detected OS: $OS"

# --- Check Node.js ---
if check_command node; then
    NODE_VER=$(node -v)
    log_ok "Node.js installed: $NODE_VER"
else
    log_warn "Node.js not found"
    case $OS in
        macos)
            log_info "Install: brew install node"
            ;;
        linux|wsl2)
            log_info "Install: sudo apt update && sudo apt install -y nodejs npm"
            ;;
    esac
fi

# --- Check FFmpeg ---
if check_command ffmpeg; then
    FF_VER=$(ffmpeg -version | head -1)
    log_ok "FFmpeg installed: ${FF_VER:0:50}"
else
    log_warn "FFmpeg not found"
    case $OS in
        macos)
            log_info "Install: brew install ffmpeg"
            ;;
        linux|wsl2)
            log_info "Install: sudo apt update && sudo apt install -y ffmpeg"
            ;;
    esac
fi

# --- Check curl ---
if check_command curl; then
    log_ok "curl installed"
else
    log_warn "curl not found"
fi

# --- Check ASR API Key ---
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
ENV_FILE="$(dirname "$SCRIPT_DIR")/config/.env"

if [ -f "$ENV_FILE" ]; then
    if grep -q "ASR_API_KEY=" "$ENV_FILE"; then
        API_KEY=$(grep "ASR_API_KEY=" "$ENV_FILE" | cut -d'=' -f2 | head -1)
        if [ -n "$API_KEY" ] && [ "$API_KEY" != "your_api_key_here" ]; then
            log_ok "ASR API Key configured"
        else
            log_warn "ASR API Key not filled in"
            log_info "Edit: $ENV_FILE"
        fi
    else
        log_warn "ASR API_KEY not configured"
        log_info "Edit: $ENV_FILE"
    fi
else
    log_warn "Config file not found: $ENV_FILE"
    log_info "Create: cp $(dirname "$SCRIPT_DIR")/config/.env.example $(dirname "$SCRIPT_DIR")/config/.env"
fi

# --- Check CJK fonts (for subtitle burn-in) ---
if check_command fc-list; then
    CN_FONT=$(fc-list :lang=zh -f "%{family}\n" 2>/dev/null | head -1)
    if [ -n "$CN_FONT" ]; then
        log_ok "CJK font installed: $CN_FONT"
    else
        log_warn "No CJK font detected (subtitle burn-in may fail)"
        case $OS in
            linux|wsl2)
                log_info "Install: sudo apt install -y fonts-noto-cjk"
                ;;
        esac
    fi
else
    log_warn "fontconfig not installed (cannot detect fonts)"
fi

echo ""
echo "================================================"

# Summary
MISSING=0
if ! check_command node; then MISSING=$((MISSING+1)); fi
if ! check_command ffmpeg; then MISSING=$((MISSING+1)); fi
if ! check_command curl; then MISSING=$((MISSING+1)); fi

if [ "$MISSING" -eq 0 ]; then
    echo -e "${GREEN}Environment check passed. Ready to use auto-editor!${NC}"
    echo ""
    log_info "Quick start:"
    echo "  /auto-editor cut video.mp4"
    echo "  /auto-editor subtitle video.mp4"
    echo "  /auto-editor export-hd video.mp4"
else
    echo -e "${YELLOW}$MISSING dependencies missing, install per instructions above${NC}"
fi
