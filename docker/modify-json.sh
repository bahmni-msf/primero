#!/bin/bash

set -euxo pipefail

# Read image names from environment variables
echo "Generated Image Names=$IMAGE_NAMES"

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
sed -i "s/\"image\": \"\"/\"image\": \"$IMAGE_NAMES\"/g" "$SERVICES_JSON_PATH" || {
  echo "Error: Failed to update image names in services.json. Exiting..."
  exit 1
}

# Display the updated JSON
cat "$SERVICES_JSON_PATH"

# Set the output
echo "::set-output name=services-updated-json::$(<"$SERVICES_JSON_PATH")"
