# Harbor : votre private registry
[Harbor](https://goharbor.io/) est sans doute l'un des private registry **open source** offert par [vmware](https://github.com/goharbor/harbor)

## Déployer votre private registry 
Vous allez pouvoir déployer **automatiquement** [Harbor](https://goharbor.io/) avec [vagrant](https://www.youtube.com/watch?v=mRgiFZZG4pk) 
vous n'avez qu'a lancer la commande ```vagrant up```

## Connecter vos container engine
Afin d'héberger vos images il est aussi possible de connecter vos *container engine* tel que : 
- Docker
- Podman
- CRI-O
- ... 
example *connect-to-registry.sh* : 
```bash
HARBOR_FQDN="registry.formini.local"
HARBOR_PORT="443"
HARBOR_USER="admin"
HARBOR_PASSWORD="formini"
docker login $HARBOR_FQDN -u $HARBOR_USER -p $HARBOR_PASSWORD
```