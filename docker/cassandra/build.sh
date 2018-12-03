#!/bin/sh
docker build -t gcr.io/k8sinitialtests/cuneiform-release:cassandra-3.11-f . && docker push gcr.io/k8sinitialtests/cuneiform-release:cassandra-3.11-f
