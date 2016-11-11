#!/usr/bin/env bash
set -x

term_handler() {
    if [ -e /root/.dropbox/dropbox.pid ]
        then
        db_pid=$(cat /root/.dropbox/dropbox.pid)
        kill -SIGTERM "$db_pid"
        wait "$db_pid"
    fi
    exit 143;
}

trap 'kill ${!}; term_handler' SIGTERM

[ -e "/root/.dropbox/command_socket" ] && rm /root/.dropbox/command_socket
[ -e "/root/.dropbox/iface_socket" ] && rm /root/.dropbox/iface_socket
[ -e "/root/.dropbox/unlink.db" ] && rm /root/.dropbox/unlink.db
[ -e "/root/.dropbox/dropbox.pid" ] && rm /root/.dropbox/dropbox.pid
/opt/dropbox/dropboxd &

while true
do
  tail -f /dev/null & wait ${!}
done
