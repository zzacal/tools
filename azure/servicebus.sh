#! /bin/bash

TOP_NAME=yes
RESOURCE_GROUP=$TOP_NAME-group
SURVICEBUS_NAME=$TOP_NAME-bus
TOPIC_NAME=$TOP_NAME-topic
SUBSCRIPTION_NAME=$TOP_NAME-sub
ACCESS_POLICY_NAME=readwrite
LOCATION=westcentralus

az group create \
  --location westcentralus \
  --name $RESOURCE_GROUP

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

az servicebus topic authorization-rule create \
  --name $ACCESS_POLICY_NAME \
  --namespace-name $SURVICEBUS_NAME \
  --resource-group $RESOURCE_GROUP \
  --topic-name $TOPIC_NAME \
  --rights Manage Send Listen \
