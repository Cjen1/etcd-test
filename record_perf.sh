#!/bin/bash

source cluster.sh

eval `ssh-agent` >&2
ssh-add ~/.ssh/cjen1

echo "src, dst, bw, lat"

for server in H1 H2 H3 H4; do
  ssh ${!server} "sudo apt update && sudo apt install -y iperf3" >&2
done

for server in H1 H2 H3 H4; do
  for client in H1 H2 H3 H4; do
    ssh Cjen1@${!server} "killall iperf3"
    ssh Cjen1@${!server} "iperf3 -s -1" > /dev/null &
    SERVER_PID=$!
    sleep 0.5
    BANDWIDTH=$(ssh Cjen1@${!client} "iperf3 -c ${!server} -J" | jq '.end.streams[].receiver.bits_per_second' | numfmt --to=si)

    LATENCY=$(ssh Cjen1@${!client} "ping -c 1 ${!server}" | sed -ne '/.*time=/{;s///;s/\..*//;p;}')

    echo "$client, $server, $BANDWIDTH, $LATENCY"
  done
done

