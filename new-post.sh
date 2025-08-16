#!/bin/bash

# 색상 정의
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
RED='\033[0;31m'
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

# 영문 슬러그 생성을 위한 간단한 제안
echo -e "${YELLOW}🔗 URL 슬러그를 입력하세요 (영문 권장, 예: my-new-post):${NC}"
echo -e "${BLUE}💡 비워두면 자동 생성됩니다${NC}"
read -r slug

# 슬러그가 비어있으면 제목을 기반으로 자동 생성
if [ -z "$slug" ]; then
    # 한글과 특수문자를 제거하고 영문/숫자/하이픈만 남김
    slug=$(echo "$title" | sed 's/[^a-zA-Z0-9가-힣 ]//g' | sed 's/ /-/g' | tr '[:upper:]' '[:lower:]')
    # 연속된 하이픈 정리
    slug=$(echo "$slug" | sed 's/-\+/-/g' | sed 's/^-\|-$//g')
    
    # 한글이 포함된 경우 기본 슬러그 제안
    if [[ "$slug" =~ [가-힣] ]]; then
        slug="post-$(date +%m%d)"
        echo -e "${YELLOW}⚠️  한글 제목이므로 기본 슬러그를 제안합니다: $slug${NC}"
        echo -e "${BLUE}🔄 다른 슬러그를 원하시면 입력하세요 (엔터시 '$slug' 사용):${NC}"
        read -r custom_slug
        if [ -n "$custom_slug" ]; then
            slug="$custom_slug"
        fi
    fi
fi

# 파일명 생성 (영문 슬러그 기반)
filename="${slug}.md"
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

# 기존 글들의 weight 값을 확인하고 조정
echo -e "${BLUE}🔄 기존 글들의 순서를 조정 중...${NC}"

# content/posts 디렉터리의 모든 .md 파일을 찾아서 weight 값 증가
find content/posts -name "*.md" -type f | while read -r file; do
    # 파일에 weight 속성이 있는지 확인
    if grep -q "^weight:" "$file"; then
        # 기존 weight 값을 1 증가
        current_weight=$(grep "^weight:" "$file" | sed 's/weight: *//')
        new_weight=$((current_weight + 1))
        sed -i.bak "s/^weight: .*/weight: $new_weight/" "$file"
        rm -f "$file.bak"  # 백업 파일 삭제
    else
        # weight 속성이 없으면 date 라인 다음에 weight: 2 추가
        sed -i.bak '/^date:/a\
weight: 2' "$file"
        rm -f "$file.bak"  # 백업 파일 삭제
    fi
done

# 새 글은 weight: 1로 설정 (가장 위에 표시)
cat > "$filepath" << EOF
---
title: '$title'
date: $current_date
weight: 1
slug: "$slug"
---

여기에 글 내용을 작성하세요.
EOF

echo -e "${GREEN}✅ 새 글이 생성되었습니다!${NC}"
echo -e "${BLUE}📁 파일 위치: $filepath${NC}"
echo -e "${BLUE}🔗 URL 슬러그: $slug${NC}"
echo -e "${GREEN}🔝 새 글이 목록 맨 위에 표시되도록 설정되었습니다! (weight: 1)${NC}"
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