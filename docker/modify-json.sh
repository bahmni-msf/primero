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

# Save the JSON data to a temporary file
echo "$SERVICES" > /tmp/services.json

# Path to the services JSON file
SERVICES_FILE="/tmp/services.json"

# Replace the empty image field with the generated image names for the specified service
sed -i "s|\"image\": \"\"|\"image\": \"$IMAGE_NAMES\"|g" "$SERVICES_FILE"

# Filter the JSON array to extract only the object for the specified service
UPDATED_JSON=$(jq --arg service "$SERVICE_NAME" '.[] | select(.service_name == $service)' "$SERVICES_FILE")

# Output the updated JSON content as a string
UPDATED_JSON_STRING=$(echo "$UPDATED_JSON" | jq -c '.')
echo "$UPDATED_JSON_STRING"

# Clean up temporary file
rm "$SERVICES_FILE"