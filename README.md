# otus
Задание 1

Описание домашнего задания
1) Запустить ВМ c Ubuntu.
2) Обновить ядро ОС на новейшую стабильную версию из mainline-репозитория.
3) Оформить отчет в README-файле в GitHub-репозитории.

Проверила ядро
```
root@5206583-rs39011:~# uname -r
6.8.0-62-generic
```

Скачала новую версию
```
root@5206583-rs39011:~# mkdir kernel && cd kernel
root@5206583-rs39011:~/kernel# wget https://kernel.ubuntu.com/mainline/v6.16-rc4/amd64/linux-headers-6.16.0-061600rc4-generic_6.16.0-061600rc4.202506292136_amd64.deb
--2025-07-02 21:52:55--  https://kernel.ubuntu.com/mainline/v6.16-rc4/amd64/linux-headers-6.16.0-061600rc4-generic_6.16.0-061600rc4.202506292136_amd64.deb
Resolving kernel.ubuntu.com (kernel.ubuntu.com)... 185.125.189.75, 185.125.189.74, 185.125.189.76
Connecting to kernel.ubuntu.com (kernel.ubuntu.com)|185.125.189.75|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: 3703788 (3.5M) [application/x-debian-package]
Saving to: ‘linux-headers-6.16.0-061600rc4-generic_6.16.0-061600rc4.202506292136_amd64.deb’

linux-headers-6.16. 100%[===================>]   3.53M  8.36MB/s    in 0.4s    

2025-07-02 21:52:56 (8.36 MB/s) - ‘linux-headers-6.16.0-061600rc4-generic_6.16.0-061600rc4.202506292136_amd64.deb’ saved [3703788/3703788]

root@5206583-rs39011:~/kernel# wget https://kernel.ubuntu.com/mainline/v6.16-rc4/amd64/linux-headers-6.16.0-061600rc4_6.16.0-061600rc4.202506292136_all.deb
--2025-07-02 21:53:07--  https://kernel.ubuntu.com/mainline/v6.16-rc4/amd64/linux-headers-6.16.0-061600rc4_6.16.0-061600rc4.202506292136_all.deb
Resolving kernel.ubuntu.com (kernel.ubuntu.com)... 185.125.189.75, 185.125.189.76, 185.125.189.74
Connecting to kernel.ubuntu.com (kernel.ubuntu.com)|185.125.189.75|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: 14250758 (14M) [application/x-debian-package]
Saving to: ‘linux-headers-6.16.0-061600rc4_6.16.0-061600rc4.202506292136_all.deb’

linux-headers-6.16. 100%[===================>]  13.59M  22.3MB/s    in 0.6s    

2025-07-02 21:53:07 (22.3 MB/s) - ‘linux-headers-6.16.0-061600rc4_6.16.0-061600rc4.202506292136_all.deb’ saved [14250758/14250758]
root@5206583-rs39011:~/kernel# wget https://kernel.ubuntu.com/mainline/v6.16-rc4/amd64/linux-image-unsigned-6.16.0-061600rc4-generic_6.16.0-061600rc4.202506292136_amd64.deb
--2025-07-02 21:53:28--  https://kernel.ubuntu.com/mainline/v6.16-rc4/amd64/linux-image-unsigned-6.16.0-061600rc4-generic_6.16.0-061600rc4.202506292136_amd64.deb
Resolving kernel.ubuntu.com (kernel.ubuntu.com)... 185.125.189.75, 185.125.189.74, 185.125.189.76
Connecting to kernel.ubuntu.com (kernel.ubuntu.com)|185.125.189.75|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: 16056512 (15M) [application/x-debian-package]
Saving to: ‘linux-image-unsigned-6.16.0-061600rc4-generic_6.16.0-061600rc4.202506292136_amd64.deb’

linux-image-unsigne 100%[===================>]  15.31M  28.5MB/s    in 0.5s    

2025-07-02 21:53:28 (28.5 MB/s) - ‘linux-image-unsigned-6.16.0-061600rc4-generic_6.16.0-061600rc4.202506292136_amd64.deb’ saved [16056512/16056512]

root@5206583-rs39011:~/kernel# wget https://kernel.ubuntu.com/mainline/v6.16-rc4/amd64/linux-modules-6.16.0-061600rc4-generic_6.16.0-061600rc4.202506292136_amd64.deb
--2025-07-02 21:53:38--  https://kernel.ubuntu.com/mainline/v6.16-rc4/amd64/linux-modules-6.16.0-061600rc4-generic_6.16.0-061600rc4.202506292136_amd64.deb
Resolving kernel.ubuntu.com (kernel.ubuntu.com)... 185.125.189.74, 185.125.189.75, 185.125.189.76
Connecting to kernel.ubuntu.com (kernel.ubuntu.com)|185.125.189.74|:443... connected.
HTTP request sent, awaiting response... 200 OK
Length: 262113472 (250M) [application/x-debian-package]
Saving to: ‘linux-modules-6.16.0-061600rc4-generic_6.16.0-061600rc4.202506292136_amd64.deb’

linux-modules-6.16. 100%[===================>] 249.97M  80.8MB/s    in 3.5s    

2025-07-02 21:53:42 (72.1 MB/s) - ‘linux-modules-6.16.0-061600rc4-generic_6.16.0-061600rc4.202506292136_amd64.deb’ saved [262113472/262113472]
```

