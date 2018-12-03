#!/bin/sh
export APP_INSTANCE_NAME=cuneiform-1
export NAMESPACE=default
export IMAGE_CUNEIFORM="gcr.io/peernova-public-project/cuneiform:3.0.1"
export IMAGE_COUNTERPARTY="gcr.io/peernova-public-project/cuneiform/counterparty:3.0.1"
export IMAGE_COUNTERPARTY="gcr.io/peernova-public-project/cuneiform/counterparty:3.0.1"
export IMAGE_HDFS_DATANODE="gcr.io/peernova-public-project/cuneiform/hdfs-datanode-2.7.3:3.0.1"
export IMAGE_HDFS_NAMENODE="gcr.io/peernova-public-project/cuneiform/hdfs-namenode-2.7.3:3.0.1"
export IMAGE_JOBENGINE="gcr.io/peernova-public-project/cuneiform/jobengine:3.0.1"
export IMAGE_LIVY="gcr.io/peernova-public-project/cuneiform/livy-0.4:3.0.1"
export IMAGE_REST_PRODUCER="gcr.io/peernova-public-project/cuneiform/rest-producer:3.0.1"
export IMAGE_SPARK_DASHBOARD="gcr.io/peernova-public-project/cuneiform/spark-dashboard:3.0.1"
export IMAGE_YARN_RM="gcr.io/peernova-public-project/cuneiform/yarn-rm-2.7.3:3.0.1"
export IMAGE_YARN_NM="gcr.io/peernova-public-project/cuneiform/yarn-nm-2.7.3:3.0.1"
export IMAGE_ELASTICSEARCH="gcr.io/peernova-public-project/cuneiform/elasticsearch-5.6.9:3.0.1"
export IMAGE_ELASTICSEARCH_RESTORE="gcr.io/peernova-public-project/cuneiform/elasticsearch-restore:3.0.1"
export IMAGE_KAFKA="gcr.io/peernova-public-project/cuneiform/kafka-0.10.2:3.0.1"
export IMAGE_MONGODB="gcr.io/peernova-public-project/cuneiform/mongodb:3.0.1"
export IMAGE_NSQ="gcr.io/peernova-public-project/cuneiform/nsq:3.0.1"
export IMAGE_NSQ_LOOKUP="gcr.io/peernova-public-project/cuneiform/nsq-lookup:3.0.1"
export IMAGE_ZOOKEEPER="gcr.io/peernova-public-project/cuneiform/zookeeper-3.4.11:3.0.1"
export IMAGE_CONSUL="gcr.io/peernova-public-project/cuneiform/consul-1.1.0:3.0.1"
export IMAGE_CASSANDRA="gcr.io/peernova-public-project/cuneiform/cassandra-3.11:3.0.1"
export IMAGE_CASSANDRA_RESTORE="gcr.io/peernova-public-project/cuneiform/cassandra-restore:3.0.1"
export IMAGE_DBSETUP="gcr.io/peernova-public-project/cuneiform/dbsetup:3.0.1"
export IMAGE_PN_DOCS="gcr.io/peernova-public-project/cuneiform/pn-docs:3.0.1"
export IMAGE_FE_CADDY="gcr.io/peernova-public-project/cuneiform/fe-caddy:3.0.1"
export IMAGE_FE_PLATFORM="gcr.io/peernova-public-project/cuneiform/fe-platform:3.0.1"
export IMAGE_MW_ANCHOR="gcr.io/peernova-public-project/cuneiform/mw-anchor:3.0.1"
export IMAGE_MW_ANALYTICS="gcr.io/peernova-public-project/cuneiform/mw-analytics:3.0.1"
export IMAGE_MW_LINEAGE="gcr.io/peernova-public-project/cuneiform/mw-lineage:3.0.1"
export IMAGE_MW_SEARCH="gcr.io/peernova-public-project/cuneiform/mw-search:3.0.1"


awk 'BEGINFILE {print "---"}{print}' manifest/*template  \
  | envsubst '$APP_INSTANCE_NAME $NAMESPACE $IMAGE_CUNEIFORM \
$IMAGE_COUNTERPARTY $IMAGE_HDFS_DATANODE $IMAGE_HDFS_NAMENODE \
$IMAGE_JOBENGINE $IMAGE_LIVY $IMAGE_REST_PRODUCER \
$IMAGE_SPARK_DASHBOARD $IMAGE_YARN_RM $IMAGE_YARN_NM \
$IMAGE_ELASTICSEARCH $IMAGE_KAFKA $IMAGE_MONGODB $IMAGE_NSQ_LOOKUP \
$IMAGE_ELASTICSEARCH_RESTORE $IMAGE_CASSANDRA_RESTORE \
$IMAGE_ZOOKEEPER $IMAGE_CONSUL $IMAGE_CASSANDRA $IMAGE_DBSETUP $IMAGE_FE_CADDY $IMAGE_PN_DOCS \
$IMAGE_FE_PLATFORM $IMAGE_MW_ANCHOR $IMAGE_MW_ANALYTICS $IMAGE_MW_LINEAGE $IMAGE_MW_SEARCH $IMAGE_NSQ'  \
> "${APP_INSTANCE_NAME}_manifest.yaml"

L=`ls manifest/*template` 
for l in $L; do  
   envsubst < $l > /tmp/`basename $l .template`
done
