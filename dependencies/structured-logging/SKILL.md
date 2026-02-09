# Structured Logging for Agent Observability

You cannot debug what you cannot see. Structured logs make agents observable.

## Installation

Create logging directory:
```bash
mkdir -p ~/.openclaw/workspace/logs
```

## Usage

### Basic JSON Logging
Instead of plain console.log, use structured JSON:

**Bad:**
```javascript
console.log("Started task");
```

**Good:**
```json
{
  "timestamp": "2026-02-08T00:30:00Z",
  "level": "info", 
  "agent": "xiaomi_cat",
  "event": "task_started",
  "taskId": "CHANLUN_PRACTICE_1",
  "details": "Starting缠论实战练习"
}
```

### Log File Structure
- `logs/tasks.jsonl` - Task execution logs (JSONL format)
- `logs/errors.jsonl` - Error and exception logs  
- `logs/heartbeat.jsonl` - Heartbeat activity logs

### Logging Functions

#### Log Task Start
```bash
log_task_start() {
  local task_id="$1"
  local description="$2" 
  echo "{\"timestamp\":\"$(date -u +%Y-%m-%dT%H:%M:%SZ)\",\"level\":\"info\",\"agent\":\"xiaomi_cat\",\"event\":\"task_started\",\"taskId\":\"$task_id\",\"details\":\"$description\"}" >> ~/.openclaw/workspace/logs/tasks.jsonl
}
```

#### Log Task Completion  
```bash
log_task_complete() {
  local task_id="$1"
  local status="$2" # success/failure/partial
  local duration="$3" # in minutes
  echo "{\"timestamp\":\"$(date -u +%Y-%m-%dT%H:%M:%SZ)\",\"level\":\"info\",\"agent\":\"xiaomi_cat\",\"event\":\"task_completed\",\"taskId\":\"$task_id\",\"status\":\"$status\",\"durationMin\":$duration}" >> ~/.openclaw/workspace/logs/tasks.jsonl
}
```

#### Log Progress Update
```bash
log_progress() {
  local task_id="$1"
  local progress="$2" # percentage
  local message="$3"
  echo "{\"timestamp\":\"$(date -u +%Y-%m-%dT%H:%M:%SZ)\",\"level\":\"info\",\"agent\":\"xiaomi_cat\",\"event\":\"progress_update\",\"taskId\":\"$task_id\",\"progress\":$progress,\"message\":\"$message\"}" >> ~/.openclaw/workspace/logs/tasks.jsonl
}
```

## Benefits

- **Searchable**: Use jq to query logs
  ```bash
  jq 'select(.taskId == "CHANLUN_PRACTICE_1")' logs/tasks.jsonl
  ```
- **Aggregatable**: Count errors by tool or task type
- **Auditable**: Track what was done on specific dates
- **Analyzable**: Calculate actual vs planned task durations

## Integration with QMD

Structured logs are automatically indexed by QMD for semantic search:
- Natural language queries like "show me failed tasks last week"
- Pattern recognition across execution history
- Automatic efficiency benchmarking

## Best Practices

1. **Always log task start and completion**
2. **Include meaningful task IDs** (not generic names)
3. **Log progress updates for long-running tasks** (>30 minutes)
4. **Use consistent event types** for easy filtering
5. **Include duration metrics** for efficiency analysis

## Example Workflow

```bash
# Start task
log_task_start "CHANLUN_PRACTICE_1" "缠论实战练习"

# Progress update  
log_progress "CHANLUN_PRACTICE_1" 50 "Completed分型识别练习"

# Task completion
log_task_complete "CHANLUN_PRACTICE_1" "success" 120
```

This creates a complete audit trail that survives context compression and enables continuous improvement.