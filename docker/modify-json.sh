#!/bin/bash

set -euxo pipefail

# Read service name and image names from environment variables
SERVICE_NAME="$1"
IMAGE_NAMES=$(echo "$IMAGE_NAMES" | tr -d '\n')

# Check if service name or image names are empty
if [ -z "$SERVICE_NAME" ]; then
  echo "Error: Service name not provided."
  exit 1
fi

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

# Escape special characters in the image name for sed
ESCAPED_IMAGE_NAMES=$(echo "$IMAGE_NAMES" | sed 's/[\/&]/\\&/g')

# Filter the JSON array to extract only the object for the specified service
UPDATED_JSON=$(jq --arg service "$SERVICE_NAME" '.[] | select(.service_name == $service)' "$SERVICES_JSON_PATH")

# Use sed to filter the JSON array and update the image field for the specified service
# sed -i "/\"service_name\": \"$SERVICE_NAME\"/ {N;s|\"image\": \"\"|\"image\": \"$IMAGE_NAMES\"|}" "$UPDATED_JSON"
sed -i "/\"service_name\": \"$SERVICE_NAME\"/ {N;s|\"image\": \"\"|\"image\": \"$ESCAPED_IMAGE_NAMES\"|}" "$UPDATED_JSON"

# Output the updated JSON content as a string
echo "$UPDATED_JSON"
