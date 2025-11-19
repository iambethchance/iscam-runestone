# Read file as raw bytes and convert from Windows-1252
$content = Get-Content "source\ch-1.ptx" -Raw -Encoding UTF8

# Fix em dashes and en dashes 
$content = $content -creplace '\u00e2\u0080\u0093', '-'  # en dash
$content = $content -creplace '\u00e2\u0080\u0094', '-'  # em dash  
$content = $content -creplace '\u20ac\u201c', '-'  # euro + quote

# Fix greater than or equal
$content = $content -creplace '\u00e2\u0089\u00a5', '≥'

# Fix multiplication sign
$content = $content -creplace '\u00c3\u00d7', '×'

# Fix approximately equal
$content = $content -creplace '\u00e2\u0089\u0088', '≈'
$content = $content -creplace '\u00e2\u0089\u02c6', '≈'

# Fix subscripts
$content = $content -creplace '\u00e2\u201a\u20ac', '₀'  # subscript 0
$content = $content -creplace '\u00e2\u201a', 'ₐ'  # subscript a

# Fix pi
$content = $content -creplace '\u00cf\u20ac', 'π'

# Fix square root
$content = $content -creplace '\u00e2\u0088\u009a', '√'

# Fix less than or equal
$content = $content -creplace '\u00e2\u0089\u00a4', '≤'

# Fix umlaut in Güntürkün
$content = $content -creplace 'G\u00c3\u00bcnt\u00c3\u00bcrk\u00c3\u00bcn', 'Güntürkün'

# Save with UTF-8 encoding without BOM
[System.IO.File]::WriteAllText("$PWD\source\ch-1.ptx", $content, [System.Text.UTF8Encoding]::new($false))

Write-Host "Unicode fixes applied successfully"
