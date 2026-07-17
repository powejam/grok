# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

grok is a password generator PWA — no ads, no tracking, fully client-side. It is deployed via GitHub Pages, which builds automatically on push to `main`.

## Development

No build step, no dependencies. Serve the repo root and open it:

```
python3 -m http.server 8000
```

There is no test framework; verify changes by loading the page in a browser (headless Chrome screenshots work: `google-chrome --headless=new --screenshot=... http://localhost:8000/`).

## Architecture

- `index.html` — the entire app: all CSS and JS are inline. Character sets, generation logic (crypto.getRandomValues with rejection sampling, per-set guarantee, Fisher–Yates shuffle), and the entropy-based strength meter all live in its single `<script>` block.
- `sw.js` — service worker, cache-first. **Bump the `CACHE` version constant whenever any asset changes**, or clients will keep serving the stale cached copy.
- `manifest.webmanifest` / `icons/` — PWA metadata. Icons are rendered from SVG with ImageMagick (`convert`); the four-dot motif uses the same character-class colors as the UI.
- All URLs are relative (`./`) because GitHub Pages serves the app from a subpath (`/grok/`). Keep them relative.

## Conventions

- Dark theme only; design tokens are CSS custom properties in `:root` in index.html.
- Character classes (upper/lower/digit/common/extended symbols) each have a color used consistently across the password display, checkbox samples, checkbox accents, and app icon. New character-class features should follow this pattern.
- System font stacks only — the app must work fully offline, so no web fonts or other external resources.
