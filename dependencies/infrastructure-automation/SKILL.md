# Infrastructure Automation for OpenClaw Agents

Running Clawdbot on various platforms, handling email/cron/automation for humans. Comprehensive toolkit for system integration.

## Installation

Create automation directory:
```bash
mkdir -p ~/.openclaw/workspace/automation/scripts
mkdir -p ~/.openclaw/workspace/automation/config
```

## Core Components

### 1. Shell Scripting Framework

#### Basic Script Template
```bash
#!/bin/bash
# Standard OpenClaw automation script template
set -euo pipefail

# Configuration
WORKSPACE="$HOME/.openclaw/workspace"
LOG_DIR="$WORKSPACE/logs"
SCRIPT_NAME=$(basename "$0")

# Logging function
log() {
    echo "[$(date '+%Y-%m-%d %H:%M:%S')] $SCRIPT_NAME: $*" >> "$LOG_DIR/automation.log"
}

# Error handling
cleanup() {
    log "Script completed with exit code $?"
}
trap cleanup EXIT

# Main execution
main() {
    log "Starting automation task: $*"
    # Your automation logic here
}

if [[ "${BASH_SOURCE[0]}" == "${0}" ]]; then
    main "$@"
fi
```

### 2. Cron Job Management

#### List Current Cron Jobs
```bash
openclaw cron list --json > ~/.openclaw/workspace/automation/config/cron-backup.json
```

#### Add Cron Job Helper
```bash
add_cron_job() {
    local name="$1"
    local schedule="$2" 
    local message="$3"
    
    openclaw cron add \
        --name "$name" \
        --cron "$schedule" \
        --tz "Asia/Shanghai" \
        --session isolated \
        --message "$message" \
        --announce
}
```

### 3. GitHub Integration

#### Clone Repository
```bash
clone_repo() {
    local repo_url="$1"
    local target_dir="$2"
    
    if [ ! -d "$target_dir" ]; then
        git clone "$repo_url" "$target_dir"
    else
        cd "$target_dir" && git pull
    fi
}
```

#### Commit and Push Changes
```bash
commit_changes() {
    local repo_dir="$1"
    local commit_message="$2"
    
    cd "$repo_dir"
    git add .
    git commit -m "$commit_message" || true  # Continue if no changes
    git push
}
```

### 4. File Operations

#### Safe File Writing
```bash
safe_write() {
    local content="$1"
    local target_file="$2"
    local backup_dir="$3"
    
    # Create backup
    mkdir -p "$backup_dir"
    if [ -f "$target_file" ]; then
        cp "$target_file" "$backup_dir/$(basename "$target_file").$(date +%Y%m%d_%H%M%S)"
    fi
    
    # Write new content
    echo "$content" > "$target_file"
}
```

#### Directory Synchronization
```bash
sync_dirs() {
    local source_dir="$1"
    local target_dir="$2"
    
    rsync -av --delete "$source_dir/" "$target_dir/"
}
```

### 5. System Monitoring

#### Check Disk Space
```bash
check_disk_space() {
    local threshold="$1"  # percentage
    local usage=$(df / | tail -1 | awk '{print $5}' | sed 's/%//')
    
    if [ "$usage" -gt "$threshold" ]; then
        echo "WARNING: Disk usage is ${usage}%"
        return 1
    fi
    return 0
}
```

#### Monitor Process Health
```bash
check_process() {
    local process_name="$1"
    if pgrep -x "$process_name" > /dev/null; then
        return 0
    else
        echo "ERROR: $process_name is not running"
        return 1
    fi
}
```

## Usage Examples

### Example 1: Daily Backup Script
```bash
#!/bin/bash
# daily-backup.sh
source ~/.openclaw/workspace/automation/scripts/framework.sh

main() {
    log "Starting daily backup"
    
    # Backup workspace
    tar -czf "/backup/workspace-$(date +%Y%m%d).tar.gz" "$HOME/.openclaw/workspace"
    
    # Sync to remote
    rclone sync "/backup" "remote:openclaw-backups"
    
    log "Daily backup completed"
}
```

### Example 2: K线数据获取脚本
```bash
#!/bin/bash
# fetch-kline-data.sh
source ~/.openclaw/workspace/automation/scripts/framework.sh

main() {
    local stock_codes=("688981" "159516" "000905" "600362")
    local output_dir="$WORKSPACE/data/kline"
    
    mkdir -p "$output_dir"
    
    for code in "${stock_codes[@]}"; do
        log "Fetching kline data for $code"
        # Simulate API call to get kline data
        curl -s "https://api.example.com/kline?code=$code&days=30" > "$output_dir/$code.csv"
    done
    
    log "Kline data fetching completed"
}
```

### Example 3: Task Scheduler
```bash
#!/bin/bash
# task-scheduler.sh
source ~/.openclaw/workspace/automation/scripts/framework.sh

main() {
    local task_queue="$WORKSPACE/tasks/queue.json"
    
    # Read pending tasks
    while read -r task; do
        local task_id=$(echo "$task" | jq -r '.id')
        local task_type=$(echo "$task" | jq -r '.type')
        
        log "Processing task: $task_id ($task_type)"
        
        case "$task_type" in
            "kline_fetch")
                ~/.openclaw/workspace/automation/scripts/fetch-kline-data.sh
                ;;
            "memory_maintenance")
                ~/.openclaw/workspace/automation/scripts/memory-maintenance.sh
                ;;
            *)
                log "Unknown task type: $task_type"
                ;;
        esac
        
        # Mark task as completed
        mark_task_completed "$task_id"
    done < <(jq -c '.[] | select(.status == "pending")' "$task_queue")
}
```

## Integration Points

### With Structured Logging
- All automation scripts use the structured logging framework
- Task execution is automatically logged to JSONL files
- Errors are captured and categorized for analysis

### With QMD Memory System
- Automation results are automatically indexed by QMD
- Configuration files are stored in memory for easy retrieval
- Historical execution data enables pattern recognition

### With Heartbeat System
- Automation tasks can be triggered by heartbeat events
- Progress updates are reported during long-running operations
- Failed tasks are automatically retried or escalated

## Best Practices

1. **Always use the framework.sh template** for consistency
2. **Implement proper error handling** with trap statements
3. **Log all significant events** using structured logging
4. **Create backups before modifying files**
5. **Test scripts in isolation** before integrating into cron jobs
6. **Use configuration files** instead of hardcoding values
7. **Document all scripts** with clear usage instructions

## Security Considerations

- **Never store secrets in scripts** - use environment variables or secure config files
- **Validate all inputs** to prevent injection attacks
- **Run with minimal privileges** - don't use root unless absolutely necessary
- **Audit script execution** through structured logging
- **Regularly review and update** automation scripts for security patches

This infrastructure automation skill provides the foundation for reliable, maintainable, and secure agent operations.