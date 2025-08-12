## Настройка сервера NFS

Установила сервер NFS

```
root@5440591-rs39011:~# apt install nfs-kernel-server
Reading package lists... Done
Building dependency tree... Done
Reading state information... Done
The following additional packages will be installed:
  keyutils libnfsidmap1 nfs-common rpcbind
Suggested packages:
  watchdog
The following NEW packages will be installed:
  keyutils libnfsidmap1 nfs-common nfs-kernel-server rpcbind
0 upgraded, 5 newly installed, 0 to remove and 83 not upgraded.
Need to get 569 kB of archives.
After this operation, 2022 kB of additional disk space will be used.
Do you want to continue? [Y/n] Y
Get:1 http://ru.archive.ubuntu.com/ubuntu noble-updates/main amd64 libnfsidmap1 amd64 1:2.6.4-3ubuntu5.1 [48.3 kB]
Get:2 http://ru.archive.ubuntu.com/ubuntu noble/main amd64 rpcbind amd64 1.2.6-7ubuntu2 [46.5 kB]
Get:3 http://ru.archive.ubuntu.com/ubuntu noble/main amd64 keyutils amd64 1.6.3-3build1 [56.8 kB]
Get:4 http://ru.archive.ubuntu.com/ubuntu noble-updates/main amd64 nfs-common amd64 1:2.6.4-3ubuntu5.1 [248 kB]
Get:5 http://ru.archive.ubuntu.com/ubuntu noble-updates/main amd64 nfs-kernel-server amd64 1:2.6.4-3ubuntu5.1 [169 kB]
Fetched 569 kB in 0s (3757 kB/s)       
Selecting previously unselected package libnfsidmap1:amd64.
(Reading database ... 75172 files and directories currently installed.)
Preparing to unpack .../libnfsidmap1_1%3a2.6.4-3ubuntu5.1_amd64.deb ...
Unpacking libnfsidmap1:amd64 (1:2.6.4-3ubuntu5.1) ...
Selecting previously unselected package rpcbind.
Preparing to unpack .../rpcbind_1.2.6-7ubuntu2_amd64.deb ...
Unpacking rpcbind (1.2.6-7ubuntu2) ...
Selecting previously unselected package keyutils.
Preparing to unpack .../keyutils_1.6.3-3build1_amd64.deb ...
Unpacking keyutils (1.6.3-3build1) ...
Selecting previously unselected package nfs-common.
Preparing to unpack .../nfs-common_1%3a2.6.4-3ubuntu5.1_amd64.deb ...
Unpacking nfs-common (1:2.6.4-3ubuntu5.1) ...
Selecting previously unselected package nfs-kernel-server.
Preparing to unpack .../nfs-kernel-server_1%3a2.6.4-3ubuntu5.1_amd64.deb ...
Unpacking nfs-kernel-server (1:2.6.4-3ubuntu5.1) ...
Setting up libnfsidmap1:amd64 (1:2.6.4-3ubuntu5.1) ...
Setting up rpcbind (1.2.6-7ubuntu2) ...
Created symlink /etc/systemd/system/multi-user.target.wants/rpcbind.service → /usr/lib/systemd/system/rpcbind.service.
Created symlink /etc/systemd/system/sockets.target.wants/rpcbind.socket → /usr/lib/systemd/system/rpcbind.socket.
Setting up keyutils (1.6.3-3build1) ...
Setting up nfs-common (1:2.6.4-3ubuntu5.1) ...

Creating config file /etc/idmapd.conf with new version

Creating config file /etc/nfs.conf with new version
info: Selecting UID from range 100 to 999 ...

info: Adding system user `statd' (UID 110) ...
info: Adding new user `statd' (UID 110) with group `nogroup' ...
info: Not creating home directory `/var/lib/nfs'.
Created symlink /etc/systemd/system/multi-user.target.wants/nfs-client.target → /usr/lib/systemd/system/nfs-client.target.
Created symlink /etc/systemd/system/remote-fs.target.wants/nfs-client.target → /usr/lib/systemd/system/nfs-client.target.
auth-rpcgss-module.service is a disabled or a static unit, not starting it.
nfs-idmapd.service is a disabled or a static unit, not starting it.
nfs-utils.service is a disabled or a static unit, not starting it.
proc-fs-nfsd.mount is a disabled or a static unit, not starting it.
rpc-gssd.service is a disabled or a static unit, not starting it.
rpc-statd-notify.service is a disabled or a static unit, not starting it.
rpc-statd.service is a disabled or a static unit, not starting it.
rpc-svcgssd.service is a disabled or a static unit, not starting it.
Setting up nfs-kernel-server (1:2.6.4-3ubuntu5.1) ...
Created symlink /etc/systemd/system/nfs-mountd.service.requires/fsidd.service → /usr/lib/systemd/system/fsidd.service.
Created symlink /etc/systemd/system/nfs-server.service.requires/fsidd.service → /usr/lib/systemd/system/fsidd.service.
Created symlink /etc/systemd/system/nfs-client.target.wants/nfs-blkmap.service → /usr/lib/systemd/system/nfs-blkmap.service.
Created symlink /etc/systemd/system/multi-user.target.wants/nfs-server.service → /usr/lib/systemd/system/nfs-server.service.
nfs-mountd.service is a disabled or a static unit, not starting it.
nfsdcld.service is a disabled or a static unit, not starting it.

Creating config file /etc/exports with new version

Creating config file /etc/default/nfs-kernel-server with new version
Processing triggers for man-db (2.12.0-4build2) ...
Processing triggers for libc-bin (2.39-0ubuntu8.4) ...
```

