#!/bin/bash
# maintainer : "Bilal Kalem"
# maintainer email : "bkalem@ios.dz"
# Licence " CC BY-NC-SA 4.0 "
#
# adapter votre HARBOR_FQDN au hostname que vous souhaiter utiliser dans votre machine
HARBOR_FQDN="registry.formini.local"
HARBOR_USER="admin"
HARBOR_PASSWORD="formini"

echo "###############################"
echo "[Pre-Task] Your Harbor FQDN"
echo "###############################"
echo "votre HARBOR FQDN est : $HARBOR_FQDN"

echo "###############################"
echo "[Task 1] installation curl et wget"
echo "###############################"
sudo yum install curl wget -y

echo "###############################"
echo "[Task 2] Telechargement harbor-offline-installer"
echo "###############################"
echo "heure de début du Telechargement de harbor-offline-installer : $(date +%R)"
echo "Telechargement en cours de harbor-offline-installer 508Mb"
echo "Veuillez patienter quelques minutes (20minutes et ++) ..."
curl -s https://api.github.com/repos/goharbor/harbor/releases/latest | grep browser_download_url | cut -d '"' -f 4 | grep '\.tgz$' | wget -qi -
echo "heure de fin du Telechargement de harbor-offline-installer : $(date +%R)"

echo "###############################"
echo "[Task 3] decompression harbor-offline-installer"
echo "###############################"
cp harbor-offline-installer*.tgz /tmp/
tar xzvf /tmp/harbor-offline-installer*.tgz -C /tmp
rm -rf /tmp/harbor-offline-installer*.tgz

echo "###############################"
echo "[Task 4] Generation d'un CA"
echo "###############################"
openssl genrsa -out /etc/pki/CA/private/ca.key 4096
openssl req -x509 -new -nodes -sha512 -days 3650 -subj "/C=DZ/ST=Algiers/L=ALGER/O=Formini/OU=BilalKalemCA/CN=$HARBOR_FQDN" -key /etc/pki/CA/private/ca.key -out /etc/pki/CA/certs/ca.crt

echo "###############################"
echo "[Task 5] Generation certificat Request"
echo "###############################"
openssl genrsa -out /etc/pki/tls/private/$HARBOR_FQDN.key 4096
openssl req -sha512 -new -subj "/C=DZ/ST=Algiers/L=ALGER/O=Formini/CN=$HARBOR_FQDN" -key /etc/pki/tls/private/$HARBOR_FQDN.key -out /etc/pki/tls/$HARBOR_FQDN.csr

cat > /etc/pki/tls/v3.ext <<-EOF
authorityKeyIdentifier=keyid,issuer
basicConstraints=CA:FALSE
keyUsage = digitalSignature, nonRepudiation, keyEncipherment, dataEncipherment
extendedKeyUsage = serverAuth
subjectAltName = @alt_names

[alt_names]
DNS.1=$HARBOR_FQDN
EOF

echo "###############################"
echo "[Task 6] Generation certificat self-signed"
echo "###############################"
openssl x509 -req -sha512 -days 3650 -extfile /etc/pki/tls/v3.ext -CA /etc/pki/CA/certs/ca.crt -CAkey /etc/pki/CA/private/ca.key -CAcreateserial -in /etc/pki/tls/$HARBOR_FQDN.csr -out /etc/pki/tls/certs/$HARBOR_FQDN.crt

echo "###############################"
echo "[Task 7] Trust CA & CRT"
echo "###############################"
cp /etc/pki/CA/certs/ca.crt /etc/pki/ca-trust/source/anchors/
cp /etc/pki/tls/certs/$HARBOR_FQDN.crt /etc/pki/ca-trust/source/anchors/
update-ca-trust

echo "###############################"
echo "[Task 8] Preparing Docker Harbor Host to accepte Certificats"
echo "###############################"
# convert to cert 
openssl x509 -inform PEM -in /etc/pki/tls/certs/$HARBOR_FQDN.crt -out /etc/pki/tls/certs/$HARBOR_FQDN.cert

# copy cert to docker harbor host
mkdir -p /etc/docker/certs.d/$HARBOR_FQDN/
cp /etc/pki/tls/certs/$HARBOR_FQDN.cert /etc/docker/certs.d/$HARBOR_FQDN/
cp /etc/pki/tls/private/$HARBOR_FQDN.key /etc/docker/certs.d/$HARBOR_FQDN/
cp /etc/pki/CA/certs/ca.crt /etc/docker/certs.d/$HARBOR_FQDN/
systemctl restart docker

echo "###############################"
echo "[Task 9] Configuration du Hostname + Certificat"
echo "###############################"
cp /tmp/harbor/harbor.yml.tmpl /tmp/harbor/harbor.yml
sed -i "/^hostname:/ s/reg.mydomain.com$/ $HARBOR_FQDN/" /tmp/harbor/harbor.yml
sed -i "/certificate:/ s/\/your\/certificate\/path/ \/etc\/pki\/tls\/certs\/$HARBOR_FQDN.crt/" /tmp/harbor/harbor.yml
sed -i "/private_key:/ s/\/your\/private\/key\/path/ \/etc\/pki\/tls\/private\/$HARBOR_FQDN.key/" /tmp/harbor/harbor.yml
sed -i "/^harbor_admin_password:/ s/Harbor12345$/ $HARBOR_PASSWORD/" /tmp/harbor/harbor.yml

echo "###############################"
echo "[Task 10] installation de Harbor"
echo "###############################"
bash /tmp/harbor/install.sh --with-notary --with-clair --with-chartmuseum

echo "###############################"
echo "[End-Task] Your Harbor FQDN / PORT / USER / PASSWORD"
echo "###############################"
echo "installation réussie de Harbor"
echo "Sur votre navigateur taper https://$HARBOR_FQDN"
echo "votre HARBOR USER est : $HARBOR_USER"
echo "votre HARBOR PASS est : $HARBOR_PASSWORD"