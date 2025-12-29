# Script to move <hint> tags inside <statement> blocks, but exclude tech-detour exercises
# Tech detour exercises have R/JMP instructions and should not be modified

$files = Get-ChildItem -Path source -Recurse -Filter *.ptx | Where-Object { $_.Name -notmatch 'backup|old' }

$modifiedFiles = @()
$skippedExercises = @()
$totalChanges = 0

foreach ($file in $files) {
    $content = Get-Content $file.FullName -Raw
    $originalContent = $content
    
    # Split into lines for line-by-line processing
    $lines = $content -split "`r?`n"
    $result = New-Object System.Collections.ArrayList
    
    $i = 0
    while ($i -lt $lines.Count) {
        $line = $lines[$i]
        
        # Check if we're at an exercise start
        if ($line -match '<exercise\s') {
            # Collect the entire exercise block to analyze it
            $exerciseStart = $i
            $exerciseDepth = 0
            $exerciseLines = New-Object System.Collections.ArrayList
            $j = $i
            
            while ($j -lt $lines.Count) {
                [void]$exerciseLines.Add($lines[$j])
                if ($lines[$j] -match '<exercise\s') { $exerciseDepth++ }
                if ($lines[$j] -match '</exercise>') {
                    $exerciseDepth--
                    if ($exerciseDepth -eq 0) {
                        $j++
                        break
                    }
                }
                $j++
            }
            
            $exerciseBlock = $exerciseLines -join "`n"
            
            # Check if this is a tech-detour exercise (don't modify)
            $isTechDetour = $false
            if ($exerciseBlock -match 'xml:id\s*=\s*[''"].*tech-detour.*[''"]') {
                $isTechDetour = $true
                $skippedExercises += "$($file.Name): tech-detour xml:id"
            }
            elseif ($exerciseBlock -match '<title>.*Technology Detour.*</title>') {
                $isTechDetour = $true
                $skippedExercises += "$($file.Name): Technology Detour title"
            }
            elseif ($exerciseBlock -match '<title>\s*(R|JMP)\s*(Instructions|Probability)') {
                $isTechDetour = $true
                $skippedExercises += "$($file.Name): R/JMP hint title"
            }
            
            if ($isTechDetour) {
                # Don't modify - just add all lines as-is
                foreach ($eLine in $exerciseLines) {
                    [void]$result.Add($eLine)
                }
                $i = $j
                continue
            }
            
            # Not a tech-detour exercise - check if we need to move hints
            # Look for pattern: </statement> followed by <response/> and/or <hint>
            $needsFixing = $false
            $statementEndIdx = -1
            $hintStartIdx = -1
            
            for ($k = 0; $k -lt $exerciseLines.Count; $k++) {
                if ($exerciseLines[$k] -match '^\s*</statement>\s*$') {
                    $statementEndIdx = $k
                }
                if ($statementEndIdx -ge 0 -and $exerciseLines[$k] -match '^\s*<hint') {
                    $hintStartIdx = $k
                    $needsFixing = $true
                    break
                }
            }
            
            if ($needsFixing) {
                # Need to move hints inside the statement
                # Find where to insert hints (before </statement>, preferably before <var>)
                $insertIdx = -1
                $varIdx = -1
                
                for ($k = 0; $k -lt $statementEndIdx; $k++) {
                    if ($exerciseLines[$k] -match '<var\s') {
                        if ($varIdx -eq -1) {
                            $varIdx = $k  # First var found
                        }
                    }
                }
                
                # Insert before first <var> if found, otherwise just before </statement>
                if ($varIdx -ge 0) {
                    $insertIdx = $varIdx
                } else {
                    $insertIdx = $statementEndIdx
                }
                
                # Collect all hint blocks after </statement>
                $hintLines = New-Object System.Collections.ArrayList
                $k = $hintStartIdx
                $hintDepth = 0
                $inHint = $false
                
                while ($k -lt $exerciseLines.Count) {
                    $eLine = $exerciseLines[$k]
                    
                    if ($eLine -match '^\s*<hint') {
                        $inHint = $true
                        $hintDepth++
                        [void]$hintLines.Add($eLine)
                    }
                    elseif ($inHint) {
                        [void]$hintLines.Add($eLine)
                        if ($eLine -match '</hint>') {
                            $hintDepth--
                            if ($hintDepth -eq 0) {
                                $inHint = $false
                                $k++
                                # Check if there's another hint coming
                                while ($k -lt $exerciseLines.Count -and $exerciseLines[$k] -match '^\s*$') {
                                    $k++
                                }
                                if ($k -ge $exerciseLines.Count -or $exerciseLines[$k] -notmatch '^\s*<hint') {
                                    break
                                }
                                continue
                            }
                        }
                    }
                    else {
                        break
                    }
                    $k++
                }
                
                # Rebuild the exercise with hints moved
                $newExercise = New-Object System.Collections.ArrayList
                
                for ($m = 0; $m -lt $exerciseLines.Count; $m++) {
                    if ($m -eq $insertIdx) {
                        # Insert hints here
                        foreach ($hLine in $hintLines) {
                            [void]$newExercise.Add($hLine)
                        }
                    }
                    
                    # Skip the original hint location
                    if ($m -ge $hintStartIdx -and $m -lt $k) {
                        # Skip response tag if it's right before hints
                        if ($exerciseLines[$m] -match '^\s*<response/>\s*$') {
                            continue
                        }
                        # Skip empty lines between statement and hints
                        if ($m -gt $statementEndIdx -and $m -lt $hintStartIdx -and $exerciseLines[$m] -match '^\s*$') {
                            continue
                        }
                        # Skip hint lines (already added above)
                        if ($m -ge $hintStartIdx) {
                            continue
                        }
                    }
                    
                    [void]$newExercise.Add($exerciseLines[$m])
                }
                
                # Add the modified exercise to result
                foreach ($eLine in $newExercise) {
                    [void]$result.Add($eLine)
                }
                
                $totalChanges++
                $i = $j
            }
            else {
                # No fixing needed - add as-is
                foreach ($eLine in $exerciseLines) {
                    [void]$result.Add($eLine)
                }
                $i = $j
            }
        }
        else {
            [void]$result.Add($line)
            $i++
        }
    }
    
    $newContent = $result -join "`r`n"
    if ($newContent -ne $originalContent) {
        Set-Content -Path $file.FullName -Value $newContent -NoNewline
        $modifiedFiles += $file.FullName
        Write-Host "Modified: $($file.Name)" -ForegroundColor Green
    }
}

Write-Host "`n=== Summary ===" -ForegroundColor Cyan
Write-Host "Modified $($modifiedFiles.Count) files" -ForegroundColor Green
Write-Host "Made $totalChanges total changes" -ForegroundColor Green
Write-Host "Skipped $(($skippedExercises | Sort-Object -Unique).Count) tech-detour exercises" -ForegroundColor Yellow

if ($modifiedFiles.Count -gt 0) {
    Write-Host "`nModified files:" -ForegroundColor Green
    $modifiedFiles | ForEach-Object { Write-Host "  $_" }
}
