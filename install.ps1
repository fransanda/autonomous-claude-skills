# install.ps1 — Install autonomous Claude Code skills
# Remote install: irm https://raw.githubusercontent.com/fransanda/autonomous-claude-skills/main/install.ps1 | iex
# Local install:  .\install.ps1 (from inside a cloned repo)

$ErrorActionPreference = "Stop"

$skillsDirs = @(
    "$env:USERPROFILE\.claude\skills",
    "$env:USERPROFILE\.agents\skills"
)

# Determine source: use the script's folder if it contains the skills,
# otherwise clone to a temp folder (needed for remote irm | iex install).
$tempClone = $null
if ($PSScriptRoot -and (Test-Path (Join-Path $PSScriptRoot "skills\kickoff\SKILL.md"))) {
    $sourceRoot = $PSScriptRoot
} else {
    if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
        Write-Host "Error: git is required to install. Install git first." -ForegroundColor Red
        exit 1
    }
    $tempClone = Join-Path $env:TEMP "_acs_install_$(Get-Random)"
    Write-Host "Fetching skills..." -ForegroundColor Cyan
    git clone --depth=1 --quiet https://github.com/fransanda/autonomous-claude-skills.git $tempClone
    $sourceRoot = $tempClone
}

Write-Host ""
Write-Host "Installing autonomous Claude Code skills..." -ForegroundColor Cyan
Write-Host ""

$installed = @()
foreach ($skill in @("kickoff", "autonomy", "ship")) {
    $source = Join-Path $sourceRoot "skills\$skill\SKILL.md"
    if (-not (Test-Path $source)) {
        Write-Host "  Source not found for /$skill — skipping" -ForegroundColor Yellow
        continue
    }
    foreach ($skillsDir in $skillsDirs) {
        $dest = "$skillsDir\$skill"
        New-Item -ItemType Directory -Path $dest -Force | Out-Null
        Copy-Item $source "$dest\SKILL.md" -Force
    }
    Write-Host "  Installed /$skill" -ForegroundColor Green
    $installed += $skill
}

if ($tempClone -and (Test-Path $tempClone)) {
    Remove-Item $tempClone -Recurse -Force
}

Write-Host ""
if ($installed.Count -eq 3) {
    Write-Host "Done! Restart Claude Code, then use:" -ForegroundColor Green
    Write-Host "  /kickoff [description]  — start a new project" -ForegroundColor White
    Write-Host "  /autonomy               — add autonomy to existing project" -ForegroundColor White
    Write-Host "  /ship                   — wrap up and prepare for testing" -ForegroundColor White
    Write-Host ""
    Write-Host "Also make sure GitHub CLI is installed:" -ForegroundColor Gray
    Write-Host "  winget install GitHub.cli" -ForegroundColor Gray
    Write-Host "  gh auth login" -ForegroundColor Gray
    Write-Host ""
} else {
    Write-Host "Installation incomplete. Installed: $($installed -join ', ')" -ForegroundColor Yellow
    Write-Host ""
}
