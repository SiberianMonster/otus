## Создание RPM пакета

Установила rpm модули

```
[root@5504953-rs39011 ~]# yum install -y wget rpmdevtools rpm-build createrepo \
 yum-utils cmake gcc git nano
AlmaLinux 9 - AppStream                     7.2 kB/s | 4.2 kB     00:00    
AlmaLinux 9 - AppStream                     7.5 MB/s |  16 MB     00:02    
AlmaLinux 9 - BaseOS                        8.2 kB/s | 3.8 kB     00:00    
AlmaLinux 9 - BaseOS                        2.6 MB/s |  19 MB     00:07    
AlmaLinux 9 - Extras                        7.1 kB/s | 3.3 kB     00:00    
AlmaLinux 9 - Extras                         37 kB/s |  20 kB     00:00    
Zabbix Agent From Timeweb                   437 kB/s | 2.9 kB     00:00    
TimeWeb Mirror AppStream                    1.2 MB/s | 4.4 kB     00:00    
TimeWeb Mirror BaseOS                       1.3 MB/s | 3.9 kB     00:00    
TimeWeb Mirror EPEL                         1.3 MB/s | 4.0 kB     00:00    
TimeWeb Mirror EPEL                          30 MB/s |  20 MB     00:00    
Dependencies resolved.
============================================================================
 Package                Arch   Version              Repository         Size
============================================================================
Installing:
 cmake                  x86_64 3.26.5-2.el9         appstream         8.7 M
 createrepo_c           x86_64 0.20.1-4.el9         timeweb_AppStream  74 k
 gcc                    x86_64 11.5.0-7.el9         timeweb_AppStream  32 M
 git                    x86_64 2.47.3-1.el9_6       appstream          50 k
 nano                   x86_64 5.6.1-7.el9          baseos            692 k
 rpm-build              x86_64 4.16.1.3-38.el9      timeweb_AppStream  67 k
 rpmdevtools            noarch 9.5-1.el9            appstream          75 k
 wget                   x86_64 1.21.1-8.el9_4       appstream         768 k
 yum-utils              noarch 4.3.0-21.el9         timeweb_BaseOS     40 k
Upgrading:
 dnf-plugins-core       noarch 4.3.0-21.el9         timeweb_BaseOS     37 k
 ima-evm-utils          x86_64 1.6.2-1.el9          timeweb_BaseOS     78 k

....


  pkgconf-m4-1.7.3-10.el9.noarch                                            
  pkgconf-pkg-config-1.7.3-10.el9.x86_64                                    
  pyproject-srpm-macros-1.16.2-1.el9.noarch                                 
  python-srpm-macros-3.9-54.el9.noarch                                      
  python3-argcomplete-1.12.0-5.el9.noarch                                   
  qt5-srpm-macros-5.15.9-1.el9.noarch                                       
  redhat-rpm-config-209-1.el9.alma.1.noarch                                 
  rpm-build-4.16.1.3-38.el9.x86_64                                          
  rpmdevtools-9.5-1.el9.noarch                                              
  rust-srpm-macros-17-4.el9.noarch                                          
  tar-2:1.34-7.el9.x86_64                                                   
  unzip-6.0-58.el9_5.x86_64                                                 
  vim-filesystem-2:8.2.2637-22.el9_6.noarch                                 
  wget-1.21.1-8.el9_4.x86_64                                                
  yum-utils-4.3.0-21.el9.noarch                                             
  zip-3.0-35.el9.x86_64                                                     
  zstd-1.5.5-1.el9.x86_64                                                   

Complete!

```

Создала скрипт для своего пакета

```
[root@5505541-rs39011 rpmbuild]# cat << EOF >> hello.sh
#!/bin/sh
echo "Hello world"
EOF
```

Создала архив

```
[root@5505541-rs39011 rpmbuild]# mv hello.sh hello-0.0.1
[root@5505541-rs39011 rpmbuild]# tar --create --file hello-0.0.1.tar.gz hello-0.0.1
```

Создала spec file

```
[root@5505541-rs39011 rpmbuild]# mv hello-0.0.1.tar.gz SOURCES
[root@5505541-rs39011 rpmbuild]# rpmdev-newspec hello
hello.spec created; type minimal, rpm version >= 4.16.
[root@5505541-rs39011 rpmbuild]# cd SPECS
[root@5505541-rs39011 SPECS]# rpmdev-newspec hello
hello.spec created; type minimal, rpm version >= 4.16.
[root@5505541-rs39011 SPECS]# nano hello.spec
[root@5505541-rs39011 SPECS]# rpmlint hello.spec
hello.spec: E: specfile-error error: line 7: Empty tag: URL:
0 packages and 1 specfiles checked; 1 error, 0 warnings.
[root@5505541-rs39011 SPECS]# rpmspec -q hello.spec
error: line 7: Empty tag: URL:
```

Создала RPM пакет

