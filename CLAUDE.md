# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Python-based Telegram chat processor that converts exported Telegram chat data (JSON) into optimized PDF files suitable for AI processing and vector databases. The tool is specifically designed for n8n workflow integration.

## Core Architecture

**Single-file design**: The entire processing logic is contained in `process_telegram_chats.py` (~650 lines), making it a monolithic but focused tool.

**Key components**:
- **Configuration system**: Environment-based config using `Config` class with `.env` file support
- **Message processing pipeline**: JSON parsing → text extraction → chunking → PDF generation
- **Font handling**: Cross-platform font detection for Cyrillic text support
- **Memory optimization**: Streaming processing for large chat exports
- **Dynamic chunking**: Adaptive chunk sizing based on message length patterns

**Core functions**:
- `process_telegram_chats_optimized()` - Main entry point and orchestration
- `create_optimized_pdf_parts()` - Handles chunking and PDF splitting logic
- `create_single_pdf_file()` - PDF generation using ReportLab
- `extract_person_info()` - User identification and message direction detection
- `setup_fonts()` - Cross-platform font detection and registration

## Common Development Commands

**Run the processor**:
```bash
python process_telegram_chats.py
```

**Install dependencies**:
```bash
pip install -r requirements.txt
```

**Platform-specific launchers**:
- Windows: `launch_windows.bat` (production launcher with dependency checking)
- Linux: `launch_linux.sh` (production launcher)
- Windows installer: `install_and_run_windows.bat` (includes Python installation)
- Ubuntu installer: `install_and_run_ubuntu.sh` (includes system dependencies)

**Configuration setup**:
```bash
# Copy example configuration
cp .env.example .env
# Edit configuration (Windows)
notepad .env
# Edit configuration (Linux/macOS)
nano .env
```

## Configuration System

The application uses a `Config` class that loads settings from environment variables with sensible defaults. Key configuration areas:

**File paths**: `INPUT_FILE`, `OUTPUT_DIR`, `METADATA_DIR`, `METADATA_FILE`
**PDF settings**: `MAX_FILE_SIZE_KB`, `PDF_FONT_SIZE`, `PDF_LINE_SPACING`, margins
**Processing**: Message length thresholds, chunk sizes, user identification
**Chunking algorithm**: `CHUNK_SIZE_SHORT/MEDIUM/LONG`, size estimation parameters
**Font paths**: Platform-specific font paths for Cyrillic support
**Debug options**: `VERBOSE_LOGGING`, `SHOW_FONT_INFO`, `SHOW_PROGRESS`

Configuration can be overridden via `.env` file - the launchers handle this automatically. Use `.env.example` as a template with comprehensive documentation of all settings.

## Key Processing Logic

**Message chunking algorithm**: The tool uses dynamic chunk sizing based on average message length:
- Short messages (< 50 chars): 25 messages per chunk
- Medium messages (50-150 chars): 18 messages per chunk
- Long messages (> 150 chars): 12 messages per chunk

**PDF optimization**: Files are kept under 200KB by default for optimal n8n processing, with automatic splitting into multiple parts for large chats.

**Text processing**: Extensive emoji conversion to text descriptions, Cyrillic font support, and text normalization for better AI processing.

## Input/Output Structure

**Input**: `result.json` - Telegram Desktop export in machine-readable JSON format
**Output**:
- `chats_clean_pdf/` - Generated PDF files
- `metadata/metadata_summary.json` - Processing metadata for n8n workflows

## Development Notes

- **No testing framework**: This is a utility script without formal tests
- **Dependencies**: Only requires `reportlab>=3.6.0` and `python-dotenv>=0.19.0`
- **Cross-platform**: Handles Windows, macOS, and Linux font paths
- **Error handling**: Comprehensive error handling with user-friendly messages
- **Memory efficient**: Processes large exports without loading everything into memory
- **Unicode support**: Windows console UTF-8 encoding and safe print functions
- **n8n optimized**: Output format specifically designed for n8n text splitter workflows

## Launcher Architecture

**Production launchers**: `launch_windows.bat` and `launch_linux.sh`
- Automatic dependency checking and installation
- Configuration file creation from `.env.example`
- Input validation (`result.json` existence)
- User-friendly error messages with colored output

**Installer scripts**: `install_and_run_windows.bat` and `install_and_run_ubuntu.sh`
- Full Python installation (Windows downloads Python 3.11)
- System dependency installation
- Automatic script execution after setup

## Telegram Export Requirements

Users must export data from Telegram Desktop:
1. Settings → Advanced → Export Telegram data
2. Select "Personal chats" and "Machine-readable JSON"
3. Save as `result.json` in project directory

## Font System

The application includes comprehensive Cyrillic text support with fallback font detection across platforms. Font paths are configurable via environment variables.

**Font detection logic** (in `setup_fonts()` function):
1. Attempts to load platform-specific fonts from configured paths
2. Registers fonts with ReportLab's font system
3. Falls back to default Helvetica if no custom fonts available
4. Supports Windows (arial.ttf, calibri.ttf), macOS (Arial.ttf), and Linux (DejaVuSans.ttf)

## Processing Algorithm Details

**Memory optimization strategy**:
- Messages are processed in chunks rather than loading entire chat history
- PDF files are created incrementally with size monitoring
- Large chats are automatically split into multiple PDF parts

**User identification logic** (in `extract_person_info()` function):
- Attempts to identify user by comparing `USER_NAME` and `USER_ID` configuration
- Fallback logic for message direction detection
- Handles cases where user information is not found in chat data

**Chunking algorithm** (in `create_optimized_pdf_parts()` function):
1. Calculates average message length for the chat
2. Determines appropriate chunk size based on thresholds
3. Groups messages into chunks with size estimation
4. Splits into multiple PDF files when size limits are exceeded