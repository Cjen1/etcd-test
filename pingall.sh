#!/bin/bash

source ./cluster.sh

for host in $H1 $H2 $H3 $H4; do
  ping -c 10 $host -q
done