```
[root@5505541-rs39011 rpmbuild]# rpmbuild -ba ~/rpmbuild/SPECS/hello.spec
setting SOURCE_DATE_EPOCH=1756512000
Executing(%prep): /bin/sh -e /var/tmp/rpm-tmp.de4SG1
+ umask 022
+ cd /root/rpmbuild/BUILD
+ cd /root/rpmbuild/BUILD
+ rm -rf hello-0.0.1
+ /usr/bin/tar -xof /root/rpmbuild/SOURCES/hello-0.0.1.tar.gz
+ STATUS=0
+ '[' 0 -ne 0 ']'
+ cd hello-0.0.1
+ /usr/bin/chmod -Rf a+rX,u+w,g-w,o-w .
+ RPM_EC=0
++ jobs -p
+ exit 0
Executing(%install): /bin/sh -e /var/tmp/rpm-tmp.LquYoY
+ umask 022
+ cd /root/rpmbuild/BUILD
+ '[' /root/rpmbuild/BUILDROOT/hello-0.0.1-1.el9.x86_64 '!=' / ']'
+ rm -rf /root/rpmbuild/BUILDROOT/hello-0.0.1-1.el9.x86_64
++ dirname /root/rpmbuild/BUILDROOT/hello-0.0.1-1.el9.x86_64
+ mkdir -p /root/rpmbuild/BUILDROOT
+ mkdir /root/rpmbuild/BUILDROOT/hello-0.0.1-1.el9.x86_64
+ cd hello-0.0.1
+ rm -rf /root/rpmbuild/BUILDROOT/hello-0.0.1-1.el9.x86_64
+ mkdir -p /root/rpmbuild/BUILDROOT/hello-0.0.1-1.el9.x86_64//usr/bin
+ cp hello.sh /root/rpmbuild/BUILDROOT/hello-0.0.1-1.el9.x86_64//usr/bin
+ '[' '%{buildarch}' = noarch ']'
+ QA_CHECK_RPATHS=1
+ case "${QA_CHECK_RPATHS:-}" in
+ /usr/lib/rpm/check-rpaths
+ /usr/lib/rpm/check-buildroot
+ /usr/lib/rpm/redhat/brp-ldconfig
+ /usr/lib/rpm/brp-compress
+ /usr/lib/rpm/brp-strip /usr/bin/strip
+ /usr/lib/rpm/brp-strip-comment-note /usr/bin/strip /usr/bin/objdump
+ /usr/lib/rpm/redhat/brp-strip-lto /usr/bin/strip
+ /usr/lib/rpm/brp-strip-static-archive /usr/bin/strip
+ /usr/lib/rpm/redhat/brp-python-bytecompile '' 1 0
+ /usr/lib/rpm/brp-python-hardlink
+ /usr/lib/rpm/redhat/brp-mangle-shebangs
Processing files: hello-0.0.1-1.el9.x86_64
Provides: hello = 0.0.1-1.el9 hello(x86-64) = 0.0.1-1.el9
Requires(rpmlib): rpmlib(CompressedFileNames) <= 3.0.4-1 rpmlib(FileDigests) <= 4.6.0-1 rpmlib(PayloadFilesHavePrefix) <= 4.0-1
Checking for unpackaged file(s): /usr/lib/rpm/check-files /root/rpmbuild/BUILDROOT/hello-0.0.1-1.el9.x86_64
Wrote: /root/rpmbuild/SRPMS/hello-0.0.1-1.el9.src.rpm
Wrote: /root/rpmbuild/RPMS/x86_64/hello-0.0.1-1.el9.x86_64.rpm
Executing(%clean): /bin/sh -e /var/tmp/rpm-tmp.Vk2hBd
+ umask 022
+ cd /root/rpmbuild/BUILD
+ cd hello-0.0.1
+ rm -rf /root/rpmbuild/BUILDROOT/hello-0.0.1-1.el9.x86_64
+ RPM_EC=0
++ jobs -p
+ exit 0
```

Проверила установку пакета

```
[root@5505541-rs39011 RPMS]# cd noarch
[root@5505541-rs39011 noarch]# sudo dnf install /root/rpmbuild/RPMS/x86_64/hello-0.0.1-1.el9.x86_64.rpm
Last metadata expiration check: 0:28:14 ago on Sat 30 Aug 2025 08:28:58 PM MSK.
Dependencies resolved.
================================================================================
 Package       Architecture   Version                Repository            Size
================================================================================
Installing:
 hello         x86_64         0.0.1-1.el9            @commandline         6.6 k

Transaction Summary
================================================================================
Install  1 Package

Total size: 6.6 k
Installed size: 29  
Is this ok [y/N]: y
Downloading Packages:
Running transaction check
Transaction check succeeded.
Running transaction test
Transaction test succeeded.
Running transaction
  Preparing        :                                                        1/1 
  Installing       : hello-0.0.1-1.el9.x86_64                               1/1 
  Verifying        : hello-0.0.1-1.el9.x86_64                               1/1 

Installed:
  hello-0.0.1-1.el9.x86_64                                                      

Complete!
[root@5505541-rs39011 noarch]# rpm -qi hello
Name        : hello
Version     : 0.0.1
Release     : 1.el9
Architecture: x86_64
Install Date: Sat 30 Aug 2025 08:57:16 PM MSK
Group       : Unspecified
Size        : 29
License     : GPL
Signature   : (none)
Source RPM  : hello-0.0.1-1.el9.src.rpm
Build Date  : Sat 30 Aug 2025 08:55:59 PM MSK
Build Host  : 5505541-rs39011.twc1.net.twc1.net
URL         : https://github.com/SiberianMonster/otus
Summary     : Test module
Description :
A demo file
[root@5505541-rs39011 noarch]# rpm -ql hello
/usr/bin/hello.sh
```

