#!/bin/bash

set -euxo pipefail

services_json="${SERVICES}"

for service in $(echo "$services_json" | jq -c '.[]'); do
    task_definition=$(echo "$service" | jq -r '.task_definition')
    container_name=$(echo "$service" | jq -r '.container_name')
    image=$(echo "$service" | jq -r '.image')
    service_name=$(echo "$service" | jq -r '.service_name')

    # Update task definition with the new image
    new_task_definition_arn=$(aws ecs register-task-definition \
        --cli-input-json file://$task_definition \
        --container-definitions "$(jq --arg container_name "$container_name" --arg image "$image" '.containerDefinitions[] | if .name == $container_name then .image = $image else . end' $task_definition)" \
        --query 'taskDefinition.taskDefinitionArn' \
        --output text)

    # Update ECS service with the new task definition
    aws ecs update-service \
        --cluster $ECS_CLUSTER \
        --service $service_name \
        --task-definition $new_task_definition_arn
done
