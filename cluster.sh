#!/bin/bash

H1=amd113.utah.cloudlab.us
H2=c220g5-111302.wisc.cloudlab.us
H3=clnode244.clemson.cloudlab.us
H4=pc530.emulab.net
>&2 echo $H1
>&2 echo $H2
>&2 echo $H3
>&2 echo $H4

CLUSTER_PORT=2380
CLUSTER_STR="h2=http://${H2}:${CLUSTER_PORT},h3=http://${H3}:${CLUSTER_PORT},h4=http://${H4}:${CLUSTER_PORT}"
>&2 echo $CLUSTER_STR

CLIENT_PORT=2379
CLIENT_STR="http://${H2}:${CLIENT_PORT},http://${H3}:${CLIENT_PORT},http://${H4}:${CLIENT_PORT}"
>&2 echo $CLIENT_STR


