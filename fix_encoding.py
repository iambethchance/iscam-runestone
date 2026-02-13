import re

# Read the file  
with open(r'c:\Users\bchance\Dropbox\My Documents\Classes\Stat 301 - Win 26\lectures\review1_clean.html', 'r', encoding='utf-8') as f:
    content = f.read()

# Fix common encoding issues
replacements = {
    'â€"': '–',
    'â€™': "'",
    'â€œ': '"',
    'â€': '"',
    'â‰¤': '≤',
    'â‰¥': '≥',
    'Ï€': 'π',
    'ðŸ˜Š': '😊',
    'Ã—': '×',
    'Â±': '±',
    '&nbsp;': ' '
}

for old, new in replacements.items():
    content = content.replace(old, new)

# Write back
with open(r'c:\Users\bchance\Dropbox\My Documents\Classes\Stat 301 - Win 26\lectures\review1_clean.html', 'w', encoding='utf-8') as f:
    f.write(content)

print('Encoding fixed!')
