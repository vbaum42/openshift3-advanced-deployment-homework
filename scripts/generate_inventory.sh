#!/usr/bin/env bash

echo "Copy a new hosts file to /etc/ansible/hosts"
cp -a /root/openshift3-advanced-deployment-homework/hosts /etc/ansible/hosts

echo "Set the current GUID to generate the inventory"
GUID=`hostname|awk -F. '{print $2}'`
sed -i "s/GUID/$GUID/g" /etc/ansible/hosts
