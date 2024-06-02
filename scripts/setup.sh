#!/bin/sh

# Create topics
echo "###################################### Creating topics ######################################"
kafka-topics --bootstrap-server broker:29092 --create --if-not-exists --topic itausegdev-insurance-quote-received --replication-factor 1 --partitions 3 
kafka-topics --bootstrap-server broker:29092 --create --if-not-exists --topic itausegdev-insurance-policy-emitted --replication-factor 1 --partitions 3 
echo "###################################### Topics were created successfully ######################################"

echo "###################################### Registering schemas ######################################"

SCHEMA_REGISTRY_URL=http://schema-registry:8081

FILE_PATH_ONE="/schemas/br.itausegdev.quotes.schemas.insurance_quote_received.avsc"
SCHEMA_ONE='{"schema":"'$(cat ${FILE_PATH_ONE} | tr '\n' '\r' | sed  's/"/\\"/g' | sed 's/\s//g')'"}'
SUBJECT_ONE="itausegdev-insurance-quote-received-value"
URL_ONE="${SCHEMA_REGISTRY_URL}/subjects/${SUBJECT_ONE}/versions" 

cat ${FILE_PATH_ONE} | tr '\n' '\r' | sed  's/"/\\"/g' | sed 's/\s//g'

echo -e "###################################### Registering schema ${FILE_PATH_ONE} ######################################"
curl -X POST -H 'Content-Type:application/vnd.schemaregistry.v1+json' --data ${SCHEMA_ONE} ${URL_ONE}
echo -e "###################################### Schema ${FILE_PATH_ONE} was registered successfully ######################################"


FILE_PATH_TWO="/schemas/br.itausegdev.policies.schemas.insurance_policy_emitted.avsc"
SCHEMA_TWO='{"schema":"'$(cat ${FILE_PATH_TWO} | tr '\n' '\r' | sed  's/"/\\"/g' | sed 's/\s//g')'"}'
SUBJECT_TWO="itausegdev-insurance-policy-emitted-value"
URL_TWO="${SCHEMA_REGISTRY_URL}/subjects/${SUBJECT_TWO}/versions" 

cat ${FILE_PATH_TWO} | tr '\n' '\r' | sed  's/"/\\"/g' | sed 's/\s//g'

echo -e "###################################### Registering schema ${FILE_PATH_TWO} ######################################"
curl -X POST -H 'Content-Type:application/vnd.schemaregistry.v1+json' --data ${SCHEMA_TWO} ${URL_TWO}
echo -e "###################################### Schema ${FILE_PATH_TWO} was registered successfully ######################################"


echo -e "###################################### Schemas were registered successfully ######################################"

tail -f /dev/null
