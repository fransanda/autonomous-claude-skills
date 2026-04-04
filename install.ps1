# install.ps1 — Install autonomous Claude Code skills
# Run: irm https://raw.githubusercontent.com/fransanda/autonomous-claude-skills/main/install.ps1 | iex
# Or:  .\install.ps1 (after cloning)

# Install to BOTH possible skill directories (Claude Code reads from one or the other)
$skillsDirs = @(
    "$env:USERPROFILE\.claude\skills",
    "$env:USERPROFILE\.agents\skills"
)

Write-Host ""
Write-Host "Installing autonomous Claude Code skills..." -ForegroundColor Cyan
Write-Host ""

foreach ($skillsDir in $skillsDirs) {
    foreach ($skill in @("kickoff", "autonomy", "ship")) {
        $dest = "$skillsDir\$skill"
        if (!(Test-Path $dest)) {
            New-Item -ItemType Directory -Path $dest -Force | Out-Null
        }
        
        $source = Join-Path $PSScriptRoot "skills\$skill\SKILL.md"
        if (Test-Path $source) {
            Copy-Item $source "$dest\SKILL.md" -Force
        }
    }
}

Write-Host "  Installed /kickoff" -ForegroundColor Green
Write-Host "  Installed /autonomy" -ForegroundColor Green
Write-Host "  Installed /ship" -ForegroundColor Green
Write-Host ""
Write-Host "Done! Restart Claude Code, then use:" -ForegroundColor Green
Write-Host "  /kickoff [description]  — start a new project" -ForegroundColor White
Write-Host "  /autonomy               — add autonomy to existing project" -ForegroundColor White
Write-Host "  /ship                    — wrap up and prepare for testing" -ForegroundColor White
Write-Host ""
