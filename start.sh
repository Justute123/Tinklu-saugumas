#!/bin/sh

VM_NAME="mikrotikRouter"
VM_USER="NAME"
VM_PASSWORD="{{MYPASSW}}"
privateIP="10.0.1.11"

sudo mkdir /etc/ansible
sudo touch /etc/ansible/hosts
ANSIBLE_HOSTS=/etc/ansible/hosts

sudo apt-get update
sudo apt-get install sshpass
sudo apt-get install ansible

echo "removing ip from known_hosts"
ssh-keygen -f "$HOME/.ssh/known_hosts" -R "$privateIP"
echo "adding ip to known_hosts again"
ssh-keyscan -H $privateIP >> ~/.ssh/known_hosts
sshpass -p $VM_PASSWORD ssh-keygen
echo "copying ssh key to other virtual machine"
ssh-copy-id -i ~/.ssh/id_rsa.pub -f $VM_USER@$privateIP
echo "fill hosts file"
echo "[$VM_NAME]" >> $ANSIBLE_HOSTS
echo $privateIP >> $ANSIBLE_HOSTS

ansible-playbook ../ansible/mikrotik.yml


