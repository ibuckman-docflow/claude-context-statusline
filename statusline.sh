#!/bin/bash
input=$(cat)
transcript_path=$(echo "$input" | python3 -c "import sys, json; print(json.load(sys.stdin).get('transcript_path', ''))")
cache_file="/tmp/claude_context_cache.txt"

# If no transcript, use cache
if [ -z "$transcript_path" ] || [ ! -f "$transcript_path" ]; then
    if [ -f "$cache_file" ]; then
        cat "$cache_file"
    else
        printf "Context: 100%% free"
    fi
    exit 0
fi

# Read the last line of the transcript and extract token usage
last_line=$(tail -n 1 "$transcript_path")
usage=$(echo "$last_line" | python3 -c "
import sys, json
try:
    data = json.load(sys.stdin)
    usage = data.get('message', {}).get('usage', {})
    input_tokens = usage.get('input_tokens', 0)
    cache_creation = usage.get('cache_creation_input_tokens', 0)
    cache_read = usage.get('cache_read_input_tokens', 0)
    total = input_tokens + cache_creation + cache_read
    print(total)
except:
    print(0)
")

# Calculate free percentage (200k budget)
budget=200000

# If no valid usage yet, show pending state
if [ "$usage" = "0" ] || [ -z "$usage" ]; then
    printf "Context: --% (pending)"
    exit 0
fi

free=$(python3 -c "print(int(round((($budget - $usage) * 100) / $budget)))")

# Color code based on percentage
# Green: > 50%, Yellow: 11-50%, Red: <= 10%
if [ "$free" -gt 50 ]; then
    color="\033[32m"  # Green
elif [ "$free" -gt 10 ]; then
    color="\033[33m"  # Yellow
else
    color="\033[31m"  # Red
fi
reset="\033[0m"

output=$(printf "${color}Context: %d%% free${reset}" "$free")
echo "$output" > "$cache_file"
printf "%s" "$output"
