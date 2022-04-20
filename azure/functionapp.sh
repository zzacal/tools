#! /bin/bash
TOP_NAME=blocky
RESOURCE_GROUP=$TOP_NAME-group
STORAGE_ACCOUNT_NAME=${TOP_NAME}tempstore
PLAN_NAME=$TOP_NAME-plan
FUNC_NAME=$TOP_NAME-func
FUNC_ID_NAME=$TOP_NAME-func-id

LOCATION=westus2

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
                      --os-type Linux
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

# Create Managed Identity
identity = az identity create \
    --name $FUNC_ID_NAME \
    --resource-group $RESOURCE_GROUP \
    --location $LOCATION \

# example:
az identity create \
    --name glassy-func-id \
    --resource-group glassy-group \
    --location westcentralus

# Assign Identity to Function App
az functionapp identity assign \
    --name $FUNC_NAME \
    --resource-group $RESOURCE_GROUP \
    --identities $FUNC_ID \

# Allow Access to Service Bus
# example: 
# az role assignment create \
#     --role "Azure Service Bus Data Receiver" \
#     --assignee "a8a2a233-7399-4b19-9774-0b6065fd2f40" \
#     --scope "/subscriptions/c28725a0-a61d-4a6c-999a-0a8980111fbf/resourceGroups/glassy-group/providers/Microsoft.ServiceBus/namespaces/glassy-bus/topics/glassy-topic"
