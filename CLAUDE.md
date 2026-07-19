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
- `sw.js` — service worker. Network-first for page navigations (so a refresh always pulls the latest deploy, with the cache as offline fallback), cache-first for static assets. Its `CACHE` constant carries the app version (see Versioning).
- `manifest.webmanifest` / `icons/` — PWA metadata. The PNGs are rendered from the committed SVG sources (`icons/icon.svg`, `icons/icon-maskable.svg`) via headless Chrome screenshots at the target sizes; the motif is a beast emerging from the dark with glowing red eyes, over a haphazard scattered field of binary digits (a "password") in the same character-class colors as the UI.
- All URLs are relative (`./`) because GitHub Pages serves the app from a subpath (`/grok/`). Keep them relative.

## Versioning

The app is semver'd, and the version must be bumped on **every commit** that touches app files (patch for fixes/tweaks, minor for features, major for breaking changes or redesigns). Run:

```
scripts/bump-version.sh [major|minor|patch]   # default: patch
```

This updates the `index.html` footer (`vX.Y.Z · built YYYY-MM-DD`) and the `CACHE` constant in `sw.js` together — the latter invalidates clients' offline asset caches.

A pre-commit hook in `.githooks/` rejects commits that change app files without a bump. It is enabled per-clone with:

```
git config core.hooksPath .githooks
```

## Conventions

- Dark theme only; design tokens are CSS custom properties in `:root` in index.html.
- Character classes (upper/lower/digit/common/extended symbols) each have a color used consistently across the password display, checkbox samples, checkbox accents, and app icon. New character-class features should follow this pattern.
- System font stacks only — the app must work fully offline, so no web fonts or other external resources.
- A strict CSP `<meta>` tag in index.html blocks all external requests; any new resource must be same-origin or inline, and the CSP must be updated deliberately if a new resource type is added. Keep the no-referrer and notranslate metas and the `translate="no"` on the password element — they stop browsers shipping page content (including the password) to translation services.
