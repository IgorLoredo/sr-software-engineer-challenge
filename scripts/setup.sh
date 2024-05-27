#!/bin/bash

#Create topics
kafka-topics --create --topic itausegdev-insurance-quote-received --bootstrap-server broker:9092 --partitions 3 --replication-factor 1
kafka-topics --create --topic itausegdev-insurance-policy-emitted --bootstrap-server broker:9092 --partitions 3 --replication-factor 1

curl -X POST -H "Content-Type:application/vnd.schemaregistry.v1+json" --data '{"schema": "'"$(cat /schemas/br.itausegdev.quotes.schemas.insurance_quote_received.avsc)"'"}' http://schema-registry:8081/subjects/itausegdev-insurance-quote-received/versions 
curl -X POST -H "Content-Type:application/vnd.schemaregistry.v1+json" --data '{"schema": "'"$(cat /schemas/br.itausegdev.policies.schemas.insurance_policy_emitted.avsc)"'"}' http://schema-registry:8081/subjects/itausegdev-insurance-policy-emitted/versions

