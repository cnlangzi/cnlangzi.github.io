#!/bin/bash



# 系统所有进程一共可以打开的文件数量， 每个套接字也占用一个文件描述字
sed -i '/^fs.file-max/ d' /etc/sysctl.conf
echo "fs.file-max = 1491124" >>/etc/sysctl.conf
# 系统同时保持TIME_WAIT套接字的最大数目，http 短链接会产生很多 TIME_WAIT 套接字。
sed -i '/^net.ipv4.tcp_max_tw_buckets/ d' /etc/sysctl.conf
echo "net.ipv4.tcp_max_tw_buckets = 7000" >>/etc/sysctl.conf
# 关闭 tcp 来源跟踪
sed -i '/^net.ipv4.conf.default.accept_source_route/ d' /etc/sysctl.conf
echo "net.ipv4.conf.default.accept_source_route = 0" >>/etc/sysctl.conf

# 缩短套接字处于 TIME_WAIT 的时间， 60s -> 30s
sed -i '/^net.ipv4.tcp_fin_timeout/ d' /etc/sysctl.conf
echo "net.ipv4.tcp_fin_timeout = 30" >>/etc/sysctl.conf
# 启用 TIME_WAIT 复用，使得结束 TIEM_WAIT 状态的套接字的端口可以立刻被其他套接字使用。
sed -i '/^net.ipv4.tcp_tw_reuse/ d' /etc/sysctl.conf
echo "net.ipv4.tcp_tw_reuse = 1" >>/etc/sysctl.conf
sed -i '/^net.ipv4.tcp_tw_recycle/ d' /etc/sysctl.conf
echo "net.ipv4.tcp_tw_recycle = 1" >>/etc/sysctl.conf
# 关闭 tcp timestamp, 和 tw_reuse/tw_recycle 同时使用
# tw_recycle 一般不建议使用，RFC1323里面，TCP_TW_RECYCLE和TCP的timestamp选项（timestamp系统默认开启）同时生效的时候，在NAT场景下会导致服务器无法响应连接，这个也是可以复现的。
sed -i '/^net.ipv4.tcp_timestamps/ d' /etc/sysctl.conf
echo "net.ipv4.tcp_timestamps = 0" >>/etc/sysctl.conf
# 打开内核的 SYN Cookie 功能，可以防止部分 DOS 攻击。
sed -i '/^net.ipv4.tcp_syncookies/ d' /etc/sysctl.conf
echo "net.ipv4.tcp_syncookies = 1" >>/etc/sysctl.conf
# 减小 tcp keepalive 探测次数，可以即时释放长链接
sed -i '/^net.ipv4.tcp_keepalive_probes/ d' /etc/sysctl.conf
echo "net.ipv4.tcp_keepalive_probes = 3" >>/etc/sysctl.conf

# 缩短 tcp keepalive 探测间隔时间，同上
sed -i '/^net.ipv4.tcp_keepalive_intvl/ d' /etc/sysctl.conf
echo "net.ipv4.tcp_keepalive_intvl = 15" >>/etc/sysctl.conf
# 增大内核 backlog 参数，使得系统能够保持更多的尚未完成 TCP 三次握手的套接字。
sed -i '/^net.ipv4.tcp_max_syn_backlog/ d' /etc/sysctl.conf
echo "net.ipv4.tcp_max_syn_backlog = 8388608" >>/etc/sysctl.conf
# 同上
sed -i '/^net.core.netdev_max_backlog/ d' /etc/sysctl.conf
echo "net.core.netdev_max_backlog = 8388608" >>/etc/sysctl.conf
# 同上
sed -i '/^net.core.somaxconn/ d' /etc/sysctl.conf
echo "net.core.somaxconn = 8388608" >>/etc/sysctl.conf
# 默认参数
sed -i '/^net.ipv4.tcp_keepalive_time/ d' /etc/sysctl.conf
echo "net.ipv4.tcp_keepalive_time = 7200" >>/etc/sysctl.conf

# 关闭对更大的滑动窗口(如长肥管道)支持，节省系统计算资源
sed -i '/^net.ipv4.tcp_window_scaling/ d' /etc/sysctl.conf
echo "net.ipv4.tcp_window_scaling = 0" >>/etc/sysctl.conf
# 关闭内核对误码大约拥塞的环境(如wifi/3g)的TCP优化，有线线路不需要 tcp_sack
sed -i '/^net.ipv4.tcp_sack/ d' /etc/sysctl.conf
echo "net.ipv4.tcp_sack = 0" >>/etc/sysctl.conf
# 增大应用程序可用端口范围。
sed -i '/^net.ipv4.ip_local_port_range/ d' /etc/sysctl.conf
echo "net.ipv4.ip_local_port_range = 1024 65000" >>/etc/sysctl.conf
# Increase TCP buffer sizes
sed -i '/^net.core.rmem_default/ d' /etc/sysctl.conf
echo "net.core.rmem_default = 8388608" >>/etc/sysctl.conf
sed -i '/^net.core.rmem_max/ d' /etc/sysctl.conf
echo "net.core.rmem_max = 16777216" >>/etc/sysctl.conf
sed -i '/^net.core.wmem_max/ d' /etc/sysctl.conf
echo "net.core.wmem_max = 16777216" >>/etc/sysctl.conf
sed -i '/^net.ipv4.tcp_rmem/ d' /etc/sysctl.conf
echo "net.ipv4.tcp_rmem = 4096 87380 16777216" >>/etc/sysctl.conf
sed -i '/^net.ipv4.tcp_wmem/ d' /etc/sysctl.conf
echo "net.ipv4.tcp_wmem = 4096 65536 16777216" >>/etc/sysctl.conf
sed -i '/^net.ipv4.tcp_congestion_control/ d' /etc/sysctl.conf
echo "net.ipv4.tcp_congestion_control = cubic" >>/etc/sysctl.conf


