# sync-skills.ps1 - sync skills (repo root, incl. reference/) to deployment dir (~/.agents/skills), hash-verified per file.
# Usage: powershell -ExecutionPolicy Bypass -File sync-skills.ps1
# Rule: always run this after editing skills; trust hashes, not memory.
# NOTE: keep this file ASCII-only (PowerShell 5.1 reads BOM-less files as ANSI).

$src = $PSScriptRoot          # skills live flat at repo root
$dst = Join-Path $env:USERPROFILE ".agents\skills"
if (-not (Test-Path $dst)) { New-Item -ItemType Directory -Path $dst | Out-Null }

$fail = 0
foreach ($dir in Get-ChildItem $src -Directory) {
    $skill = Join-Path $dir.FullName "SKILL.md"
    if (-not (Test-Path $skill)) { continue }   # not a skill dir (docs/.git etc.)
    $targetDir = Join-Path $dst $dir.Name
    # mirror whole dir (SKILL.md + reference/); wipe target first so removed files do not linger
    if (Test-Path $targetDir) { Remove-Item $targetDir -Recurse -Force }
    Copy-Item $dir.FullName $targetDir -Recurse -Force
    # verify every file hash
    $count = 0
    foreach ($f in Get-ChildItem $targetDir -Recurse -File) {
        $rel = $f.FullName.Substring($targetDir.Length + 1)
        $srcf = Join-Path $dir.FullName $rel
        $h1 = (Get-FileHash $srcf -Algorithm MD5).Hash
        $h2 = (Get-FileHash $f.FullName -Algorithm MD5).Hash
        if ($h1 -ne $h2) { Write-Output ("FAIL  " + $dir.Name + "\" + $rel); $fail++ }
        $count++
    }
    Write-Output ("OK    " + $dir.Name + " (" + $count + " files)")
}

# skills deployed but removed from source repo: list for manual confirmation (no auto-delete)
$srcNames = (Get-ChildItem $src -Directory | Where-Object { Test-Path (Join-Path $_.FullName "SKILL.md") }).Name
foreach ($d in Get-ChildItem $dst -Directory) {
    if ($srcNames -notcontains $d.Name) {
        Write-Output ("STALE " + $d.Name + " (not in repo; delete manually after confirming)")
    }
}

if ($fail -gt 0) { Write-Output ("DONE with " + $fail + " FAILED verifications"); exit 1 }
else { Write-Output "DONE, all hashes match" }