Установила пакеты 
```
root@5206583-rs39011:~/kernel# sudo dpkg -i *.deb 
Selecting previously unselected package linux-headers-6.16.0-061600rc4-generic.
(Reading database ... 75172 files and directories currently installed.)
Preparing to unpack linux-headers-6.16.0-061600rc4-generic_6.16.0-061600rc4.202506292136_amd64.deb ...
Unpacking linux-headers-6.16.0-061600rc4-generic (6.16.0-061600rc4.202506292136) ...
Selecting previously unselected package linux-headers-6.16.0-061600rc4.
Preparing to unpack linux-headers-6.16.0-061600rc4_6.16.0-061600rc4.202506292136_all.deb ...
Unpacking linux-headers-6.16.0-061600rc4 (6.16.0-061600rc4.202506292136) ...
Selecting previously unselected package linux-image-unsigned-6.16.0-061600rc4-generic.
Preparing to unpack linux-image-unsigned-6.16.0-061600rc4-generic_6.16.0-061600rc4.202506292136_amd64.deb ...
Unpacking linux-image-unsigned-6.16.0-061600rc4-generic (6.16.0-061600rc4.202506292136) ...
Selecting previously unselected package linux-modules-6.16.0-061600rc4-generic.
Preparing to unpack linux-modules-6.16.0-061600rc4-generic_6.16.0-061600rc4.202506292136_amd64.deb ...
Unpacking linux-modules-6.16.0-061600rc4-generic (6.16.0-061600rc4.202506292136) ...
Setting up linux-headers-6.16.0-061600rc4 (6.16.0-061600rc4.202506292136) ...
Setting up linux-modules-6.16.0-061600rc4-generic (6.16.0-061600rc4.202506292136) ...
Setting up linux-headers-6.16.0-061600rc4-generic (6.16.0-061600rc4.202506292136) ...
Setting up linux-image-unsigned-6.16.0-061600rc4-generic (6.16.0-061600rc4.202506292136) ...
I: /boot/vmlinuz is now a symlink to vmlinuz-6.16.0-061600rc4-generic
I: /boot/initrd.img is now a symlink to initrd.img-6.16.0-061600rc4-generic
Processing triggers for linux-image-unsigned-6.16.0-061600rc4-generic (6.16.0-061600rc4.202506292136) ...
/etc/kernel/postinst.d/initramfs-tools:
update-initramfs: Generating /boot/initrd.img-6.16.0-061600rc4-generic
/etc/kernel/postinst.d/zz-update-grub:
Sourcing file `/etc/default/grub'
Generating grub configuration file ...
Found linux image: /boot/vmlinuz-6.16.0-061600rc4-generic
Found initrd image: /boot/initrd.img-6.16.0-061600rc4-generic
Found linux image: /boot/vmlinuz-6.8.0-62-generic
Found initrd image: /boot/initrd.img-6.8.0-62-generic
Warning: os-prober will not be executed to detect other bootable partitions.
Systems on them will not be added to the GRUB boot configuration.
Check GRUB_DISABLE_OS_PROBER documentation entry.
Adding boot menu entry for UEFI Firmware Settings ...
done
```

Проверила, что ядро появилось в /boot.
```
root@5206583-rs39011:~/kernel# ls -al /boot
total 159016
drwxr-xr-x  3 root root     4096 Jul  2 21:54 .
drwxr-xr-x 23 root root     4096 Jul  2 21:43 ..
-rw-------  1 root root 10126926 Jun 30 00:36 System.map-6.16.0-061600rc4-generic
-rw-------  1 root root  9109506 May 19 13:55 System.map-6.8.0-62-generic
-rw-r--r--  1 root root   299500 Jun 30 00:36 config-6.16.0-061600rc4-generic
-rw-r--r--  1 root root   287598 May 19 13:55 config-6.8.0-62-generic
drwxr-xr-x  5 root root     4096 Jul  2 21:54 grub
lrwxrwxrwx  1 root root       35 Jul  2 21:54 initrd.img -> initrd.img-6.16.0-061600rc4-generic
-rw-r--r--  1 root root 66064943 Jul  2 21:54 initrd.img-6.16.0-061600rc4-generic
-rw-r--r--  1 root root 45877069 Jun 23 12:32 initrd.img-6.8.0-62-generic
lrwxrwxrwx  1 root root       27 Jun 23 12:21 initrd.img.old -> initrd.img-6.8.0-62-generic
lrwxrwxrwx  1 root root       32 Jul  2 21:54 vmlinuz -> vmlinuz-6.16.0-061600rc4-generic
-rw-------  1 root root 16024064 Jun 30 00:36 vmlinuz-6.16.0-061600rc4-generic
-rw-------  1 root root 15006088 May 19 18:52 vmlinuz-6.8.0-62-generic
lrwxrwxrwx  1 root root       24 Jun 23 12:21 vmlinuz.old -> vmlinuz-6.8.0-62-generic
```

Перезагрузила
```
root@5206583-rs39011:~/kernel# sudo reboot
```

```
root@5206583-rs39011:~# uname -r
6.16.0-061600rc4-generic
```
