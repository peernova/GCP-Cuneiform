#!/bin/sh
set -ox

get_ext_ip() {
# $1 == service
  identifier=$1
  sleep=15
  attempts=15

  attempt=0
  while [ ${attempt} -lt ${attempts} ]
  do
    attempt=$(( ${attempt} + 1 ))
    if kubectl get svc ${identifier} --output jsonpath='{.status.loadBalancer.ingress[].ip}' | grep '^[0-9]*\.[0-9]*\.[0-9]*\.[0-9]*$'
    then
      break
    fi
    sleep ${sleep}
  done
}

replace_ip() {
# $1 == service
# $2 == template
# $3 == output
  if get_ext_ip "$1"
  then
    var_name=$( echo "$1" | tr "[:lower:]" "[:upper:]" | tr "-" "_" )
    export ${var_name}=$( get_ext_ip "$1" )
    envsubst < "$2" | sed -e "s/$1/\$${var_name}/" | envsubst > "$3"
  fi
}



# deployer will preset: 
# - NAME
# - NAMESPACE
# - IMAGE_MW_ANALYTICS
# - IMAGE_FE_PLATFORM
# - IMAGE_PN_DOCS
# - MANIFEST_DIR, YML_DIR
# 
# It will NOT set:
# - REGISTRY
# - TAG

export REGISTRY="${REGISTRY:-gcr.io/peernova-public-project/cuneiform}"
export TAG="${TAG:-3.0.1}"
# deployer container receives APP_INSTANCE_NAME as NAME
export APP_INSTANCE_NAME="${NAME:-cuneiform-1}"
export IMAGE_MW_ANALYTICS="${IMAGE_MW_ANALYTICS:-${REGISTRY}/mw-analytics:${TAG}}"
export IMAGE_FE_PLATFORM="${IMAGE_FE_PLATFORM:-${REGISTRY}/fe-platform:${TAG}}"
export IMAGE_PN_DOCS="${IMAGE_PN_DOCS:-${REGISTRY}/pn-docs:${TAG}}"
MANIFEST_DIR=${MANIFEST_DIR:-manifest} 
YML_DIR=${YML_DIR:-./} 

if replace_ip ${APP_INSTANCE_NAME}-dashboard-ext $MANIFEST_DIR/mw-analytics.yml.template $YML_DIR/mw-analytics.yml
then
  diff $MANIFEST_DIR/mw-analytics.yml.template $YML_DIR/mw-analytics.yml || echo ok
  kubectl apply -f $YML_DIR/mw-analytics.yml
fi


if get_ext_ip $APP_INSTANCE_NAME-pn-docs && get_ext_ip $APP_INSTANCE_NAME-gateway-ext
then
  var_name=$( echo "$APP_INSTANCE_NAME-pn-docs" | tr "[:lower:]" "[:upper:]" | tr "-" "_" )
  export ${var_name}=$( get_ext_ip "$APP_INSTANCE_NAME-pn-docs" )
  envsubst < "$MANIFEST_DIR/fe-platform.yml.template" | sed -e "s/$APP_INSTANCE_NAME-pn-docs/\$${var_name}/" | envsubst > "$YML_DIR/fe-platform.yml.tmp"

  var_name=$( echo "$APP_INSTANCE_NAME-gateway-ext" | tr "[:lower:]" "[:upper:]" | tr "-" "_" )
  export ${var_name}=$( get_ext_ip "$APP_INSTANCE_NAME-gateway-ext" )
  cat "$YML_DIR/fe-platform.yml.tmp" | sed -e "s/$APP_INSTANCE_NAME-gateway-ext/\$${var_name}/" | envsubst > "$YML_DIR/fe-platform.yml.tmp2"

  var_name=$( echo "$APP_INSTANCE_NAME-dashboard-ext" | tr "[:lower:]" "[:upper:]" | tr "-" "_" )
  export ${var_name}=$( get_ext_ip "$APP_INSTANCE_NAME-dashboard-ext" )
  cat "$YML_DIR/fe-platform.yml.tmp2" | sed -e "s/$APP_INSTANCE_NAME-dashboard-ext/\$${var_name}/" | envsubst > "$YML_DIR/fe-platform.yml"

  diff $MANIFEST_DIR/fe-platform.yml.template $YML_DIR/fe-platform.yml || echo ok
  kubectl apply -f $YML_DIR/fe-platform.yml
fi
