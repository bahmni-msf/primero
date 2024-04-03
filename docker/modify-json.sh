#!/bin/bash

set -euxo pipefail

# Remove any newline characters from the image names
IMAGE_NAMES=$(echo "$IMAGE_NAMES" | tr -d '\n')

# Check if image names are empty
if [ -z "$IMAGE_NAMES" ]; then
  echo "Error: No image names were generated."
  exit 1
fi

SERVICES_JSON_PATH="docker/services.json"

# Check if services.json exists
if [ ! -f "$SERVICES_JSON_PATH" ]; then
  echo "Error: $SERVICES_JSON_PATH not found."
  exit 1
fi

# Replace the empty image field with the generated image names
sed -i "s|\"image\": \"\"|\"image\": \"$IMAGE_NAMES\"|g" "$SERVICES_JSON_PATH"

# Output the updated JSON content directly
cat "$SERVICES_JSON_PATH"
