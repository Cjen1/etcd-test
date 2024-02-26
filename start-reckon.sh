#!/bin/bash

set -x

CLIENT_PATH=./reckon-client/client

source ./cluster.sh

cat ./reckon-client/test_input_60s_10000.in | $CLIENT_PATH --targets=$CLIENT_STR --id=0 --ncpr=false > client.out
