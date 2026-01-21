# Git 명령어 가이드

## 초기 설정 (bexelpatra 계정)

```bash
# Git 사용자 정보 설정
git config --global user.name "bexelpatra"
git config --global user.email "bexelpatra@example.com"  # 실제 이메일로 변경

# 설정 확인
git config --global user.name
git config --global user.email
```

## 기본 명령어

### 저장소 상태 확인
```bash
# 현재 상태 확인
git status

# 변경 내역 확인
git diff

# 커밋 히스토리 확인
git log
git log --oneline  # 한 줄로 보기
```

### 파일 추가 및 커밋
```bash
# 특정 파일 스테이징
git add <파일명>

# 모든 변경사항 스테이징
git add .

# 커밋하기
git commit -m "커밋 메시지"

# 스테이징과 커밋 동시에 (이미 추적 중인 파일만)
git commit -am "커밋 메시지"
```

### 원격 저장소 작업

```bash
# 원격 저장소 확인
git remote -v

# 원격 저장소 추가
git remote add origin https://github.com/bexelpatra/<저장소명>.git

# 원격 저장소에서 가져오기
git fetch origin

# 원격 저장소에서 가져오기 + 병합
git pull origin main

# 원격 저장소로 푸시
git push origin main

# 처음 푸시할 때 (upstream 설정)
git push -u origin main

# upstream 설정 후에는
git push
```

### 브랜치 관리
```bash
# 브랜치 목록 확인
git branch

# 새 브랜치 생성
git branch <브랜치명>

# 브랜치 전환
git checkout <브랜치명>

# 브랜치 생성 + 전환
git checkout -b <브랜치명>

# 브랜치 삭제
git branch -d <브랜치명>

# 브랜치 병합 (현재 브랜치에 다른 브랜치 병합)
git merge <브랜치명>
```

### 변경 취소
```bash
# 파일 변경 취소 (unstaged)
git checkout -- <파일명>

# 스테이징 취소
git reset HEAD <파일명>

# 마지막 커밋 취소 (변경사항은 유지)
git reset --soft HEAD~1

# 마지막 커밋 취소 (변경사항도 삭제)
git reset --hard HEAD~1
```

## GitHub 인증 (bexelpatra)

### Personal Access Token 사용 (권장)

1. GitHub에서 Personal Access Token 생성:
   - Settings → Developer settings → Personal access tokens → Tokens (classic)
   - Generate new token 클릭
   - repo 권한 선택
   - 토큰 복사

2. 푸시 시 인증:
   ```bash
   git push origin main
   # Username: bexelpatra
   # Password: <생성한 토큰>
   ```

3. 자격 증명 저장 (매번 입력 방지):
   ```bash
   git config --global credential.helper store
   ```

### SSH 키 사용

```bash
# SSH 키 생성
ssh-keygen -t ed25519 -C "bexelpatra@example.com"

# SSH 키 확인
cat ~/.ssh/id_ed25519.pub

# GitHub에 SSH 키 등록:
# Settings → SSH and GPG keys → New SSH key
# 위에서 복사한 공개키 붙여넣기

# SSH URL로 원격 저장소 변경
git remote set-url origin git@github.com:bexelpatra/<저장소명>.git
```

## 자주 사용하는 워크플로우

### 새 프로젝트 시작
```bash
git init
git add .
git commit -m "Initial commit"
git remote add origin https://github.com/bexelpatra/<저장소명>.git
git push -u origin main
```

### 일반적인 작업 흐름
```bash
# 1. 변경사항 확인
git status

# 2. 파일 스테이징
git add .

# 3. 커밋
git commit -m "작업 내용 설명"

# 4. 푸시
git push
```

### 협업 시
```bash
# 1. 최신 코드 받기
git pull

# 2. 작업

# 3. 커밋 및 푸시
git add .
git commit -m "작업 내용"
git push
```

## 현재 프로젝트 푸시하기

```bash
# 1. 현재 상태 확인
git status

# 2. .gitignore 추가
git add .gitignore

# 3. 커밋
git commit -m "Add .gitignore"

# 4. 원격 저장소 추가 (아직 안했다면)
git remote add origin https://github.com/bexelpatra/<저장소명>.git

# 5. 푸시
git push -u origin main
```

## 유용한 팁

```bash
# 커밋 히스토리를 그래프로 보기
git log --graph --oneline --all

# 특정 파일의 변경 이력 확인
git log -p <파일명>

# 마지막 커밋 메시지 수정
git commit --amend -m "새로운 메시지"

# 임시 저장 (stash)
git stash
git stash pop

# 특정 커밋으로 이동
git checkout <커밋 해시>

# 원격 브랜치 목록 확인
git branch -r
```
