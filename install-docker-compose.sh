#!/bin/bash
# maintainer : "Bilal Kalem"
# maintainer email : "bkalem@ios.dz"
# Licence " CC BY-NC-SA 4.0 "
#
echo "###############################"
echo "[Task 1] installation curl et wget"
echo "###############################"
sudo yum install curl wget -y

echo "###############################"
echo "[Task 2] Telechargement docker compose"
echo "###############################"
curl -s https://api.github.com/repos/docker/compose/releases/latest | grep browser_download_url | cut -d '"' -f 4 | grep 'docker-compose-Linux-x86_64$' | wget -qi -

echo "###############################"
echo "[Task 3] copy with execution docker-compose"
echo "###############################"
sudo cp docker-compose-Linux-x86_64 /usr/bin/docker-compose
sudo chmod +x /usr/bin/docker-compose

echo "###############################"
echo "[Task 4] version docker-compose"
echo "###############################"
/usr/bin/docker-compose --version