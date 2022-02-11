#! /bin/bash

##
# WARNING:
#  Concatenating vars is done for iteration convenience only
#  Recommend only specified names for resources
##
NAMESPACE=space-race
RESOURCE_GROUP=$NAMESPACE-group
COSMOS_ACCOUNT_NAME=$NAMESPACE-cosmos
DB_NAME=$NAMESPACE-mongod

COSMOS_KIND=MongoDB
THROUGHPUT=400
MAX_THROUGHPUT=4000
COLLECTION_NAME=users
SHARD_KEY_PATH=the-dang-shard-key

if [ "false" != "$DRYRUN" ]
then
  echo "check these values:"
  echo "    NAMESPACE=$NAMESPACE"
  echo "    RESOURCE_GROUP=$RESOURCE_GROUP"
  echo "    COSMOS_ACCOUNT_NAME=$COSMOS_ACCOUNT_NAME"
  echo "    COSMOS_KIND=$COSMOS_KIND"
  echo "    DB_NAME=$DB_NAME"
  echo "    COLLECTION_NAME=$COLLECTION_NAME"
  echo "    SHARD_KEY_PATH=$SHARD_KEY_PATH"
  echo "    THROUGHPUT=$THROUGHPUT"
  echo "    MAX_THROUGHPUT=$MAX_THROUGHPUT"
  echo
  echo "ensure:"
  echo "    az login"
  echo "    az account set --subscription=[THE_NAME_OF_YOUR_SUBSCRIPTION_YOU_WANT_TO_ITERATE_IN]"
  echo
  echo "to execute:"
  echo "    DRYRUN=false ./cosmosdb.sh"
  exit 0
fi

  # Create resource group
  az group create --location westcentralus \
                  --name $RESOURCE_GROUP \

  # Create a Cosmos account for mongodb API
  az cosmosdb create \
      -n $COSMOS_ACCOUNT_NAME \
      -g $RESOURCE_GROUP \
      --kind $COSMOS_KIND \
      --default-consistency-level Eventual \
      --locations regionName='West Central US' failoverPriority=0 isZoneRedundant=False \
      --locations regionName='Central US' failoverPriority=1 isZoneRedundant=False

  # Create a document database
  az cosmosdb mongodb database create --account-name $COSMOS_ACCOUNT_NAME \
                                      --name $DB_NAME \
                                      --resource-group $RESOURCE_GROUP \
                                      --throughput $THROUGHPUT \

  # Create a document collection
  az cosmosdb mongodb collection create --account-name $COSMOS_ACCOUNT_NAME \
                                        --database-name $DB_NAME \
                                        --name $COLLECTION_NAME \
                                        --resource-group $RESOURCE_GROUP \
                                        --throughput $THROUGHPUT \
                                        --shard $SHARD_KEY_PATH \
