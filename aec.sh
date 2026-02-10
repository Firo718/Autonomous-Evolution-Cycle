#!/bin/bash
# Autonomous Evolution Cycle - 主入口脚本（修复版）
# 整合所有功能，提供统一CLI

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SCRIPTS_DIR="${SCRIPT_DIR}"
LIB_DIR="${SCRIPT_DIR}/lib"

# 导入公共库
if [[ -f "${LIB_DIR}/core.sh" ]]; then
    source "${LIB_DIR}/core.sh"
else
    # 备用初始化
    AEC_WORKSPACE="${OPENCLAW_WORKSPACE:-${HOME}/.openclaw/workspace}"
    AEC_LOG_DIR="${HOME}/.openclaw/logs"
    AEC_SCRIPT_NAME="aec"
    mkdir -p "${AEC_WORKSPACE}"/{config,memory/{working,factual,experiential,patterns},logs}
    
    log_info() { echo "[$(date '+%Y-%m-%d %H:%M:%S')] [INFO] [aec] $1"; }
    log_warn() { echo "[$(date '+%Y-%m-%d %H:%M:%S')] [WARN] [aec] $1"; }
    log_error() { echo "[$(date '+%Y-%m-%d %H:%M:%S')] [ERROR] [aec] $1"; }
    
    aec_init() { log_info "Autonomous Evolution Cycle initialized"; }
fi

WORKSPACE="${AEC_WORKSPACE}"

#######################################
# 帮助信息
#######################################

show_help() {
    cat << 'EOF'
╔═══════════════════════════════════════════════════════════════╗
║          Autonomous Evolution Cycle v2.0                   ║
║          自主演化周期 - OpenClaw AI助手Skill                    ║
╚═══════════════════════════════════════════════════════════════╝

用法: aec <命令> [参数]

📋 核心命令:
  init                    初始化系统环境
  plan [summary]          生成今日任务计划
  status                  显示当前状态
  progress [report]       分析进度偏差

🔄 任务管理:
  task create <标题> <描述> [类型] [优先级]  创建任务
  task activate <ID>      激活任务
  task progress <ID> <进度> [消息]         更新进度
  task complete <ID> [结果]               完成任务
  task list               列出所有任务
  task cancel <ID>        取消任务

📊 分析与报告:
  analyze                 分析进度偏差
  health                  计算健康度评分
  report                 生成完整报告
  heartbeat               执行Heartbeat检查

🧠 知识管理:
  extract                 提取知识
  compost                 生成Compost种子
  patterns                发现模式

🚀 高级命令:
  run                     运行完整演化周期
  monitor [间隔秒]        连续监控模式
  reset                   重置状态

📖 帮助:
  help                    显示此帮助
  version                 显示版本

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

示例:
  aec plan                 # 生成今日任务计划
  aec task create "学习TS" "阅读文档" autonomous 3
  aec task activate abc-123
  aec task progress abc-123 50
  aec heartbeat            # 检查零进度任务
  aec extract              # 提取今日知识
  aec run                  # 运行完整周期

━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

技术栈:
  - Shell脚本 (Bash)
  - JSON处理 (jq)
  - 文件系统存储
  - 兼容OpenClaw生态

EOF
}

show_version() {
    cat << 'EOF'
Autonomous Evolution Cycle v2.0.0
Author: xiaomi_cat & xiaomii (主人的助手)
License: MIT
Homepage: https://github.com/Firo718/ForTrae

Powered by OpenClaw 🦞
EOF
}

#######################################
# 核心功能
#######################################

cmd_init() {
    echo "初始化 Autonomous Evolution Cycle..."
    echo ""
    
    # 创建目录结构
    echo "📁 创建目录结构..."
    mkdir -p "${WORKSPACE}"/{config,memory/{working,factual,experiential,patterns},logs}
    
    # 创建默认配置（简化版）
    echo "⚙️  创建默认配置..."
    cat > "${WORKSPACE}/config/autonomous-evolution-config.json" << 'EOF'
{
  "version": "2.0.0",
  "timeSlots": {
    "freeActivity": {"start": "05:00", "end": "07:00"},
    "planning": {"start": "07:00", "end": "08:00"},
    "deepWork": [{"start": "09:00", "end": "12:00"}, {"start": "14:00", "end": "17:00"}],
    "consolidation": {"start": "21:00", "end": "22:00"}
  },
  "heartbeatInterval": 300,
  "progressCheckInterval": 60,
  "maxTasksPerDay": 10,
  "deviationThresholds": {"minor": 10, "moderate": 25, "severe": 50},
  "enabledFeatures": {
    "autoTaskActivation": true,
    "progressDeviationAlerts": true,
    "automaticRescheduling": true,
    "patternExtraction": true,
    "knowledgeExtraction": true,
    "strategicAlignmentCheck": true
  }
}
EOF
    
    echo "✅ 初始化完成！"
    echo ""
    echo "下一步:"
    echo "  1. 运行 'aec plan' 生成今日任务计划"
    echo "  2. 运行 'aec help' 查看更多命令"
}

