Write-Host " Claude dotfiles 설정 시작..." -ForegroundColor Cyan

$dotfilesDir = "$env:USERPROFILE\dotfiles\claude"

# 
# Claude Desktop
# 
$claudePackage = Get-ChildItem "$env:LOCALAPPDATA\Packages" |
  Where-Object { $_.Name -like "Claude_*" } |
  Select-Object -First 1

if (-not $claudePackage) {
  Write-Host "  Claude Desktop 앱을 찾을 수 없습니다. 스킵합니다." -ForegroundColor Yellow
} else {
  $claudeDir     = "$($claudePackage.FullName)\LocalCache\Roaming\Claude"
  $desktopSource = "$dotfilesDir\claude_desktop_config.json"
  $desktopTarget = "$claudeDir\claude_desktop_config.json"

  if (-not (Test-Path $claudeDir)) { mkdir $claudeDir }
  if (Test-Path $desktopTarget) { Remove-Item $desktopTarget }

  New-Item -ItemType SymbolicLink -Path $desktopTarget -Target $desktopSource
  Write-Host " Claude Desktop 링크 완료" -ForegroundColor Green
  Write-Host "   $desktopSource" -ForegroundColor Gray
  Write-Host "    $desktopTarget" -ForegroundColor Gray
}

# 
# Claude Code (CLI)
# 
$codeDir    = "$env:USERPROFILE\.claude"
$codeSource = "$dotfilesDir\claude_code_settings.json"
$codeTarget = "$codeDir\settings.json"

if (-not (Test-Path $codeDir)) { mkdir $codeDir }
if (Test-Path $codeTarget) { Remove-Item $codeTarget }

New-Item -ItemType SymbolicLink -Path $codeTarget -Target $codeSource
Write-Host " Claude Code 링크 완료" -ForegroundColor Green
Write-Host "   $codeSource" -ForegroundColor Gray
Write-Host "    $codeTarget" -ForegroundColor Gray

Write-Host ""
Write-Host " 완료! Claude Desktop/Code를 재시작하세요." -ForegroundColor Yellow
