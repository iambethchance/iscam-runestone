# PowerShell script to download all ISCAM data files
# This will download files from rossmanchance.com and put them in the data folder

$dataFolder = "c:\Users\bchance\repos\iscam-runestone\data"

# Ensure data folder exists
if (-not (Test-Path $dataFolder)) {
    New-Item -ItemType Directory -Path $dataFolder -Force
}

# List of data file URLs from iscam3 and iscam4
# You can add more URLs here as needed
$dataFiles = @(
    "https://www.rossmanchance.com/iscam3/data/InfantData.txt",
    "https://www.rossmanchance.com/iscam3/data/Reese.txt",
    "https://www.rossmanchance.com/iscam3/data/Kissing.txt",
    "https://www.rossmanchance.com/iscam3/data/AIDS.txt",
    "https://www.rossmanchance.com/iscam3/data/BaseballSalaries2011.txt",
    "https://www.rossmanchance.com/iscam3/data/Caffeine.txt",
    "https://www.rossmanchance.com/iscam3/data/Gettysburg.txt",
    "https://www.rossmanchance.com/iscam3/data/Sleepdeprived.txt"
    # Add more URLs here as you identify them
)

Write-Host "Starting download of data files..." -ForegroundColor Green
Write-Host ""

foreach ($url in $dataFiles) {
    try {
        $fileName = Split-Path $url -Leaf
        $outputPath = Join-Path $dataFolder $fileName
        
        Write-Host "Downloading $fileName..." -ForegroundColor Cyan
        Invoke-WebRequest -Uri $url -OutFile $outputPath -ErrorAction Stop
        Write-Host "  ✓ Successfully downloaded $fileName" -ForegroundColor Green
    }
    catch {
        Write-Host "  ✗ Failed to download $fileName : $_" -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "Download complete! Files are in: $dataFolder" -ForegroundColor Green
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Yellow
Write-Host "1. Review the files in the data folder"
Write-Host "2. Run: git add data/"
Write-Host "3. Run: git commit -m 'Add ISCAM data files'"
Write-Host "4. Run: git push"
