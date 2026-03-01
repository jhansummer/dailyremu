#!/bin/bash
# dailyremu 자동 포스팅 스크립트
# 매일 아침 실행 → 요일별 주제로 글 작성 → git push

BLOG_DIR="/Users/hanjin/dailyremu"
LOG_DIR="$BLOG_DIR/logs"
DATE=$(date +%Y-%m-%d)
LOG_FILE="$LOG_DIR/post_${DATE}.log"

mkdir -p "$LOG_DIR"

echo "=== 자동 포스팅 시작: $(date) ===" >> "$LOG_FILE"

# 요일별 주제 (1=월 ~ 7=일)
DOW=$(date +%u)

case $DOW in
  1) TOPIC="서울 집값/시세"
     DETAIL="KB부동산 주간 시세, 한국부동산원 아파트 가격지수, 실거래가 동향 등을 웹 검색해서 서울 아파트 매매 시세 분석 글을 작성" ;;
  2) TOPIC="공급/분양"
     DETAIL="청약홈 분양일정, 신규 분양 단지, 분양가 동향, 청약 경쟁률 등을 웹 검색해서 수도권 분양 시장 분석 글을 작성" ;;
  3) TOPIC="정책/규제"
     DETAIL="국토교통부 보도자료, 한국은행 기준금리, 부동산 세제, 대출 규제 등을 웹 검색해서 부동산 정책 분석 글을 작성" ;;
  4) TOPIC="지역분석"
     DETAIL="서울 주요 구 또는 수도권 신도시의 실거래가, 개발 호재, 도시계획 등을 웹 검색해서 지역 부동산 심층 분석 글을 작성" ;;
  5) TOPIC="GTX/교통"
     DETAIL="GTX, 신규 철도, 도로 개통, 교통 인프라 등을 웹 검색해서 교통 호재와 부동산 가치 변화 분석 글을 작성" ;;
  6) TOPIC="전세/임대"
     DETAIL="전세가격지수, 전월세 동향, 전세보증 통계, 임대차 시장 등을 웹 검색해서 전세/임대 시장 분석 글을 작성" ;;
  7) TOPIC="재건축/정비"
     DETAIL="서울 정비사업 현황, 재건축 진단, 조합 인가, 시공사 선정 등을 웹 검색해서 재건축/정비사업 분석 글을 작성" ;;
esac

PROMPT="오늘은 ${DATE}이고 블로그 요일별 주제는 '${TOPIC}'입니다.
${DETAIL}해주세요.

작성 규칙:
1. 반드시 WebSearch로 최신 뉴스를 검색하고 WebFetch로 기사 내용을 확인해서 실제 데이터와 수치 기반으로 작성
2. 기존 글 스타일 참고 (content/posts/ 내 최근 글 하나를 Read로 읽어볼 것)
3. 글 저장: content/posts/${DATE}-제목슬러그/index.md 형태로 Write로 저장
4. frontmatter에 반드시 포함: title, date: ${DATE}T07:00:00+09:00, categories: [부동산정보], tags, description(150자 이내 요약문)
5. 본문에 출처 링크 포함
6. 물결표(~)는 취소선이 아니라 일반 텍스트로 사용
7. 저장 후 Bash로 git add, git commit, git push 실행"

cd "$BLOG_DIR"

/Users/hanjin/.local/bin/claude -p "$PROMPT" \
  --allowedTools "WebSearch WebFetch Read Write Edit Bash(git:*) Glob Grep" \
  --model sonnet \
  >> "$LOG_FILE" 2>&1

echo "=== 자동 포스팅 완료: $(date) ===" >> "$LOG_FILE"
