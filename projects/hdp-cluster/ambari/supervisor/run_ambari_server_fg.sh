#! /usr/bin/env bash
setenforce 0
set -eu

pidfile="/var/run/ambari-server/ambari-server.pid"
command="/usr/sbin/ambari-server start"

# Proxy signals
function kill_app(){
    kill $(cat $pidfile)
    exit 0 # exit okay
}
trap "kill_app" SIGINT SIGTERM

# Launch daemon
$command
sleep 20

# Loop while the pidfile and the process exist
while [ -f $pidfile ] && kill -0 $(cat $pidfile) ; do
    sleep 0.5
done
exit 1000 # exit unexpected