# Install Guide

## Dependencies

| Dependency | Purpose | macOS | Linux/WSL2 | Windows |
|------------|---------|-------|-----------|---------|
| Node.js 18+ | Script runtime | `brew install node` | `sudo apt install nodejs npm` | [Download](https://nodejs.org) |
| FFmpeg | Video processing | `brew install ffmpeg` | `sudo apt install ffmpeg` | [Download](https://ffmpeg.org) |
| curl | API calls | Pre-installed | Pre-installed | Pre-installed |
| CJK fonts | Subtitle burn-in | PingFang SC (pre-installed) | `sudo apt install fonts-noto-cjk` | Manual install |

## Quick Install

### macOS

```bash
brew install node ffmpeg
```

### Ubuntu / Debian / WSL2

```bash
sudo apt update
sudo apt install -y nodejs npm ffmpeg fonts-noto-cjk
```

### CentOS / RHEL / Fedora

```bash
sudo yum install -y nodejs ffmpeg
# or
sudo dnf install -y nodejs ffmpeg
```

### Arch Linux

```bash
sudo pacman -S nodejs npm ffmpeg noto-fonts-cjk
```

## Configure ASR API Key

1. Get an ASR API key from your provider (e.g. ByteDance Volcano Engine)
2. Configure auto-editor:

```bash
cp ~/.agents/skills/auto-editor/config/.env.example ~/.agents/skills/auto-editor/config/.env
# Edit .env and fill in ASR_API_KEY
```

## Verify Installation

```bash
bash ~/.agents/skills/auto-editor/scripts/install.sh
```

Should show all dependencies installed and API key configured.
