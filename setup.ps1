# Encoding: UTF-8
$OutputEncoding = [System.Text.Encoding]::UTF8
[Console]::OutputEncoding = [System.Text.Encoding]::UTF8

Write-Host "Claude dotfiles setup starting..." -ForegroundColor Cyan

$dotfilesDir = "$env:USERPROFILE\dotfiles\claude"

# Claude Desktop - Copy config file
$claudePackage = Get-ChildItem "$env:LOCALAPPDATA\Packages" |
  Where-Object { $_.Name -like "Claude_*" } |
  Select-Object -First 1

if (-not $claudePackage) {
  Write-Host "[SKIP] Claude Desktop app not found." -ForegroundColor Yellow
} else {
  $claudeDir    = "$($claudePackage.FullName)\LocalCache\Roaming\Claude"
  $configTarget = "$claudeDir\claude_desktop_config.json"
  $configSource = "$dotfilesDir\claude_desktop_config.json"

  if (-not (Test-Path $claudeDir)) { mkdir $claudeDir }

  $content = Get-Content $configSource -Raw
  $utf8NoBom = New-Object System.Text.UTF8Encoding $false
  [System.IO.File]::WriteAllText($configTarget, $content, $utf8NoBom)
  Write-Host "[OK] Claude Desktop config copied" -ForegroundColor Green
  Write-Host "     -> $configTarget" -ForegroundColor Gray
}

# Claude Code - Symbolic link
$codeDir    = "$env:USERPROFILE\.claude"
$codeSource = "$dotfilesDir\claude_code_settings.json"
$codeTarget = "$codeDir\settings.json"

if (-not (Test-Path $codeDir)) { mkdir $codeDir }
if (Test-Path $codeTarget) { Remove-Item $codeTarget }

New-Item -ItemType SymbolicLink -Path $codeTarget -Target $codeSource
Write-Host "[OK] Claude Code settings symlinked" -ForegroundColor Green
Write-Host "     -> $codeTarget" -ForegroundColor Gray

# Claude Code MCP - Register user scope
Write-Host "Registering Claude Code MCP servers..." -ForegroundColor Cyan

claude mcp remove -s user filesystem 2>$null
claude mcp remove -s user context7 2>$null

claude mcp add -s user filesystem npx -- -y @modelcontextprotocol/server-filesystem "$env:USERPROFILE\Desktop" "$env:USERPROFILE\Downloads"
claude mcp add -s user context7 npx -- -y @upstash/context7-mcp

Write-Host "[OK] Claude Code MCP registered" -ForegroundColor Green
Write-Host ""
claude mcp list
Write-Host ""
Write-Host "Done! Please restart Claude Desktop." -ForegroundColor Yellow