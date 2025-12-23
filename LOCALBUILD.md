# Setup for local build

Reference: https://pretextbook.org/doc/guide/html/tutorial-install.html

1. Install VSCode
1. Install docker desktop - usually requires reboot plus WSL update.
    1. Do not need to sign in to docker desktop.
1. Create new repo
1. Download pretext codespace zip file and unzip into new repo. Folder .devcontainer should be top-level folder in the repo.
1. Open VSCode
1. Install VSCode extensions:
    1. Dev Containers
    1. PreTeXt-tools
1. Open the repo folder.
1. If it doesn't ask to open in dev container, hit ctrl-shift-p and choose "Dev Containers: Reopen in Container"
1. Open a terminal (ctrl-`). Should see $ prompt for dev container (linux).
1. Create pretext files: `pretext init`
1. project.ptx should look like this:
    ```
    <?xml version="1.0" encoding="UTF-8"?>
    <project ptx-version="2">
    <targets>
        <target name="html" format="html" publication="publication.ptx"/>
        <target name="runestone" format="html" publication="runestone.ptx"/>
    </targets>
    </project>
    ```
1. To build html: `pretext build html`
1. To view html: from vscode bottom var, "> PreTeXt" choose "View full document" | html
    1. This should open a browser pointing to http://localhost:8131/output/html
