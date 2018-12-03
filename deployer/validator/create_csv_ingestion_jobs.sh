#!/bin/bash
set -eox pipefail

curl -m 120 -f -X POST \
  http://$1:4599/api/v1/streams/ \
  -H 'Cache-Control: no-cache' \
  -H 'Content-Type: application/json' \
  -d "{
  \"query\" : \"select * from demo_trade_view\",
  \"source\" : {
    \"name\" : \"file\",
    \"viewName\" : \"demo_trade_view\",
    \"encoding\" : \"csv\",
    \"separator\" : \",\",
    \"schemaName\" : \"demo_trade\",
    \"path\" : \"/tmp/bigdemodata/csv1/\"
  },
  \"sink\" : {
    \"name\" : \"kafka\",
    \"schemaName\" : \"demo_trade_ingest\",
    \"topic\" : \"in_writer\",
    \"encoding\" : \"canonical\",
    \"triggerTime\" : \"1 second\",
    \"bootstrapServers\" : \"$NAME-kafka:9092\",
    \"numPartitions\" : 1,
    \"replicationFactor\" : 1
  }
}"


# demo-trade-ingest-job
curl  -m 120  -f -X POST \
  http://$1:4599/api/v1/streams/ \
  -H 'Cache-Control: no-cache' \
  -H 'Content-Type: application/json' \
  -d "{
  \"query\" : \"select * from demo_execution_view\",
  \"source\" : {
    \"name\" : \"file\",
    \"viewName\" : \"demo_execution_view\",
    \"encoding\" : \"csv\",
    \"separator\" : \",\",
    \"schemaName\" : \"demo_execution\",
    \"path\" : \"/tmp/bigdemodata/csv2/\"
  },
  \"sink\" : {
    \"name\" : \"kafka\",
    \"schemaName\" : \"demo_execution_ingest\",
    \"topic\" : \"in_writer\",
    \"encoding\" : \"canonical\",
    \"triggerTime\" : \"1 second\",
    \"bootstrapServers\" : \"$NAME-kafka:9092\",
    \"numPartitions\" : 1,
    \"replicationFactor\" : 1
  }
}"


exit 0
