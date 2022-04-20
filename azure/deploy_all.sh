#! /bin/bash

TOP_NAME=trembling

# VARS RESOURCE GROUP
RESOURCE_GROUP=$TOP_NAME-group

# VARS SERVICE BUS
SURVICEBUS_NAME=$TOP_NAME-bus
TOPIC_NAME=loungecheckin-topic
SUBSCRIPTION_NAME=analytics-subscription
SUBSCRIPTION_NAME2=database-subscription
ACCESS_POLICY_NAME=readwrite
LOCATION=westus2

# VARS COSMOS
COSMOS_ACCOUNT_NAME=$TOP_NAME-cosmos
DB_NAME=lounge
COSMOS_KIND=GlobalDocumentDB
THROUGHPUT=400
MAX_THROUGHPUT=4000
COLLECTION_NAME=checkins
SHARD_KEY_PATH=fullName

# STORAGE
STORAGE_ACCOUNT_NAME=${TOP_NAME}tempstore

# FUNCTION
PLAN_NAME=$TOP_NAME-plan
FUNC_NAME=$TOP_NAME-func
FUNC_ID_NAME=$TOP_NAME-func-id

## RESOURCE GROUP ##
az group create \
  --location westcentralus \
  --name $RESOURCE_GROUP

## SERVICE BUS ##
az servicebus namespace create \
  --resource-group $RESOURCE_GROUP \
  --name $SURVICEBUS_NAME \
  --location $LOCATION

az servicebus topic create \
  --resource-group $RESOURCE_GROUP \
  --namespace-name $SURVICEBUS_NAME \
  --name $TOPIC_NAME

az servicebus topic subscription create \
  --resource-group $RESOURCE_GROUP \
  --namespace-name $SURVICEBUS_NAME \
  --topic-name $TOPIC_NAME \
  --name $SUBSCRIPTION_NAME \

az servicebus topic subscription create \
  --resource-group $RESOURCE_GROUP \
  --namespace-name $SURVICEBUS_NAME \
  --topic-name $TOPIC_NAME \
  --name $SUBSCRIPTION_NAME2 \

az servicebus topic authorization-rule create \
  --name $ACCESS_POLICY_NAME \
  --namespace-name $SURVICEBUS_NAME \
  --resource-group $RESOURCE_GROUP \
  --topic-name $TOPIC_NAME \
  --rights Manage Send Listen \

## COSMOS ##
az cosmosdb create \
    -n $COSMOS_ACCOUNT_NAME \
    -g $RESOURCE_GROUP \
    --kind $COSMOS_KIND \
    --default-consistency-level Eventual \
    --locations regionName='North Central US' failoverPriority=0 isZoneRedundant=False \
    # --locations regionName='Central US' failoverPriority=1 isZoneRedundant=False

# Create a document database
az cosmosdb sql database create \
  --account-name $COSMOS_ACCOUNT_NAME \
  --name $DB_NAME \
  --resource-group $RESOURCE_GROUP \
  --throughput $THROUGHPUT \

# Create a document collection
az cosmosdb sql container create \
  --account-name $COSMOS_ACCOUNT_NAME \
  --database-name $DB_NAME \
  --name $COLLECTION_NAME \
  --resource-group $RESOURCE_GROUP \
  --partition-key-path "/fullName" \


## STORAGE ACCOUNT ##
az storage account create \
    --resource-group $RESOURCE_GROUP \
    --name $STORAGE_ACCOUNT_NAME \
    --location $LOCATION \
    --sku Standard_LRS

## FUNCTION ##
az functionapp create --name $FUNC_NAME \
                      --resource-group $RESOURCE_GROUP \
                      --storage-account $STORAGE_ACCOUNT_NAME \
                      --consumption-plan-location $LOCATION \
                      --functions-version 4 \
                      --runtime node \
                      --assign-identity '[system]' \
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
az identity create \
    --name $FUNC_ID_NAME \
    --resource-group $RESOURCE_GROUP \
    --location $LOCATION \

# Assign Identity to Function App
az functionapp identity assign \
    --name $FUNC_NAME \
    --resource-group $RESOURCE_GROUP \
    --identities $FUNC_ID \
