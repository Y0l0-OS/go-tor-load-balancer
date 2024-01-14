#!/bin/bash 
for userno in $(seq 1 $(cat /tmp/.TOR_COUNT));do 
   printf 'AUTHENTICATE "'$(cat /dev/shm/.ctrlpsw)'"\r\nSIGNAL NEWNYM\r\n' | nc 127.0.0.1 $((20000+$userno)) |sed 's/^/'$((20000+$userno))':/g';
done