Проверила наличие слушающих портов

```
root@5440591-rs39011:/# ss -tnplu
Netid  State   Recv-Q  Send-Q         Local Address:Port     Peer Address:Port  Process                                                                         
udp    UNCONN  0       0                    0.0.0.0:49491         0.0.0.0:*      users:(("rpc.mountd",pid=707,fd=4))                                            
udp    UNCONN  0       0                  127.0.0.1:867           0.0.0.0:*      users:(("rpc.statd",pid=691,fd=5))                                             
udp    UNCONN  0       0                    0.0.0.0:46091         0.0.0.0:*                                                                                     
udp    UNCONN  0       0                    0.0.0.0:58416         0.0.0.0:*      users:(("rpc.statd",pid=691,fd=8))                                             
udp    UNCONN  0       0                 127.0.0.54:53            0.0.0.0:*      users:(("systemd-resolve",pid=428,fd=16))                                      
udp    UNCONN  0       0              127.0.0.53%lo:53            0.0.0.0:*      users:(("systemd-resolve",pid=428,fd=14))                                      
udp    UNCONN  0       0        188.225.27.164%eth0:68            0.0.0.0:*      users:(("systemd-network",pid=640,fd=21))                                      
udp    UNCONN  0       0                    0.0.0.0:111           0.0.0.0:*      users:(("rpcbind",pid=423,fd=5),("systemd",pid=1,fd=40))                       
udp    UNCONN  0       0                    0.0.0.0:48341         0.0.0.0:*      users:(("rpc.mountd",pid=707,fd=12))                                           
udp    UNCONN  0       0                    0.0.0.0:42320         0.0.0.0:*      users:(("rpc.mountd",pid=707,fd=8))                                            
udp    UNCONN  0       0                       [::]:38569            [::]:*      users:(("rpc.statd",pid=691,fd=10))                                            
udp    UNCONN  0       0                       [::]:49006            [::]:*      users:(("rpc.mountd",pid=707,fd=6))                                            
udp    UNCONN  0       0                       [::]:58382            [::]:*                                                                                     
udp    UNCONN  0       0                       [::]:50227            [::]:*      users:(("rpc.mountd",pid=707,fd=14))                                           
udp    UNCONN  0       0                       [::]:111              [::]:*      users:(("rpcbind",pid=423,fd=7),("systemd",pid=1,fd=42))                       
udp    UNCONN  0       0                       [::]:55497            [::]:*      users:(("rpc.mountd",pid=707,fd=10))                                           
udp    LISTEN  0       0                    0.0.0.0:2049          0.0.0.0:*                                                                                     
tcp    LISTEN  0       4096                 0.0.0.0:46081         0.0.0.0:*      users:(("rpc.mountd",pid=707,fd=13))                                           
tcp    LISTEN  0       4096                 0.0.0.0:111           0.0.0.0:*      users:(("rpcbind",pid=423,fd=4),("systemd",pid=1,fd=39))                       
tcp    LISTEN  0       4096                 0.0.0.0:34285         0.0.0.0:*      users:(("rpc.mountd",pid=707,fd=5))                                            
tcp    LISTEN  0       4096              127.0.0.54:53            0.0.0.0:*      users:(("systemd-resolve",pid=428,fd=17))                                      
tcp    LISTEN  0       4096           127.0.0.53%lo:53            0.0.0.0:*      users:(("systemd-resolve",pid=428,fd=15))                                      
tcp    LISTEN  0       4096                 0.0.0.0:50161         0.0.0.0:*      users:(("rpc.mountd",pid=707,fd=9))                                            
tcp    LISTEN  0       4096                 0.0.0.0:52169         0.0.0.0:*      users:(("rpc.statd",pid=691,fd=9))                                             
tcp    LISTEN  0       64                   0.0.0.0:45869         0.0.0.0:*                                                                                     
tcp    LISTEN  0       128                  0.0.0.0:10050         0.0.0.0:*      users:(("zabbix_agentd",pid=743,fd=4),("zabbix_agentd",pid=742,fd=4),("zabbix_agentd",pid=741,fd=4),("zabbix_agentd",pid=740,fd=4),("zabbix_agentd",pid=722,fd=4))
tcp    LISTEN  0       4096                       *:22                  *:*      users:(("sshd",pid=838,fd=3),("systemd",pid=1,fd=100))                         
tcp    LISTEN  0       64                      [::]:2049             [::]:*                                                                                     
tcp    LISTEN  0       4096                    [::]:111              [::]:*      users:(("rpcbind",pid=423,fd=6),("systemd",pid=1,fd=41))                       
tcp    LISTEN  0       4096                    [::]:55701            [::]:*      users:(("rpc.mountd",pid=707,fd=15))                                           
tcp    LISTEN  0       4096                    [::]:54585            [::]:*      users:(("rpc.mountd",pid=707,fd=7))                                            
tcp    LISTEN  0       4096                    [::]:37535            [::]:*      users:(("rpc.mountd",pid=707,fd=11))                                           
tcp    LISTEN  0       4096                    [::]:49765            [::]:*      users:(("rpc.statd",pid=691,fd=11))                                            
tcp    LISTEN  0       64                      [::]:34781            [::]:*    
```

