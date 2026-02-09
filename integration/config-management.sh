#!/bin/bash
# Configuration Management for Autonomous Evolution Cycle
# Handles configuration loading and management across all skills

set -euo pipefail

WORKSPACE="$HOME/.openclaw/workspace"
LOG_DIR="$WORKSPACE/logs"
SCRIPT_NAME="config-management"

# Logging function
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $SCRIPT_NAME: $*" >> "$LOG_DIR/automation.log"
}

# Load user configuration
load_user_config() {
    local config_file="$WORKSPACE/config/user-time-slots.json"
    
    if [ -f "$config_file" ]; then
        log "Loading user configuration from $config_file"
        cat "$config_file"
    else
        log "User configuration not found, using defaults"
        echo "{}"
    fi
}

# Load TASK_SCHEDULE configuration
load_task_schedule() {
    local schedule_file="$WORKSPACE/TASK_SCHEDULE.md"
    
    if [ -f "$schedule_file" ]; then
        log "Loading task schedule from $schedule_file"
        # Parse TASK_SCHEDULE.md for time slots
        grep -E "## ⏰ [0-9]+:[0-9]+" "$schedule_file" | sed 's/## ⏰ //g' | sed 's/ .*//g'
    else
        log "TASK_SCHEDULE.md not found, using default time slots"
        echo -e "08:00\n10:00\n16:00\n23:00"
    fi
}

# Save configuration
save_config() {
    local config_name="$1"
    local config_content="$2"
    
    mkdir -p "$WORKSPACE/config"
    echo "$config_content" > "$WORKSPACE/config/$config_name.json"
    log "Saved configuration: $config_name"
}

# Main execution
main() {
    case "$1" in
        "user")
            load_user_config
            ;;
        "schedule")
            load_task_schedule
            ;;
        "save")
            save_config "$2" "$3"
            ;;
        *)
            echo "Usage: $0 {user|schedule|save} [args...]"
            exit 1
            ;;
    esac
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi