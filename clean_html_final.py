import re
from html import unescape

# Read the original file
input_file = r'c:\Users\bchance\Dropbox\My Documents\Classes\Stat 301 - Win 26\lectures\review1.html'
output_file = r'c:\Users\bchance\Dropbox\My Documents\Classes\Stat 301 - Win 26\lectures\review1_clean.html'

with open(input_file, 'r', encoding='windows-1252') as f:
    content = f.read()

# Extract body content
body_match = re.search(r'<body[^>]*>(.*?)</body>', content, re.DOTALL)
if not body_match:
    print("Could not find body content")
    exit(1)

body_content = body_match.group(1)

# Remove all MSO/Office tags and comments
body_content = re.sub(r'<o:p>.*?</o:p>', '', body_content, flags=re.DOTALL)
body_content = re.sub(r'<!\[if[^\]]*\]>.*?<!\[endif\]>', '', body_content, flags=re.DOTALL)
body_content = re.sub(r'<!--\[if[^\]]*\]>.*?<!\[endif\]-->', '', body_content, flags=re.DOTALL)
body_content = re.sub(r'<!--.*?-->', '', body_content, flags=re.DOTALL)
body_content = re.sub(r'<v:.*?>.*?</v:.*?>', '', body_content, flags=re.DOTALL)
body_content = re.sub(r'<xml>.*?</xml>', '', body_content, flags=re.DOTALL)

# Remove Word section divs
body_content = re.sub(r'<div class=WordSection\d+>', '', body_content)
body_content = re.sub(r'</div>\s*$', '', body_content, flags=re.DOTALL)

# Extract all paragraphs with their attributes
paragraphs = re.findall(r'<p\s+class=([^>]+)>(.*?)</p>', body_content, re.DOTALL)

# Process each paragraph
processed = []
for class_attr, para_content in paragraphs:
    # Clean the content
    para_content = re.sub(r'<span[^>]*>', '', para_content)
    para_content = re.sub(r'</span>', '', para_content)
    para_content = re.sub(r'<b[^>]*>', '<strong>', para_content)
    para_content = re.sub(r'</b>', '</strong>', para_content)
    para_content = re.sub(r'<i[^>]*>', '<em>', para_content)
    para_content = re.sub(r'</i>', '</em>', para_content)
    
    # Preserve links
    para_content = re.sub(r'<a[^>]*href="([^"]+)"[^>]*>(.*?)</a>', r'<a href="\1">\2</a>', para_content)
    
    # Remove images but keep placeholder for math symbols
    para_content = re.sub(r'<img[^>]*>', 'p̂', para_content)
    
    # Unescape HTML entities
    para_content = unescape(para_content)
    
    # Clean extra whitespace
    para_content = re.sub(r'\s+', ' ', para_content).strip()
    
    if not para_content:
        continue
    
    # Determine the type
    is_list_item = 'MsoListParagraph' in class_attr
    is_centered = 'text-align:center' in str(class_attr)
    
    processed.append({
        'content': para_content,
        'is_list': is_list_item,
        'is_centered': is_centered,
        'original_class': class_attr
    })

# Build the HTML output
html_lines = [
    '<!DOCTYPE html>',
    '<html lang="en">',
    '<head>',
    '    <meta charset="UTF-8">',
    '    <meta name="viewport" content="width=device-width, initial-scale=1.0">',
    '    <title>Stat 301 - Exam 1 Preparations</title>',
    '    <style>',
    '        body {',
    '            font-family: Arial, sans-serif;',
    '            line-height: 1.6;',
    '            max-width: 900px;',
    '            margin: 0 auto;',
    '            padding: 20px;',
    '            color: #333;',
    '            background-color: #fff;',
    '        }',
    '        h1 {',
    '            text-align: center;',
    '            color: #000;',
    '            margin-bottom: 1.5em;',
    '            font-size: 1.8em;',
    '        }',
    '        h2 {',
    '            margin-top: 1.5em;',
    '            margin-bottom: 0.5em;',
    '            color: #000;',
    '            font-size: 1.3em;',
    '        }',
    '        p {',
    '            margin: 0.8em 0;',
    '        }',
    '        ul {',
    '            margin: 0.8em 0;',
    '            padding-left: 2em;',
    '            list-style-type: disc;',
    '        }',
    '        ul ul {',
    '            list-style-type: circle;',
    '            margin: 0.3em 0;',
    '        }',
    '        li {',
    '            margin: 0.4em 0;',
    '        }',
    '        strong {',
    '            font-weight: bold;',
    '        }',
    '        em {',
    '            font-style: italic;',
    '        }',
    '        a {',
    '            color: #0066cc;',
    '            text-decoration: underline;',
    '        }',
    '        a:hover {',
    '            color: #004499;',
    '        }',
    '        a:visited {',
    '            color: #800080;',
    '        }',
    '        .note {',
    '            color: #0066cc;',
    '        }',
    '        .important {',
    '            color: #cc0000;',
    '        }',
    '    </style>',
    '</head>',
    '<body>',
    ''
]

