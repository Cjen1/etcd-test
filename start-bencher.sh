#!/bin/bash

set -x

BENCHER_PATH=$1

source ./cluster.sh

$BENCHER_PATH etcd put-single test --endpoints $CLIENT_STR --metrics-endpoints $CLIENT_STR -o $2 --total $3 --rate $4
