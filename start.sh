#!/bin/sh
cp -a /root/keys/id* /root/.ssh/
cp -a /root/keys/known_hosts /root/.ssh/

chmod 600 /root/.ssh/id*
chmod 600 /root/.ssh/known_hosts

chown root. /root/.ssh/id*
chown root. /root/.ssh/known_hosts

/bin/bash /command.sh

/usr/sbin/sshd -D
