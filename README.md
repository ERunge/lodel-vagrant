# Description

Ce dépôt a pour but de faciliter l'accès à l'installation du CMS [Lodel](https://github.com/OpenEdition/lodel), outil de publication de revues et ouvrages électroniques utilisé pour propulser [OpenEdition Journals](https://journals.openedition.org/).

Cette solution permet d'avoir en quelques minutes une installation minimale et fonctionnelle de Lodel, tout en détaillant toutes les étapes de l'installation sur un serveur Debian.

**Attention: ne pas utiliser cette solution en production. Ce dépôt a uniquement pour but le démarrage rapide d'un nouveau projet Lodel en développement, et de pallier les différents problèmes rencontrés lors de l'installation.**



## Installation

```
git clone https://github.com/roundge/lodel-vagrant.git
cd lodel-vagrant
vagrant up
```
ou
``vagrant up --provision ``
pour forcer l'utilisation du script d'installation

Lodel est accessible à l'adresse http://10.0.0.200
et l'installation se termine dans le navigateur à l'adresse: http://10.0.0.200/lodeladmin/install.php


## Détails

La machine est basée sur la box Vagrant *generic/debian9*

Une fois la box téléchargée et installée, le script d'installation `shell_provisioner/install.sh` s’exécute.

Lodel est installé dans le dossier `/var/www/lodel` sur la machine virtuelle,
et dans le dossier `lodel` sur la machine hôte.

lodel-vagrant utilise
- php7.0
- composer
- apache2
- mariadb
- git

Pour une mise en production, vous devez
- vous passez de la machine virtuelle, reproduire les étapes de l'installation.
- former votre propre fichier de configuration
- bien supprimer le script d'installation (lodeladmin/install.php)
- supprimer la clé (ici: 03dde1bd-c6b6-4424-8618-c4488e30484a)
- bien sûr utiliser des mots de passe forts



## Debug
Pour un débogage confortable, passé à 1 la variable `$cfg['debugMode']` du fichier de configuration lodelconfig.php

Dans la console, on peut surveiller les logs d'apache de cette manière:
```
vagrant ssh -c "sudo tail -f /var/log/apache2/lodel_error.log"
vagrant ssh -c "sudo tail -f /var/log/apache2/lodel_access.log"
```


## Réinstallation
Pour recommencer le processus d'installation, arrêtez d'abord vagrant (`vagrant halt`) puis détruisez la machine (`vagrant destroy`).
Assurez vous d'avoir supprimé tous les fichiers et dossiers présents dans le répertoire /lodel (attention aux fichiers et dossiers cachés présents) avant de relancer `vagrant up --provision`
