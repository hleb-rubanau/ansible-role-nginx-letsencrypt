#!/bin/bash

# prerequisites: curl
# usage:
# curl -s https://raw.githubusercontent.com/hleb-rubanau/ansible-role-nginx-letsencrypted/master/bootstrap.sh | /bin/bash

set -e

function say() { echo "[$(date '+%F %H:%M:%S')] $*" >&2 }
function die() { say "ERROR: $*" ; exit 1 ; }
function run() { say "RUN: $*" ; $* ; }

if [ -z "$( which ansible )" ]; then
    if [ -z "$( which pip3 )" ]; then
        if [ -z "$( which apt-get )" ]; then
            echo "Apt-get not found, please install ansible or pip3 manually and rerun"
        fi
        apt-get update && apt-get install python3-pip
    fi
    run pip3 install ansible
fi

if [ -z "$(which git)" ] ; then
        if [ -z "$( which apt-get )" ]; then
            echo "Apt-get not found, please install ansible or pip3 manually and rerun"
        fi
        apt-get update && apt-get install git
fi

say "Configuring local ansible"
curl -s https://gitlab.com/Rubanau/cloud-tools/raw/master/configure_local_ansible.sh | /bin/bash

say "Preparing playbook"
PLAYBOOK_DIR="./ansible-nginx-letsencrypted"
PLAYBOOK_FILE=nginx-playbook.yml
mkdir -v $PLAYBOOK_DIR
cd $PLAYBOOK_DIR

cat > requirements.yml <<REQUIREMENTS
---
- src: https://github.com/hleb-rubanau/ansible-role-docker
  name: docker
- src: https://github.com/hleb-rubanau/ansible-role-nginx-letsencrypted
  name: nginx
REQUIREMENTS

cat > $PLAYBOOK_FILE << PLAYBOOK
---
- hosts: localhost
  vars:
    nginx_le_account:           your_email@example.com
    nginx_le_primary_domain:    yourdomain.com
    # nginx_le_mode: prod
  roles:
    - docker
    - nginx
PLAYBOOK

set -x 
ansible-galaxy install -r requirements.yml --roles-path ./roles
set +x


cat <<USAGE
Minimal ansible playbook created. Next steps:
0. CONFIGURE YOUR DOMAINS!!!!!
1. cd $PLAYBOOK_DIR
2. edit $PLAYBOOK_FILE (fill in vars appropriately)
3. ansible-playbook $PLAYBOOK_FILE
4. Edit /opt/nginx-letsencrypted/data/configs/default.conf
5. ansible-playbook $PLAYBOOK_FILE
6. Wait few minutes and check the domain. It will use test (insecure) certificates

If everything works
7. Edit $PLAYBOOK_FILE changing nginx_le_mode to prod
8. ansible-playbook $PLAYBOOK_FILE
USAGE
