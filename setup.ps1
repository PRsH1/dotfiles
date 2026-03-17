Write-Host "Claude dotfiles 설정 시작..." -ForegroundColor Cyan

$dotfilesDir = "$env:USERPROFILE\dotfiles\claude"

# Claude Desktop - 파일 직접 복사
$claudePackage = Get-ChildItem "$env:LOCALAPPDATA\Packages" |
  Where-Object { $_.Name -like "Claude_*" } |
  Select-Object -First 1

if (-not $claudePackage) {
  Write-Host "Claude Desktop 앱을 찾을 수 없습니다. 스킵합니다." -ForegroundColor Yellow
} else {
  $claudeDir    = "$($claudePackage.FullName)\LocalCache\Roaming\Claude"
  $configTarget = "$claudeDir\claude_desktop_config.json"
  $configSource = "$dotfilesDir\claude_desktop_config.json"

  if (-not (Test-Path $claudeDir)) { mkdir $claudeDir }

  $content = Get-Content $configSource -Raw
  $utf8NoBom = New-Object System.Text.UTF8Encoding $false
  [System.IO.File]::WriteAllText($configTarget, $content, $utf8NoBom)
  Write-Host "Claude Desktop config 복사 완료" -ForegroundColor Green
  Write-Host "   -> $configTarget" -ForegroundColor Gray
}

# Claude Code - 심볼릭 링크
$codeDir    = "$env:USERPROFILE\.claude"
$codeSource = "$dotfilesDir\claude_code_settings.json"
$codeTarget = "$codeDir\settings.json"

if (-not (Test-Path $codeDir)) { mkdir $codeDir }
if (Test-Path $codeTarget) { Remove-Item $codeTarget }

New-Item -ItemType SymbolicLink -Path $codeTarget -Target $codeSource
Write-Host "Claude Code settings 링크 완료" -ForegroundColor Green
Write-Host "   -> $codeTarget" -ForegroundColor Gray

# Claude Code MCP - user 스코프 등록
Write-Host "Claude Code MCP 등록 중..." -ForegroundColor Cyan

claude mcp remove -s user filesystem 2>$null
claude mcp remove -s user context7 2>$null

claude mcp add -s user filesystem npx -- -y @modelcontextprotocol/server-filesystem "$env:USERPROFILE\Desktop" "$env:USERPROFILE\Downloads"
claude mcp add -s user context7 npx -- -y @upstash/context7-mcp

Write-Host "Claude Code MCP 등록 완료" -ForegroundColor Green
Write-Host ""
claude mcp list
Write-Host ""
Write-Host "완료! Claude Desktop을 재시작하세요." -ForegroundColor Yellow