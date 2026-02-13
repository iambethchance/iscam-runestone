#!/usr/bin/env python3
import re
from html import unescape
from html.parser import HTMLParser

# Read original file
with open(r'c:\Users\bchance\Dropbox\My Documents\Classes\Stat 301 - Win 26\lectures\review1.html', 'r', encoding='windows-1252') as f:
    content = f.read()

# Extract body
body_match = re.search(r'<body[^>]*>(.*?)</body>', content, re.DOTALL)
body = body_match.group(1) if body_match else ""

# Extract all paragraphs with their class attributes
# Pattern: <p class=...>.....</p>
para_pattern = r'<p\s+class=([^\s>]+)([^>]*)>(.*?)</p>'
paragraphs = re.findall(para_pattern, body, re.DOTALL)

# Parse each paragraph
items = []
for para_class, para_attrs, para_content in paragraphs:
    # Determine list level from class name
    level = 1
    if 'level2' in para_class:
        level = 2
    elif 'level3' in para_class:
        level = 3
    
    is_list = 'MsoListParagraph' in para_class
    is_centered = 'text-align:center' in para_attrs
    
    # Clean content
    para_content = re.sub(r'<!\[if[^\]]*\]>.*?<!\[endif\]>', '', para_content, flags=re.DOTALL)
    para_content = re.sub(r'<span[^>]*>', '', para_content)
    para_content = re.sub(r'</span>', '', para_content)
    para_content = re.sub(r'<o:p>.*?</o:p>', '', para_content)
    para_content = re.sub(r'<!--.*?-->', '', para_content)
    para_content = re.sub(r'\s+', ' ', para_content)
    para_content = para_content.strip()
    
    # Skip empty
    if not para_content or para_content in ['&nbsp;', '']:
        continue
    
    # Unescape
    para_content = unescape(para_content)
    
    items.append({
        'content': para_content,
        'is_list': is_list,
        'level': level,
        'is_centered': is_centered
    })

# Build HTML
html = []
html.append('<!DOCTYPE html>')
html.append('<html lang="en">')
html.append('<head>')
html.append('    <meta charset="UTF-8">')
html.append('    <meta name="viewport" content="width=device-width, initial-scale=1.0">')
html.append('    <title>Stat 301 - Exam 1 Preparations</title>')
html.append('    <style>')
html.append('        * { margin: 0; padding: 0; }')
html.append('        body {')
html.append('            font-family: Arial, sans-serif;')
html.append('            line-height: 1.6;')
html.append('            max-width: 950px;')
html.append('            margin: 0 auto;')
html.append('            padding: 20px;')
html.append('            color: #333;')
html.append('        }')
html.append('        h1 {')
html.append('            text-align: center;')
html.append('            margin: 1em 0;')
html.append('            font-size: 1.8em;')
html.append('        }')
html.append('        h2 {')
html.append('            margin-top: 1.2em;')
html.append('            margin-bottom: 0.4em;')
html.append('            font-size: 1.1em;')
html.append('            font-weight: bold;')
html.append('        }')
html.append('        p { margin: 0.6em 0; }')
html.append('        ul { margin: 0.6em 0 0.6em 2em; }')
html.append('        ul ul { margin: 0.2em 0 0.2em 1.5em; }')
html.append('        li { margin: 0.3em 0; }')
html.append('        strong { font-weight: bold; }')
html.append('        em { font-style: italic; }')
html.append('        a { color: #0066cc; text-decoration: underline; }')
html.append('        a:visited { color: #800080; }')
html.append('        .blue { color: #0066cc; }')
html.append('        .red { color: #cc0000; }')
html.append('    </style>')
html.append('</head>')
html.append('<body>')
html.append('')

# Process items
list_stack = []  # Track open lists
prev_level = 0

for i, item in enumerate(items):
    content = item['content']
    is_list = item['is_list']
    level = item['level']
    is_centered = item['is_centered']
    
    # First item should be title
    if i == 0 and is_centered:
        title_text = re.sub(r'</?b>', '', content)
        title_text = re.sub(r'</?strong>', '', title_text)
        html.append(f'<h1>{title_text}</h1>')
        continue
    
    # Check if this is a heading (bold, ends with colon, not a list item)
    is_heading = (not is_list and 
                  ('<strong>' in content or '<b>' in content) and 
                  ':</strong>' in content or ':</b>' in content)
    
    if is_heading:
        # Close any open lists
        while list_stack:
            html.append('    </ul>')
            list_stack.pop()
        
        # Extract heading text
        heading = re.sub(r'</?strong>', '', content)
        heading = re.sub(r'</?b>', '', heading)
        heading = heading.rstrip(':').strip()
        html.append(f'<h2>{heading}</h2>')
        prev_level = 0
        
    elif is_list:
        # Adjust list stack for level
        while len(list_stack) > level:
            html.append('        ' * (len(list_stack) - 1) + '</ul>')
            list_stack.pop()
        
        while len(list_stack) < level:
            if list_stack:
                html.append('        ' * len(list_stack) + '<ul>')
            else:
                html.append('    <ul>')
            list_stack.append(level)
        
        # Clean list content
        clean_content = content.strip()
        
        # Add list item with proper indentation
        indent = '        ' * len(list_stack)
        html.append(f'{indent}<li>{clean_content}</li>')
        prev_level = level
        
    else:
        # Close any open lists
        while list_stack:
            html.append('    </ul>')
            list_stack.pop()
        
        if content.strip():
            # Handle colored text
            if 'color:blue' in str(item):
                html.append(f'<p class="blue">{content}</p>')
            elif 'color:red' in str(item):
                html.append(f'<p class="red">{content}</p>')
            else:
                html.append(f'<p>{content}</p>')
        prev_level = 0

# Close any remaining lists
while list_stack:
    html.append('    </ul>')
    list_stack.pop()

html.append('')
html.append('</body>')
html.append('</html>')

# Write to file
output = '\n'.join(html)

# Fix encoding issues
output = output.replace('–', '–')
output = output.replace('â€"', '–')
output = output.replace('â€™', "'")
output = output.replace('â€œ', '"')

with open(r'c:\Users\bchance\Dropbox\My Documents\Classes\Stat 301 - Win 26\lectures\review1_cleaned2.html', 'w', encoding='utf-8') as f:
    f.write(output)

print("✓ Created review1_cleaned2.html")
print(f"✓ Processed {len(items)} content items")
print(f"✓ File location: c:\\Users\\bchance\\Dropbox\\My Documents\\Classes\\Stat 301 - Win 26\\lectures\\review1_cleaned2.html")
