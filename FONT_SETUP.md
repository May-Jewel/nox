# Unicode Font Setup for PDF Export

## Overview
The PDF export feature uses iText 7 with embedded TrueType fonts to properly render Unicode text (Burmese, Thai, Japanese, Chinese, Korean, Arabic, etc.) in exported PDFs.

## Required Font Files
Place the following `.ttf` font files in `src/main/resources/fonts/`:

| Font File | Purpose | Download URL |
|-----------|---------|--------------|
| `NotoSansMyanmar-Regular.ttf` | **Primary** - Burmese/Myanmar script support | [Download](https://github.com/googlefonts/noto-fonts/raw/main/hinted/ttf/NotoSansMyanmar/NotoSansMyanmar-Regular.ttf) |
| `NotoSans-Regular.ttf` | Fallback - General Unicode (Latin, Greek, Cyrillic, etc.) | [Download](https://github.com/googlefonts/noto-fonts/raw/main/hinted/ttf/NotoSans/NotoSans-Regular.ttf) |
| `DejaVuSans.ttf` | Fallback - Broad Unicode coverage | [Download](https://github.com/dejavu-fonts/dejavu-fonts/raw/master/ttf/DejaVuSans.ttf) |

## Quick Setup

### Windows (PowerShell)
```powershell
.\download_fonts.ps1
```

### Linux/macOS (Bash)
```bash
chmod +x download_fonts.sh
./download_fonts.sh
```

### Manual Download
1. Create directory: `src/main/resources/fonts/`
2. Download each font from the URLs above
3. Place `.ttf` files in the fonts directory
4. Rebuild the project: `mvn clean package`

## Font Loading Priority
The `PdfExportService` loads fonts in this order:
1. **Noto Sans Myanmar** - Best for Burmese translations
2. **Noto Sans** - General Unicode fallback
3. **DejaVu Sans** - Broad coverage fallback
4. **Helvetica** - Last resort (limited Unicode support)

If a font fails to load, it logs a warning and tries the next one. The export will not crash.

## API Endpoints

| Endpoint | Method | Description |
|----------|--------|-------------|
| `/api/history/pdf/activity/{id}` | GET | Export single activity as PDF |
| `/api/history/pdf/bulk` | POST | Export selected activities (JSON array of IDs) |
| `/api/history/pdf/all` | GET | Export all/filtered history as PDF |

### Query Parameters for `/all`
- `filter` - Feature type filter (transcribe, translate, summary, todo, tts, qna)
- `search` - Search query string

### Request Body for `/bulk`
```json
["123", "456", "789"]
```

## Response
All endpoints return `application/pdf` with `Content-Disposition: attachment` header for direct browser download.

## Architecture
- **Backend**: Java Spring Boot + iText 7
- **Font Embedding**: Uses `IDENTITY_H` (UTF-8) encoding with full font embedding
- **Text Handling**: Explicit UTF-8 preservation from database to PDF
- **Line Breaking**: iText's built-in complex script support for proper word wrapping

## Troubleshooting

### Garbled Characters in PDF
1. Verify font files exist in `src/main/resources/fonts/`
2. Check application logs for font loading messages
3. Ensure Maven includes resources: `mvn clean compile`

### Font Not Found Warnings
```
WARN  PdfExportService - Font not found at classpath: fonts/NotoSansMyanmar-Regular.ttf
```
→ Download the missing font file and rebuild.

### OutOfMemoryError on Large Exports
For very large exports, consider implementing streaming/chunked PDF generation (future enhancement).

## Dependencies Added
```xml
<dependency>
    <groupId>com.itextpdf</groupId>
    <artifactId>itext7-core</artifactId>
    <version>7.2.5</version>
    <type>pom</type>
</dependency>
<dependency>
    <groupId>com.itextpdf</groupId>
    <artifactId>font-asian</artifactId>
    <version>7.2.5</version>
</dependency>
```