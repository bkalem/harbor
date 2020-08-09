#!/bin/bash
# maintainer : "Bilal Kalem"
# maintainer email : "bkalem@ios.dz"
# Licence " CC BY-NC-SA 4.0 "
#
echo "###############################"
echo "[Task 1] installation packagage complémentaire"
echo "###############################"
sudo yum install git vim nano wget bash-completion -y

echo "###############################"
echo "[Task 2] resolution DNS local /etc/hosts"
echo "###############################"
cat >> /etc/hosts <<EOF
172.15.20.99  registry registry.formini.local
172.15.20.199  worker worker.formini.local
EOF

echo "###############################"
echo "[Task 3] enable SSH Password Authentication"
echo "###############################"
sudo sed -i 's/^PasswordAuthentication no/PasswordAuthentication yes/' /etc/ssh/sshd_config

echo "###############################"
echo "[Task 4] reload SSHd"
echo "###############################"
sudo systemctl reload sshd

echo "###############################"
echo "[Task 5] Password root = formini"
echo "###############################"
echo "formini" | passwd --stdin root 