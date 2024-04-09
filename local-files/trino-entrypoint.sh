#!/bin/bash

export PATH="${JAVA_HOME}/bin:${PATH}"
usr/lib/trino/bin/launcher stop
usr/lib/trino/bin/launcher start

while [ ! -f /data/trino/var/log/server.log ]; do
    sleep 1
done
tail -f /data/trino/var/log/server.log
