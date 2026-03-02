#!/bin/bash
# dailyremu 주식 자동 포스팅 스크립트
# 매일 새벽 6시 실행 → 요일별 주제로 글 작성 → git push

export TZ="Asia/Seoul"

BLOG_DIR="/Users/hanjin/dailyremu"
LOG_DIR="$BLOG_DIR/logs"
DATE=$(date +%Y-%m-%d)
LOG_FILE="$LOG_DIR/stock_${DATE}.log"

mkdir -p "$LOG_DIR"

echo "=== 주식 자동 포스팅 시작: $(date) ===" >> "$LOG_FILE"

# 요일별 주제 (1=월 ~ 7=일)
DOW=$(date +%u)

case $DOW in
  1) TOPIC="주간 시장 전망"
     DETAIL="이번 주 코스피, 코스닥, 나스닥, S&P500 등 국내외 증시 주간 전망을 웹 검색해서 주요 이슈, 예상 흐름, 주목할 이벤트를 정리한 분석 글을 작성" ;;
  2) TOPIC="코스피·코스닥 시황"
     DETAIL="최근 코스피, 코스닥 시장 동향, 수급 분석, 외국인·기관 매매 동향, 주요 종목 이슈 등을 웹 검색해서 국내 증시 시황 분석 글을 작성" ;;
  3) TOPIC="미국 주식"
     DETAIL="나스닥, S&P500, 다우존스 동향과 빅테크(애플, 엔비디아, 테슬라 등) 실적 및 이슈를 웹 검색해서 미국 증시 분석 글을 작성" ;;
  4) TOPIC="테마주·섹터 분석"
     DETAIL="최근 주목받는 테마주(AI, 반도체, 2차전지, 바이오 등)와 섹터별 동향을 웹 검색해서 테마·섹터 심층 분석 글을 작성" ;;
  5) TOPIC="ETF·배당주"
     DETAIL="국내외 인기 ETF 동향, 배당주 추천, 배당 수익률 비교, 장기 투자 전략 등을 웹 검색해서 ETF·배당주 분석 글을 작성" ;;
  6) TOPIC="주간 시장 리뷰"
     DETAIL="이번 주 국내외 증시를 종합 리뷰하고 주요 종목 등락, 거래대금, 수급 변화 등을 웹 검색해서 주간 시장 정리 글을 작성" ;;
  7) TOPIC="경제지표·투자 전략"
     DETAIL="주요 경제지표(금리, 환율, 유가, CPI 등) 발표 내용과 투자 전략, 자산배분 방향 등을 웹 검색해서 경제·투자 전략 분석 글을 작성" ;;
esac

PROMPT="오늘은 ${DATE}이고 블로그 요일별 주식 주제는 '${TOPIC}'입니다.
${DETAIL}해주세요.

작성 규칙:
1. 반드시 WebSearch로 최신 뉴스를 검색하고 WebFetch로 기사 내용을 확인해서 실제 데이터와 수치 기반으로 작성
2. 기존 글 스타일 참고 (content/posts/ 내 최근 글 하나를 Read로 읽어볼 것)
3. 글 저장: content/posts/${DATE}-주식-제목슬러그/index.md 형태로 Write로 저장
4. frontmatter에 반드시 포함: title, date: ${DATE}T06:00:00+09:00, categories: [주식정보], tags, description(150자 이내 요약문)
5. 본문에 출처 링크 포함
6. 물결표(~)는 취소선이 아니라 일반 텍스트로 사용
7. 저장 후 Bash로 git add, git commit, git push 실행"

cd "$BLOG_DIR"

/Users/hanjin/.local/bin/claude -p "$PROMPT" \
  --allowedTools "WebSearch WebFetch Read Write Edit Bash(git:*) Glob Grep" \
  --model sonnet \
  >> "$LOG_FILE" 2>&1

echo "=== 주식 자동 포스팅 완료: $(date) ===" >> "$LOG_FILE"
