#!/bin/bash
set -ex

MD=/tmp

S="consul cassandra hdfs-namenode elasticsearch"
for s in $S; do
   kubectl apply --namespace="$NAMESPACE" -f $MD/$s.yml
done

sleep 60


S="hdfs-datanode-1 hdfs-datanode-2 yarn-rm"
for s in $S; do
   kubectl apply --namespace="$NAMESPACE" -f $MD/$s.yml
done
sleep 45


S="yarn-nm-1 yarn-nm-2 nsqlookup nsq zookeeper dashboard"
for s in $S; do
   kubectl apply --namespace="$NAMESPACE" -f $MD/$s.yml
done
sleep 15

S="kafka livy dbsetup"
for s in $S; do
   kubectl apply --namespace="$NAMESPACE" -f $MD/$s.yml
done
sleep 40


S="jobengine gateway lineage router dispatcher counterparty inclusiongist mapper lineage-rpc rest-producer fe-caddy fe-platform mw-anchor mw-search mw-lineage pn-docs"
for s in $S; do
   kubectl apply --namespace="$NAMESPACE" -f $MD/$s.yml
done
sleep 45


scripts/external_replace.sh
