#!/bin/bash

set -eox pipefail

cd /ingestor

function retry_cmd()
{
        local n=0
        local try=$1
        local interval=$2
        local cmd="${@: 3}"

        until [[ $n -ge $try ]]
        do
                $cmd && break || {
                        echo "Command Fail.."
                        ((n++))
                        echo "retry $n ::"
                        sleep $interval;
                        }

        done
        if [ "$n" == "$try" ] ; then 
           echo "$cmd failed" 
           exit 1 
        fi
}

# NAME is the variable supplied by Google cotaining the name prefix
NAME_PREFIX=$NAME

# Unless otherwise specified (by setting USE_PRE_LOADED_DATA to 0), we should
# assume the ES/Cassandra data has been already loaded and we just need to load
# the consul data and then validate the system
if [ "$USE_PRE_LOADED_DATA" != "0" ]; then 
   set +e
   retry_cmd 5 30 curl -X PUT  --data-binary @/ingestor/consul-snapshot-large.tgz http://${NAME_PREFIX}-consul:8500/v1/snapshot
   retry_cmd 8 30 /validator/validator run  --validator.dataconfig /validator/data.config --consul.server=${NAME_PREFIX}-consul --kv.connection consul://${NAME_PREFIX}-consul --gatewayclient.jeconnection http://${NAME_PREFIX}-jobengine:4599/api/v1 --validator.gateway ${NAME_PREFIX}-gateway:9710 --security.serverkeystore /validator/ks
   set -e
   exit 0
fi
   

# If data has not been pre-loadded, we will do that now.
# We'll copy a small set of files to hdfs, load the schemas and LDLs, start jobengine jobs
# and then do the validation. Once it's ok, we'll copy larger files for demo
HDFS="/usr/local/hadoop-2.7.3/bin/hadoop fs"
JAVA_HOME=/usr/lib/jvm/java-8-oracle/

# Fix hdfs config files
sed -i  "s/\([0-9a-zA-Z\-]*\)\.service.consul/${NAME_PREFIX}-\1/g" /usr/local/hadoop/etc/hadoop/*

# test if hdfs is up?
set +e
retry_cmd 10 30 $HDFS -ls /apps/peernova &> /dev/null
set -e

echo Sending files to HDFS
$HDFS -mkdir -p /tmp/demodata/order/
$HDFS -mkdir -p /tmp/demodata/execution/

#
# copy initial small files
#
$HDFS -copyFromLocal  demo_orders_small.csv /tmp/demodata/order/ || echo ok
$HDFS -copyFromLocal  demo_executions_small.csv /tmp/demodata/execution/ || echo ok

#
# LDL, schemas, jobs
#
set +e
retry_cmd 10 30 ./register_schemas.sh
retry_cmd 10 30 ./store_rules.sh
KAFKA=$NAME-kafka envsubst '$KAFKA' < start_jobs.sh.in > start_jobs.sh
chmod +x start_jobs.sh
retry_cmd 10 30 ./start_jobs.sh
set -e

#
# Performs the validation
#
set +e
retry_cmd 5 30 /validator/validator run  --validator.dataconfig /validator/data.config --consul.server=${NAME_PREFIX}-consul --kv.connection consul://${NAME_PREFIX}-consul --gatewayclient.jeconnection http://${NAME_PREFIX}-jobengine:4599/api/v1 --validator.gateway ${NAME_PREFIX}-gateway:9710 --security.serverkeystore /validator/ks
set -e

#
# rebuild & copy to the hdfs the  large files
#
[ -f  demo_orders_large-aa ] || gunzip *gz
cat demo_orders_large-* > demo_orders_large.csv
cat demo_executions_large-a* > demo_executions_large.csv

$HDFS -copyFromLocal  demo_orders_large.csv /tmp/demodata/order/ || echo ok
$HDFS -copyFromLocal  demo_executions_large.csv /tmp/demodata/execution/ || echo ok

cd - 

exit 0 

