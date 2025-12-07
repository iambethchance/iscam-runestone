# Deploying Your PreTeXt Book to Runestone Academy

## Overview
This guide explains how to deploy your PreTeXt book to Runestone Academy so you can use it as an instructor.

## What to Put on GitHub

Your GitHub repository should contain:
- `project.ptx` - Project configuration
- `source/main.ptx` - Your book content
- `publication/publication.ptx` - Publication settings for Runestone
- `assets/` - Your images and other static files
- `.gitignore` - To exclude build outputs

**DO NOT** include in GitHub:
- `output/` folder (build artifacts)
- `generated-assets/` folder
- `logs/` folder

## Steps to Deploy to Runestone

### 1. Create a .gitignore file
Create a `.gitignore` file in your project root with:
```
output/
generated-assets/
logs/
__pycache__/
*.pyc
.DS_Store
```

### 2. Initialize Git and Push to GitHub
```powershell
git init
git add .
git commit -m "Initial commit of PreTeXt book"
git branch -M main
git remote add origin https://github.com/YOUR-USERNAME/YOUR-REPO-NAME.git
git push -u origin main
```

### 3. Register on Runestone Academy
1. Go to https://runestone.academy
2. Create an instructor account if you don't have one
3. Log in as an instructor

### 4. Create Your Book on Runestone
1. Go to the Instructor Page
2. Click "Add a Custom Book" or "Create a Course"
3. You'll need to provide:
   - **Book ID**: A unique identifier (lowercase, no spaces) - update this in `publication/publication.ptx`
   - **GitHub Repository URL**: Your repo URL
   - **Branch**: Usually `main` or `master`

### 5. Build for Runestone
Option A - Let Runestone build it:
- Runestone Academy can build directly from your GitHub repo
- It will use the `runestone` target from your `project.ptx`

Option B - Build locally and deploy:
```powershell
pretext build runestone
pretext deploy
```

### 6. Access as Instructor
1. Log in to https://runestone.academy
2. Go to Instructor Page
3. Create a course using your custom book
4. You'll get instructor features like:
   - Student progress tracking
   - Assignment creation
   - Grade book access
   - Analytics on student interactions

## Important Configuration Notes

### R Code Execution in Runestone
**Good news: Runestone DOES support R code through SageMath cells!**

Based on other Runestone textbooks, R execution works via:
- `<sage language="r">` tags with `<input>` blocks
- SageCell server integration (configured in publication/runestone.ptx)
- Each cell runs independently via https://sagecell.sagemath.org

**Syntax:**
```xml
<sage language="r">
  <input>
# Your R code here
data &lt;- data.frame(...)
print(data)
  </input>
</sage>
```

**Note:** Use `&lt;-` (XML-encoded) for R's assignment operator in the source files.

### Sage Cells in Runestone (Independent Sessions)
**Independence of Sage Cells**: Each Sage cell in the interactive Runestone textbook runs completely independently. Variables created in one cell are NOT available in other cells. This means:
- Students must re-create or re-load data in each cell where they need it
- You should include all necessary setup code in each Sage cell
- Explain this clearly to students to avoid confusion

**Best Practice - Cumulative Code Pattern**:
Since there is NO persistent R session or workspace students can build upon, use this pattern:
- **Cell 1**: Create data + show it
- **Cell 2**: Create data (repeated) + table command
- **Cell 3**: Create data (repeated) + bar graph command
- **Cell 4**: Create data (repeated) + new analysis command

This "cumulative code" approach (similar to CourseKata) means:
- Each cell is self-contained and can run independently
- Students don't have to scroll back and re-run earlier cells
- Later cells include all previous setup PLUS the new command
- Comment the repeated code as "from earlier" so it's clear what's new

**Common Issues**:
- If students see `<rpy2.rinterface_lib.sexp.NULLType object...>` message, the R code didn't produce output properly
- Solution: Use explicit `print()` statements for all output (e.g., `print(table(data))` instead of just `table(data)`)
- Always include verification text after Sage cells so students know what output to expect

**Expand Window Feature**: 
- Sage cells have an expand icon to open in a larger window
- Known issue: This sometimes shows a white screen in Runestone
- Workaround: Students should run code in the inline cell first, then expand if needed
- The expanded window does NOT maintain state between cells (still independent)

### In publication/publication.ptx:
- Update `<book-id>` to match what you set on Runestone Academy
- This must be unique and lowercase with no spaces

### GitHub Repository:
- Keep it public for easier Runestone integration
- Or make it private and give Runestone access

### Building Locally:
```powershell
# Build for runestone target
pretext build runestone

# View locally (optional)
pretext view runestone
```

## Workflow Summary
1. Create content in `source/main.ptx`
2. Build locally to test: `pretext build`
3. Commit and push to GitHub
4. Runestone Academy pulls from GitHub and builds
5. Create course on Runestone using your book
6. Students enroll in your course

## Getting Help
- PreTeXt documentation: https://pretextbook.org/doc/guide/html/
- Runestone documentation: https://runestone.academy/ns/books/published/overview/overview.html
- PreTeXt forum: https://groups.google.com/g/pretext-support
