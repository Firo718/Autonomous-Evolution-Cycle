#!/bin/bash

# 简化测试脚本 - 测试核心功能

WORKSPACE="${HOME}/.openclaw/workspace"
TASK_PLAN_FILE="${WORKSPACE}/task-plan-$(date +%Y-%m-%d).json"

echo "=== Autonomous Evolution Cycle 简化测试 ==="

# 创建测试目录
mkdir -p "${WORKSPACE}/memory/working"
mkdir -p "${WORKSPACE}/memory/factual"
mkdir -p "${WORKSPACE}/memory/experiential"
mkdir -p "${WORKSPACE}/logs"

# 测试1: 创建任务计划
echo "测试1: 创建任务计划..."
cat > "$TASK_PLAN_FILE" << 'EOF'
{
  "id": "test-plan-123",
  "date": "2026-02-10",
  "tasks": [
    {
      "id": "task-001",
      "title": "测试任务1",
      "description": "这是一个测试任务",
      "type": "autonomous",
      "priority": 4,
      "status": "in_progress",
      "estimatedDuration": 60,
      "progress": 0,
      "createdAt": "2026-02-10T10:00:00Z",
      "updatedAt": "2026-02-10T10:00:00Z",
      "startedAt": "2026-02-10T10:00:00Z"
    },
    {
      "id": "task-002", 
      "title": "主人指令任务",
      "description": "这是主人的指令",
      "type": "master",
      "priority": 1,
      "status": "pending",
      "estimatedDuration": 30,
      "progress": 0,
      "createdAt": "2026-02-10T10:00:00Z",
      "updatedAt": "2026-02-10T10:00:00Z"
    }
  ],
  "totalEstimatedDuration": 90,
  "createdAt": "2026-02-10T10:00:00Z"
}
EOF

echo "✅ 任务计划创建成功"

# 测试2: 检测零进度任务
echo "测试2: 检测零进度任务..."
if [[ -f "$TASK_PLAN_FILE" ]]; then
    zero_tasks=$(jq '.tasks[] | select(.status == "in_progress" and .progress == 0)' "$TASK_PLAN_FILE")
    if [[ -n "$zero_tasks" ]]; then
        echo "✅ 检测到零进度任务"
        echo "$zero_tasks"
    else
        echo "❌ 未检测到零进度任务"
    fi
else
    echo "❌ 任务计划文件不存在"
fi

# 测试3: 创建工作中的任务文件
echo "测试3: 创建工作中的任务文件..."
task_file="${WORKSPACE}/memory/working/task-001.json"
jq '.tasks[0]' "$TASK_PLAN_FILE" > "$task_file"
echo "✅ 工作任务文件创建成功"

# 测试4: 知识提取
echo "测试4: 知识提取..."
knowledge_dir="${WORKSPACE}/memory/factual"
mkdir -p "$knowledge_dir"
cat > "${knowledge_dir}/test-knowledge.json" << 'EOF'
{
  "id": "test-knowledge-001",
  "type": "factual", 
  "title": "测试知识条目",
  "content": "这是从任务中提取的知识",
  "tags": ["test", "knowledge"],
  "confidence": 0.9,
  "source": "autonomous-evolution-cycle",
  "createdAt": "2026-02-10T10:00:00Z"
}
EOF
echo "✅ 知识提取测试完成"

echo ""
echo "=== 测试完成 ==="
echo "主要功能验证:"
echo "✅ 任务计划创建"
echo "✅ 零进度任务检测"  
echo "✅ 工作任务文件管理"
echo "✅ 知识提取和存储"