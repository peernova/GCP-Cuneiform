#!/bin/sh
cp ~/git/pn/canary/metadata/cassandra/* .
docker build -t gcr.io/k8sinitialtests/cuneiform-release:dbsetup-053500 . && docker push gcr.io/k8sinitialtests/cuneiform-release:dbsetup-053500

