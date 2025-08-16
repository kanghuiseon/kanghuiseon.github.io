# hi. sun 블로그

Hugo 기반의 개인 블로그입니다.

## 🚀 빠른 시작

### 새 글 작성하기

```bash
./new-post.sh
```

- 글 제목을 입력하면 자동으로 연도별 폴더에 마크다운 파일이 생성됩니다
- 생성된 파일을 편집하여 글을 작성하세요

### 배포하기

```bash
./deploy.sh
```

- 변경된 파일들을 자동으로 커밋하고 GitHub에 푸시합니다
- GitHub Actions가 자동으로 사이트를 빌드하고 배포합니다

## 📁 프로젝트 구조

```
├── .github/workflows/
│   └── deploy.yml          # GitHub Actions 자동 배포 설정
├── content/posts/
│   ├── 2025/              # 2025년 글들
│   └── 2024/              # 2024년 글들
├── layouts/
│   ├── _default/
│   │   ├── home.html      # 홈페이지 레이아웃
│   │   └── list.html      # 기본 목록 레이아웃
│   └── posts/
│       └── list.html      # 포스트 목록 레이아웃 (연도별 그룹핑)
├── themes/typo/           # Hugo 테마
├── deploy.sh              # 배포 스크립트
├── new-post.sh           # 새 글 생성 스크립트
└── hugo.toml             # Hugo 설정 파일
```

## 🛠️ 로컬 개발

```bash
# 개발 서버 시작
hugo server

# 또는 외부 접속 허용
hugo server --bind 0.0.0.0 --port 1313
```

## 🎨 특징

- **연도별 글 분류**: 2025, 2024 등 연도별로 글이 자동 그룹핑됩니다
- **자동 배포**: GitHub Actions를 통한 자동 빌드 및 배포
- **간편한 글 작성**: 스크립트를 통한 원클릭 글 생성 및 배포
- **깔끔한 디자인**: Typo 테마 기반의 미니멀한 디자인

## 🌐 배포 정보

- **사이트**: https://blog.hisun.cloud
- **저장소**: https://github.com/kanghuiseon/kanghuiseon.github.io
- **배포 상태**: GitHub Actions 자동 배포

## 📝 글 작성 가이드

1. `./new-post.sh` 실행
2. 글 제목 입력
3. 생성된 마크다운 파일 편집
4. `./deploy.sh` 실행하여 배포

매우 간단합니다! 🎉
