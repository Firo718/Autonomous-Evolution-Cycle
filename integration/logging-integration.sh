#!/bin/bash
# Logging Integration for Autonomous Evolution Cycle
# Handles integration with Structured Logging skill

set -euo pipefail

WORKSPACE="$HOME/.openclaw/workspace"
LOG_DIR="$WORKSPACE/logs"
SCRIPT_NAME="logging-integration"

# Logging function
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $SCRIPT_NAME: $*" >> "$LOG_DIR/automation.log"
}

# Log task event to structured logging
log_task_event() {
    local event_type="$1"
    local task_id="$2"
    local details="$3"
    local progress="${4:-0}"
    
    # Create structured log entry
    cat > "$LOG_DIR/task_${event_type}_$(date +%s).json" << EOF
{
  "timestamp": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
  "level": "info",
  "agent": "xiaomi_cat",
  "event": "$event_type",
  "taskId": "$task_id",
  "details": "$details",
  "progress": $progress
}
EOF
    
    # Also append to tasks.jsonl for QMD indexing
    echo "{\"timestamp\":\"$(date -u +%Y-%m-%dT%H:%M:%SZ)\",\"level\":\"info\",\"agent\":\"xiaomi_cat\",\"event\":\"$event_type\",\"taskId\":\"$task_id\",\"details\":\"$details\",\"progress\":$progress}" >> "$WORKSPACE/logs/tasks.jsonl"
    
    log "Logged task event: $event_type - $task_id"
}

# Log system event
log_system_event() {
    local event_type="$1"
    local message="$2"
    
    cat > "$LOG_DIR/system_${event_type}_$(date +%s).json" << EOF
{
  "timestamp": "$(date -u +%Y-%m-%dT%H:%M:%SZ)",
  "level": "info",
  "agent": "xiaomi_cat",
  "event": "$event_type",
  "message": "$message"
}
EOF
    
    log "Logged system event: $event_type"
}

# Main execution
main() {
    case "$1" in
        "task")
            log_task_event "$2" "$3" "$4" "$5"
            ;;
        "system")
            log_system_event "$2" "$3"
            ;;
        *)
            echo "Usage: $0 {task|system} [args...]"
            exit 1
            ;;
    esac
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi