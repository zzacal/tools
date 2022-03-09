#! /bin/bash
TOP_NAME=yes
RESOURCE_GROUP=$TOP_NAME-group
STORAGE_ACCOUNT_NAME=${TOP_NAME}tempstore
PLAN_NAME=$TOP_NAME-plan
FUNC_NAME=$TOP_NAME-func

LOCATION=westcentralus

echo $TOP_NAME
echo $RESOURCE_GROUP
echo $STORAGE_ACCOUNT_NAME
echo $FUNC_NAME
echo $LOCATION

az group create --location $LOCATION \
                  --name $RESOURCE_GROUP

az storage account create \
    --resource-group $RESOURCE_GROUP \
    --name $STORAGE_ACCOUNT_NAME \
    --location $LOCATION \
    --sku Standard_LRS

az functionapp create --name $FUNC_NAME \
                      --resource-group $RESOURCE_GROUP \
                      --storage-account $STORAGE_ACCOUNT_NAME \
                      --consumption-plan-location $LOCATION \
                      --functions-version 4 \
                      --runtime node \
                      # [--assign-identity]
                      # [--app-insights]
                      # [--app-insights-key]
                      
                      # [--deployment-local-git]
                      # [--deployment-container-image-name]
                      # [--deployment-source-branch]
                      # [--deployment-source-url]
                      # [--disable-app-insights {false, true}]
                      # [--docker-registry-server-password]
                      # [--docker-registry-server-user]
                      # [--role]
                      # [--runtime-version]
                      # [--scope]
                      # [--subnet]
                      # [--subscription]
                      # [--tags]
                      # [--vnet]