sed -i '/^net.ipv4.tcp_syncookies/ d' /etc/sysctl.conf
echo "net.ipv4.tcp_syncookies = 1" >>/etc/sysctl.conf
# 表示开启 SYN Cookies。当出现 SYN 等待队列溢出时，启用 cookies 来处理，可防范少量 SYN 攻击，默认为 0，表示关闭；
sed -i '/^net.ipv4.tcp_tw_reuse/ d' /etc/sysctl.conf
echo "net.ipv4.tcp_tw_reuse = 1" >>/etc/sysctl.conf
# 表示开启重用。允许将 TIME-WAIT sockets 重新用于新的 TCP 连接，默认为 0，表示关闭；
sed -i '/^net.ipv4.tcp_tw_recycle/ d' /etc/sysctl.conf
echo "net.ipv4.tcp_tw_recycle = 1" >>/etc/sysctl.conf
# 表示开启 TCP 连接中 TIME-WAIT sockets 的快速回收，默认为 0，表示关闭；
sed -i '/^net.ipv4.tcp_fin_timeout/ d' /etc/sysctl.conf
echo "net.ipv4.tcp_fin_timeout = 30" >>/etc/sysctl.conf
# 修改系統默认的 TIMEOUT 时间。
sed -i '/^net.ipv4.tcp_keepalive_time/ d' /etc/sysctl.conf
echo "net.ipv4.tcp_keepalive_time = 1200" >>/etc/sysctl.conf
# 表示当 keepalive 起用的时候，TCP 发送 keepalive 消息的频度。缺省是 2 小时，改为 20 分钟。
sed -i '/^net.ipv4.ip_local_port_range/ d' /etc/sysctl.conf
echo "net.ipv4.ip_local_port_range = 10000 65535" >>/etc/sysctl.conf # 表示用于向外连接的端口范围。缺省情况下很小：32768 到 61000，改为 10000 到 65000。（注意：这里不要将最低值设的太低，否则可能会占用掉正常的端口！）
sed -i '/^net.ipv4.tcp_max_syn_backlog/ d' /etc/sysctl.conf
echo "net.ipv4.tcp_max_syn_backlog = 8192" >>/etc/sysctl.conf
# 表示 SYN 队列的长度，默认为 1024，加大队列长度为 8192，可以容纳更多等待连接的网络连接数。
sed -i '/^net.ipv4.tcp_max_tw_buckets/ d' /etc/sysctl.conf
echo "net.ipv4.tcp_max_tw_buckets = 5000" >>/etc/sysctl.conf
# 表示系统同时保持 TIME_WAIT 的最大数量，如果超过这个数字，TIME_WAIT 将立刻被清除并打印警告信息。
# increase TCP max buffer size settable using setsockopt()
sed -i '/^net.core.rmem_max/ d' /etc/sysctl.conf
echo "net.core.rmem_max = 67108864" >>/etc/sysctl.conf
sed -i '/^net.core.wmem_max/ d' /etc/sysctl.conf
echo "net.core.wmem_max = 67108864" >>/etc/sysctl.conf
# increase Linux autotuning TCP buffer limit
sed -i '/^net.ipv4.tcp_rmem/ d' /etc/sysctl.conf
echo "net.ipv4.tcp_rmem = 4096 87380 67108864" >>/etc/sysctl.conf
sed -i '/^net.ipv4.tcp_wmem/ d' /etc/sysctl.conf
echo "net.ipv4.tcp_wmem = 4096 65536 67108864" >>/etc/sysctl.conf
# increase the length of the processor input queue
sed -i '/^net.core.netdev_max_backlog/ d' /etc/sysctl.conf
echo "net.core.netdev_max_backlog = 250000" >>/etc/sysctl.conf
# recommended for hosts with jumbo frames enabled
sed -i '/^net.ipv4.tcp_mtu_probing/ d' /etc/sysctl.conf
echo "net.ipv4.tcp_mtu_probing=1" >>/etc/sysctl.conf




sysctl -p

echo "*	hard	nofile	65535" > /etc/security/limits.conf
echo "*	soft	nofile	65535" >> /etc/security/limits.conf