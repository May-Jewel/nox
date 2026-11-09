#!/bin/bash
# Bash script to download Unicode fonts for PDF export
# Run this script from the project root directory

FONT_DIR="src/main/resources/fonts"
mkdir -p "$FONT_DIR"

download_font() {
    local url=$1
    local name=$2
    local desc=$3
    local output="$FONT_DIR/$name"
    
    if [ -f "$output" ]; then
        echo "[$name] Already exists, skipping..."
        return
    fi
    
    echo "Downloading [$name] - $desc..."
    if curl -fL "$url" -o "$output"; then
        echo "  ✓ Saved to $output"
    else
        echo "  ✗ Failed to download $name"
    fi
}

echo "Downloading Unicode fonts for PDF export..."
echo "Target directory: $FONT_DIR"
echo ""

download_font "https://github.com/googlefonts/noto-fonts/raw/main/hinted/ttf/NotoSansMyanmar/NotoSansMyanmar-Regular.ttf" \
    "NotoSansMyanmar-Regular.ttf" \
    "Noto Sans Myanmar - Supports Burmese/Myanmar script"

download_font "https://github.com/googlefonts/noto-fonts/raw/main/hinted/ttf/NotoSans/NotoSans-Regular.ttf" \
    "NotoSans-Regular.ttf" \
    "Noto Sans - General Unicode fallback font"

download_font "https://github.com/dejavu-fonts/dejavu-fonts/raw/master/ttf/DejaVuSans.ttf" \
    "DejaVuSans.ttf" \
    "DejaVu Sans - Broad Unicode coverage"

echo ""
echo "Font download complete. Fonts are in: $FONT_DIR"
echo "The PDF export service will automatically use these fonts for Unicode text rendering."