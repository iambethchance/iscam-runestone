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
