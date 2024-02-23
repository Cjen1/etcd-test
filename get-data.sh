#!/bin/bash

FILEPATH=$1
SSH_PUBKEY=$2

source cluster.sh

eval `ssh-agent`

ssh-add $SSH_PUBKEY

mkdir -p $FILEPATH

for server in H1 H2 H3; do
  scp Cjen1@${!server}:etcd-test/pcap.pcap $FILEPATH/$server.pcap
done

scp Cjen1@$H4:etcd-test/out.csv $FILEPATH/datapoints.csv
