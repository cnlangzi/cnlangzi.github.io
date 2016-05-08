#!/bin/bash

arch=`uname -m`

rm -rf shadowsocks-server

#if [ $arch = "x86_64" ]
#then
#	wget http://cnlangzi.github.io/files/ss/x64/shadowsocks-server
#else
#	wget http://cnlangzi.github.io/files/ss/x32/shadowsocks-server
#fi


if [ $arch = "x86_64" ]
then
	wget -O shadowsocks-server.gz http://dl.chenyufei.info/shadowsocks/1.1.4/shadowsocks-server-linux64-1.1.4.gz
	gunzip -f shadowsocks-server.gz
else
	wget -O shadowsocks-server.gz http://dl.chenyufei.info/shadowsocks/1.1.4/shadowsocks-server-linux32-1.1.4.gz
	gunzip -f shadowsocks-server.gz
fi



\cp -rf shadowsocks-server /usr/local/shadowsocks-server -f
chmod +x /usr/local/shadowsocks-server 

\cp -rf $prj/etc/init.d/shadowsocks-server /etc/init.d/shadowsocks-server
chmod +x /etc/init.d/shadowsocks-server

\cp -rf $prj/etc/init.d/shadowsocks-server.conf /usr/local/shadowsocks-server.conf

chkconfig shadowsocks-server on
service shadowsocks-server restart


service shadowsocks-server stop
\cp -rf shadowsocks-server /usr/local/shadowsocks-server -f
chmod +x /usr/local/shadowsocks-server

chkconfig shadowsocks-server on
service shadowsocks-server start