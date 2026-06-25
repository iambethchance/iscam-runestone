"""
Undo bullet fix: restore manual bullet characters and Normal style
for paragraphs that were converted from manual bullets to List Paragraph.
"""
import docx
from docx.shared import Inches

FILEPATH = r'c:\Users\bchance\Dropbox\My Documents\Classes\Stat 301 - Win 26\lectures\finalreview.docx'

doc = docx.Document(FILEPATH)

restored = 0
for p in doc.paragraphs:
    if p.style.name != 'List Paragraph':
        continue
    
    indent = p.paragraph_format.left_indent
    if indent is None:
        continue
    
    indent_inches = indent / 914400  # EMU to inches
    
    # Determine which bullet char to restore based on indent level
    if abs(indent_inches - 0.5) < 0.05:
        # Was a dot bullet - restore "·   " prefix
        bullet_prefix = '\xb7\xa0\xa0\xa0'
    elif abs(indent_inches - 1.0) < 0.05:
        # Was an 'o' sub-bullet - restore "o   " prefix
        bullet_prefix = 'o\xa0\xa0\xa0'
    elif abs(indent_inches - 1.5) < 0.05:
        # Was a wingdings sub-sub - restore "§  " prefix
        bullet_prefix = '\xa7\xa0\xa0'
    else:
        continue
    
    # Add bullet char back to first run
    if p.runs:
        p.runs[0].text = bullet_prefix + p.runs[0].text
    
    # Restore Normal style and clear indent
    p.style = doc.styles['Normal']
    p.paragraph_format.left_indent = None
    
    restored += 1

print(f"Restored {restored} paragraphs back to manual bullets")
doc.save(FILEPATH)
print(f"Saved to: {FILEPATH}")
