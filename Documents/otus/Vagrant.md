## Обновление ядра

Проверила текущую версию ядра

```
vagrant@kernel-update:~$ uname -r
6.8.0-51-generic
```

Взяла новую версию:

```
vagrant@kernel-update:~$ sudo add-apt-repository ppa:cappelikan/ppa
Repository: 'Types: deb
URIs: https://ppa.launchpadcontent.net/cappelikan/ppa/ubuntu/
Suites: noble
Components: main
'
Description:
Mainline Ubuntu Kernel Installer https://github.com/bkw777/mainline
More info: https://launchpad.net/~cappelikan/+archive/ubuntu/ppa
Adding repository.
Press [ENTER] to continue or Ctrl-c to cancel.
Hit:1 http://ports.ubuntu.com/ubuntu-ports noble InRelease
Get:2 http://ports.ubuntu.com/ubuntu-ports noble-updates InRelease [126 kB]
Get:3 https://ppa.launchpadcontent.net/cappelikan/ppa/ubuntu noble InRelease [17.8 kB]
Get:4 https://ppa.launchpadcontent.net/cappelikan/ppa/ubuntu noble/main arm64 Packages [588 B]
...

vagrant@kernel-update:~$ sudo apt update
Hit:1 http://ports.ubuntu.com/ubuntu-ports noble InRelease
Hit:2 https://ppa.launchpadcontent.net/cappelikan/ppa/ubuntu noble InRelease
Hit:3 http://ports.ubuntu.com/ubuntu-ports noble-updates InRelease
Hit:4 http://ports.ubuntu.com/ubuntu-ports noble-backports InRelease
Hit:5 http://ports.ubuntu.com/ubuntu-ports noble-security InRelease
Reading package lists... Done
Building dependency tree... Done
Reading state information... Done
259 packages can be upgraded. Run 'apt list --upgradable' to see them.
vagrant@kernel-update:~$ sudo apt install mainline
Reading package lists... Done
Building dependency tree... Done
Reading state information... Done
...

vagrant@kernel-update:~$ mainline list
mainline 1.4.13
Updating Kernels...
----------------------------------------------------------------      
Available Kernels
----------------------------------------------------------------
6.18.1                     
6.18.1_64k                 
6.18                       
6.18_64k                   
6.17.12                    
6.17.12_64k                
6.17.11              
...

vagrant@kernel-update:~$ sudo mainline install 6.10.12
mainline 1.4.13
Updating Kernels...
Downloading 6.10.12
Installing 6.10.12                                                    
Selecting previously unselected package linux-headers-6.10.12-061012-generic.
(Reading database ... 103336 files and directories currently installed.)
Preparing to unpack .../linux-headers-6.10.12-061012-generic_6.10.12-061012.202411060323_arm64.deb ...
Unpacking linux-headers-6.10.12-061012-generic (6.10.12-061012.202411060323) ...
Selecting previously unselected package linux-headers-6.10.12-061012.
Preparing to unpack .../linux-
...

vagrant@kernel-update:~$ sudo reboot

vagrant@kernel-update:~$ uname -r
6.10.12-061012-generic

```
