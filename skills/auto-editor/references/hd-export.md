# HD Export Workflow

## When to use

The `cut_video.sh` script already performs frame-accurate cutting + bitrate-matched re-encoding.
HD export is an **optional enhancement** using 2-pass + higher bitrate + sharpening to exceed source quality.

## Parameters

| Parameter | Default | Description |
|-----------|---------|-------------|
| Bitrate multiplier | 1.2x | Relative to source bitrate |
| preset | slow | Encoding speed (slower = better quality) |
| Sharpening | On | `unsharp=5:5:0.3` slight sharpening |
| Encoding | 2-pass | Two-pass encoding |

## Usage

```bash
# Auto-detect params, 1.2x bitrate, 2-pass
bash scripts/hd_export.sh input.mp4

# Custom output
bash scripts/hd_export.sh input.mp4 output_hd.mp4

# Custom bitrate multiplier (1.5 = 1.5x source bitrate)
bash scripts/hd_export.sh input.mp4 output_hd.mp4 1.5
```

## Why 2-pass beats 1-pass?

- **1-pass**: Allocates bitrate by fixed rules; simple scenes may get too much, complex scenes too little
- **2-pass**: First pass analyzes full-scene complexity, second pass allocates bitrate precisely based on analysis
- At same bitrate, 2-pass looks better; at same quality, 2-pass files are smaller

## Why add sharpening?

- Any re-encode introduces slight blur (quantization noise)
- Slight sharpening (`unsharp=5:5:0.3`) compensates for this loss
- Parameters are conservative, no sharpening artifacts

## Match source parameters

Auto-detect and match:
- `-profile:v` → source profile (usually high)
- `-pix_fmt` → source pixel format (usually yuv420p)
- `-b:v` → source bitrate × multiplier