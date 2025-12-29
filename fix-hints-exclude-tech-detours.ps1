# Script to move <hint> tags inside <statement> blocks, excluding tech detour exercises
# This fixes XML structure issues where hints need to be inside statement blocks

$files = Get-ChildItem -Path source -Recurse -Filter *.ptx

$modifiedFiles = @()
$skippedTechDetours = @()

foreach ($file in $files) {
    $content = Get-Content $file.FullName -Raw
    $originalContent = $content
    $modified = $false
    
    # Split content into lines for processing
    $lines = $content -split "`r?`n"
    $result = New-Object System.Collections.ArrayList
    
    $i = 0
    while ($i -lt $lines.Count) {
        $line = $lines[$i]
        
        # Check if we're at the start of an exercise
        if ($line -match '<exercise\s') {
            # Look ahead to see if this is a tech-detour exercise
            $isTechDetour = $false
            $exerciseBlock = ""
            $j = $i
            
            # Scan the exercise opening tag and first few lines to check xml:id and title
            $linesToCheck = 10  # Check first 10 lines of exercise
            $checkCount = 0
            while ($j -lt $lines.Count -and $checkCount -lt $linesToCheck) {
                $exerciseBlock += $lines[$j] + "`n"
                $j++
                $checkCount++
                if ($lines[$j-1] -match '</title>') {
                    break  # We've seen the title, no need to check further
                }
            }
            
            # Check if xml:id contains "tech-detour" or title contains "Technology Detour"
            if ($exerciseBlock -match 'xml:id\s*=\s*[''"].*tech-detour.*[''"]') {
                $isTechDetour = $true
                $skippedTechDetours += "$($file.Name): Found tech-detour exercise (xml:id)"
            }
            elseif ($exerciseBlock -match '<title>.*Technology Detour.*</title>') {
                $isTechDetour = $true
                $skippedTechDetours += "$($file.Name): Found tech-detour exercise (title)"
            }
            
            if ($isTechDetour) {
                # Skip this exercise - don't modify it
                [void]$result.Add($line)
                $i++
                continue
            }
        }
        
        # Check if this line closes a statement tag and the next non-empty line starts a hint
        if ($line -match '^\s*</statement>\s*$') {
            # Look ahead to find the next significant line
            $nextLineIdx = $i + 1
            while ($nextLineIdx -lt $lines.Count -and $lines[$nextLineIdx] -match '^\s*$') {
                $nextLineIdx++
            }
            
            if ($nextLineIdx -lt $lines.Count -and $lines[$nextLineIdx] -match '^\s*<hint') {
                # We found a hint after the statement closure
                # We need to move hints inside the statement
                
                # First, collect all the whitespace lines between statement and hint
                $whitespaceLines = @()
                for ($k = $i + 1; $k -lt $nextLineIdx; $k++) {
                    $whitespaceLines += $lines[$k]
                }
                
                # Collect all hint blocks
                $hintBlocks = New-Object System.Collections.ArrayList
                $currentHint = @()
                $hintDepth = 0
                $inHint = $false
                
                $k = $nextLineIdx
                while ($k -lt $lines.Count) {
                    $currentLine = $lines[$k]
                    
                    if ($currentLine -match '^\s*<hint') {
                        $inHint = $true
                        $hintDepth = 1
                        $currentHint = @($currentLine)
                    }
                    elseif ($inHint) {
                        $currentHint += $currentLine
                        
                        # Track nested tags
                        if ($currentLine -match '<hint') {
                            $hintDepth++
                        }
                        if ($currentLine -match '</hint>') {
                            $hintDepth--
                            if ($hintDepth -eq 0) {
                                [void]$hintBlocks.Add($currentHint)
                                $currentHint = @()
                                $inHint = $false
                                
                                # Check if there's another hint coming
                                $nextK = $k + 1
                                while ($nextK -lt $lines.Count -and $lines[$nextK] -match '^\s*$') {
                                    $nextK++
                                }
                                if ($nextK -ge $lines.Count -or $lines[$nextK] -notmatch '^\s*<hint') {
                                    # No more hints, we're done
                                    $k++
                                    break
                                }
                            }
                        }
                    }
                    else {
                        break
                    }
                    $k++
                }
                
                if ($hintBlocks.Count -gt 0) {
                    # Add the hint blocks before the </statement> tag
                    foreach ($hintBlock in $hintBlocks) {
                        foreach ($hintLine in $hintBlock) {
                            [void]$result.Add($hintLine)
                        }
                    }
                    
                    # Now add the </statement> tag
                    [void]$result.Add($line)
                    
                    # Skip past the whitespace and hint blocks we already added
                    $i = $k - 1
                    $modified = $true
                }
                else {
                    [void]$result.Add($line)
                }
            }
            else {
                [void]$result.Add($line)
            }
        }
        else {
            [void]$result.Add($line)
        }
        
        $i++
    }
    
    if ($modified) {
        $newContent = $result -join "`r`n"
        Set-Content -Path $file.FullName -Value $newContent -NoNewline
        $modifiedFiles += $file.FullName
        Write-Host "Modified: $($file.FullName)" -ForegroundColor Green
    }
}

Write-Host "`n=== Summary ===" -ForegroundColor Cyan
Write-Host "Modified $($modifiedFiles.Count) files" -ForegroundColor Green
Write-Host "Skipped $($skippedTechDetours.Count) tech-detour exercises" -ForegroundColor Yellow

if ($skippedTechDetours.Count -gt 0) {
    Write-Host "`nSkipped tech-detour exercises:" -ForegroundColor Yellow
    $skippedTechDetours | ForEach-Object { Write-Host "  $_" }
}

Write-Host "`nModified files:" -ForegroundColor Green
$modifiedFiles | ForEach-Object { Write-Host "  $_" }
