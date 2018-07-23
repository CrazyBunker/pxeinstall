#!/bin/bash -xe
source ./config.cfg
sudo patch -d "$tmp/root/root/" -p0 <<'EOF'
--- .bashrc.orig	2018-07-19 03:56:34.000000000 +0300
+++ .bashrc	2018-07-22 17:12:50.973585791 +0300
@@ -12,3 +12,25 @@
 		fi
 	fi
 fi
+
+setterm -blank 0
+server='192.168.0.1'
+share="pxeboot"
+if [ $(tty) = "/dev/tty1" ];then
+rmmod tg3
+sleep 1s
+modprobe tg3
+while :
+    do
+        sleep 1;
+        if [ $(ping $server -c 10 -w 30 -q &> /dev/null && echo $?) ] 
+        then
+            break
+        fi
+    done
+ntpdate $server
+ip address
+mkdir -p /mnt/net
+mount //$server/$share /mnt/net -o username=anon,password=nopass
+/mnt/net/script.sh
+fi
EOF
