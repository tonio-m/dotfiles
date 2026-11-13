---
name: youtube-summary
description: Summarize a YouTube video by downloading its original-language subtitles with yt-dlp. Use whenever the user gives a YouTube URL (youtube.com/watch, youtu.be, shorts) and asks for a summary, recap, or "what's this video about".
---

# YouTube video summary

Summarize a YouTube video from its subtitles. Always download subtitles with `yt-dlp`, and always prefer the **original** (spoken-language) track rather than a translated/auto-translated one.

## Steps

1. **Verify yt-dlp is available** (only if unsure): `yt-dlp --version`. If missing, tell the user to install it (`brew install yt-dlp` or `pip install yt-dlp`).

2. **Work in the scratchpad dir**, not the user's project. Use the session scratchpad directory for the downloaded `.srt` files.

3. **List available subtitle tracks** to find the original language:
   ```
   yt-dlp --list-subs "<URL>"
   ```
   - The original audio language is the track whose name ends in **`(Original)`** or whose code ends in **`-orig`** (e.g. `pt-orig` = Portuguese Original, `en-orig`). That is the one to download.
   - If there is a **manually-uploaded** track (listed under "Available subtitles" rather than "Available automatic captions"), prefer it over auto-captions for the same language.
   - If no `-orig` track exists, fall back to the plain language code that matches the spoken language (often `en`).

4. **Download the original subtitles** as SRT into the scratchpad. Use `--write-subs` for manual subs or `--write-auto-subs` for auto-captions (the `--list-subs` output tells you which exists). A combined command that works for either:
   ```
   yt-dlp --skip-download --write-subs --write-auto-subs \
     --sub-langs "<ORIG_LANG_CODE>" --sub-format srt --convert-subs srt \
     -o "%(title)s.%(ext)s" "<URL>"
   ```
   Replace `<ORIG_LANG_CODE>` with the code from step 3 (e.g. `pt-orig`).

5. **Read the downloaded `.srt`** and write the summary.

## Output

- State the video title, the original language, and the saved `.srt` filename/path.
- If you used auto-captions (no manual subs existed), note that briefly — auto-captions can contain transcription errors.
- Then give the summary. Default to a structured summary: a one-line gist, then the key points/sections with headers as the content warrants. Match length to the video; keep it tight. If the user asked for a specific format (bullets, TL;DR, timestamps), follow that instead.

## Notes

- `youtu.be/<id>`, `youtube.com/watch?v=<id>`, and `youtube.com/shorts/<id>` are all valid URLs to pass to yt-dlp.
- If a video genuinely has no subtitles in any language, `--list-subs` will say so — tell the user; do not fabricate a summary.
- An `impersonation` warning from yt-dlp is harmless and can be ignored if the download still succeeds.
