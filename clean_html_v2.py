import re
from html import unescape
from html.parser import HTMLParser

class WordHTMLCleaner(HTMLParser):
    def __init__(self):
        super().__init__()
        self.content_stack = []
        self.current_text = []
        self.in_list = False
        self.list_level = 0
        self.bold_stack = 0
        self.italic_stack = 0
        self.list_items = []
        
    def handle_starttag(self, tag, attrs):
        attrs_dict = dict(attrs)
        
        # Handle lists
        if tag == 'p' and 'class' in attrs_dict:
            if 'MsoListParagraph' in attrs_dict.get('class', ''):
                self.in_list = True
                
        # Handle bold
        if tag in ['b', 'strong']:
            self.bold_stack += 1
        if tag == 'span' and 'style' in attrs_dict:
            if 'font-weight:bold' in attrs_dict['style']:
                self.bold_stack += 1
                
        # Handle italic
        if tag in ['i', 'em']:
            self.italic_stack += 1
            
    def handle_endtag(self, tag):
        if tag in ['b', 'strong']:
            self.bold_stack = max(0, self.bold_stack - 1)
        if tag in ['i', 'em']:
            self.italic_stack = max(0, self.italic_stack - 1)
            
    def handle_data(self, data):
        # Clean up text
        text = data.strip()
        if text and text not in ['', ' ']:
            if self.bold_stack > 0:
                text = f'<strong>{text}</strong>'
            if self.italic_stack > 0:
                text = f'<em>{text}</em>'
            self.current_text.append(text)

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

# Remove all MSO/Office specific tags
body_content = re.sub(r'<o:p>.*?</o:p>', '', body_content, flags=re.DOTALL)
body_content = re.sub(r'<!\[if[^\]]*\]>.*?<!\[endif\]>', '', body_content, flags=re.DOTALL)
body_content = re.sub(r'<!--\[if[^\]]*\]>.*?<!\[endif\]-->', '', body_content, flags=re.DOTALL)
body_content = re.sub(r'<!--.*?-->', '', body_content, flags=re.DOTALL)
body_content = re.sub(r'<v:.*?>.*?</v:.*?>', '', body_content, flags=re.DOTALL)
body_content = re.sub(r'<\?xml.*?\?>', '', body_content, flags=re.DOTALL)
body_content = re.sub(r'<m:oMath>.*?</m:oMath>', 'π', body_content, flags=re.DOTALL)

# Remove Word section divs
body_content = re.sub(r'<div class=WordSection\d+>', '', body_content)

# Fix mathematical symbols - preserve hat-p symbol
body_content = body_content.replace('<!--[if gte vml 1]>.*?<![endif]-->', '')
body_content = body_content.replace('<!--[if gte msEquation 12]>', '')
body_content = body_content.replace('<![endif]>', '')

# Convert to plain text structure, then rebuild
lines = []
current_para = []

# Split into paragraphs
paras = re.findall(r'<p[^>]*>(.*?)</p>', body_content, re.DOTALL)

for para in paras:
    # Clean spans
    para = re.sub(r'<span[^>]*>', '', para)
    para = re.sub(r'</span>', '', para)
    
    # Preserve bold/italic
    para = re.sub(r'<b[^>]*>', '<strong>', para)
    para = re.sub(r'</b>', '</strong>', para)
    para = re.sub(r'<i[^>]*>', '<em>', para)
    para = re.sub(r'</i>', '</em>', para)
    
    # Remove images
    para = re.sub(r'<img[^>]*>', 'p̂', para)
    
    # Unescape
    para = unescape(para)
    
    # Clean whitespace
    para = re.sub(r'\s+', ' ', para).strip()
    
    if para:
        lines.append(para)

