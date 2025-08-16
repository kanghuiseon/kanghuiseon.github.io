#!/bin/bash

# 색상 정의
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}📝 새 글 생성 도구${NC}"

# 현재 연도
current_year=$(date +%Y)

# 글 제목 입력받기
echo -e "${YELLOW}✍️  글 제목을 입력하세요:${NC}"
read -r title

if [ -z "$title" ]; then
    echo -e "${RED}❌ 제목을 입력해주세요.${NC}"
    exit 1
fi

# 파일명 생성 (한글 제목을 파일명으로 변환)
filename=$(echo "$title" | sed 's/ /-/g').md
current_date=$(date +%Y-%m-%d)

# 연도별 디렉터리 생성
mkdir -p "content/posts/$current_year"

# 파일 경로
filepath="content/posts/$current_year/$filename"

# 이미 존재하는 파일인지 확인
if [ -f "$filepath" ]; then
    echo -e "${YELLOW}⚠️  같은 이름의 파일이 이미 존재합니다: $filepath${NC}"
    echo -e "${YELLOW}🔄 덮어쓰시겠습니까? (y/N):${NC}"
    read -r overwrite
    if [[ ! "$overwrite" =~ ^[Yy]$ ]]; then
        echo -e "${BLUE}💡 다른 제목으로 다시 시도해주세요.${NC}"
        exit 0
    fi
fi

# 마크다운 파일 생성
cat > "$filepath" << EOF
---
title: '$title'
date: $current_date
---

여기에 글 내용을 작성하세요.
EOF

echo -e "${GREEN}✅ 새 글이 생성되었습니다!${NC}"
echo -e "${BLUE}📁 파일 위치: $filepath${NC}"
echo -e "${YELLOW}📝 이제 파일을 편집한 후 './deploy.sh'를 실행하여 배포하세요!${NC}"

# 파일을 에디터로 열기 (선택사항)
echo -e "${BLUE}🖊️  지금 바로 편집하시겠습니까? (y/N):${NC}"
read -r edit_now
if [[ "$edit_now" =~ ^[Yy]$ ]]; then
    # VS Code가 있으면 VS Code로, 없으면 기본 에디터로
    if command -v code &> /dev/null; then
        code "$filepath"
    elif command -v nano &> /dev/null; then
        nano "$filepath"
    else
        open "$filepath"
    fi
fi