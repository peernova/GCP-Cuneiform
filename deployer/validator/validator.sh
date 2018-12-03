#!/bin/bash

set -eox pipefail

cd /validator

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
}

HDFS="/usr/local/hadoop-2.7.3/bin/hadoop fs"
NAME_PREFIX=$NAME
JAVA_HOME=/usr/lib/jvm/java-8-oracle/

# Fix hdfs config files
sed -i  "s/\([0-9a-zA-Z\-]*\)\.service.consul/${NAME_PREFIX}-\1/g" /usr/local/hadoop/etc/hadoop/*

# test if hdfs is up?
set +e
retry_cmd 10 30 $HDFS -ls /apps/peernova &> /dev/null
set -e

echo Sending files to HDFS
$HDFS -mkdir -p /tmp/bigdemodata/csv1
$HDFS -mkdir -p /tmp/bigdemodata/csv2
$HDFS -mkdir -p /tmp/demodata/csv1
$HDFS -mkdir -p /tmp/demodata/csv2

# copy initial files
$HDFS -copyFromLocal -f /validator/demo_trade_1500.csv /tmp/demodata/csv1/
$HDFS -copyFromLocal -f /validator/demo_execution_1500.csv  /tmp/demodata/csv2/

# run validator
set +e
retry_cmd 10 60 /validator/validator run --consul.server=$NAME_PREFIX-consul --kv.connection consul://$NAME_PREFIX-consul  --gatewayclient.jeconnection http://$NAME_PREFIX-jobengine:4599/api/v1 --validator.gateway $NAME_PREFIX-gateway:9710 --security.serverkeystore /validator/ks
set -e


./create_csv_ingestion_jobs.sh $NAME_PREFIX-jobengine

# Explode the gz files, rebuild them and copy to hdfs
[ -f /validator/demo_execution_255k_tr-aa ]  || gunzip /validator/*gz
cat /validator/demo_trade_255k_tr-a* > /validator/demo_trade_255k_tr.csv
cat /validator/demo_execution_255k_tr-a* >  /validator/demo_execution_255k_tr.csv

$HDFS -copyFromLocal -f /validator/demo_trade_255k_tr.csv /tmp/bigdemodata/csv1/
$HDFS -copyFromLocal -f /validator/demo_execution_255k_tr.csv  /tmp/bigdemodata/csv2/

cd -