Создала и настроила директорию

```
root@5443921-rs39011:/# cd etc
root@5443921-rs39011:/etc# mkdir -p /srv/share/upload
root@5443921-rs39011:/etc# chown -R nobody:nogroup /srv/share
root@5443921-rs39011:/etc# chmod 0777 /srv/share/upload
```

Cоздала в файле /etc/exports структуру, которая позволит экспортировать ранее созданную директорию
```
root@5443921-rs39011:/etc# cat << EOF > /etc/exports
> /srv/share 46.149.66.166/32(rw,sync,root_squash) 
> EOF
```

Экспортировала ранее созданную директорию

```
root@5443921-rs39011:/etc# exportfs -r
exportfs: /etc/exports [1]: Neither 'subtree_check' or 'no_subtree_check' specified for export "46.149.66.166/32:/srv/share".
  Assuming default behaviour ('no_subtree_check').
  NOTE: this default has changed since nfs-utils version 1.0.x
```

Проверила экспортированную директорию

```
root@5443921-rs39011:/etc# exportfs -s
/srv/share  46.149.66.166/32(sync,wdelay,hide,no_subtree_check,sec=sys,rw,secure,root_squash,no_all_squash)
```

## Настройка клиента NFS

Установила пакет с NFS-клиентом

```
root@5440671-rs39011:~# sudo apt install nfs-common
Reading package lists... Done
Building dependency tree... Done
Reading state information... Done
The following additional packages will be installed:
  keyutils libnfsidmap1 rpcbind
Suggested packages:
  watchdog
The following NEW packages will be installed:
  keyutils libnfsidmap1 nfs-common rpcbind
0 upgraded, 4 newly installed, 0 to remove and 1 not upgraded.
Need to get 400 kB of archives.
After this operation, 1416 kB of additional disk space will be used.
Do you want to continue? [Y/n] Y
Get:1 http://ru.archive.ubuntu.com/ubuntu noble-updates/main amd64 libnfsidmap1 amd64 1:2.6.4-3ubuntu5.1 [48.3 kB]
Get:2 http://ru.archive.ubuntu.com/ubuntu noble/main amd64 rpcbind amd64 1.2.6-7ubuntu2 [46.5 kB]
Get:3 http://ru.archive.ubuntu.com/ubuntu noble/main amd64 keyutils amd64 1.6.3-3build1 [56.8 kB]
Get:4 http://ru.archive.ubuntu.com/ubuntu noble-updates/main amd64 nfs-common amd64 1:2.6.4-3ubuntu5.1 [248 kB]
Fetched 400 kB in 0s (3241 kB/s)
Selecting previously unselected package libnfsidmap1:amd64.
(Reading database ... 75172 files and directories currently installed.)
Preparing to unpack .../libnfsidmap1_1%3a2.6.4-3ubuntu5.1_amd64.deb ...
Unpacking libnfsidmap1:amd64 (1:2.6.4-3ubuntu5.1) ...
Selecting previously unselected package rpcbind.
Preparing to unpack .../rpcbind_1.2.6-7ubuntu2_amd64.deb ...
Unpacking rpcbind (1.2.6-7ubuntu2) ...
Selecting previously unselected package keyutils.
Preparing to unpack .../keyutils_1.6.3-3build1_amd64.deb ...
Unpacking keyutils (1.6.3-3build1) ...
Selecting previously unselected package nfs-common.
Preparing to unpack .../nfs-common_1%3a2.6.4-3ubuntu5.1_amd64.deb ...
Unpacking nfs-common (1:2.6.4-3ubuntu5.1) ...
Setting up libnfsidmap1:amd64 (1:2.6.4-3ubuntu5.1) ...
Setting up rpcbind (1.2.6-7ubuntu2) ...
Created symlink /etc/systemd/system/multi-user.target.wants/rpcbind.service → /usr/lib/systemd/system/rpcbind.service.
Created symlink /etc/systemd/system/sockets.target.wants/rpcbind.socket → /usr/lib/systemd/system/rpcbind.socket.
Setting up keyutils (1.6.3-3build1) ...
Setting up nfs-common (1:2.6.4-3ubuntu5.1) ...

Creating config file /etc/idmapd.conf with new version

Creating config file /etc/nfs.conf with new version
info: Selecting UID from range 100 to 999 ...

info: Adding system user `statd' (UID 110) ...
info: Adding new user `statd' (UID 110) with group `nogroup' ...
info: Not creating home directory `/var/lib/nfs'.
Created symlink /etc/systemd/system/multi-user.target.wants/nfs-client.target → /usr/lib/systemd/system/nfs-client.target.
Created symlink /etc/systemd/system/remote-fs.target.wants/nfs-client.target → /usr/lib/systemd/system/nfs-client.target.
auth-rpcgss-module.service is a disabled or a static unit, not starting it.
nfs-idmapd.service is a disabled or a static unit, not starting it.
nfs-utils.service is a disabled or a static unit, not starting it.
proc-fs-nfsd.mount is a disabled or a static unit, not starting it.
rpc-gssd.service is a disabled or a static unit, not starting it.
rpc-statd-notify.service is a disabled or a static unit, not starting it.
rpc-statd.service is a disabled or a static unit, not starting it.
rpc-svcgssd.service is a disabled or a static unit, not starting it.
Processing triggers for man-db (2.12.0-4build2) ...
Processing triggers for libc-bin (2.39-0ubuntu8.4) ...
```

