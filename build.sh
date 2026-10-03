#!/usr/bin/env sh
set -eu

ROOT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)

if [ "$#" -ne 1 ]; then
  echo "Usage: $0 path/to/article.md" >&2
  exit 2
fi

SOURCE=$1

if [ ! -f "$SOURCE" ]; then
  echo "Error: source file not found: $SOURCE" >&2
  exit 1
fi

if ! command -v pandoc >/dev/null 2>&1; then
  echo "Error: pandoc is required but was not found in PATH." >&2
  exit 1
fi

SOURCE_DIR=$(CDPATH= cd -- "$(dirname -- "$SOURCE")" && pwd)
SOURCE_NAME=$(basename -- "$SOURCE")
BASENAME=${SOURCE_NAME%.*}

mkdir -p "$ROOT_DIR/dist"

OUTPUT="$ROOT_DIR/dist/$BASENAME.html"

pandoc "$SOURCE" \
  --from=markdown+yaml_metadata_block+fenced_divs \
  --to=html5 \
  --standalone \
  --embed-resources \
  --template="$ROOT_DIR/templates/article.html" \
  --css="$ROOT_DIR/themes/gotoo.css" \
  --resource-path="$SOURCE_DIR:$ROOT_DIR" \
  --output="$OUTPUT"

echo "$OUTPUT"
