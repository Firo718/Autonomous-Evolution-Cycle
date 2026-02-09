#!/bin/bash
# Memory Integration for Autonomous Evolution Cycle
# Handles integration with Agent Memory Research skill

set -euo pipefail

WORKSPACE="$HOME/.openclaw/workspace"
LOG_DIR="$WORKSPACE/logs"
SCRIPT_NAME="memory-integration"

# Logging function
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $SCRIPT_NAME: $*" >> "$LOG_DIR/automation.log"
}

# Create factual memory entry
create_factual_memory() {
    local title="$1"
    local content="$2"
    local tags="$3"
    
    local memory_id=$(uuidgen)
    local timestamp=$(date -u +%Y-%m-%dT%H:%M:%SZ)
    
    mkdir -p "$WORKSPACE/memory/factual"
    cat > "$WORKSPACE/memory/factual/$memory_id.json" << EOF
{
  "id": "$memory_id",
  "type": "factual",
  "title": "$title",
  "content": "$content",
  "tags": [$tags],
  "links": [],
  "created_at": "$timestamp",
  "updated_at": "$timestamp",
  "confidence": 0.95,
  "source": "autonomous-evolution-cycle"
}
EOF
    
    log "Created factual memory: $title"
}

# Create experiential memory entry
create_experiential_memory() {
    local title="$1"
    local content="$2"
    local tags="$3"
    
    local memory_id=$(uuidgen)
    local timestamp=$(date -u +%Y-%m-%dT%H:%M:%SZ)
    
    mkdir -p "$WORKSPACE/memory/experiential"
    cat > "$WORKSPACE/memory/experiential/$memory_id.json" << EOF
{
  "id": "$memory_id",
  "type": "experiential",
  "title": "$title",
  "content": "$content",
  "tags": [$tags],
  "links": [],
  "created_at": "$timestamp",
  "updated_at": "$timestamp",
  "confidence": 0.9,
  "source": "autonomous-evolution-cycle"
}
EOF
    
    log "Created experiential memory: $title"
}

# Create working memory entry
create_working_memory() {
    local title="$1"
    local content="$2"
    local tags="$3"
    
    local memory_id=$(uuidgen)
    local timestamp=$(date -u +%Y-%m-%dT%H:%M:%SZ)
    
    mkdir -p "$WORKSPACE/memory/working"
    cat > "$WORKSPACE/memory/working/$memory_id.json" << EOF
{
  "id": "$memory_id",
  "type": "working",
  "title": "$title",
  "content": "$content",
  "tags": [$tags],
  "links": [],
  "created_at": "$timestamp",
  "updated_at": "$timestamp",
  "confidence": 1.0,
  "source": "autonomous-evolution-cycle"
}
EOF
    
    log "Created working memory: $title"
}

# Main execution
main() {
    case "$1" in
        "factual")
            create_factual_memory "$2" "$3" "$4"
            ;;
        "experiential")
            create_experiential_memory "$2" "$3" "$4"
            ;;
        "working")
            create_working_memory "$2" "$3" "$4"
            ;;
        *)
            echo "Usage: $0 {factual|experiential|working} [title] [content] [tags]"
            exit 1
            ;;
    esac
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi