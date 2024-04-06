#!/bin/bash

export PATH="${JAVA_HOME}/bin:${PATH}"
usr/lib/trino/bin/launcher stop
usr/lib/trino/bin/launcher start
sleep 2
tail -f /data/trino/var/log/server.log
