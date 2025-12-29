#!/bin/bash
set -e

echo "🚀 Installing Claude Context Statusline..."
echo ""

# Check for required dependencies
echo "📋 Checking dependencies..."
if ! command -v python3 &> /dev/null; then
    echo "❌ Error: python3 is required but not installed."
    echo "   Please install Python 3 and try again."
    exit 1
fi

if ! command -v bash &> /dev/null; then
    echo "❌ Error: bash is required but not installed."
    exit 1
fi

echo "✅ All dependencies found"
echo ""

# Determine Claude Code config directory
CLAUDE_DIR="$HOME/.claude"
if [ ! -d "$CLAUDE_DIR" ]; then
    echo "❌ Error: Claude Code directory not found at $CLAUDE_DIR"
    echo "   Please ensure Claude Code is installed."
    exit 1
fi

# Download statusline script
echo "📥 Downloading statusline script..."
STATUSLINE_PATH="$CLAUDE_DIR/statusline.sh"
SCRIPT_URL="https://raw.githubusercontent.com/ibuckman-docflow/claude-context-statusline/main/statusline.sh"

if command -v curl &> /dev/null; then
    curl -fsSL "$SCRIPT_URL" -o "$STATUSLINE_PATH"
elif command -v wget &> /dev/null; then
    wget -q "$SCRIPT_URL" -O "$STATUSLINE_PATH"
else
    echo "❌ Error: Neither curl nor wget found. Please install one of them."
    exit 1
fi

chmod +x "$STATUSLINE_PATH"
echo "✅ Statusline script installed to $STATUSLINE_PATH"
echo ""

# Update settings.json
SETTINGS_FILE="$CLAUDE_DIR/settings.json"
echo "⚙️  Updating Claude Code settings..."

# Create backup
if [ -f "$SETTINGS_FILE" ]; then
    cp "$SETTINGS_FILE" "$SETTINGS_FILE.backup.$(date +%Y%m%d_%H%M%S)"
    echo "✅ Backup created: $SETTINGS_FILE.backup.$(date +%Y%m%d_%H%M%S)"
else
    echo "{}" > "$SETTINGS_FILE"
    echo "✅ Created new settings file"
fi

# Check if statusline is already configured
if grep -q '"statusline"' "$SETTINGS_FILE"; then
    echo "⚠️  Statusline already configured in settings.json"
    echo "   Skipping settings update to preserve your existing configuration."
else
    # Add statusline configuration using python to handle JSON properly
    python3 << 'EOF'
import json
import os

settings_file = os.path.expanduser("~/.claude/settings.json")
with open(settings_file, 'r') as f:
    settings = json.load(f)

statusline_path = os.path.expanduser("~/.claude/statusline.sh")
settings["statusline"] = statusline_path

with open(settings_file, 'w') as f:
    json.dump(settings, f, indent=2)
EOF
    echo "✅ Settings updated successfully"
fi

echo ""
echo "🎉 Installation complete!"
echo ""
echo "The context statusline will now appear in your Claude Code CLI."
echo "It shows:"
echo "  • Green: >50% context remaining"
echo "  • Yellow: 11-50% context remaining"
echo "  • Red: ≤10% context remaining"
echo ""
echo "Start a new Claude Code session to see it in action!"
echo ""
echo "To uninstall, remove the statusline script and entry from settings.json:"
echo "  rm $STATUSLINE_PATH"
echo "  # Then manually remove the 'statusline' entry from $SETTINGS_FILE"
