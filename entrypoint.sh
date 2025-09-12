#!/bin/bash

# Exit immediately if a command exits with a non-zero status
set -e

# Main script logic
echo "Starting script execution..."

if echo "$*" | grep -i -q FIXED;
then 
    echo "FIXED found in arguments. Executing fixed task..."
    # Add your fixed task commands here
else
    echo "FIXED not found. Executing default task..."
    # Add your default task commands here
fi

echo "Script execution completed."