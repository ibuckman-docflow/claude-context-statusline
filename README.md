# Claude Context Statusline

A color-coded statusline for Claude Code that shows your remaining context window in real-time.

## Features

- **Early warning before auto-compact**: The primary goal is to give you advance notice before Claude Code auto-compacts your conversation, so you can take action (start a new conversation, manually compact, etc.)
- **Measures "until auto-compact"**: Claude Code auto-compacts at ~10% context remaining. This statusline shows how much context you have left *before that threshold*, giving you actionable information
- **Color-coded warnings**:
  - 🟢 Green: >30% until auto-compact (plenty of room)
  - 🟡 Yellow: 1-30% until auto-compact (getting close, plan accordingly)
  - 🔴 Red: 0% (auto-compact imminent or in progress)
- **Accurate from start**: Shows "Context: --% (pending)" until first response, then displays actual usage
- **Cached for performance**: Uses smart caching to minimize performance impact

## Display Examples

```
Context: --% (pending)        # At conversation start (waiting for first response)
Context: 78% until compact    # Plenty of room (green)
Context: 25% until compact    # Getting close, consider wrapping up (yellow)
Context: 0% until compact     # Auto-compact is imminent or starting (red)
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
- Subtracts the ~10% auto-compact threshold to show "until compact"
- Applies color coding based on how close you are to auto-compact
- Caches results for quick display

**Why "until compact" instead of "free"?**

Claude Code doesn't wait until 0% to compact—it has a safety buffer and triggers auto-compact at ~10% remaining. Showing raw "free" percentage is misleading because you'll see "12% free" right as compaction starts, which is confusing. By showing "until compact", the number hits 0% exactly when you'd expect: when auto-compact begins.

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
- Remember: this shows "until auto-compact" not raw "free" - so 0% means auto-compact is starting, not that you're out of context

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
