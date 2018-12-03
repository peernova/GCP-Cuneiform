# Overview

The PeerNova Cuneiform Platform is an innovative platform designed to bring operational insight and increased audit-ability to large financial institutions.  It utilizes big data infrastructure, cloud technologies,  and blockchain-inspired cryptographic techniques, to provide end-to-end event lineage, state tracking, streaming analytics, data immutability, non-repudiation, and support for complex reconciliation in real-time.

[Learn more](https://peernova.com)

## About Google Click to Deploy

Popular open stacks on Kubernetes packaged by Google.

## Costs and licenses

Users are responsible for the cost of the GCP services used while running Cuneiform. There are no additional costs for using the platform. The GCP configuration template for this Quick Start includes configuration parameters and settings you can customize, however, these will affect the cost of your deployment. For those costs, refer the pricing pages for each GCP to be used. Prices are subject to change.

Cuneiform is free to use on GCP when you obtain a license from Peernova, Inc. [Request a license](http://peernova.com/support-form/). The [terms of the license](http://peernova.com/EULA/) can be found on the Peernova, Inc. website. The license will provide you with registration access to enable access to GCP on Cunieform. You will be prompted to create a username and password. Once registration is complete you will be able to use Cunieform on GCP.  

# Installation

## Quick install with Google Cloud Marketplace

Get up and running with a few clicks! Install this Cuneiform  app to a
Google Kubernetes Engine cluster using Google Cloud Marketplace. Follow the
[on-screen instructions](https://console.cloud.google.com/marketplace/details/google/cuneiform).

## Command line instructions

### Prerequisites

#### Set up command-line tools

You'll need the following tools in your development environment:
- [gcloud](https://cloud.google.com/sdk/gcloud/)
- [kubectl](https://kubernetes.io/docs/reference/kubectl/overview/)
- [docker](https://docs.docker.com/install/)
- [git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)

Configure `gcloud` as a Docker credential helper:

```shell
gcloud auth configure-docker
```

#### Create a Google Kubernetes Engine cluster

Optionally you can create a new cluster from the command line:

```shell
export CLUSTER=cuneiform-cluster
export ZONE=us-west1-a

gcloud container clusters create "$CLUSTER" --zone "$ZONE"  --machine-type "n1-standard-8"  --num-nodes "5"
```

Configure `kubectl` to connect to the new cluster:

```shell
gcloud container clusters get-credentials "$CLUSTER" --zone "$ZONE"
```

#### Clone this repo

Clone this repo and the associated tools repo:

```shell
git clone --recursive https://github.com/GoogleCloudPlatform/click-to-deploy.git
```

#### Install the Application resource definition

An Application resource is a collection of individual Kubernetes components,
such as Services, Deployments, and so on, that you can manage as a group.

To set up your cluster to understand Application resources, run the following command:

```shell
kubectl apply -f click-to-deploy/k8s/vendor/marketplace-tools/crd/*
```

You need to run this command once.

The Application resource is defined by the
[Kubernetes SIG-apps](https://github.com/kubernetes/community/tree/master/sig-apps)
community. The source code can be found on
[github.com/kubernetes-sigs/application](https://github.com/kubernetes-sigs/application).

### Install the Application

Navigate to the `cuneiform` directory:

```shell
cd click-to-deploy/k8s/cuneiform
```

#### Configure the app with environment variables

Choose the instance name and namespace for the app.

```shell
export APP_INSTANCE_NAME=cuneiform-1
export NAMESPACE=default
```

Configure the container images:

```shell
export IMAGE_CUNEIFORM="gcr.io/peernova-public-project/cuneiform:3.0.1"
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
export IMAGE_NSQ="gcr.io/peernova-public-project/cuneiform/nsq:3.0.1"
export IMAGE_NSQ_LOOKUP="gcr.io/peernova-public-project/cuneiform/nsq-lookup:3.0.1"
export IMAGE_ZOOKEEPER="gcr.io/peernova-public-project/cuneiform/zookeeper-3.4.11:3.0.1"
export IMAGE_CONSUL="gcr.io/peernova-public-project/cuneiform/consul-1.1.0:3.0.1"
export IMAGE_CASSANDRA="gcr.io/peernova-public-project/cuneiform/cassandra-3.11:3.0.1"
export IMAGE_CASSANDRA_RESTORE="gcr.io/peernova-public-project/cuneiform/cassandra-restore:3.0.1"
export IMAGE_DBSETUP="gcr.io/peernova-public-project/cuneiform/dbsetup:3.0.1"
export IMAGE_FE_CADDY="gcr.io/peernova-public-project/cuneiform/fe-caddy:3.0.1"
export IMAGE_FE_PLATFORM="gcr.io/peernova-public-project/cuneiform/fe-platform:3.0.1"
export IMAGE_MW_ANCHOR="gcr.io/peernova-public-project/cuneiform/mw-anchor:3.0.1"
export IMAGE_MW_ANALYTICS="gcr.io/peernova-public-project/cuneiform/mw-analytics:3.0.1"
export IMAGE_MW_LINEAGE="gcr.io/peernova-public-project/cuneiform/mw-lineage:3.0.1"
export IMAGE_MW_SEARCH="gcr.io/peernova-public-project/cuneiform/mw-search:3.0.1"
```

The images above are referenced by
[tag](https://docs.docker.com/engine/reference/commandline/tag). We recommend
that you pin each image to an immutable
[content digest](https://docs.docker.com/registry/spec/api/#content-digests).
This ensures that the installed application always uses the same images,
until you are ready to upgrade. To get the digest for the image, use the
following script:

```shell
for i in "IMAGE_CUNEIFORM" "IMAGE_CASSANDRA" "IMAGE_CONSUL" \
         "IMAGE_COUNTERPARTY" "IMAGE_CUNEIFORM" "IMAGE_DBSETUP" \
         "IMAGE_ELASTICSEARCH" "IMAGE_FE_CADDY" "IMAGE_FE_PLATFORM" \
         "IMAGE_HDFS_DATANODE" "IMAGE_HDFS_NAMENODE" "IMAGE_JOBENGINE" \
         "IMAGE_KAFKA" "IMAGE_LIVY" "IMAGE_MW_ANCHOR" \
         "IMAGE_MW_ANALYTICS" "IMAGE_MW_LINEAGE" "IMAGE_MW_SEARCH" \
         "IMAGE_NSQ" "IMAGE_NSQ_LOOKUP" "IMAGE_REST_PRODUCER" \
         "IMAGE_SPARK_DASHBOARD" "IMAGE_YARN_NM" "IMAGE_YARN_RM" \
         "IMAGE_ZOOKEEPER" "IMAGE_ELASTICSEARCH_RESTORE" \ 
         "IMAGE_CASSANDRA_RESTORE"; do
  repo=$(echo ${!i} | cut -d: -f1);
  digest=$(docker pull ${!i} | sed -n -e 's/Digest: //p');
  export $i="$repo@$digest";
  env | grep $i;
done
```

#### Create namespace in your Kubernetes cluster

If you use a different namespace than the `default`, run the command below to create a new namespace:

```shell
kubectl create namespace "$NAMESPACE"
```

#### Expand the manifest template

Use `envsubst` to expand the template. We recommend that you save the
expanded manifest file for future updates to the application.

```shell
awk 'BEGINFILE {print "---"}{print}' manifest/* \
  | envsubst '$APP_INSTANCE_NAME $NAMESPACE $IMAGE_CUNEIFORM \
$IMAGE_COUNTERPARTY $IMAGE_HDFS_DATANODE $IMAGE_HDFS_NAMENODE \
$IMAGE_JOBENGINE $IMAGE_LIVY $IMAGE_REST_PRODUCER \
$IMAGE_SPARK_DASHBOARD $IMAGE_YARN_RM $IMAGE_YARN_NM \
$IMAGE_ELASTICSEARCH $IMAGE_KAFKA $IMAGE_NSQ_LOOKUP \
$IMAGE_ZOOKEEPER $IMAGE_CONSUL $IMAGE_CASSANDRA $IMAGE_DBSETUP $IMAGE_FE_CADDY \
$IMAGE_FE_PLATFORM $IMAGE_MW_ANCHOR $IMAGE_MW_LINEAGE $IMAGE_MW_SEARCH \
$IMAGE_NSQ' > "${APP_INSTANCE_NAME}_manifest.yaml"
```

#### Apply the manifest to your Kubernetes cluster

Use `kubectl` to apply the manifest to your Kubernetes cluster:

```shell
kubectl apply -f "${APP_INSTANCE_NAME}_manifest.yaml" --namespace "${NAMESPACE}"
```

#### View the app in the Google Cloud Console

To get the Console URL for your app, run the following command:

```shell
echo "https://console.cloud.google.com/kubernetes/application/${ZONE}/${CLUSTER}/${NAMESPACE}/${APP_INSTANCE_NAME}"
```

To view the app, open the URL in your browser.


### Accessing Cuneiform's frontend

Get the external IP of your installation frontend by running:

```
SERVICE_IP=$(kubectl get svc $APP_INSTANCE_NAME-fe-caddy \
  --namespace $NAMESPACE \
  --output jsonpath='{.status.loadBalancer.ingress[0].ip}')

echo "http://${SERVICE_IP}"
```

The command will then show you the URL to be accessed.


# Upgrade the Application

TBD 


# Uninstall the Application

## Using the Google Cloud Platform Console

1. In the GCP Console, open [Kubernetes Applications](https://console.cloud.google.com/kubernetes/application).

1. From the list of applications, click **Cuneiform**.

1. On the Application Details page, click **Delete**.

## Using the command line

### Prepare the environment

Set your installation name and Kubernetes namespace:

```shell
export APP_INSTANCE_NAME=cuneiform-1
export NAMESPACE=default
```

### Delete the resources

> **NOTE:** We recommend to use a kubectl version that is the same as the version of your cluster. Using the same versions of kubectl and the cluster helps avoid unforeseen issues.

To delete the resources, use the expanded manifest file used for the
installation.

Run `kubectl` on the expanded manifest file:

```shell
kubectl delete -f ${APP_INSTANCE_NAME}_manifest.yaml --namespace $NAMESPACE
```

Otherwise, delete the resources using types and a label:

```shell
kubectl delete application,statefulset,deployment,service \
  --namespace $NAMESPACE \
  --selector app.kubernetes.io/name=$APP_INSTANCE_NAME
```
### Delete the persistent volumes of your installation

By design, the removal of StatefulSets in Kubernetes does not remove
PersistentVolumeClaims that were attached to their Pods. This prevents your
installations from accidentally deleting stateful data.

To remove the PersistentVolumeClaims with their attached persistent disks, run
the following `kubectl` commands:

```shell
# specify the variables values matching your installation:
export APP_INSTANCE_NAME=cuneiform-1
export NAMESPACE=default

kubectl delete persistentvolumeclaims \
  --namespace $NAMESPACE
  --selector app.kubernetes.io/name=$APP_INSTANCE_NAME
```
