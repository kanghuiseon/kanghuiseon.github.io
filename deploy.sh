#!/bin/bash

# 색상 정의
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}🚀 Hugo 블로그 배포를 시작합니다...${NC}"

# Git 상태 확인
if [[ -n $(git status --porcelain) ]]; then
    echo -e "${YELLOW}📝 변경된 파일들:${NC}"
    git status --short
    
    # 커밋 메시지 입력받기
    echo -e "${BLUE}💬 커밋 메시지를 입력하세요 (기본값: 'Add new post'):${NC}"
    read -r commit_message
    
    # 기본값 설정
    if [ -z "$commit_message" ]; then
        commit_message="Add new post"
    fi
    
    # Git add, commit, push
    echo -e "${YELLOW}📦 파일들을 스테이징합니다...${NC}"
    git add .
    
    echo -e "${YELLOW}💾 커밋을 생성합니다...${NC}"
    git commit -m "$commit_message"
    
    echo -e "${YELLOW}🌐 GitHub에 푸시합니다...${NC}"
    git push origin main
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✅ 성공적으로 푸시되었습니다!${NC}"
        echo -e "${GREEN}🎉 GitHub Actions가 자동으로 배포를 시작합니다.${NC}"
        echo -e "${BLUE}🔗 진행 상황: https://github.com/kanghuiseon/kanghuiseon.github.io/actions${NC}"
        echo -e "${BLUE}🌐 블로그: https://blog.hisun.cloud${NC}"
    else
        echo -e "${RED}❌ 푸시 중 오류가 발생했습니다.${NC}"
        exit 1
    fi
else
    echo -e "${GREEN}✅ 변경된 파일이 없습니다.${NC}"
    echo -e "${BLUE}💡 새 글을 추가한 후 다시 실행해주세요.${NC}"
fi

echo -e "${GREEN}🏁 배포 프로세스가 완료되었습니다!${NC}"