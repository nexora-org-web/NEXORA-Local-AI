# NEXORA Local AI

Run a small AI model (Qwen2.5-Coder-0.5B-Instruct-heretic) on your own Windows PC or from a USB drive.

- No internet needed after setup.
- No message limits imposed by a cloud AI service.
- AI inference runs locally on your computer.
- Your prompts are not sent to a cloud AI API.

## Download All Files in ZIP

Get the complete project from the NEXORA GitHub repository:

https://github.com/nexora-org-web/NEXORA-Local-AI

## Quick Start (Windows)

1. Extract the ZIP file anywhere on your computer. A USB drive works too.

2. Double-click `setup.bat` while connected to the internet.

3. Read the instructions displayed in the terminal. Press `Y`, then `ENTER`, to begin setup.

4. The setup script downloads the llama.cpp runtime and the Qwen model automatically.

5. Wait until the terminal displays `[COMPLETED]`.

6. Double-click `start.bat`.

7. Your default browser should open the NEXORA Local AI chat interface automatically.

   If it does not, open this address manually:

   **http://127.0.0.1:8080/index.html**

8. Start chatting!

Keep the terminal window open while using the AI. Press `Ctrl+C` in that window to stop the server.

> The address uses `http://`, not `https://`. This is normal for a local application. The server listens on `127.0.0.1`, so it is intended to be accessible only from your own computer.

## Folder Layout

```text
NEXORA-Local-AI/
├── setup.bat       <- Downloads the AI runtime and model
├── start.bat       <- Starts the local AI server and opens the browser
├── README.txt      <- Instructions and documentation
└── web/
    └── index.html  <- Modern NEXORA AI chat interface

---

©NEXORA - https://github.com/nexora-org-web/Nexora-Official/tree/main
