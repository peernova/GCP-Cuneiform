#!/bin/sh
docker build -t gcr.io/k8sinitialtests/cuneiform-release:livy-0.4-b43fdb8-f2 . && docker push gcr.io/k8sinitialtests/cuneiform-release:livy-0.4-b43fdb8-f2
