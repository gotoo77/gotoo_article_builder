#!/usr/bin/env sh
set -eu

if command -v pandoc >/dev/null 2>&1; then
  echo "pandoc already installed: $(pandoc --version | head -n 1)"
  exit 0
fi

echo "pandoc not found. Installing dependency..."

if command -v apt-get >/dev/null 2>&1; then
  sudo apt-get update
  sudo apt-get install -y pandoc
elif command -v dnf >/dev/null 2>&1; then
  sudo dnf install -y pandoc
elif command -v pacman >/dev/null 2>&1; then
  sudo pacman -S --needed pandoc
elif command -v brew >/dev/null 2>&1; then
  brew install pandoc
else
  echo "Error: unsupported package manager." >&2
  echo "Install pandoc manually, then rerun ./build.sh." >&2
  exit 1
fi

pandoc --version | head -n 1
echo "Bootstrap complete."
