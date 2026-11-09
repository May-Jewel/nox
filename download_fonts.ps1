#!/usr/bin/env pwsh
# PowerShell script to download Unicode fonts for PDF export
# Run this script from the project root directory

$fontDir = "src/main/resources/fonts"
if (-not (Test-Path $fontDir)) {
    New-Item -ItemType Directory -Path $fontDir -Force | Out-Null
}

$fonts = @(
    @{
        Url = "https://github.com/googlefonts/noto-fonts/raw/main/hinted/ttf/NotoSansMyanmar/NotoSansMyanmar-Regular.ttf"
        Name = "NotoSansMyanmar-Regular.ttf"
        Desc = "Noto Sans Myanmar - Supports Burmese/Myanmar script"
    },
    @{
        Url = "https://github.com/googlefonts/noto-fonts/raw/main/hinted/ttf/NotoSans/NotoSans-Regular.ttf"
        Name = "NotoSans-Regular.ttf"
        Desc = "Noto Sans - General Unicode fallback font"
    },
    @{
        Url = "https://github.com/dejavu-fonts/dejavu-fonts/raw/master/ttf/DejaVuSans.ttf"
        Name = "DejaVuSans.ttf"
        Desc = "DejaVu Sans - Broad Unicode coverage (Latin, Cyrillic, Greek, etc.)"
    }
)

foreach ($font in $fonts) {
    $outputPath = Join-Path $fontDir $font.Name
    if (Test-Path $outputPath) {
        Write-Host "[$font.Name] Already exists, skipping..." -ForegroundColor Yellow
        continue
    }
    
    Write-Host "Downloading [$font.Name] - $($font.Desc)..." -ForegroundColor Cyan
    try {
        Invoke-WebRequest -Uri $font.Url -OutFile $outputPath -ErrorAction Stop
        Write-Host "  ✓ Saved to $outputPath" -ForegroundColor Green
    } catch {
        Write-Host "  ✗ Failed to download $($font.Name): $($_.Exception.Message)" -ForegroundColor Red
    }
}

Write-Host "`nFont download complete. Fonts are in: $fontDir" -ForegroundColor Green
Write-Host "The PDF export service will automatically use these fonts for Unicode text rendering." -ForegroundColor Cyan