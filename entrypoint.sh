#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Main script logic
echo "Starting script execution..."
echo "GITHUB_EVENT_PATH: $GITHUB_EVENT_PATH"

if [ -n "$GITHUB_EVENT_PATH" ]
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


if jq '.commits[].message, .head_commit.message' < "$EVENT_PATH" | grep -i -q "$*"
then
    echo "Keyword '$*' found in commit messages."
    VERSION="1.0.$(date +%F.%s)"
    echo "VERSION=$VERSION" >> $GITHUB_ENV
    echo "Set VERSION to $VERSION"

    DATA=$(cat << EOF
    {
    "tag_name": "v${VERSION}",
    "target_commitish": "main",
    "name": "v${VERSION}",
    "body": "Automated release based on keyword: ${*}",
    "draft": false,
    "prerelease": false
    }
EOF
)

    echo "Release data: $DATA"
    URL="https://api.github.com/repos/${GITHUB_REPOSITORY}/releases"
    curl -L \
        -v -X POST \
        -H "Authorization: Bearer $GH_TOKEN" \
        -H "Accept: application/vnd.github+json" \
        -H "X-GitHub-Api-Version: 2022-11-28" \
        "$URL" \
        -d "$DATA" | jq .
else
    echo "Keyword '$*' not found in commit messages."
fi

echo "Script execution completed."