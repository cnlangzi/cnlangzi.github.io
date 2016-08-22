#!/bin/bash

# shadowsocks server
#
# chkconfig: 2345 80 30
# description: shadowsocks server
# processname: shadowsocks-server


# Source function library.
. /etc/init.d/functions

# Source networking configuration.
. /etc/sysconfig/network

APP_PATH=/usr/local
EXEC=shadowsocks-server
DAEMON=$APP_PATH/$EXEC
OPTIONS="-c=/usr/local/shadowsocks-server.conf"
LOGFILE=$APP_PATH/shadowsocks-server.log

if [ -f /etc/sysconfig/shadowsocks-server ];then
        . /etc/sysconfig/shadowsocks-server
fi

prog='shadowsocks-server'

start() {
        # Check that networking is up.
        [ "$NETWORKING" = "no" ] && exit 1
        
        echo -n $"Starting $prog: "
        daemon --check $EXEC $DAEMON $OPTIONS >> $LOGFILE &
        RETVAL=$?
        echo
        [ $RETVAL -eq 0 ] && touch /var/lock/subsys/$EXEC
        return $RETVAL
}
        
stop() {
        echo -n $"Shutting down $prog: "
        killproc $EXEC
        RETVAL=$?
        echo
        [ $RETVAL -eq 0 ] && rm -f /var/lock/subsys/$EXEC
        return $RETVAL
}

# See how we were called.
case "$1" in
  start)
        start
        ;;
  stop)
        stop
        ;;
  status)
        status $EXEC
        RETVAL=$?
        ;;
  restart)
        stop
        start
        RETVAL=$?
        ;;
  reload)
		killall -HUP $EXEC
		;;
  *)
        echo $"Usage: $0 {start|stop|restart|status|reload}"
        RETVAL=3
esac


exit $RETVAL
