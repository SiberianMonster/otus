## Написать service, который будет раз в 30 секунд мониторить лог на предмет наличия ключевого слова

Создала файл с конфигурацией для сервиса 

```
[root@5505541-rs39011 default]# touch /etc/default/watchlog
[root@5505541-rs39011 default]# nano /etc/default/watchlog
```

Создала /var/log/watchlog.log 

```
root@5477585-rs39011:~# touch /var/log/watchlog.log
root@5477585-rs39011:~# nano /var/log/watchlog.log
```

Создала скрипт:

```
root@5477585-rs39011:~# touch /opt/watchlog.sh
root@5477585-rs39011:~# nano /opt/watchlog.sh
```

Добавила права на запуск файла:

```
root@5477585-rs39011:~# chmod +x /opt/watchlog.sh
```

Создала юнит для сервиса:

```
root@5477585-rs39011:~# touch /etc/systemd/system/watchlog.service
root@5477585-rs39011:~# nano /etc/systemd/system/watchlog.service
```

Запустила timer:

```
root@5477585-rs39011:/var# sudo systemctl restart watchlog.service
root@5477585-rs39011:/var# sudo systemctl status  watchlog.service
○ watchlog.service - My watchlog service
     Loaded: loaded (/etc/systemd/system/watchlog.service; static)
     Active: inactive (dead) since Mon 2025-12-29 19:10:06 MSK; 5s ago
TriggeredBy: ● watchlog.timer
    Process: 2470492 ExecStart=/opt/watchlog.sh $WORD $LOG (code=exited, status>
   Main PID: 2470492 (code=exited, status=0/SUCCESS)
        CPU: 7ms

Dec 29 19:10:06 5477585-rs39011 systemd[1]: Starting watchlog.service - My watc>
Dec 29 19:10:06 5477585-rs39011 systemd[1]: watchlog.service: Deactivated succe>
Dec 29 19:10:06 5477585-rs39011 systemd[1]: Finished watchlog.service - My watc>
root@5477585-rs39011:/var# tail -n 1000 /var/log/syslog  | grep word
2025-12-29T19:10:06.963259+03:00 5477585-rs39011 root: Mon Dec 29 07:10:06 PM MSK 2025: I found word, Master!
2025-12-29T19:10:38.555238+03:00 5477585-rs39011 root: Mon Dec 29 07:10:38 PM MSK 2025: I found word, Master!

```

## Установить spawn-fcgi и создать unit-файл (spawn-fcgi.sevice) с помощью переделки init-скрипта

Устанавила spawn-fcgi и необходимые для него пакеты:

```
root@5477585-rs39011:/var# apt install spawn-fcgi php php-cgi php-cli \
 apache2 libapache2-mod-fcgid -y
Reading package lists... Done
Building dependency tree... Done
Reading state information... Done
The following additional packages will be installed:
  apache2-bin apache2-data apache2-utils libapache2-mod-php8.3 libapr1t64
  libaprutil1-dbd-sqlite3 libaprutil1-ldap libaprutil1t64 liblua5.4-0
...
Processing triggers for php8.3-cli (8.3.6-0ubuntu0.24.04.5) ...
Processing triggers for php8.3-cgi (8.3.6-0ubuntu0.24.04.5) ...
Processing triggers for libapache2-mod-php8.3 (8.3.6-0ubuntu0.24.04.5) ...
```

Создала файл с настройками для будущего сервиса в файле /etc/spawn-fcgi/fcgi.conf.

```
root@5477585-rs39011:/etc# mkdir spawn-fcgi
root@5477585-rs39011:/etc# touch /etc/spawn-fcgi/fcgi.conf
root@5477585-rs39011:/etc# nano /etc/spawn-fcgi/fcgi.conf
```

Юнит-файл :

```
root@5477585-rs39011:/etc# touch /etc/systemd/system/spawn-fcgi.service
root@5477585-rs39011:/etc# nano /etc/systemd/system/spawn-fcgi.service
```

Убедилась, что все успешно работает:

