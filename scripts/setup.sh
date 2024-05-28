#!/bin/sh

# Create topics
echo "###################################### Creating topics ######################################"
kafka-topics --bootstrap-server broker:29092 --create --if-not-exists --topic itausegdev-insurance-quote-received --replication-factor 1 --partitions 3 
kafka-topics --bootstrap-server broker:29092 --create --if-not-exists --topic itausegdev-insurance-policy-emitted --replication-factor 1 --partitions 3 
echo "###################################### Topics were created successfully ######################################"

echo "###################################### Registering schemas ######################################"

INSURANCE_QUOTE_SCHEMA=$(cat /schemas/br.itausegdev.quotes.schemas.insurance_quote_received.avsc | sed "s/'/\\'/g")
curl -X POST -H "Content-Type:application/vnd.schemaregistry.v1+json" --data "{\"schema\": \"${INSURANCE_QUOTE_SCHEMA}\"}" http://schema-registry:8081/subjects/itausegdev-insurance-quote-received-value/versions 

INSURANCE_POLICY_SCHEMA=$(cat /schemas/br.itausegdev.policies.schemas.insurance_policy_emitted.avsc | sed "s/'/\\'/g")
curl -X POST -H "Content-Type:application/vnd.schemaregistry.v1+json" --data "{\"schema\": \"${INSURANCE_POLICY_SCHEMA}\"}" http://schema-registry:8081/subjects/itausegdev-insurance-policy-emitted-value/versions

echo "###################################### Schemas were registered successfully ######################################"

tail -f /dev/null