# Now rebuild with proper structure
output_lines = []
output_lines.append('<!DOCTYPE html>')
output_lines.append('<html lang="en">')
output_lines.append('<head>')
output_lines.append('    <meta charset="UTF-8">')
output_lines.append('    <meta name="viewport" content="width=device-width, initial-scale=1.0">')
output_lines.append('    <title>Stat 301 - Exam 1 Preparations</title>')
output_lines.append('    <style>')
output_lines.append('        body {')
output_lines.append('            font-family: Arial, sans-serif;')
output_lines.append('            line-height: 1.6;')
output_lines.append('            max-width: 900px;')
output_lines.append('            margin: 0 auto;')
output_lines.append('            padding: 20px;')
output_lines.append('            color: #333;')
output_lines.append('            background-color: #fff;')
output_lines.append('        }')
output_lines.append('        h1 {')
output_lines.append('            text-align: center;')
output_lines.append('            color: #000;')
output_lines.append('            margin-bottom: 1.5em;')
output_lines.append('            font-size: 1.8em;')
output_lines.append('        }')
output_lines.append('        h2 {')
output_lines.append('            margin-top: 1.5em;')
output_lines.append('            margin-bottom: 0.5em;')
output_lines.append('            color: #000;')
output_lines.append('            font-size: 1.3em;')
output_lines.append('        }')
output_lines.append('        p {')
output_lines.append('            margin: 0.8em 0;')
output_lines.append('        }')
output_lines.append('        ul {')
output_lines.append('            margin: 0.8em 0;')
output_lines.append('            padding-left: 2em;')
output_lines.append('            list-style-type: disc;')
output_lines.append('        }')
output_lines.append('        ul ul {')
output_lines.append('            list-style-type: circle;')
output_lines.append('        }')
output_lines.append('        li {')
output_lines.append('            margin: 0.4em 0;')
output_lines.append('        }')
output_lines.append('        strong {')
output_lines.append('            font-weight: bold;')
output_lines.append('        }')
output_lines.append('        em {')
output_lines.append('            font-style: italic;')
output_lines.append('        }')
output_lines.append('        a {')
output_lines.append('            color: #0066cc;')
output_lines.append('            text-decoration: underline;')
output_lines.append('        }')
output_lines.append('        a:hover {')
output_lines.append('            color: #004499;')
output_lines.append('        }')
output_lines.append('        a:visited {')
output_lines.append('            color: #800080;')
output_lines.append('        }')
output_lines.append('        .note {')
output_lines.append('            color: #0066cc;')
output_lines.append('        }')
output_lines.append('        .important {')
output_lines.append('            color: #cc0000;')
output_lines.append('        }')
output_lines.append('    </style>')
output_lines.append('</head>')
output_lines.append('<body>')

# Add title
output_lines.append('    <h1>Stat 301 – Exam 1 Preparations</h1>')
output_lines.append('')

# Process lines
in_list = False
i = 0
while i < len(lines):
    line = lines[i]
    
    # Check if it's a list item (starts with bullet or has certain patterns)
    is_list_item = (line.startswith('•') or line.startswith('○') or 
                   line.startswith('–') or line.startswith('o ') or
                   (i > 0 and in_list and not line.startswith('<strong>')))
    
    # Check if it's a heading (starts with bold text)
    is_heading = line.startswith('<strong>') and line.endswith(':</strong>')
    
    if is_heading:
        # Close list if open
        if in_list:
            output_lines.append('    </ul>')
            in_list = False
        
        # Add as heading
        heading_text = re.sub(r'</?strong>', '', line).rstrip(':')
        output_lines.append(f'    <h2>{heading_text}</h2>')
        
    elif is_list_item:
        # Start list if not started
        if not in_list:
            output_lines.append('    <ul>')
            in_list = True
        
        # Clean list item
        clean_line = line.lstrip('•○–o ').strip()
        output_lines.append(f'        <li>{clean_line}</li>')
        
    else:
        # Close list if open
        if in_list:
            output_lines.append('    </ul>')
            in_list = False
        
        # Add as paragraph
        if line.strip():
            output_lines.append(f'    <p>{line}</p>')
    
    i += 1

# Close any open list
if in_list:
    output_lines.append('    </ul>')

output_lines.append('')
output_lines.append('</body>')
output_lines.append('</html>')

# Write output
with open(output_file, 'w', encoding='utf-8') as f:
    f.write('\n'.join(output_lines))

print(f"Cleaned HTML saved to: {output_file}")
print(f"Processed {len(lines)} content blocks")
