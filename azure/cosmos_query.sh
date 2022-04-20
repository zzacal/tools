#! /bin/bash

az cosmosdb list-connection-strings \
  --resource-group glassy-group \
  --name glassy-cosmos \

az functionapp config appsettings set \
  --resource-group glassy-group \
  --name glassy-func \
  --settings "DOCDB_CONNECTION_STRING=AccountEndpoint=https://glassy-cosmos.documents.azure.com:443/;AccountKey=qwMjnGUdVyvmVPp6GUlPsDLgMHw1b4cJiZLvFHBICI0cTzNhh1l2KBPewbuaTQBuELpmA9vCIZ56Tq5j2TodFg==;"

az servicebus topic authorization-rule keys list \
  --subscription b8bbaf52-45da-4230-9095-7059567dc658 \
  --resource-group loungecheckin-test-group \
  --namespace-name loungecheckin-test-w2-bus \
  --topic-name loungecheckin-topic \
  --name Consumers

az monitor alert create \
  --name "DLQ has message" \
  --resource-group glassy-group
  --condition "DeadletteredMessages > 0" \
  --target glassy-bus
  # [--action]
  # [--description]
  # [--disabled {false, true}]
  # [--email-service-owners {false, true}]
  # [--location]
  # [--subscription]
  # [--tags]
  # [--target-namespace]
  # [--target-parent]
  # [--target-type]