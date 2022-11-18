mkdir /tmp/screens
chmod 755 /tmp/screens
 for userno in $(seq 1 6); do screen -dmS tor$userno /bin/ash -c '(echo "DataDirectory /dev/shm/tor"'$userno';echo "ControlPort 2000'$userno'";echo "SOCKSPort 1000'$userno'")|tor -f /dev/stdin';done
linecnt=0
conncnt=0
go-dispatch-proxy -lport 9050 -tunnel $(for m in $(seq 1 6 );do echo 127.0.0.1:1000$m@3;done) 2>&1|while read line; do 
[[ $(($conncnt%11)) = 250 ]] && echo "stats:connnections:"$conncnt"|lines:"$linencnt
echo "$line"|grep -q "unneled to" && conncnt=$(($conncnt+1))
linecnt=$(($linecnt+1))
done
