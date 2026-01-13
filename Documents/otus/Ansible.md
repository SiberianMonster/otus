## Установка Ansible 

Установила Ansible 

```
valchukelena@Valchuks-MacBook-Pro ~ % ansible --version
ansible [core 2.20.1]
  config file = None
  configured module search path = ['/Users/valchukelena/.ansible/plugins/modules', '/usr/share/ansible/plugins/modules']
  ansible python module location = /opt/homebrew/Cellar/ansible/13.2.0_1/libexec/lib/python3.14/site-packages/ansible
  ansible collection location = /Users/valchukelena/.ansible/collections:/usr/share/ansible/collections
  executable location = /opt/homebrew/bin/ansible
  python version = 3.14.2 (main, Dec  5 2025, 16:49:16) [Clang 17.0.0 (clang-1700.4.4.1)] (/opt/homebrew/Cellar/ansible/13.2.0_1/libexec/bin/python)
  jinja version = 3.1.6
  pyyaml version = 6.0.3 (with libyaml v0.2.5)
```

Создала каталог Ansible и положила в него Vagrantfile

```
valchukelena@Valchuks-MacBook-Pro ansible % vagrant ssh
Welcome to Ubuntu 24.04.1 LTS (GNU/Linux 6.8.0-51-generic aarch64)

 * Documentation:  https://help.ubuntu.com
 * Management:     https://landscape.canonical.com
 * Support:        https://ubuntu.com/pro

 System information as of Sun Jan 11 06:38:16 AM UTC 2026

  System load:             0.0
  Usage of /:              47.0% of 9.75GB
  Memory usage:            9%
  Swap usage:              0%
  Processes:               98
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
```

Проверила параметры с vagrant ssh-config. 

```
valchukelena@Valchuks-MacBook-Pro ansible % vagrant ssh-config
Host default
  HostName 127.0.0.1
  User vagrant
  Port 2222
  UserKnownHostsFile /dev/null
  StrictHostKeyChecking no
  PasswordAuthentication no
  IdentityFile /Users/valchukelena/.vagrant/machines/default/virtualbox/private_key
  IdentitiesOnly yes
  LogLevel FATAL
  PubkeyAcceptedKeyTypes +ssh-rsa
  HostKeyAlgorithms +ssh-rsa
```

Создала inventory файл ./staging/hosts

```
valchukelena@Valchuks-MacBook-Pro ansible % ansible nginx -i staging/hosts -m ping            
[WARNING]: Host 'nginx' is using the discovered Python interpreter at '/usr/bin/python3.12', but future installation of another Python interpreter could cause a different interpreter to be discovered. See https://docs.ansible.com/ansible-core/2.20/reference_appendices/interpreter_discovery.html for more information.
nginx | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python3.12"
    },
    "changed": false,
    "ping": "pong"
}
```

Создала файл ansible.cfg 

```
valchukelena@Valchuks-MacBook-Pro ansible % touch ansible.cfg
valchukelena@Valchuks-MacBook-Pro ansible % nano ansible.cfg
valchukelena@Valchuks-MacBook-Pro ansible % ansible nginx -m ping            
[WARNING]: Host 'nginx' is using the discovered Python interpreter at '/usr/bin/python3.12', but future installation of another Python interpreter could cause a different interpreter to be discovered. See https://docs.ansible.com/ansible-core/2.20/reference_appendices/interpreter_discovery.html for more information.
nginx | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python3.12"
    },
    "changed": false,
    "ping": "pong"
}
```

Посмотрела какое ядро установлено на хосте:

```
valchukelena@Valchuks-MacBook-Pro ansible % ansible nginx -m command -a "uname -r"
[WARNING]: Host 'nginx' is using the discovered Python interpreter at '/usr/bin/python3.12', but future installation of another Python interpreter could cause a different interpreter to be discovered. See https://docs.ansible.com/ansible-core/2.20/reference_appendices/interpreter_discovery.html for more information.
nginx | CHANGED | rc=0 >>
6.8.0-51-generic
```

Проверила статус сервиса firewalld

```
valchukelena@Valchuks-MacBook-Pro ansible % ansible nginx -m systemd -a name=firewalld
[WARNING]: Host 'nginx' is using the discovered Python interpreter at '/usr/bin/python3.12', but future installation of another Python interpreter could cause a different interpreter to be discovered. See https://docs.ansible.com/ansible-core/2.20/reference_appendices/interpreter_discovery.html for more information.
nginx | SUCCESS => {
    "ansible_facts": {
        "discovered_interpreter_python": "/usr/bin/python3.12"
    },
    "changed": false,
    "name": "firewalld",
    "status": {
        "ActiveEnterTimestampMonotonic": "0",
        "ActiveExitTimestampMonotonic": "0",
        "ActiveState": "inactive",
        "AllowIsolate": "no",
        "AssertResult": "no",
        "AssertTimestampMonotonic": "0",
        ...
        "UMask": "0022",
        "UtmpMode": "init",
        "WatchdogSignal": "6",
        "WatchdogTimestampMonotonic": "0",
        "WatchdogUSec": "infinity"
    }
}
```

Добавила шаблон для конфига NGINX и модуль, который будет копировать этот шаблон на хост:

```
valchukelena@Valchuks-MacBook-Pro ansible % touch nginx.yml
valchukelena@Valchuks-MacBook-Pro ansible % nano nginx.yml
```

Запустила playbook

```
valchukelena@Valchuks-MacBook-Pro ansible % ansible-playbook nginx.yml

PLAY [NGINX] *******************************************************************

TASK [Gathering Facts] *********************************************************
[WARNING]: Host 'nginx' is using the discovered Python interpreter at '/usr/bin/python3.12', but future installation of another Python interpreter could cause a different interpreter to be discovered. See https://docs.ansible.com/ansible-core/2.20/reference_appendices/interpreter_discovery.html for more information.
ok: [nginx]

TASK [update] ******************************************************************
changed: [nginx]

TASK [NGINX install] ***********************************************************
ok: [defaunginxlt]

TASK [NGINX create config] *****************************************************
changed: [nginx]

PLAY RECAP *********************************************************************
nginx                    : ok=4    changed=2    unreachable=0    failed=0    skipped=0    rescued=0    ignored=0   

valchukelena@Valchuks-MacBook-Pro ansible % curl http://192.168.11.150:8080
<!DOCTYPE html>
<html>
<head>
<title>Welcome to nginx!</title>
<style>
    body {
        width: 35em;
        margin: 0 auto;
        font-family: Tahoma, Verdana, Arial, sans-serif;
    }
</style>
</head>
<body>
<h1>Welcome to nginx!</h1>
<p>If you see this page, the nginx web server is successfully installed and
working. Further configuration is required.</p>

<p>For online documentation and support please refer to
<a href="http://nginx.org/">nginx.org</a>.<br/>
Commercial support is available at
<a href="http://nginx.com/">nginx.com</a>.</p>

<p><em>Thank you for using nginx.</em></p>
</body>
</html>
```
