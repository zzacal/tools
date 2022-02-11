#! /bin/bash
NAMESPACE=zac-scratch
RESOURCE_GROUP=$NAMESPACE-group
COSMOS_ACCOUNT_NAME=$NAMESPACE-cosmos
DB_NAME=$NAMESPACE-mongod

COSMOS_KIND=MongoDB
THROUGHPUT=400
MAX_THROUGHPUT=4000
COLLECTION_NAME=users
SHARD_KEY_PATH=someKey

echo "NAMESPACE=$NAMESPACE"
echo "RESOURCE_GROUP=$RESOURCE_GROUP"
echo "COSMOS_ACCOUNT_NAME=$COSMOS_ACCOUNT_NAME"
echo "DB_NAME=$DB_NAME"
echo "COSMOS_KIND=$COSMOS_KIND"
echo "THROUGHPUT=$THROUGHPUT"
echo "MAX_THROUGHPUT=$MAX_THROUGHPUT"

# Create resource group
az group create --location westcentralus \
                --name $RESOURCE_GROUP \

# Create a Cosmos account for SQL API
az cosmosdb create \
    -n $COSMOS_ACCOUNT_NAME \
    -g $RESOURCE_GROUP \
    --kind $COSMOS_KIND \
    --default-consistency-level Eventual \
    --locations regionName='West Central US' failoverPriority=0 isZoneRedundant=False \
    --locations regionName='Central US' failoverPriority=1 isZoneRedundant=False

az cosmosdb mongodb database create --account-name $COSMOS_ACCOUNT_NAME \
                                    --name $DB_NAME \
                                    --resource-group $RESOURCE_GROUP \
                                    --throughput $THROUGHPUT \

az cosmosdb mongodb collection create --account-name $COSMOS_ACCOUNT_NAME \
                                      --database-name $DB_NAME \
                                      --name $COLLECTION_NAME \
                                      --resource-group $RESOURCE_GROUP \
                                      --throughput $THROUGHPUT \
                                      --shard $SHARD_KEY_PATH \
