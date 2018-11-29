#!/bin/bash

for user in amy andrew brian betty; do 
htpasswd -b /etc/origin/master/htpasswd $user r3dh4t1!;
done

htpasswd -b /etc/origin/master/htpasswd admin adm1n;