mkdir /tmp/screens
chmod 755 /tmp/screens
phrase=$RANDOM"_asd_"$RANDOM"_wsx_"$RANDOM
pswhash=$(tor  --hash-password  "$phrase"|grep -v "You are running Tor as ro")
echo "control pass is $phrase"
echo "$phrase" > /dev/shm/.ctrlpsw
[[ -z "$TORCOUNT" ]] && TORCOUNT=6
echo $TORCOUNT > /tmp/.TOR_COUNT
mkdir /tmp/.tordata
 for userno in $(seq 1 $TORCOUNT); do screen -dmS tor$userno /bin/ash -c '(echo "DataDirectory /tmp/.tordata/tor"'$userno';echo "ControlPort 2000'$userno'";echo "SOCKSPort 1000'$userno'";echo "HashedControlPassword '$pswhash'")|tor -f /dev/stdin';done
linecnt=0
conncnt=0
go-dispatch-proxy -lhost 0.0.0.0 -lport 9050 -tunnel $(for m in $(seq 1 $TORCOUNT );do echo 127.0.0.1:1000$m@3;done) 2>&1|while read line; do 
[[ $(($conncnt%11)) = 250 ]] && echo "stats:connnections:"$conncnt"|lines:"$linencnt
echo "$line"|grep -q "unneled to" && conncnt=$(($conncnt+1))
linecnt=$(($linecnt+1))
done
