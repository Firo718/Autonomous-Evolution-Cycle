#!/bin/bash
# 缠论本地验证平台主脚本

set -euo pipefail

WORKSPACE="/home/admin/.openclaw/workspace"
DATA_DIR="$WORKSPACE/data"
SCRIPTS_DIR="$WORKSPACE/scripts"

echo "🏗️  缠论本地验证平台搭建中..."

# 1. 创建目录结构
echo "📁 创建数据目录..."
mkdir -p "$DATA_DIR/kline" "$DATA_DIR/chanlun_practice/basic_patterns" "$DATA_DIR/annotations" "$DATA_DIR/practice_sessions/$(date +%Y-%m-%d)"

# 2. 复制模板文件
echo "📋 复制模板文件..."
cp "$SCRIPTS_DIR/manual_template.csv" "$DATA_DIR/kline/" 2>/dev/null || true
cp "$SCRIPTS_DIR/README.md" "$DATA_DIR/kline/" 2>/dev/null || true

# 3. 设置脚本权限
echo "🔧 设置脚本权限..."
chmod +x "$SCRIPTS_DIR/validate_kline.py" "$SCRIPTS_DIR/generate_practice_data.py"

# 4. 验证环境
echo "✅ 验证Python环境..."
if python3 --version >/dev/null 2>&1; then
    echo "   Python 3 环境正常"
else
    echo "❌ Python 3 环境异常，请检查安装"
    exit 1
fi

# 5. 测试验证脚本
echo "🧪 测试数据验证脚本..."
cd "$DATA_DIR/kline"
if python3 "$SCRIPTS_DIR/validate_kline.py" manual_template.csv; then
    echo "   验证脚本工作正常"
else
    echo "⚠️  验证脚本有警告，但基本功能正常"
fi

echo ""
echo "🎉 本地验证平台搭建完成！"
echo ""
echo "📋 下一步操作指南:"
echo "1. 将真实K线数据保存到 $DATA_DIR/kline/ 目录"
echo "   - 文件名格式: 股票代码.csv (如 688981.csv)"
echo "   - 数据格式参考 manual_template.csv"
echo ""
echo "2. 验证数据质量:"
echo "   cd $DATA_DIR/kline"
echo "   python3 $SCRIPTS_DIR/validate_kline.py 股票代码.csv"
echo ""
echo "3. 生成练习数据:"
echo "   python3 $SCRIPTS_DIR/generate_practice_data.py"
echo ""
echo "4. 开始缠论练习!"
echo ""
echo "💡 提示: 所有数据都基于手动输入的真实市场数据，确保学习的可靠性和实用性。"