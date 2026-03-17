# dotfiles

Claude Desktop + Claude Code MCP 설정 관리 (Windows)

---

##  구조
```
dotfiles/
 claude/
    claude_desktop_config.json   # Claude Desktop MCP 설정
    claude_code_settings.json    # Claude Code MCP 설정 (글로벌)
 setup.ps1                        # 심볼릭 링크 자동 세팅
 .gitignore
 README.md
```

---

##  새 PC 세팅

### 1. 사전 준비
```powershell
# 개발자 모드 ON
# Windows 설정  시스템  개발자용  개발자 모드 ON

# PowerShell 실행 정책 허용
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser

# Git 설치 확인
git --version

# Claude Code 설치 확인
npm install -g @anthropic-ai/claude-code
```

### 2. dotfiles clone
```powershell
git clone https://github.com/yourname/dotfiles.git "$env:USERPROFILE\dotfiles"
```

### 3. 심볼릭 링크 세팅
```powershell
cd "$env:USERPROFILE\dotfiles"
.\setup.ps1
```

### 4. 환경변수 등록 (필요 시)
```powershell
# Anthropic API Key
[System.Environment]::SetEnvironmentVariable("ANTHROPIC_API_KEY", "sk-ant-실제키값", "User")

# GitHub Token (GitHub MCP 사용 시)
[System.Environment]::SetEnvironmentVariable("GITHUB_TOKEN", "ghp_실제토큰값", "User")
```

### 5. Claude Desktop / Code 재시작  완료! 

---

##  설정 파일 수정 방법

### Claude Desktop MCP 수정
```powershell
notepad "$env:USERPROFILE\dotfiles\claude\claude_desktop_config.json"
```

### Claude Code MCP 수정
```powershell
notepad "$env:USERPROFILE\dotfiles\claude\claude_code_settings.json"
```

수정 후 변경사항 저장:
```powershell
cd "$env:USERPROFILE\dotfiles"
git add .
git commit -m "feat: MCP 설정 변경 내용 요약"
git push
```

>  심볼릭 링크 덕분에 파일 수정 후 Claude 재시작만 하면 바로 반영됩니다.  
>  git push 후 다른 PC에서 git pull 하면 자동 동기화됩니다.

---

##  다른 PC에서 설정 동기화
```powershell
cd "$env:USERPROFILE\dotfiles"
git pull
# Claude Desktop / Code 재시작  완료! 
```

---

##  MCP 서버 추가 예시

### filesystem (로컬 파일 접근)
```json
"mcpServers": {
  "filesystem": {
    "command": "npx",
    "args": [
      "-y",
      "@modelcontextprotocol/server-filesystem",
      "${USERPROFILE}\\Desktop",
      "${USERPROFILE}\\Downloads"
    ]
  }
}
```

### GitHub (PR, 이슈, 코드 검색)
```json
"mcpServers": {
  "github": {
    "command": "npx",
    "args": ["-y", "@modelcontextprotocol/server-github"],
    "env": {
      "GITHUB_TOKEN": "${GITHUB_TOKEN}"
    }
  }
}
```

---

##  주의사항

- API 키, Token 등 민감한 값은 절대 이 파일에 직접 작성하지 마세요.
- 민감한 값은 환경변수로 등록 후 `${변수명}` 형태로 참조하세요.
- 설정 파일 수정 후에는 반드시 Claude Desktop / Code를 재시작하세요.
