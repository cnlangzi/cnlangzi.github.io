#!/bin/bash

arch=`uname -m`

rm -rf shadowsocks-server

if [ $arch = "x86_64" ]
then
	wget http://cnlangzi.github.io/files/ss/x64/shadowsocks-server
else
	wget http://cnlangzi.github.io/files/ss/x32/shadowsocks-server
fi


service shadowsocks-server stop
\cp -rf shadowsocks-server /usr/local/shadowsocks-server -f
chmod +x /usr/local/shadowsocks-server

chkconfig shadowsocks-server on
service shadowsocks-server start