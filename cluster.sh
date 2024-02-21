#!/bin/bash

H1=ms1103.utah.cloudlab.us
H2=c220g2-010620.wisc.cloudlab.us
H3=clgpu018.clemson.cloudlab.us
H4=apt083.apt.emulab.net
echo $H1
echo $H2
echo $H3
echo $H4

CLUSTER_PORT=2380
CLUSTER_STR="h1=http://${H1}:${CLUSTER_PORT},h2=http://${H2}:${CLUSTER_PORT},h3=http://${H3}:${CLUSTER_PORT}"
echo $CLUSTER_STR

CLIENT_PORT=2379
CLIENT_STR="http://${H1}:${CLIENT_PORT},http://${H2}:${CLIENT_PORT},http://${H3}:${CLIENT_PORT}"
echo $CLIENT_STR


