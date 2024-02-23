#!/bin/bash

source cluster.sh

for h in H1 H2 H3 H4; do
  ping -c 1 ${!h}
done
