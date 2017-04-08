#!/bin/sh
time=0 
while true 
do  
	sleep 20
        let time=$time+20
        if [ "$time" -eq 1800 ];then
	      service shadowsocks-server restart &
              logger -i "stopped" -t "ss_server restart after 60 minutes "
              let time=0
	      continue
	fi 
   
        ss_count=$(pgrep -f "shadowsocks-server" | grep -v grep | wc -l)  
	if [ "\ss_count" -eq "0" ];then  
            logger -i "stopped" -t "ss_server"   
	    service shadowsocks-server restart &
            continue  
            #echo "has restarted"  
        fi 
       #ret=`service shadowsocks-server status | grep "dead but subsys locked" | wc -l` 
       ret=`service shadowsocks-server status | grep "subsys" | wc -l` 
       #echo $ret 
       if [ "$ret" == "1" ];then 
            logger -i "stopped" -t "ss_server has dead locked" 
            service shadowsocks-server restart &
       fi   
done    