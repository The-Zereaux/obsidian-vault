#!/usr/bin/env bash
# Deploy the vault to GitHub Pages from the gh-pages branch.
set -euo pipefail

cd "$(dirname "$0")/.."

# Make sure we're starting from a clean main branch
git checkout main
git pull --ff-only origin main

# Create orphan gh-pages branch, wipe everything, then copy the repo (minus .git)
git branch -D gh-pages 2>/dev/null || true
git checkout --orphan gh-pages
git rm -rf . 2>/dev/null || true

# Copy working tree (excludes .git)
cp -a . .ghpages-tmp
rm -rf .ghpages-tmp/.git

# Move contents up into the root of the gh-pages branch
find .ghpages-tmp -mindepth 1 -maxdepth 1 -exec mv {} . \;
rm -rf .ghpages-tmp

git add -A
git commit -m "Deploy to GitHub Pages: $(date +%Y-%m-%d)"
git push origin gh-pages
echo "=== Pages deployed. Push this commit to the repo then set Pages source to 'gh-pages' in GitHub repo settings. ==="
