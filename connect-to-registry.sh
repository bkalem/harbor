#!/bin/bash
# maintainer : "Bilal Kalem"
# maintainer email : "bkalem@ios.dz"
# Licence " CC BY-NC-SA 4.0 "
#
# adapter votre HARBOR_FQDN / PORT / USER / PASS selon la configuration de votre Harbor
HARBOR_FQDN="registry.formini.local"
HARBOR_PORT="443"
HARBOR_USER="admin"
HARBOR_PASSWORD="formini"
echo "###############################"
echo "[Pre-Task] Your Harbor FQDN / PORT / USER / PASSWORD"
echo "###############################"
echo "votre HARBOR FQDN est : $HARBOR_FQDN"
echo "votre HARBOR PORT est : $HARBOR_PORT"
echo "votre HARBOR USER est : $HARBOR_USER"
echo "votre HARBOR PASS est : $HARBOR_PASSWORD"

echo "###############################"
echo "[Task 1] Creation du dossier de certificat CA"
echo "###############################"
mkdir -p /etc/docker/certs.d/$HARBOR_FQDN

echo "###############################"
echo "[Task 2] Recuperation du certificat CA"
echo "###############################"
openssl s_client -showcerts -connect $HARBOR_FQDN:$HARBOR_PORT < /dev/null | sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p' > /etc/docker/certs.d/$HARBOR_FQDN/ca.crt

echo "###############################"
echo "[Task 3] Trust CRT"
echo "###############################"
cp /etc/docker/certs.d/$HARBOR_FQDN/ca.crt /etc/pki/ca-trust/source/anchors/
update-ca-trust

echo "###############################"
echo "[Task 4] Redemarrage de Docker"
echo "###############################"
systemctl restart docker

echo "###############################"
echo "[Task 5] Connexion au registry"
echo "###############################"
docker login $HARBOR_FQDN -u $HARBOR_USER -p $HARBOR_PASSWORD

echo "###############################"
echo "[Task 6] example de TAG et PUSH"
echo "###############################"
echo "vous pouvez maintenant effectuer des pull / push (depuis / vers la registry) "
echo "docker pull alpine"
echo "docker tag alpine $HARBOR_FQDN/library/alpine"
echo "docker push $HARBOR_FQDN/library/alpine"

echo "###############################"
echo "[End-Task] Your Harbor FQDN / PORT / USER / PASSWORD"
echo "###############################"
echo "Sur votre navigateur taper https://$HARBOR_FQDN"
echo "votre HARBOR USER est : $HARBOR_USER"
echo "votre HARBOR PASS est : $HARBOR_PASSWORD"