cmd_plan() {
    local show_summary="${1:-}"
    
    echo "📋 生成今日任务计划..."
    echo ""
    
    # 检查是否有bash
    if ! command -v bash &> /dev/null; then
        log_error "需要bash环境"
        return 1
    fi
    
    # 检查jq
    if ! command -v jq &> /dev/null; then
        log_error "需要jq工具"
        return 1
    fi
    
    # 检查任务生成脚本
    local generator_script="${SCRIPTS_DIR}/task-generator-fixed.sh"
    if [[ -f "$generator_script" ]]; then
        bash "$generator_script" generate
    else
        log_error "任务生成脚本不存在: $generator_script"
        return 1
    fi
    
    # 显示摘要
    if [[ "$show_summary" == "summary" ]]; then
        echo ""
        bash "${SCRIPTS_DIR}/task-generator-fixed.sh" summary
    fi
}

cmd_status() {
    echo "📊 当前状态"
    echo ""
    
    local today_plan="${WORKSPACE}/task-plan-$(date +%Y-%m-%d).json"
    
    if [[ ! -f "$today_plan" ]]; then
        echo "⚠️  今日任务计划不存在"
        echo "运行 'aec plan' 生成任务计划"
        return
    fi
    
    local total completed in_progress pending
    total=$(jq '.tasks | length' "$today_plan")
    completed=$(jq '[.tasks[] | select(.status == "completed")] | length' "$today_plan")
    in_progress=$(jq '[.tasks[] | select(.status == "in_progress")] | length' "$today_plan")
    pending=$(jq '[.tasks[] | select(.status == "pending")] | length' "$today_plan")
    
    local completion_rate="0"
    if [[ "$total" -gt 0 ]]; then
        completion_rate=$(echo "scale=1; $completed * 100 / $total" | bc)
    fi
    
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    printf "  总任务:    %d\n" "$total"
    printf "  已完成:    %d\n" "$completed"
    printf "  进行中:    %d\n" "$in_progress"
    printf "  待执行:    %d\n" "$pending"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    printf "  完成率:    %s%%\n" "$completion_rate"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    
    # 显示主人指令任务
    local master_count
    master_count=$(jq '[.tasks[] | select(.type == "master")] | length' "$today_plan")
    if [[ "$master_count" -gt 0 ]]; then
        echo ""
        echo "⚡ 主人指令任务 ($master_count):"
        jq -r '.tasks[] | select(.type == "master") | "  - [\(.priority)] \(.title)"' "$today_plan" 2>/dev/null | head -5
    fi
    
    # 显示进行中任务
    if [[ "$in_progress" -gt 0 ]]; then
        echo ""
        echo "🔄 进行中任务:"
        jq -r '.tasks[] | select(.status == "in_progress") | "  - [\(.progress)%] \(.title)"' "$today_plan" 2>/dev/null | head -5
    fi
}

cmd_heartbeat() {
    echo "💓 执行Heartbeat检查..."
    echo ""
    bash "${SCRIPTS_DIR}/heartbeat.sh" check
}

cmd_extract() {
    bash "${SCRIPTS_DIR}/knowledge-extractor.sh" all
}

cmd_run() {
    echo "🚀 运行完整演化周期..."
    echo ""
    
    echo "步骤 1: 生成任务计划"
    cmd_plan
    
    echo ""
    echo "步骤 2: 执行Heartbeat检查"
    cmd_heartbeat
    
    echo ""
    echo "步骤 3: 提取知识"
    cmd_extract
    
    echo ""
    echo "✅ 演化周期完成！"
}

#######################################
# 主入口
#######################################

main() {
    local command="${1:-help}"
    shift || true
    
    # 初始化
    aec_init "main"
    
    case "$command" in
        "init")              cmd_init ;;
        "plan")              cmd_plan "$@" ;;
        "status")            cmd_status ;;
        "heartbeat")         cmd_heartbeat ;;
        "extract")           cmd_extract ;;
        "run")               cmd_run ;;
        "version"|"--version") show_version ;;
        "help"|"--help"| "")   show_help ;;
        *)
            log_error "未知命令: $command"
            echo "运行 'aec help' 查看帮助"
            exit 1
            ;;
    esac
}

main "$@"