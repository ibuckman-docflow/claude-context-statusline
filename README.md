# Claude Context Statusline

A color-coded statusline for Claude Code that shows your remaining context window in real-time.

## Features

- **Real-time context tracking**: Shows the percentage of your 200K token budget remaining
- **Color-coded indicators**:
  - 🟢 Green: >50% context remaining
  - 🟡 Yellow: 11-50% context remaining
  - 🔴 Red: ≤10% context remaining
- **Accurate from start**: Shows "Context: --% (pending)" until first response, then displays actual usage
- **Cached for performance**: Uses smart caching to minimize performance impact
- **No stale data**: Fixed issue where previous conversation's context would show at startup

## Display Examples

```
Context: --% (pending)        # At conversation start (waiting for first response)
Context: 88% free             # After first response (green)
Context: 35% free             # Mid-conversation (yellow)
Context: 8% free              # Nearly full (red)
```

## Installation

### One-Command Install (Recommended)

```bash
curl -fsSL https://raw.githubusercontent.com/ibuckman-docflow/claude-context-statusline/main/install.sh | bash
```

This will:
1. Check for required dependencies
2. Download the statusline script to `~/.claude/statusline.sh`
3. Backup and update your `~/.claude/settings.json`
4. Set proper permissions

### Manual Installation

1. Download the script:
```bash
curl -fsSL https://raw.githubusercontent.com/ibuckman-docflow/claude-context-statusline/main/statusline.sh -o ~/.claude/statusline.sh
chmod +x ~/.claude/statusline.sh
```

2. Update your `~/.claude/settings.json` to include:
```json
{
  "statusline": "/Users/YOUR_USERNAME/.claude/statusline.sh"
}
```

## Requirements

- **Python 3**: For JSON parsing and calculations
- **Bash**: For running the script
- **Claude Code**: This is a Claude Code statusline customization

## How It Works

The script reads the Claude Code transcript file to extract token usage information:
- Parses the last line of the transcript for usage data
- Calculates percentage of 200K token budget remaining
- Applies color coding based on thresholds
- Caches results for quick display

## Troubleshooting

### Statusline not appearing
- Ensure Claude Code is properly installed
- Check that `~/.claude/settings.json` has the correct statusline path
- Verify the script is executable: `ls -la ~/.claude/statusline.sh`
- Start a new Claude Code session

### Shows "--% (pending)" even after response
- Check that Python 3 is installed: `python3 --version`
- Verify the transcript file exists and is being updated

### Percentage seems incorrect
- The first message will show "--% (pending)" until Claude responds
- After the first response, it will show accurate usage including system prompts and CLAUDE.md

## Uninstall

```bash
rm ~/.claude/statusline.sh
```

Then remove the `"statusline"` entry from `~/.claude/settings.json`.

## Contributing

Contributions are welcome! Feel free to:
- Report bugs via GitHub Issues
- Submit pull requests for improvements
- Share feature requests

## License

MIT License - See [LICENSE](LICENSE) file for details

## Credits

Created by [Ilan Buckman](https://github.com/ibuckman-docflow)

Inspired by the Claude Code community's need for better context awareness during long coding sessions.

## Related Projects

- [ccstatusline](https://github.com/hesreallyhim/ccstatusline) - Feature-rich TUI statusline with themes
- [awesome-claude-code](https://github.com/hesreallyhim/awesome-claude-code) - Curated list of Claude Code resources