# Process the content and build proper structure
in_list = False
prev_was_list = False

for i, item in enumerate(processed):
    content = item['content']
    is_list = item['is_list']
    is_centered = item['is_centered']
    
    # Check if this is a heading (bold text ending with colon)
    is_heading = (content.startswith('<strong>') and 
                  (':</strong>' in content or content.endswith(':</strong>')) and
                  not is_list)
    
    # First item - make it the title
    if i == 0 and is_centered:
        title_text = re.sub(r'</?strong>', '', content)
        html_lines.append(f'    <h1>{title_text}</h1>')
        html_lines.append('')
        continue
    
    # Handle heading
    if is_heading and not is_list:
        # Close list if open
        if in_list:
            html_lines.append('    </ul>')
            html_lines.append('')
            in_list = False
        
        # Add heading
        heading_text = re.sub(r'<strong>(.*?):</strong>', r'\1', content)
        heading_text = re.sub(r'</?strong>', '', heading_text).strip()
        html_lines.append(f'    <h2>{heading_text}</h2>')
        html_lines.append('')
        
    # Handle list item
    elif is_list:
        # Open list if not open
        if not in_list:
            html_lines.append('    <ul>')
            in_list = True
        
        # Determine if this is a sub-item (starts with 'o' or nested indicator)
        is_subitem = (content.startswith('o ') or 
                     content.startswith('○') or
                     (prev_was_list and not content.startswith('•') and 
                      not content.startswith('<strong>')))
        
        # Clean list markers
        content = re.sub(r'^[•○o]\s*', '', content)
        
        # Add list item with proper indentation
        if is_subitem and not content.startswith('<strong>'):
            # Check if we need a nested list
            if html_lines[-1].startswith('        <li>'):
                # Already in nested list
                html_lines.append(f'        <li>{content}</li>')
            else:
                # Start nested list
                html_lines.append('        <ul>')
                html_lines.append(f'            <li>{content}</li>')
        else:
            # Close nested list if it was open
            if html_lines[-1].startswith('            <li>'):
                html_lines.append('        </ul>')
            
            html_lines.append(f'        <li>{content}</li>')
        
        prev_was_list = True
        
    # Handle regular paragraph
    else:
        # Close nested list if open
        if in_list and html_lines[-1].startswith('            <li>'):
            html_lines.append('        </ul>')
        
        # Close main list if open
        if in_list:
            html_lines.append('    </ul>')
            html_lines.append('')
            in_list = False
        
        # Add paragraph
        if content.strip():
            html_lines.append(f'    <p>{content}</p>')
        
        prev_was_list = False

# Close any open lists
if in_list:
    if html_lines[-1].startswith('            <li>'):
        html_lines.append('        </ul>')
    html_lines.append('    </ul>')

html_lines.extend([
    '',
    '</body>',
    '</html>'
])

# Write output
output_html = '\n'.join(html_lines)

# Fix encoding issues
replacements = {
    '–': '–',
    ''': "'",
    '"': '"',
    '"': '"',
    '≤': '≤',
    '≥': '≥',
    'π': 'π',
    '😊': '😊',
    '×': '×',
    '±': '±'
}

for old, new in replacements.items():
    output_html = output_html.replace(old, new)

with open(output_file, 'w', encoding='utf-8') as f:
    f.write(output_html)

print(f"Successfully created clean HTML with proper list structure!")
print(f"Output file: {output_file}")
print(f"Processed {len(processed)} content blocks")
