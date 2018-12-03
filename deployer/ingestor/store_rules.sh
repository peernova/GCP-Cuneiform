#!/bin/bash
set -ex 

# store rules for demo.

# Please edit HOST as needed.
HOST="$NAME-gateway"
echo $HOST

# demo ldl
./ldlstore run --consul.server=consul://$NAME-consul --kv.connection=consul://$NAME-consul --ldlstore.ldlfile=demo.yaml --gatewayclient.lineageconnection=$NAME-gateway:9708  --gatewayclient.lineageconnection=$NAME-lineage-rpc:9708

# list ldl
curl -k -X GET "https://$HOST:9710/api/v1/lineage/ldl/list" -H "accept: application/json"
echo "\n"
