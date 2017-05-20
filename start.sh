#!/bin/sh

echo -e  'y\n'|ssh-keygen -q -t ecdsa -N "" -f ~/.ssh/id_ecdsa > /dev/null 2>&1

if [ ! -z ${KEY_ECDSA+x} ]
  then
    echo "$KEY_ECDSA" > /root/.ssh/id_ecdsa
fi
if [ ! -z ${KEY_DSA+x} ]
  then
    echo "$KEY_DSA" > /root/.ssh/id_dsa
fi
if [ ! -z ${KEY_RSA+x} ]
  then
    echo "$KEY_RSA" > /root/.ssh/id_rsa
fi

touch ~/.ssh/known_hosts
ssh-keyscan -p $REMOTE_PORT $REMOTE_HOST 2>&1 | sort -u - ~/.ssh/known_hosts > ~/.ssh/tmp_hosts
mv ~/.ssh/tmp_hosts ~/.ssh/known_hosts

chmod 600 /root/.ssh/id*
chmod 600 /root/.ssh/known_hosts

chown root. /root/.ssh/id*
chown root. /root/.ssh/known_hosts

autossh -M $MONITOR_PORT  -g -L $LOCAL_PORT:0.0.0.0:$FORWARDED_PORT -f -p$REMOTE_PORT -N $REMOTE_USER@$REMOTE_HOST

/usr/sbin/sshd -D
