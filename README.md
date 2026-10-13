# NEXORA Local AI (https://nexora-org-web.github.io/NEXORA-Local-AI/index.html)

Run a small AI model (Gemma 3 270M) on your own PC or from a USB drive.
No internet needed after setup, no message limits, nothing leaves your computer.
## Download All Files In Zip - https://github.com/user-attachments/files/33340325/Portable.Local.Ai.By.NEXORA.zip

## Quick start (Windows)

1. Extract this folder anywhere (a USB drive works too).
2. Double-click `setup.bat` **once** (needs internet). It downloads the engine and the model.
   - Skip this step if the release you downloaded already includes `bin/` and `models/` files.
3. Double-click `start.bat`, then press **ENTER**.
4. When the window says the server is listening, open this in your browser:

   **http://127.0.0.1:8080**

5. Chat. Close the terminal window to stop the AI.

> The address is `http://`, not `https://`. This is normal for a local app and is private to your computer.

## Folder layout

```
NexoraAI/
├── start.bat      <- run the AI
├── setup.bat      <- one-time download of engine + model
├── bin/           <- llama.cpp (llama-server.exe and DLLs)
└── models/        <- gemma-3-270m-it-Q8_0.gguf
```

## Manual download (if setup.bat fails)

- Engine: https://github.com/ggml-org/llama.cpp/releases - download the `win-cpu-x64` zip and extract everything into `bin/`.
- Model: https://huggingface.co/ggml-org/gemma-3-270m-it-GGUF - download `gemma-3-270m-it-Q8_0.gguf` into `models/`.

## Notes

- Gemma 3 270M is tiny. It is fast on any PC, but its answers are basic. Larger GGUF models (1B-4B) work with the same setup: put the file in `models/` and edit the filename in `start.bat`.
- The default model has built-in safety tuning. Other community GGUF models may behave differently; check each model's license and quality yourself.
- To use another port, change `8080` in `start.bat`.
- Linux/macOS: use the matching llama.cpp build and run `llama-server -m models/<file>.gguf --port 8080`.

## Licenses

- llama.cpp: MIT License - https://github.com/ggml-org/llama.cpp
- Gemma: use is subject to the Gemma Terms of Use and Prohibited Use Policy - https://ai.google.dev/gemma/terms
  If you redistribute the model file, include these terms.

---

©NEXORA - https://github.com/nexora-org-web/Nexora-Official/tree/main