## Создание RPM репозитория

Создала каталог 

```
[root@5505541-rs39011 /]# mkdir /usr/share/nginx/html/repo
[root@5505541-rs39011 /]# cp ~/rpmbuild/RPMS/x86_64/*.rpm /usr/share/nginx/html/repo/
[root@5505541-rs39011 /]# createrepo /usr/share/repo/nginx/html/
Directory walk started
Directory walk done - 11 packages
Temporary output repo path: /usr/share/nginx/html/repo/.repodata/
Preparing sqlite DBs
Pool started (with 5 workers)
Pool finished
```

Проверила синтаксис и перезапустила NGINX

```
[root@5505541-rs39011 /]# nginx -t
nginx: the configuration file /etc/nginx/nginx.conf syntax is ok
nginx: configuration file /etc/nginx/nginx.conf test is successful
[root@5505541-rs39011 /]# nginx -s reload
```

Протестировала репозиторий

```
[root@5505541-rs39011 /]# cat >> /etc/yum.repos.d/otus.repo << EOF
[otus]
name=otus-linux
baseurl=http://localhost/repo
gpgcheck=0
enabled=1
EOF
[root@5505541-rs39011 /]# yum repolist enabled | grep otus
otus                                otus-linux
```

Репозиторий доступен по http://46.149.66.166/repo/

```
[root@5505541-rs39011 /]# curl -a http://46.149.66.166/repo/
<html>
<head><title>Index of /repo/</title></head>
<body>
<h1>Index of /repo/</h1><hr><pre><a href="../">../</a>
<a href="repodata/">repodata/</a>                                          07-Sep-2025 13:06                   -
<a href="hello-0.0.1-1.el9.x86_64.rpm">hello-0.0.1-1.el9.x86_64.rpm</a>                       07-Sep-2025 13:06                6798
<a href="nginx-1.20.1-22.el9.3.alma.1.x86_64.rpm">nginx-1.20.1-22.el9.3.alma.1.x86_64.rpm</a>            07-Sep-2025 13:06               37018
<a href="nginx-all-modules-1.20.1-22.el9.3.alma.1.noarch.rpm">nginx-all-modules-1.20.1-22.el9.3.alma.1.noarch..&gt;</a> 07-Sep-2025 13:06                8133
<a href="nginx-core-1.20.1-22.el9.3.alma.1.x86_64.rpm">nginx-core-1.20.1-22.el9.3.alma.1.x86_64.rpm</a>       07-Sep-2025 13:06              590756
<a href="nginx-filesystem-1.20.1-22.el9.3.alma.1.noarch.rpm">nginx-filesystem-1.20.1-22.el9.3.alma.1.noarch.rpm</a> 07-Sep-2025 13:06                9734
<a href="nginx-mod-devel-1.20.1-22.el9.3.alma.1.x86_64.rpm">nginx-mod-devel-1.20.1-22.el9.3.alma.1.x86_64.rpm</a>  07-Sep-2025 13:06              761147
<a href="nginx-mod-http-image-filter-1.20.1-22.el9.3.alma.1.x86_64.rpm">nginx-mod-http-image-filter-1.20.1-22.el9.3.alm..&gt;</a> 07-Sep-2025 13:06               20122
<a href="nginx-mod-http-perl-1.20.1-22.el9.3.alma.1.x86_64.rpm">nginx-mod-http-perl-1.20.1-22.el9.3.alma.1.x86_..&gt;</a> 07-Sep-2025 13:06               31776
<a href="nginx-mod-http-xslt-filter-1.20.1-22.el9.3.alma.1.x86_64.rpm">nginx-mod-http-xslt-filter-1.20.1-22.el9.3.alma..&gt;</a> 07-Sep-2025 13:06               18924
<a href="nginx-mod-mail-1.20.1-22.el9.3.alma.1.x86_64.rpm">nginx-mod-mail-1.20.1-22.el9.3.alma.1.x86_64.rpm</a>   07-Sep-2025 13:06               54527
<a href="nginx-mod-stream-1.20.1-22.el9.3.alma.1.x86_64.rpm">nginx-mod-stream-1.20.1-22.el9.3.alma.1.x86_64.rpm</a> 07-Sep-2025 13:06               81125
<a href="percona-release-latest.noarch.rpm">percona-release-latest.noarch.rpm</a>                  21-Aug-2025 12:37               28532
</pre><hr></body>
</html>
```