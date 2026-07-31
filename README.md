# Telegram Chat PDF Processor

> **DEPRECATED.** This repository is archived and no longer maintained.
> It is kept read-only for reference; its GDS anchor records
> `lifecycle: archived` under `portfolio:archived-projects`.

Convert your Telegram chat exports to optimized PDF files ready for AI processing and vector databases.

## 🚀 Quick Start (Windows)

1. **Clone the repository:**
   ```bash
   git clone git@github.com:rldyourmnd/telegram_to_pdfVectorDB.git
   cd telegram_to_pdfVectorDB
   ```

2. **Export your Telegram chats:**
   - Open Telegram Desktop
   - Go to Settings → Advanced → Export Telegram data
   - Select "Personal chats" and "Machine-readable JSON"
   - Save the export as `result.json` in the project folder

3. **Run the processor:**
   - **Windows**: Double-click `launch_windows.bat`
   - **Linux**: Run `./launch_linux.sh`
   - **First-time setup**: Use `install_and_run_windows.bat` (installs Python automatically)
   - The script will automatically install dependencies and process your chats

## 📁 Output Structure

```
project/
├── chats_clean_pdf/          # Generated PDF files
├── metadata/                 # Processing metadata
│   └── metadata_summary.json
├── result.json              # Your Telegram export
└── launch_windows.bat       # Easy launcher
```

## ⚙️ Configuration

The tool works out-of-the-box, but you can customize settings by creating a `.env` file:

```bash
# Copy the example configuration
cp .env.example .env

# Edit with your settings
notepad .env  # Windows
nano .env     # Linux/macOS
```

**Key settings to configure:**

```env
# IMPORTANT: Replace with your actual Telegram data
USER_NAME=Your Actual Telegram Name
USER_ID=user123456789

# PDF optimization (default values work well)
MAX_FILE_SIZE_KB=200
PDF_FONT_SIZE=10
PDF_LINE_SPACING=12

# Chunking algorithm (recommended defaults)
CHUNK_SIZE_SHORT=25
CHUNK_SIZE_MEDIUM=18
CHUNK_SIZE_LONG=12

# Processing options
MIN_MESSAGE_LENGTH=2
SHORT_MESSAGE_THRESHOLD=50
LONG_MESSAGE_THRESHOLD=150

# Debug options
VERBOSE_LOGGING=true
SHOW_PROGRESS=true
```

### 🔍 Finding Your User Information

To correctly identify your messages vs received messages:

1. **Open `result.json`** in any text editor
2. **Search for a message you wrote** (recognize by your writing style)
3. **Find these fields** in your message:
   ```json
   "from": "Your Actual Name",
   "from_id": "user123456789"
   ```
4. **Copy exact values** to your `.env` file
5. **Test**: If messages still show as "From [Name]:" instead of "Me:", check your settings

## 🔧 Manual Installation

If you prefer manual setup:

```bash
# Install Python dependencies
pip install -r requirements.txt

# Run the processor
python process_telegram_chats.py
```

## 📊 Features

- **Optimized for AI**: PDFs sized for vector databases (max 200KB by default)
- **Smart chunking**: Dynamic chunk sizing based on message length
- **Memory efficient**: Processes large chats in parts
- **Clean formatting**: Optimized text format for AI processing
- **Metadata tracking**: Complete processing information
- **Cross-platform**: Works on Windows, macOS, and Linux

## 🤖 n8n Integration

Perfect for n8n workflows:

1. **Text Splitter settings**: 
   - Chunk size: 800
   - Overlap: 200

2. **Batch processing**: 5-8 files at a time for optimal memory usage

3. **Search patterns**: 
   - `Me:` for your messages
   - `From [NAME]:` for contact messages

4. **Embedding models**:
   - OpenAI: `text-embedding-ada-002` (1536 dimensions)
   - Local: Any 768-dimension model

## 📋 Processing Statistics

The processor provides detailed statistics:
- Total chats processed
- Messages per chat
- PDF files created
- Chunk distribution
- Large chats split into multiple parts

## 🛠️ Requirements

- Python 3.7+
- Windows/macOS/Linux
- Telegram Desktop (for export)

## 🚨 Troubleshooting

### Problem: Messages show as "From [Your Name]:" instead of "Me:"

**Solution**: Configure your user identification in `.env` file:

1. Copy `.env.example` to `.env`
2. Open `result.json` and find a message you sent
3. Look for `"from": "Your Name"` and `"from_id": "user123456789"`
4. Update `.env` with these exact values:
   ```env
   USER_NAME=Your Exact Telegram Name
   USER_ID=user123456789
   ```

### Problem: "Python not found" error

**Solutions**:
- **Windows**: Use `install_and_run_windows.bat` (auto-installs Python)
- **Manual**: Download Python from [python.org](https://python.org) and check "Add to PATH"
- **Linux**: `sudo apt install python3 python3-pip`

### Problem: "No such file 'result.json'"

**Solution**: Export your Telegram data correctly:
1. Telegram Desktop → Settings → Advanced → Export Telegram data
2. Select **"Personal chats"** and **"Machine-readable JSON"**
3. Save as `result.json` in the project folder

### Problem: Large files / GitHub limits

The `.gitignore` protects against committing:
- `result.json` (your personal chat data)
- Generated PDFs (`chats_clean_pdf/`)
- Configuration files (`.env`)

### Problem: Processing fails or crashes

1. Check if `result.json` is valid JSON (not corrupted)
2. Try with `VERBOSE_LOGGING=true` in `.env`
3. Ensure enough disk space (chat exports can be large)
4. For very large exports, process in smaller batches

## 🔐 Privacy & Security

- **Your data stays local** - no data is sent anywhere
- **Git protection** - `.gitignore` prevents accidental data commits
- **Configuration files** - Never commit `.env` files with personal data
- **Generated PDFs** - Review before sharing (contain your chat history)

## 📝 License

MIT License - feel free to use and modify! 