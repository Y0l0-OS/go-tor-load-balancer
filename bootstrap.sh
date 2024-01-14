mkdir /tmp/screens
chmod 755 /tmp/screens
[[ -z "$TORCOUNT" ]] && TORCOUNT=6
echo $TORCOUNT > /tmp/.TOR_COUNT
echo -n "START:(p"
phrase=$RANDOM"_"$(for rounds in $(seq 1 24);do tr -cd '[:alnum:]_\-.' < /dev/urandom  |head -c48;echo ;done|grep -e "_" -e "\-" -e "\."|grep ^[a-zA-Z0-9]|grep [a-zA-Z0-9]$|tail -n1)
echo "$phrase" > /dev/shm/.ctrlpsw &
echo -n P
echo -n "|INSTANCES="$TORCOUNT
echo " )"
echo "control pass is $phrase"
pswhash=$(tor  --hash-password  "$phrase"|grep -v -e '\[warn\]' -e '\[info\]' -e '\[notice\]' -e "Tor was compiled" -e "You are running Tor as ro") 2>/dev/null
mkdir /tmp/.tordata
 for userno in $(seq 1 $TORCOUNT); do 
    portcont=$((20000+$userno))
    portsock=$((10000+$userno))
    screen -dmS tor$userno /bin/ash -c '(echo "WarnUnsafeSocks 0";echo "WarnPlaintextPorts 1";echo "Log warn-err stderr";echo "DataDirectory /tmp/.tordata/tor"'$userno';echo "ControlPort '$portcont'";echo "SOCKSPort '$portsock'";echo "HashedControlPassword '$pswhash'")|tor -f /dev/stdin';
    done
linecnt=0
conncnt=0
go-dispatch-proxy -lhost 0.0.0.0 -lport 9050 -tunnel $(for m in $(seq 1 $TORCOUNT );do portsrv=$((10000+$m)); echo "127.0.0.1:"$portsrv"@3";done) 2>&1|while read line; do 
    [[ $(($conncnt%11)) = 250 ]] && echo "stats:connnections:"$conncnt"|lines:"$linencnt
    echo "$line"|grep -q "unneled to" && conncnt=$(($conncnt+1))
    linecnt=$(($linecnt+1))
done

