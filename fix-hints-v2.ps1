# Script to move <hint> tags inside <statement> blocks, excluding tech detour exercises
# More robust version using regex replacement

$files = Get-ChildItem -Path source -Recurse -Filter *.ptx

$modifiedFiles = @()
$skippedTechDetours = @()
$totalChanges = 0

foreach ($file in $files) {
    $content = Get-Content $file.FullName -Raw
    $originalContent = $content
    $fileModified = $false
    
    # First, identify all tech-detour exercise blocks to protect them
    $techDetourRanges = @()
    $exercisePattern = '(?s)<exercise[^>]*(?:xml:id\s*=\s*[''"][^''"]*tech-detour[^''"]*[''"]|<title>[^<]*Technology Detour[^<]*</title>)[^>]*>.*?</exercise>'
    
    $matches = [regex]::Matches($content, $exercisePattern)
    foreach ($match in $matches) {
        $techDetourRanges += @{Start = $match.Index; End = $match.Index + $match.Length}
        $skippedTechDetours += "$($file.Name): line $($content.Substring(0, $match.Index).Split("`n").Count)"
    }
    
    # Function to check if a position is within a tech-detour exercise
    function IsInTechDetour($position) {
        foreach ($range in $techDetourRanges) {
            if ($position -ge $range.Start -and $position -le $range.End) {
                return $true
            }
        }
        return $false
    }
    
    # Pattern to find </statement> followed by optional <response/> and then <hint>
    $pattern = '(?s)(</statement>)([\s\r\n]*)(<response/>)?([\s\r\n]*)(<hint>.*?</hint>(?:[\s\r\n]*<hint>.*?</hint>)*)'
    
    $newContent = $content
    $offset = 0
    
    $matches = [regex]::Matches($content, $pattern)
    foreach ($match in $matches) {
        # Check if this match is within a tech-detour exercise
        if (IsInTechDetour($match.Index)) {
            continue
        }
        
        # Extract the parts
        $whitespace1 = $match.Groups[2].Value
        $response = $match.Groups[3].Value
        $whitespace2 = $match.Groups[4].Value
        $hints = $match.Groups[5].Value
        
        # Construct the replacement: hints before </statement>, then </statement>, then response
        $replacement = "$hints`r`n    </statement>"
        if ($response) {
            $replacement += "`r`n    $response"
        }
        
        # Calculate position with offset
        $matchStart = $match.Index + $offset
        $matchLength = $match.Length
        
        $newContent = $newContent.Substring(0, $matchStart) + $replacement + $newContent.Substring($matchStart + $matchLength)
        
        $offset += $replacement.Length - $matchLength
        $fileModified = $true
        $totalChanges++
    }
    
    if ($fileModified) {
        Set-Content -Path $file.FullName -Value $newContent -NoNewline
        $modifiedFiles += $file.FullName
        Write-Host "Modified: $($file.Name)" -ForegroundColor Green
    }
}

Write-Host "`n=== Summary ===" -ForegroundColor Cyan
Write-Host "Modified $($modifiedFiles.Count) files" -ForegroundColor Green
Write-Host "Made $totalChanges total changes" -ForegroundColor Green
Write-Host "Skipped $(($skippedTechDetours | Sort-Object -Unique).Count) tech-detour exercises" -ForegroundColor Yellow

if ($modifiedFiles.Count -gt 0) {
    Write-Host "`nModified files:" -ForegroundColor Green
    $modifiedFiles | ForEach-Object { Write-Host "  $_" }
}
