#!/bin/bash
# Script to send commands to Quickshell master window via IPC

COMMAND=$1
shift
ARGS="$*"

if [ -z "$COMMAND" ]; then
    echo "Usage: $0 <command> [args...]"
    exit 1
fi

if [ -z "$ARGS" ]; then
    echo "$COMMAND" > /tmp/qs_widget_state
else
    # Replace spaces with colons if needed, or just pass as colon separated
    # The Main.qml splits by ":"
    FORMATTED_ARGS=$(echo "$ARGS" | tr ' ' ':')
    echo "$COMMAND:$FORMATTED_ARGS" > /tmp/qs_widget_state
fi
