## Научится проектировать централизованный сбор логов. Рассмотреть особенности разных платформ для сбора логов.

Создала виртуальные машины с помощью Vagrantfile. Проверила время, Настроила NTP (добавила IP вм log "allow 192.168.56.15"  в конце /etc/chrony/chrony.conf)

```
vagrant@web:~$ sudo -i
root@web:~# timedatectl
               Local time: Sat 2026-01-17 18:09:21 UTC
           Universal time: Sat 2026-01-17 18:09:21 UTC
                 RTC time: Sat 2026-01-17 18:09:21
                Time zone: Etc/UTC (UTC, +0000)
System clock synchronized: no
              NTP service: inactive
          RTC in local TZ: no
root@web:~# date
Sat Jan 17 18:09:31 UTC 2026
root@web:~# apt update && apt -y install chrony
root@web:~# nano /etc/chrony/chrony.conf
root@web:~# systemctl enable chrony
```

Установила nginx на виртуальной машине web

```
root@web:~# apt update && apt install -y nginx  
Hit:1 http://ports.ubuntu.com/ubuntu-ports jammy InRelease
Get:2 http://ports.ubuntu.com/ubuntu-ports jammy-updates InRelease [128 kB]
Get:3 http://ports.ubuntu.com/ubuntu-ports jammy-backports InRelease [127 kB]
...

root@web:~# systemctl status nginx
● nginx.service - A high performance web server and a reverse proxy server
     Loaded: loaded (/lib/systemd/system/nginx.service; enabled; vendor preset:>
     Active: active (running) since Sat 2026-01-17 18:10:43 UTC; 23s ago
       Docs: man:nginx(8)
    Process: 2529 ExecStartPre=/usr/sbin/nginx -t -q -g daemon on; master_proce>
    Process: 2530 ExecStart=/usr/sbin/nginx -g daemon on; master_process on; (c>
   Main PID: 2621 (nginx)
      Tasks: 3 (limit: 1410)
     Memory: 4.6M
        CPU: 17ms
...

root@web:~# ss -tln | grep 80
LISTEN 0      511          0.0.0.0:80        0.0.0.0:*          
LISTEN 0      511             [::]:80           [::]:*  
```

Подключилась по ssh к ВМ log, Настроила NTP (добавила IP вм web "server 192.168.1.10 iburst"  в /etc/chrony/chrony.conf)

```
vagrant@log:~$ sudo -i
root@log:~# apt update && apt -y install chrony
root@log:~# nano /etc/chrony/chrony.conf
root@log:~# systemctl enable chrony
```

Настроила Rsyslog

```
root@log:~# apt list rsyslog
Listing... Done
rsyslog/jammy-updates,jammy-security,now 8.2112.0-2ubuntu2.2 arm64 [installed,automatic]
N: There is 1 additional version. Please use the '-a' switch to see it
root@log:~# nano /etc/rsyslog.conf 
root@log:~# systemctl restart rsyslog
```

На ВМ web настроила отправку логов

```
root@web:~# nginx -v
nginx version: nginx/1.18.0 (Ubuntu)
root@web:~# nano /etc/nginx/nginx.conf
root@web:~# nginx -t
nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
nginx: configuration file /etc/nginx/nginx.conf test is successful
root@web:~# systemctl restart nginx
root@web:~# systemctl status nginx
● nginx.service - A high performance web server and a reverse proxy server
     Loaded: loaded (/lib/systemd/system/nginx.service; enabled; vendor preset:>
     Active: active (running) since Sat 2026-01-17 18:25:41 UTC; 26s ago
       Docs: man:nginx(8)
```

Открыла страницу и проверила логи на ВМ log

```
root@log:~# cat /var/log/rsyslog/web/nginx_access.log 
Jan 17 18:42:40 web nginx_access: 192.168.56.1 - - [17/Jan/2026:18:42:40 +0000] "GET / HTTP/1.1" 200 612 "-" "curl/8.7.1"
Jan 17 18:42:41 web nginx_access: 192.168.56.1 - - [17/Jan/2026:18:42:41 +0000] "GET / HTTP/1.1" 200 612 "-" "curl/8.7.1"
```

Переместила файл веб-страницы, который открывает nginx, и проверила лог с ошибками

```
root@log:~# cat /var/log/rsyslog/web/nginx_error.log 
Jan 17 18:43:26 web nginx_error: 2026/01/17 18:43:26 [error] 3375#3375: *1 directory index of "/var/www/html/" is forbidden, client: 192.168.56.1, server: _, request: "GET / HTTP/1.1", host: "192.168.56.10"
Jan 17 18:43:27 web nginx_error: 2026/01/17 18:43:27 [error] 3375#3375: *2 directory index of "/var/www/html/" is forbidden, client: 192.168.56.1, server: _, request: "GET / HTTP/1.1", host: "192.168.56.10
```

