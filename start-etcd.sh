#!/bin/bash

DATA=./data

rm -rf data
mkdir -p data
mount -F tmpfs -o size=10G swap data

source ./cluster.sh

./bins/etcd \
  --data-dir=$DATA \
  --initial-advertise-peer-urls http://$(hostname):2380 \
  --advertise-client-urls http://$(hostname):2379 \
  --listen-peer-urls http://0.0.0.0:2380 \
  --listen-client-urls http://0.0.0.0:2379 \
  --initial-cluster $CLUSTER_STR \
  --initial-cluster-token token \
  --initial-cluster-state new \
  --election-timeout=500 \
  --heartbeat-interval=50 \
  --name $(hostname | sed 's/\..*//')
