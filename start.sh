#!/bin/sh
cp -a /root/keys/id* /root/.ssh/

chmod 600 /root/.ssh/id*

chown root. /root/.ssh/id*

/bin/bash /command.sh

/usr/sbin/sshd -D
