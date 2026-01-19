## Ограничение доступа к системе для всех пользователей, кроме группы администраторов, в выходные дни (суббота и воскресенье), за исключением праздничных дней.

Подключилась к созданной ВМ: vagrant ssh

```
valchukelena@Valchuks-MacBook-Pro userpermission % vagrant ssh
Welcome to Ubuntu 24.04.1 LTS (GNU/Linux 6.8.0-51-generic aarch64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/pro

 System information as of Sat Jan 17 03:55:26 PM UTC 2026

  System load:             0.0
  Usage of /:              47.0% of 9.75GB
  Memory usage:            20%
  Swap usage:              0%
  Processes:               109
  Users logged in:         0
  IPv4 address for enp0s3: 10.0.2.15
  IPv6 address for enp0s3: fd17:625c:f037:2:a00:27ff:fef0:f51d


Expanded Security Maintenance for Applications is not enabled.

7 updates can be applied immediately.
To see these additional updates run: apt list --upgradable

Enable ESM Apps to receive additional future security updates.
See https://ubuntu.com/esm or run: sudo pro status


The list of available updates is more than a week old.
To check for new updates run: sudo apt update
Failed to connect to https://changelogs.ubuntu.com/meta-release-lts. Check your Internet connection or proxy settings

```

Перешла в root-пользователя и создала пользователя otusadm и otus 

```
vagrant@pam:~$ sudo -i
root@pam:~# sudo useradd otusadm && sudo useradd otus
```

Создала пользователям пароли: echo "Otus2022!" | sudo passwd --stdin otusadm && echo "Otus2022!" | sudo passwd --stdin otus

```
root@pam:~# echo "otusadm:Otus2022!" | sudo chpasswd
root@pam:~# echo "otus:Otus2022!" | sudo chpasswd
```

Создала группу admin:
Добавила пользователей vagrant,root и otusadm в группу admin:

```
root@pam:~# sudo groupadd -f admin
root@pam:~# usermod otusadm -a -G admin && usermod root -a -G admin && usermod vagrant -a -G admin
root@pam:~# cat /etc/group | grep admin
admin:x:1003:otusadm,root,vagrant
```

Проверила доступ ssh otus@192.168.57.10

```
valchukelena@Valchuks-MacBook-Pro .ssh % ssh otus@192.168.57.10               
The authenticity of host '192.168.57.10 (192.168.57.10)' can't be established.
ED25519 key fingerprint is SHA256:59xh+OeHpZyptkvQtDMihNNkF5PB2m1fCx690JvEMHo.
This host key is known by the following other names/addresses:
    ~/.ssh/known_hosts:26: [127.0.0.1]:2222
Are you sure you want to continue connecting (yes/no/[fingerprint])? yes
Warning: Permanently added '192.168.57.10' (ED25519) to the list of known hosts.
otus@192.168.57.10's password: 
Welcome to Ubuntu 24.04.1 LTS (GNU/Linux 6.8.0-51-generic aarch64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/pro

 System information as of Sat Jan 17 04:07:36 PM UTC 2026

  System load:             0.0
  Usage of /:              47.1% of 9.75GB
  Memory usage:            22%
  Swap usage:              0%
  Processes:               109
  Users logged in:         1
  IPv4 address for enp0s3: 10.0.2.15
  IPv6 address for enp0s3: fd17:625c:f037:2:a00:27ff:fef0:f51d

```

Создала файл-скрипт /usr/local/bin/login.sh адаптированный под Ubuntu 24.04
Добавила в файл /etc/pam.d/sshd модуль pam_exec и скрипт

```
root@pam:~# sudo tee /usr/local/bin/login.sh >/dev/null <<'EOF'
#!/bin/bash
set -euo pipefail

dow="$(date +%u)"
user="${PAM_USER:-}"


[[ -n "$user" ]] || exit 1

if [[ "$dow" == "6" || "$dow" == "7" ]]; then
  if id -nG "$user" | tr ' ' '\n' | grep -qx "sudo"; then
    exit 0
  else
    exit 1
  fi
fi

EOFt 0days: allow everyone
root@pam:~# sudo chmod 0755 /usr/local/bin/login.sh
root@pam:~# sudo sed -i 's/\r$//' /usr/local/bin/login.sh
root@pam:~# sudo nano /etc/pam.d/sshd
```

Проверила подключение

```
valchukelena@Valchuks-MacBook-Pro userpermission % ssh otusadm@192.168.57.10
otusadm@192.168.57.10's password: 
$ exit
Connection to 192.168.57.10 closed.
valchukelena@Valchuks-MacBook-Pro userpermission % ssh otus@192.168.57.10 
otus@192.168.57.10's password: 
/usr/local/bin/login.sh failed: exit code 1
Connection closed by 192.168.57.10 port 22
```