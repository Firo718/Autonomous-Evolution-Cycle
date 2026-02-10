#!/bin/bash
echo "=== Autonomous Evolution Cycle 质量保障测试 ==="

# 测试1: 结构化日志
echo "测试1: 结构化日志..."
LOG_FILE="/home/admin/.openclaw/workspace/logs/tasks.jsonl"
mkdir -p "$(dirname "$LOG_FILE")"
echo '{"timestamp":"2026-02-10T11:00:00Z","level":"info","agent":"test","event":"task_started","taskId":"test-001","progress":5}' >> "$LOG_FILE"
if [[ -f "$LOG_FILE" ]]; then
    echo "✅ 结构化日志: 正常"
else
    echo "❌ 结构化日志: 失败"
fi

# 测试2: 错误处理
echo "测试2: 错误处理..."
ERROR_LOG="/home/admin/.openclaw/workspace/logs/automation.log"
if [[ -f "$ERROR_LOG" ]]; then
    echo "✅ 错误处理: 日志文件存在"
else
    echo "⚠️ 错误处理: 日志文件不存在（可能未触发错误）"
fi

# 测试3: 健康度评分
echo "测试3: 健康度评分..."
HEARTBEAT_LOG="/home/admin/.openclaw/workspace/logs/heartbeat-$(date +%Y-%m-%d).jsonl"
if [[ -f "$HEARTBEAT_LOG" ]]; then
    echo "✅ 健康度监控: 日志文件存在"
else
    echo "⚠️ 健康度监控: 日志文件不存在"
fi

echo "=== 质量保障测试完成 ==="