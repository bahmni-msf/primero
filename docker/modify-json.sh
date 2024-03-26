set -euxo pipefail

          # Read image names from environment variables
          echo "Generated Image Names=$IMAGE_NAMES"

          # Update the image field in the services JSON with the generated image names
          IMAGE_NAMES=$(echo "$IMAGE_NAMES" | tr -d '\n')

          # Check if image names are empty
          if [ -z "$IMAGE_NAMES" ]; then
            echo "Error: No image names were generated."
            exit 1
          fi

          # Check if services.json exists
          if [ ! -f "services.json" ]; then
            echo "Error: services.json not found."
            exit 1
          fi

          # Construct JSON object for image names
          IMAGE_JSON="{\"image\": \"$IMAGE_NAMES\"}"

          # Use jq to merge the constructed JSON with the existing JSON
          updated_json=$(jq --argjson image_json "$IMAGE_JSON" '.[] |= . + $image_json' services.json)

          # Check if jq command succeeded
          if [ $? -ne 0 ]; then
            echo "Error: Failed to update image names in services.json."
            exit 1
          fi

          # Save the updated JSON to a file
          if ! echo "$updated_json" > updated_services.json; then
            echo "Error: Failed to save updated JSON to updated_services.json."
            exit 1
          fi

          # Display the updated JSON
          cat updated_services.json

          # Set the output
          echo "::set-output name=services-json::$(<updated_services.json)"