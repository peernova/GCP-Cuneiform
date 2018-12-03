#!/bin/sh
docker build -t gcr.io/k8sinitialtests/consul:1.1.0 . && docker push gcr.io/k8sinitialtests/consul:1.1.0 
