#!/usr/bin/env python3
"""
Script to move <hint> tags from after </statement> to inside <statement> tags in PreTeXt XML files.
"""

import re
import os
import glob

def fix_hints_in_file(filepath):
    """
    Read a PreTeXt XML file and move all <hint> tags that appear after </statement>
    to inside the <statement> tag (before </statement>).
    Returns True if changes were made, False otherwise.
    """
    with open(filepath, 'r', encoding='utf-8') as f:
        content = f.read()
    
    original_content = content
    changes_made = 0
    
    # Pattern to match: </statement> followed by whitespace/tags, then <hint>...</hint>
    # We want to move the hint(s) to before </statement>
    
    # This pattern matches:
    # 1. A </statement> tag
    # 2. Optional whitespace
    # 3. Optional <response/> or other single-line tags
    # 4. Optional whitespace
    # 5. One or more <hint>...</hint> blocks (including nested content)
    
    # We'll process this iteratively
    while True:
        # Look for pattern: </statement> ... <hint>
        # where ... can be whitespace, <response/>, etc., but NOT <solution> or </exercise>
        pattern = r'(</statement>)((?:\s*(?:<response/>|<choices[^>]*>.*?</choices>))?)(\s*)(<hint>.*?</hint>)'
        
        match = re.search(pattern, content, re.DOTALL)
        if not match:
            break
            
        # Extract the components
        statement_close = match.group(1)
        middle_tags = match.group(2)  # response, choices, etc.
        whitespace = match.group(3)
        hint_block = match.group(4)
        
        # Create the replacement: move hint before </statement>
        # Determine indentation by looking at the line with </statement>
        statement_line_start = content.rfind('\n', 0, match.start(1))
        statement_indent = content[statement_line_start+1:match.start(1)]
        
        # The hint should have the same indentation as the content inside <statement>
        # Assume hints should be indented 2 more spaces than </statement>
        hint_indent = statement_indent + '  '
        
        # Reformat the hint block with proper indentation
        hint_lines = hint_block.split('\n')
        hint_reformatted = '\n'.join([hint_indent + line.lstrip() if line.strip() else '' for line in hint_lines])
        
        # Build the replacement
        replacement = hint_reformatted + '\n' + statement_indent + statement_close + middle_tags
        
        # Replace in content
        content = content[:match.start(1)] + replacement + content[match.end(4):]
        changes_made += 1
        
    if content != original_content:
        with open(filepath, 'w', encoding='utf-8') as f:
            f.write(content)
        return True
    return False

def main():
    # Find all .ptx files in the source directory
    source_dir = os.path.join(os.path.dirname(__file__), 'source')
    
    # Exclude backup file
    exclude_files = ['ch-1-monolithic-backup.ptx']
    
    ptx_files = []
    for root, dirs, files in os.walk(source_dir):
        for file in files:
            if file.endswith('.ptx') and file not in exclude_files:
                ptx_files.append(os.path.join(root, file))
    
    print(f"Found {len(ptx_files)} .ptx files to process")
    
    files_changed = 0
    for filepath in ptx_files:
        filename = os.path.basename(filepath)
        if fix_hints_in_file(filepath):
            files_changed += 1
            print(f"✓ Fixed hints in {filename}")
        else:
            print(f"  No changes needed in {filename}")
    
    print(f"\nSummary: Fixed hints in {files_changed} out of {len(ptx_files)} files")

if __name__ == '__main__':
    main()
