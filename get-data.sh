#!/bin/bash

set -x

source cluster.sh

FILEPATH=$1
SSH_PUBKEY=$2

mkdir -p $FILEPATH

for server in H1 H2 H3; do
  scp -i $SSH_PUBKEY Cjen1@${!server}:etcd-test/pcap.pcap $FILEPATH/$server.pcap
done

scp -i $SSH_PUBKEY Cjen1@$H4:etcd-test/out.csv $FILEPATH/datapoints.csv
