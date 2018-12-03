#!/bin/sh
docker build -t gcr.io/k8sinitialtests/cuneiform-release:hdfs-datanode-2.7.3-b43fdb8-f2 . && docker push gcr.io/k8sinitialtests/cuneiform-release:hdfs-datanode-2.7.3-b43fdb8-f2
