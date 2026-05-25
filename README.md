# Bunting Previewer — Setup Guide

## Files in this folder
- `index.html` — maker sign up / log in page
- `dashboard.html` — maker dashboard (upload fabrics, tag, manage)
- `preview.html` — customer previewer (loaded at /preview/[slug])
- `vercel.json` — routing config for Vercel
- `schema.sql` — database tables (paste into Supabase)

---

## Step 1 — Supabase database setup

1. Go to your Supabase project → **SQL Editor**
2. Paste the entire contents of `schema.sql` and click **Run**
3. If you see errors about storage policies, run those separately (the last block)

---

## Step 2 — Deploy to Vercel

### Option A — Drag and drop (easiest)
1. Go to vercel.com → **Add New Project**
2. Choose **"Deploy without a Git repository"** (or "Browse" to upload)
3. Drag this entire folder in
4. Click **Deploy** — done in ~30 seconds

### Option B — GitHub (recommended for ongoing updates)
1. Create a new GitHub repo (can be private)
2. Push these files to the repo root
3. Go to vercel.com → **Add New Project** → import from GitHub
4. No build settings needed — it's all static HTML
5. Click **Deploy**

---

## Step 3 — Configure Supabase auth redirect URLs

After deploy, Vercel gives you a URL like `https://your-app.vercel.app`

1. Go to Supabase → **Authentication → URL Configuration**
2. Add these to **Redirect URLs**:
   - `https://your-app.vercel.app/dashboard`
   - `http://localhost:3000/dashboard` (for local testing)
3. Set **Site URL** to `https://your-app.vercel.app`

---

## Step 4 — Custom domain (optional)

In Vercel → your project → **Settings → Domains**, add your domain.
Then update the Supabase redirect URLs to use your custom domain.

---

## How it works

**As a maker:**
1. Sign up at `your-app.vercel.app` — choose your slug (e.g. `bobbinbaby`)
2. Confirm your email (magic link)
3. Go to dashboard → upload fabrics, name them, add tags
4. Click a swatch to toggle it in/out of the customer pool
5. Copy your customer link: `your-app.vercel.app/preview/bobbinbaby`
6. Share that link with customers

**As a customer:**
1. Open the maker's link
2. Fabrics load automatically — select which ones you want
3. Filter by tag, type your name, randomise
4. Click/shift-click flags to cycle or lock fabrics
5. Download the preview as a PNG

---

## Adding more makers

Other makers sign up themselves at your index page — it's fully self-serve.
Each gets their own slug and fabric library, completely separate.

---

## Local testing

Just open `index.html` in a browser — no local server needed for most features.
For auth redirects to work locally, you'll need a local server:
```
npx serve .
```
Then visit `http://localhost:3000`
