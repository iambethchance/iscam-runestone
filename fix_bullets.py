"""
Fix all bullet formatting in finalreview.docx:
- Convert manual Symbol dot bullets -> List Paragraph (level 1)
- Convert manual 'o' sub-bullets -> List Paragraph (level 2, 0.5" indent)
- Convert manual Wingdings section sub-sub-bullets -> List Paragraph (level 3, 1.0" indent)
- Strip manual bullet characters and leading whitespace
- Ensure existing List Paragraph bullets at level 1 have no extra indent issues
"""
import docx
from docx.shared import Inches, Pt
from lxml import etree

FILEPATH = r'c:\Users\bchance\Dropbox\My Documents\Classes\Stat 301 - Win 26\lectures\finalreview.docx'
W_NS = 'http://schemas.openxmlformats.org/wordprocessingml/2006/main'

def qn(tag):
    return f'{{{W_NS}}}{tag}'

doc = docx.Document(FILEPATH)

fixed_dot = 0
fixed_o = 0
fixed_wing = 0

for i, p in enumerate(doc.paragraphs):
    t = p.text.strip()
    if not t:
        continue
    
    style = p.style.name
    first_char = t[0] if t else ''
    
    # --- Symbol dot bullets (level 1) ---
    if first_char == '\xb7' and style == 'Normal':
        # Remove the bullet char and leading whitespace from first run(s)
        # The bullet is typically in the first run (Symbol font), followed by spacing in next run
        runs_to_remove = []
        cleaned = False
        for j, run in enumerate(p.runs):
            rt = run.text
            if not cleaned:
                # Strip bullet char and nbsp/spaces
                stripped = rt.lstrip('\xb7\xa0 \t')
                if stripped != rt:
                    if stripped:
                        run.text = stripped
                        cleaned = True
                    else:
                        runs_to_remove.append(j)
                else:
                    cleaned = True
        
        # Remove empty runs (reverse order)
        for j in reversed(runs_to_remove):
            p._element.remove(p.runs[j]._element)
        
        # Set style and indent
        p.style = doc.styles['List Paragraph']
        p.paragraph_format.left_indent = Inches(0.5)
        
        # Set all runs to Arial font
        for run in p.runs:
            if run.font.name in ('Symbol', 'Times New Roman', None):
                run.font.name = 'Arial'
        
        fixed_dot += 1
    
    # --- Manual 'o' sub-bullets (level 2) ---
    elif (t.startswith('o\xa0') or t.startswith('o ')) and style == 'Normal':
        # Remove the 'o' char and leading whitespace
        runs_to_remove = []
        cleaned = False
        for j, run in enumerate(p.runs):
            rt = run.text
            if not cleaned:
                stripped = rt.lstrip('o\xa0 \t')
                if stripped != rt:
                    if stripped:
                        run.text = stripped
                        cleaned = True
                    else:
                        runs_to_remove.append(j)
                else:
                    cleaned = True
        
        for j in reversed(runs_to_remove):
            p._element.remove(p.runs[j]._element)
        
        p.style = doc.styles['List Paragraph']
        p.paragraph_format.left_indent = Inches(1.0)
        
        for run in p.runs:
            if run.font.name in ('Courier New', 'Times New Roman', None):
                run.font.name = 'Arial'
        
        fixed_o += 1
    
    # --- Wingdings section sub-sub-bullets (level 3) ---
    elif first_char == '\xa7' and style == 'Normal':
        runs_to_remove = []
        cleaned = False
        for j, run in enumerate(p.runs):
            rt = run.text
            if not cleaned:
                stripped = rt.lstrip('\xa7\xa0 \t')
                if stripped != rt:
                    if stripped:
                        run.text = stripped
                        cleaned = True
                    else:
                        runs_to_remove.append(j)
                else:
                    cleaned = True
        
        for j in reversed(runs_to_remove):
            p._element.remove(p.runs[j]._element)
        
        p.style = doc.styles['List Paragraph']
        p.paragraph_format.left_indent = Inches(1.5)
        
        for run in p.runs:
            if run.font.name in ('Wingdings', 'Times New Roman', None):
                run.font.name = 'Arial'
        
        fixed_wing += 1

print(f"Fixed {fixed_dot} dot bullets (level 1, 0.5\" indent)")
print(f"Fixed {fixed_o} 'o' sub-bullets (level 2, 1.0\" indent)")
print(f"Fixed {fixed_wing} wingdings sub-sub-bullets (level 3, 1.5\" indent)")
print(f"Total: {fixed_dot + fixed_o + fixed_wing} paragraphs fixed")

doc.save(FILEPATH)
print(f"\nSaved to: {FILEPATH}")
