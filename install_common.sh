#!/bin/bash

#installation common for kubernetes

HOSTNAME=$(hostname)
IP=$(hostname -I | awk '{print $2}')
echo "START - install common - "$IP

echo "[1]: add host name for ip"
HOST_EXIST=$(cat /etc/hosts | grep -i "$IP" | wc -l)
if [ "$HOST_EXIST" == "0" ]; then
echo "$IP $HOSTNAME " >> /etc/hosts
fi

echo "[2]: Disabling swap for kubernetes"
# swapoff -a to disable swapping
swapoff -a 
# sed to comment the swap partition in /etc/fstab
sed -i.bak -r 's/(.+ swap .+)/#\1/' /etc/fstab

echo "[3]: Installation utils"
apt-get update -qq >/dev/null
apt-get install -qq -y apt-transport-https curl ca-certificates gnupg >/dev/null

echo "[4]: Install docker if not exist"
if [ ! -f "/usr/bin/docker" ];then
curl -s -fsSL https://get.docker.com | sh;
usermod -aG docker vagrant
newgrp docker

fi
echo "[5]: Solving docker old containerd provided by Ubuntu 20 problem "
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg
chmod a+r /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch="$(dpkg --print-architecture)" signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  "$(. /etc/os-release && echo "$VERSION_CODENAME")" stable" | \
tee /etc/apt/sources.list.d/docker.list > /dev/null 
apt remove containerd
apt-get update -qq >/dev/null

echo "[6]: add kubernetes repository to source.list"
if [ ! -f "/etc/apt/sources.list.d/kubernetes.list" ];then
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add -
echo "deb http://apt.kubernetes.io/ kubernetes-xenial main" >/etc/apt/sources.list.d/kubernetes.list
apt-get update -qq >/dev/null
rm /etc/containerd/config.toml
systemctl restart containerd
fi


echo "[6]: install kubelet / kubeadm / kubectl / kubernetes-cni"
apt-get install -y -qq kubelet kubeadm kubectl kubernetes-cni >/dev/null

echo "END - install common - " $IP
  