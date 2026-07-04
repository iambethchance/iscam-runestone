# One-time setup so `pretext validate` can find a `jing` schema validator.
#
# pretext-cli looks for a literal `jing` executable on PATH (via shutil.which).
# jingtrang (installed from requirements.txt) provides a cross-platform `pyjing`
# entrypoint instead, so this script drops a `jing.bat` shim next to it in the
# venv's Scripts folder.
#
# Prereqs (see CLAUDE.md "Dev Environment Setup"):
#   - venv created and requirements.txt installed via uv
#   - a Java runtime on PATH (e.g. `winget install EclipseAdoptium.Temurin.21.JRE`)
#
# Usage (from repo root, after `uv venv` + `uv pip install -r requirements.txt`):
#   powershell -ExecutionPolicy ByPass -File scripts/setup-jing.ps1

$ErrorActionPreference = "Stop"

$scriptsDir = Join-Path $PSScriptRoot "..\.venv\Scripts" | Resolve-Path
$pyjing = Join-Path $scriptsDir "pyjing.exe"

if (-not (Test-Path $pyjing)) {
    throw "pyjing.exe not found in $scriptsDir. Run 'uv pip install -r requirements.txt' first."
}

$jingBat = Join-Path $scriptsDir "jing.bat"
@"
@echo off
"%~dp0pyjing.exe" %*
"@ | Set-Content -Path $jingBat -Encoding ascii

Write-Host "Created $jingBat"
Write-Host "Verifying: pretext validate should now be able to find jing."
