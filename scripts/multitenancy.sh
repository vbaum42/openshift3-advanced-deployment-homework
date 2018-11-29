#!/usr/bin/sh

export GUID=`hostname | cut -d"." -f2`

ansible masters -m shell -a 'htpasswd -b /etc/origin/master/htpasswd amy r3dh4t1!'
ansible masters -m shell -a 'htpasswd -b /etc/origin/master/htpasswd andrew r3dh4t1!'
ansible masters -m shell -a 'htpasswd -b /etc/origin/master/htpasswd brian r3dh4t1!'
ansible masters -m shell -a 'htpasswd -b /etc/origin/master/htpasswd betty r3dh4t1!'
ansible masters -m shell -a 'htpasswd -b /etc/origin/master/htpasswd admin adm1n'


oc adm add-cluster-role-to-user cluster-admin admin
oc adm groups new alpha amy andrew
oc label group alpha client=alpha
oc adm policy add-role-to-group admin alpha -n alpha
oc adm groups new beta brian betty
oc label group beta client=beta
oc adm policy add-role-to-group admin beta -n beta
oc adm groups new common
oc label group common client=common
oc label node node1.$GUID.internal zone=alpha
oc label node node2.$GUID.internal zone=beta

oc patch clusterrolebinding.rbac self-provisioners -p '{"subjects": null}'

oc patch namespace alpha -p '{"metadata":{"annotations":{"openshift.io/node-selector": "zone=alpha"}}}'

oc patch namespace beta -p '{"metadata":{"annotations":{"openshift.io/node-selector": "zone=beta"}}}'

for OCP_USERNAME in amy andrew brian betty; do

oc create clusterquota clusterquota-$OCP_USERNAME \
 --project-annotation-selector=openshift.io/requester=$OCP_USERNAME \
 --hard pods=25 \
 --hard requests.memory=6Gi \
 --hard requests.cpu=5 \
 --hard limits.cpu=25  \
 --hard limits.memory=40Gi \
 --hard configmaps=25 \
 --hard persistentvolumeclaims=25  \
 --hard services=25

done

pwd=`pwd`
export pwd=$pwd/proj-temp.yml
echo "Create template from ${pwd}"
oc create -f $pwd

ansible masters -m shell -a "sed -i 's/projectRequestTemplate.*/projectRequestTemplate\: \"default\/project-request\"/g' /etc/origin/master/master-config.yaml"
ansible masters -m shell -a'systemctl restart atomic-openshift-node'
