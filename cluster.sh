#!/bin/bash

H1=pc530.emulab.net
H2=amd113.utah.cloudlab.us
H3=c220g5-111302.wisc.cloudlab.us
H4=clnode244.clemson.cloudlab.us
>&2 echo $H1
>&2 echo $H2
>&2 echo $H3
>&2 echo $H4

CLUSTER_PORT=2380
CLUSTER_STR="h1=http://${H1}:${CLUSTER_PORT},h2=http://${H2}:${CLUSTER_PORT},h3=http://${H3}:${CLUSTER_PORT}"
>&2 echo $CLUSTER_STR

CLIENT_PORT=2379
CLIENT_STR="http://${H1}:${CLIENT_PORT},http://${H2}:${CLIENT_PORT},http://${H3}:${CLIENT_PORT}"
>&2 echo $CLIENT_STR


