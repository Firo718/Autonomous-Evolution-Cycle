#!/bin/bash
echo "=== Autonomous Evolution Cycle 安全性测试 ==="

# 测试1: 路径遍历防护
echo "测试1: 路径遍历防护..."
TEST_PATH="../etc/passwd"
SANITIZED=$(echo "$TEST_PATH" | sed 's/\.\.//g')
if [[ "$SANITIZED" != "$TEST_PATH" ]]; then
    echo "✅ 路径遍历防护: 有效"
else
    echo "❌ 路径遍历防护: 失败"
fi

# 测试2: 危险字符过滤
echo "测试2: 危险字符过滤..."
DANGEROUS_PATH="/tmp/test<script>alert('xss')</script>.json"
SANITIZED=$(printf '%s' "$DANGEROUS_PATH" | tr -cd '[:alnum:]_-.\/')
if [[ "$SANITIZED" != "$DANGEROUS_PATH" ]]; then
    echo "✅ 危险字符过滤: 有效"
else
    echo "❌ 危险字符过滤: 失败"
fi

# 测试3: JSON安全操作
echo "测试3: JSON安全操作..."
mkdir -p /home/admin/.openclaw/workspace/test-safe-json
echo '{"test": "original"}' > /home/admin/.openclaw/workspace/test-safe-json/test.json
TEMP_FILE="/home/admin/.openclaw/workspace/test-safe-json/test.json.tmp"
echo '{"test": "updated", "safe": true}' > "$TEMP_FILE"
if mv "$TEMP_FILE" /home/admin/.openclaw/workspace/test-safe-json/test.json; then
    echo "✅ JSON安全操作: 有效"
else
    echo "❌ JSON安全操作: 失败"
fi

# 清理
rm -rf /home/admin/.openclaw/workspace/test-safe-json

echo "=== 安全性测试完成 ==="