Добавила в /etc/fstab строку 

```
root@5440671-rs39011:/# echo "188.225.27.164:/srv/share/ /mnt nfs vers=3,noauto,x-systemd.automount 0 0" >> /etc/fstab
```

Выполнила команды

```
root@5440671-rs39011:/# systemctl daemon-reload
root@5440671-rs39011:/# systemctl restart remote-fs.target
```

Проверила успешность монтирования

```
root@5440671-rs39011:/# mount -v | grep /mnt
systemd-1 on /mnt type autofs (rw,relatime,fd=55,pgrp=1,timeout=0,minproto=5,maxproto=5,direct,pipe_ino=3768)
188.225.27.164:/srv/share/ on /mnt type nfs (rw,relatime,vers=3,rsize=262144,wsize=262144,namlen=255,hard,proto=tcp,timeo=600,retrans=2,sec=sys,mountaddr=188.225.27.164,mountvers=3,mountport=54361,mountproto=udp,local_lock=none,addr=188.225.27.164)
```


## Проверка работоспособности 

В каталоге /srv/share/upload создала тестовый файл touch check_file.

```
root@5443921-rs39011:/srv/share/upload# touch check_file
```
 
Проверила наличие ранее созданного файла на клиенте

```
root@5440671-rs39011:/mnt/upload# ls
check_file
```

Создала тестовый файл touch client_file. 

```
root@5440671-rs39011:/mnt/upload# touch client_file
```

Проверила, что файл успешно создан.

```
root@5443921-rs39011:/srv/share/upload# ls
check_file  client_file
```

Создала bash-скрипты и проверила работоспособность


nfss_script.sh

```
#!/bin/bash
echo "Начало конфигурирования сервера..."

echo "Установка nfs"
sudo apt install nfs-kernel-server

echo "Создание директории"
mkdir -p /srv/share/upload 
chown -R nobody:nogroup /srv/share 
chmod 0777 /srv/share/upload 

echo "Обновление /etc/exports"
cat << EOF > /etc/exports 
/srv/share 185.119.57.153/32(rw,sync,root_squash)
EOF

echo "Экспортирование директории"
exportfs -r 

exportfs -s 

echo "Конфигурирование завершено."
```

nfsс_script.sh

```
#!/bin/bash
echo "Начало конфигурирования клиента..."

echo "Установка nfs"
sudo apt install nfs-common

echo "Конфигурирование /etc/fstab" 
echo "188.225.27.164:/srv/share/ /mnt nfs vers=3,noauto,x-systemd.automount 0 0" >> /etc/fstab

systemctl daemon-reload 
systemctl restart remote-fs.target 

echo "Конфигурирование завершено."
```