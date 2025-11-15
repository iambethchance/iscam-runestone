<#
.SYNOPSIS
Build the PreTeXt book inside the official PreTeXt Docker image.

.DESCRIPTION
This script runs the PreTeXt Docker image and mounts the current project directory
into the container. It defaults to building the `html` target. Use -Target to change
(e.g. `runestone`).

Usage:
    .\build-docker.ps1                # build html and open index if present
    .\build-docker.ps1 -Target runestone -Pull
    .\build-docker.ps1 -NoOpen

.PARAMETER Target
The build target to pass to PreTeXt (html or runestone).

.PARAMETER Pull
If present, pull the Docker image before running.

.PARAMETER NoOpen
If present, do not attempt to open the generated index.html after the build.

#>
param(
    [ValidateSet('html','runestone')]
    [string]$Target = 'html',

    [switch]$Pull,

    [switch]$NoOpen,

    [string]$Image = 'pretextbook/pretext:latest'
)

function Write-Info { param($m) Write-Host $m -ForegroundColor Cyan }
function Write-Success { param($m) Write-Host $m -ForegroundColor Green }
function Write-Warn { param($m) Write-Host $m -ForegroundColor Yellow }
function Write-ErrorMsg { param($m) Write-Host $m -ForegroundColor Red }

# Check docker available
try {
    $null = & docker --version 2>$null
    if ($LASTEXITCODE -ne 0) { throw 'docker not available' }
} catch {
    Write-ErrorMsg "Docker does not appear to be installed or not in PATH."
    Write-ErrorMsg "Install Docker Desktop (https://www.docker.com/products/docker-desktop) and try again."
    exit 1
}

# Optional pull
if ($Pull) {
    Write-Info "Pulling image $Image..."
    & docker pull $Image
    if ($LASTEXITCODE -ne 0) {
        Write-ErrorMsg "Failed to pull image $Image"
        exit 1
    }
}

# Resolve host path (string form)
$hostPath = (Get-Location).Path
# Docker on Windows (Docker Desktop) accepts Windows paths here; wrap in quotes for safety
$mountArg = "${hostPath}:/work"

Write-Info "Running PreTeXt inside Docker (target: $Target)"
Write-Info "Mounting: $hostPath -> /work"

$dockerArgs = @('run','--rm','-v',$mountArg,'-w','/work',$Image,'pretext','build',$Target)

Write-Info "docker $($dockerArgs -join ' ')"

# Execute docker run in-process so output and exit code are visible here
& docker @dockerArgs
$exit = $LASTEXITCODE
if ($exit -ne 0) {
    Write-ErrorMsg "Docker run failed with exit code $exit. See the output above for details."
    exit $exit
}

# Open output if present
$outputDir = Join-Path $hostPath "output\$Target"
$indexFile = Join-Path $outputDir 'index.html'

if ((Test-Path $indexFile) -and (-not $NoOpen)) {
    Write-Success "Build completed and index found at: $indexFile"
    Write-Info "Opening index in default browser..."
    Start-Process $indexFile
} else {
    if (Test-Path $outputDir) {
        Write-Success "Build completed. Output directory: $outputDir"
        if (-not (Test-Path $indexFile)) { Write-Warn "index.html not found in output; check $outputDir for files." }
    } else {
        Write-Warn "Build finished but no output directory was created: $outputDir"
    }
}
