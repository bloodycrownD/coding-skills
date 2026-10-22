# sync-skills.ps1 - sync dev-skills to deployment dir (~/.agents/skills), hash-verified per skill.
# Usage: powershell -ExecutionPolicy Bypass -File sync-skills.ps1
# Rule: always run this after editing dev-skills; trust hashes, not memory.
# NOTE: keep this file ASCII-only (PowerShell 5.1 reads BOM-less files as ANSI).

$src = Join-Path $PSScriptRoot "dev-skills"
$dst = Join-Path $env:USERPROFILE ".agents\skills"
if (-not (Test-Path $dst)) { New-Item -ItemType Directory -Path $dst | Out-Null }

$fail = 0
foreach ($dir in Get-ChildItem $src -Directory) {
    $skill = Join-Path $dir.FullName "SKILL.md"
    if (-not (Test-Path $skill)) { continue }
    $targetDir = Join-Path $dst $dir.Name
    New-Item -ItemType Directory -Path $targetDir -Force | Out-Null
    $target = Join-Path $targetDir "SKILL.md"
    Copy-Item $skill $target -Force
    $h1 = (Get-FileHash $skill -Algorithm MD5).Hash
    $h2 = (Get-FileHash $target -Algorithm MD5).Hash
    if ($h1 -eq $h2) { Write-Output ("OK    " + $dir.Name) }
    else { Write-Output ("FAIL  " + $dir.Name); $fail++ }
}

# skills deployed but removed from source repo: list for manual confirmation (no auto-delete)
$srcNames = (Get-ChildItem $src -Directory).Name
foreach ($d in Get-ChildItem $dst -Directory) {
    if ($srcNames -notcontains $d.Name) {
        Write-Output ("STALE " + $d.Name + " (not in dev-skills; delete manually after confirming)")
    }
}

if ($fail -gt 0) { Write-Output ("DONE with " + $fail + " FAILED verifications"); exit 1 }
else { Write-Output "DONE, all hashes match" }
