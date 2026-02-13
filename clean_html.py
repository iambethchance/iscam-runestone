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

# Remove Word section divs
body_content = re.sub(r'<div class=WordSection\d+>', '', body_content)
body_content = re.sub(r'</div>\s*$', '', body_content)

# Clean up paragraphs - remove all inline styles and classes
def clean_tag(match):
    full_match = match.group(0)
    content = match.group(1)
    
    # Determine semantic meaning
    if 'text-align:center' in full_match:
        return f'<h1>{content}</h1>'
    elif 'MsoListParagraph' in full_match or '•' in content or '○' in content:
        # List item
        return f'<li>{content}</li>'
    else:
        return f'<p>{content}</p>'

# Process paragraphs
body_content = re.sub(r'<p[^>]*>(.*?)</p>', clean_tag, body_content, flags=re.DOTALL)

# Clean spans - extract text while preserving bold, italic, color
def clean_span(match):
    full_match = match.group(0)
    content = match.group(1)
    
    # Check for bold
    if 'font-weight:bold' in full_match or '<b' in content:
        content = re.sub(r'<b[^>]*>(.*?)</b>', r'<strong>\1</strong>', content)
        if '<strong>' not in content:
            content = f'<strong>{content}</strong>'
    
    # Check for italic
    if 'font-style:italic' in full_match or '<i' in content:
        content = re.sub(r'<i[^>]*>(.*?)</i>', r'<em>\1</em>', content)
        if '<em>' not in content and '<strong>' not in content:
            content = f'<em>{content}</em>'
    
    # Check for color
    if 'color:red' in full_match:
        content = f'<span style="color: red;">{content}</span>'
    elif 'color:blue' in full_match:
        content = f'<span style="color: blue;">{content}</span>'
    
    return content

# Clean all inline formatting
body_content = re.sub(r'<span[^>]*>(.*?)</span>', clean_span, body_content, flags=re.DOTALL)
body_content = re.sub(r'<b[^>]*>(.*?)</b>', r'<strong>\1</strong>', body_content, flags=re.DOTALL)
body_content = re.sub(r'<i[^>]*>(.*?)</i>', r'<em>\1</em>', body_content, flags=re.DOTALL)

# Remove MSO tags and comments
body_content = re.sub(r'<o:p>.*?</o:p>', '', body_content, flags=re.DOTALL)
body_content = re.sub(r'<!\[if[^\]]*\]>.*?<!\[endif\]>', '', body_content, flags=re.DOTALL)
body_content = re.sub(r'<!--\[if[^\]]*\]>.*?<!\[endif\]-->', '', body_content, flags=re.DOTALL)
body_content = re.sub(r'<!--.*?-->', '', body_content, flags=re.DOTALL)

# Remove VML shapes and image data
body_content = re.sub(r'<v:.*?>.*?</v:.*?>', '', body_content, flags=re.DOTALL)
body_content = re.sub(r'<\?xml.*?\?>', '', body_content, flags=re.DOTALL)

# Clean up mathematical content - preserve π and other symbols
body_content = re.sub(r'<m:oMath>.*?</m:oMath>', 'π', body_content, flags=re.DOTALL)

# Remove empty tags
body_content = re.sub(r'<([a-z]+)[^>]*>\s*</\1>', '', body_content, flags=re.DOTALL)

# Clean whitespace
body_content = re.sub(r'\s+', ' ', body_content)
body_content = re.sub(r'>\s+<', '><', body_content)

# Unescape HTML entities
body_content = unescape(body_content)

# Create clean HTML structure
clean_html = f"""<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Stat 301 - Exam 1 Preparations</title>
    <style>
        body {{
            font-family: Arial, sans-serif;
            line-height: 1.6;
            max-width: 900px;
            margin: 0 auto;
            padding: 20px;
            color: #333;
        }}
        h1 {{
            text-align: center;
            color: #000;
            margin-bottom: 1.5em;
        }}
        h2 {{
            margin-top: 1.5em;
            margin-bottom: 0.5em;
            color: #000;
        }}
        p {{
            margin: 0.8em 0;
        }}
        ul, ol {{
            margin: 0.8em 0;
            padding-left: 2em;
        }}
        li {{
            margin: 0.4em 0;
        }}
        strong {{
            font-weight: bold;
        }}
        em {{
            font-style: italic;
        }}
        a {{
            color: #0066cc;
            text-decoration: underline;
        }}
        a:visited {{
            color: #800080;
        }}
    </style>
</head>
<body>
{body_content}
</body>
</html>
"""

# Write the cleaned HTML
with open(output_file, 'w', encoding='utf-8') as f:
    f.write(clean_html)

print(f"Cleaned HTML saved to: {output_file}")
