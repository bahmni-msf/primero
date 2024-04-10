#!/bin/bash

set -euo pipefail

# Function for logging errors
log_error() {
    echo "[ERROR] $1" >&2
}

# Validate required environment variables
if [[ -z "${SERVICES}" || -z "${Role_ARN}" || -z "${ENV_BUCKET}" || -z "${FS_ID}" ]]; then
    log_error "One or more required environment variables are not set."
    exit 1
fi

# Validate AWS CLI installation
if ! command -v aws &>/dev/null; then
    log_error "AWS CLI is not installed."
    exit 1
fi

# Validate jq installation
if ! command -v jq &>/dev/null; then
    log_error "jq is not installed."
    exit 1
fi

echo "Role_ARN: $Role_ARN"
echo "ENV_BUCKET: $ENV_BUCKET"
echo "FS_ID: $FS_ID"

# Convert the JSON object into an array and then loop through each object
echo "$SERVICES" | jq -c '. | [.] | .[]' | while IFS= read -r service; do
    task_definition=$(jq -r '.task_definition' <<< "$service")
    container_name=$(jq -r '.container_name' <<< "$service")
    image=$(jq -r '.image' <<< "$service")
    service_name=$(jq -r '.service_name' <<< "$service")

    # Replace placeholders in JSON file with actual bucket name, role arn, and FileSystem ID
    sed -i "s#{{BUCKET_NAME}}#$ENV_BUCKET#g; s#{{ROLE_ARN}}#$Role_ARN#g; s#{{FILESYSTEM_ID}}#$FS_ID#g" "$GITHUB_WORKSPACE/$task_definition"

    # Update task definition with the new image
    new_task_definition_arn=$(aws ecs register-task-definition \
        --cli-input-json file://"$GITHUB_WORKSPACE/$task_definition" \
        --container-definitions "$(jq --arg container_name "$container_name" --arg image "$image" '.containerDefinitions[] | if .name == $container_name then .image = $image else . end' "$GITHUB_WORKSPACE/$task_definition")" \
        --query 'taskDefinition.taskDefinitionArn' \
        --output text)

    # Update ECS service with the new task definition
    aws ecs update-service \
        --cluster "$ECS_CLUSTER" \
        --service "$service_name" \
        --task-definition "$new_task_definition_arn"
done

