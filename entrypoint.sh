#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Main script logic
echo "Starting script execution..."

if [ -n "$GITHUB_EVENT_PATH"];
then
    echo "GITHUB_EVENT_PATH is set to $GITHUB_EVENT_PATH"
    echo "Contents of the event file:"
    cat "$GITHUB_EVENT_PATH"
    EVENT_PATH="$GITHUB_EVENT_PATH"
else
    echo "GITHUB_EVENT_PATH is not set. No JSON data to process."
    exit 1
fi

env
jq . < "$EVENT_PATH"


if jq '.commits[].message, .head_commit.message' < "$EVENT_PATH" | grep -i -q "$*";
then
    echo "Keyword '$*' found in commit messages."
else
    echo "Keyword '$*' not found in commit messages."
fi

echo "Script execution completed."