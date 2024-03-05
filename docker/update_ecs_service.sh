#!/bin/bash

set -euxo pipefail

services_json="${SERVICES}"

echo "Role_ARN: $Role_ARN"
echo "ENV_BUCKET: $ENV_BUCKET"
echo "FS_ID: $FS_ID"

for service in $(echo "$services_json" | jq -c '.[]'); do
    task_definition=$(echo "$service" | jq -r '.task_definition')
    container_name=$(echo "$service" | jq -r '.container_name')
    image=$(echo "$service" | jq -r '.image')
    service_name=$(echo "$service" | jq -r '.service_name')

    # Replace placeholder in JSON file with actual bucket name
    sed -i "s/{{BUCKET_NAME}}/$ENV_BUCKET/g" "$GITHUB_WORKSPACE/$task_definition"
    sed -i "s/{{ROLE_ARN}}/$Role_ARN/g" "$GITHUB_WORKSPACE/$task_definition"
    # sed -i "s/{{FILESYSTEM_ID}}/$FS_ID/g" "$GITHUB_WORKSPACE/$task_definition"

    # Update task definition with the new image
    new_task_definition_arn=$(aws ecs register-task-definition \
        --cli-input-json file://$GITHUB_WORKSPACE/$task_definition \
        --container-definitions "$(jq --arg container_name "$container_name" --arg image "$image" '.containerDefinitions[] | if .name == $container_name then .image = $image else . end' $task_definition)" \
        --query 'taskDefinition.taskDefinitionArn' \
        --output text)

    # Update ECS service with the new task definition
    aws ecs update-service \
        --cluster $ECS_CLUSTER \
        --service $service_name \
        --task-definition $new_task_definition_arn
done
