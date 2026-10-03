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
  echo "Run: ./bootstrap.sh" >&2
  exit 1
fi

SOURCE_DIR=$(CDPATH= cd -- "$(dirname -- "$SOURCE")" && pwd)
SOURCE_NAME=$(basename -- "$SOURCE")
BASENAME=${SOURCE_NAME%.*}

mkdir -p "$ROOT_DIR/dist"

OUTPUT="$ROOT_DIR/dist/$BASENAME.html"

if pandoc --help 2>&1 | grep -q -- '--embed-resources'; then
  RESOURCE_OPTION=--embed-resources
elif pandoc --help 2>&1 | grep -q -- '--self-contained'; then
  RESOURCE_OPTION=--self-contained
else
  echo "Error: this Pandoc version supports neither --embed-resources nor --self-contained." >&2
  echo "Detected: $(pandoc --version | head -n 1)" >&2
  exit 1
fi

pandoc "$SOURCE" \
  --from=markdown+yaml_metadata_block+fenced_divs \
  --to=html5 \
  --standalone \
  "$RESOURCE_OPTION" \
  --template="$ROOT_DIR/templates/article.html" \
  --css="$ROOT_DIR/themes/gotoo.css" \
  --resource-path="$SOURCE_DIR:$ROOT_DIR" \
  --output="$OUTPUT"

echo "$OUTPUT"
