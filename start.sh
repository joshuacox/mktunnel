#!/bin/sh
DATE1=$(date +"%y-%m-%d-%H:%M:%S:%p:%N")
PASSWORD=$(echo $DATE1 | sha256sum)

mkdir -p /home/octossh/.ssh
if [ ! -f /home/octossh/.ssh/id_ecdsa.pub ]
  then
    echo -e  'y\n'|ssh-keygen -q -t ecdsa -N "" -f /home/octossh/.ssh/id_ecdsa > /dev/null 2>&1
fi

ssh-keygen -A
curl $KEY_URL|sort|uniq>/home/octossh/.ssh/authorized_keys
chown -R octossh:octossh /home/octossh
chown -R octossh:octossh /home/octossh
chmod 700 /home/octossh/.ssh
chmod 700 /home/octossh/.ssh/authorized_keys
echo "octossh:$PASSWORD" | chpasswd
passwd -u octossh
chsh octossh -s /bin/ash

#echo -e  'y\n'|ssh-keygen -q -t ecdsa -N "" -f ~/.ssh/id_ecdsa > /dev/null 2>&1
#rm  -f /root/.ssh/authorized_keys

#cp -a /root/keys/id* /root/.ssh/
#cp -a /root/keys/known_hosts /root/.ssh/

#chmod 600 /root/.ssh/id*
#chmod 600 /root/.ssh/known_hosts

#chown root. /root/.ssh/id*
#chown root. /root/.ssh/known_hosts

autossh -M $MONITOR_PORT  -g -L $LOCAL_PORT:0.0.0.0:$FORWARDED_PORT -f -p$REMOTE_PORT -N $REMOTE_USER@$REMOTE_HOST

exec /usr/sbin/sshd -D -e "$@"
