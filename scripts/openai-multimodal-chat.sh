#!/usr/bin/env bash
OPENAI_BASE_URL=https://ai-gateway.dmall.com/api/v3
OPENAI_API_KEY=05c42e26.8f0b-4675-83fa-68a3050ba472
OPENAI_MODEL=doubao-seed-1-8-251228
OPENAI_TEMPERATURE=${OPENAI_TEMPERATURE:-0.7}
OPENAI_TOP_P=${OPENAI_TOP_P:-1}
[[ -z "${1:-}" ]] && { echo "用法: $0 \"图片URL\" [系统提示词]" >&2; exit 1; }
sys="${2:-你是一个图片检查员，识别图片是否有顾客，如果有输出'有顾客'，如果没有顾客输出'无顾客'，不包含其他字符}"

resp=$(curl -s "${OPENAI_BASE_URL%/}/v1/chat/completions" -H "Authorization: Bearer ${OPENAI_API_KEY}" -H "Content-Type: application/json" -d "$(jq -n --arg model "${OPENAI_MODEL}" --arg sys "$sys" --arg u "$1" --argjson temp "${OPENAI_TEMPERATURE}" --argjson top_p "${OPENAI_TOP_P}" '{model:$model,temperature:$temp,top_p:$top_p,messages:[{role:"system",content:$sys},{role:"user",content:[{type:"image_url",image_url:{url:$u}}]}]}')")
echo "$resp"