```
root@5477585-rs39011:/etc# systemctl start spawn-fcgi
root@5477585-rs39011:/etc# systemctl status spawn-fcgi
● spawn-fcgi.service - Spawn-fcgi startup service by Otus
     Loaded: loaded (/etc/systemd/system/spawn-fcgi.service; disabled; preset: >
     Active: active (running) since Mon 2025-12-29 19:19:15 MSK; 5s ago
   Main PID: 2479855 (php-cgi)
      Tasks: 33 (limit: 2298)
     Memory: 15.0M (peak: 15.1M)
        CPU: 31ms
     CGroup: /system.slice/spawn-fcgi.service
             ├─2479855 /usr/bin/php-cgi
             ├─2479856 /usr/bin/php-cgi
             ├─2479857 /usr/bin/php-cgi
             ├─2479858 /usr/bin/php-cgi
             ├─2479859 /usr/bin/php-cgi
             ├─2479860 /usr/bin/php-cgi
             ├─2479861 /usr/bin/php-cgi
             ├─2479862 /usr/bin/php-cgi
             ├─2479863 /usr/bin/php-cgi
             ├─2479864 /usr/bin/php-cgi
             ├─2479865 /usr/bin/php-cgi
             ├─2479866 /usr/bin/php-cgi
             ├─2479867 /usr/bin/php-cgi
             ├─2479868 /usr/bin/php-cgi
             ├─2479869 /usr/bin/php-cgi
```

## Доработать unit-файл Nginx (nginx.service) для запуска нескольких инстансов сервера с разными конфигурационными файлами одновременно

Установила Nginx из стандартного репозитория:

```
root@5477585-rs39011:/etc# apt install nginx -y
Reading package lists... Done
Building dependency tree... Done
Reading state information... Done
The following additional packages will be installed:
  nginx-common
Suggested packages:
  fcgiwrap nginx-doc
The following NEW packages will be installed:
  nginx nginx-common
0 upgraded, 2 newly installed, 0 to remove and 66 not upgraded.
...
```

Создала новый Unit для работы с шаблонами (/etc/systemd/system/nginx@.service):

```
root@5477585-rs39011:/etc# touch /etc/systemd/system/nginx@.service
root@5477585-rs39011:/etc# nano /etc/systemd/system/nginx@.service
```


Создала два файла конфигурации (/etc/nginx/nginx-first.conf, /etc/nginx/nginx-second.conf). 

```
root@5477585-rs39011:/etc# touch /etc/nginx/nginx-first.conf
root@5477585-rs39011:/etc# touch /etc/nginx/nginx-second.conf
root@5477585-rs39011:/etc# cp /etc/nginx/nginx.conf /etc/nginx/nginx-first.conf
root@5477585-rs39011:/etc# cp /etc/nginx/nginx.conf /etc/nginx/nginx-second.conf
root@5477585-rs39011:/etc# nano /etc/nginx/nginx-first.conf
root@5477585-rs39011:/etc# nano /etc/nginx/nginx-second.conf
```

Проверила работу:

```
root@5477585-rs39011:/# systemctl start nginx@first
root@5477585-rs39011:/# systemctl status nginx@first
● nginx@first.service - A high performance web server and a reverse proxy server
     Loaded: loaded (/etc/systemd/system/nginx@.service; disabled; preset: enabled)
     Active: active (running) since Mon 2025-12-29 19:33:04 MSK; 15s ago
       Docs: man:nginx(8)
    Process: 2480767 ExecStartPre=/usr/sbin/nginx -t -c /etc/nginx/nginx-first.conf -q -g daemon on; master_process on>
    Process: 2480769 ExecStart=/usr/sbin/nginx -c /etc/nginx/nginx-first.conf -g daemon on; master_process on; (code=e>
   Main PID: 2480770 (nginx)
      Tasks: 2 (limit: 2298)
     Memory: 1.7M (peak: 1.9M)
        CPU: 12ms
     CGroup: /system.slice/system-nginx.slice/nginx@first.service
             ├─2480770 "nginx: master process /usr/sbin/nginx -c /etc/nginx/nginx-first.conf -g daemon on; master_proc>
             └─2480771 "nginx: worker process"

Dec 29 19:33:04 5477585-rs39011 systemd[1]: Starting nginx@first.service - A high performance web server and a reverse>
Dec 29 19:33:04 5477585-rs39011 systemd[1]: Started nginx@first.service - A high performance web server and a reverse >

root@5477585-rs39011:~# ss -tnulp | grep nginx
tcp   LISTEN 0      511                0.0.0.0:9001       0.0.0.0:*    users:(("nginx",pid=2480771,fd=5),("nginx",pid=2480770,fd=5))                                                                                                     
root@5477585-rs39011:~# systemctl start nginx@second
root@5477585-rs39011:~# ss -tnulp | grep nginx
tcp   LISTEN 0      511                0.0.0.0:9001       0.0.0.0:*    users:(("nginx",pid=2480771,fd=5),("nginx",pid=2480770,fd=5))                                                                                                     
tcp   LISTEN 0      511                0.0.0.0:9009       0.0.0.0:*    users:(("nginx",pid=2481854,fd=5),("nginx",pid=2481853,fd=5))                                                                                                     
root@5477585-rs39011:~# 

```

