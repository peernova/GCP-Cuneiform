#!/bin/bash
set -ex

app_api_version=$1
app_uid=$2
NAME=$3




MD=/data/manifest-expanded

kubectl apply --namespace="$NAMESPACE" -f $MD/application.yaml

#S="ssd-storageclass consul cassandra hdfs-namenode elasticsearch"
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


# Patch all services, deploymenyts and statefulsets 

# Create patch file
cat > /tmp/patch.yml << EOF
metadata:
  ownerReferences:
  - apiVersion: $app_api_version
    blockOwnerDeletion: true
    kind: Application
    name: $NAME
    uid: $app_uid
EOF

SVC_LIST=`kubectl get svc -o=custom-columns=NAME:.metadata.name -l app.kubernetes.io/name=$NAME|grep $NAME`
DEPLOY_LIST=`kubectl get deploy -o=custom-columns=NAME:.metadata.name -l app.kubernetes.io/name=$NAME|grep $NAME`
SS_LIST=`kubectl get statefulset -o=custom-columns=NAME:.metadata.name -l app.kubernetes.io/name=$NAME|grep $NAME`

for s in $SVC_LIST; do 
  kubectl patch services/$s --namespace="$NAMESPACE" --patch "$(cat /tmp/patch.yml)"
done
for d in $DEPLOY_LIST; do 
  kubectl patch deployment/$d --namespace="$NAMESPACE" --patch "$(cat /tmp/patch.yml)"
done
for ss in $SS_LIST; do 
  kubectl patch statefulset/$ss --namespace="$NAMESPACE" --patch "$(cat /tmp/patch.yml)"
done


kubectl describe svc,statefulset,deploy
