#!/bin/bash


NAMESPACE=${NAMESPACE:-default}
APP_INSTANCE_NAME=${APP_INSTANCE_NAME:-cuneiform-1} 

kubectl delete application,statefulset,deployment,pvc \
  --namespace $NAMESPACE \
  --selector app.kubernetes.io/name=$APP_INSTANCE_NAME
