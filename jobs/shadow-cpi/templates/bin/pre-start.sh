#!/usr/bin/env bash

set -e

# Restrict access to files containing secrets
chown vcap /var/vcap/jobs/shadow-cpi/config/id_rsa
chmod 400 /var/vcap/jobs/shadow-cpi/config/id_rsa

chmod 700 /var/vcap/jobs/shadow-cpi/bin/create-remote-tmp-dir.sh


# Accept the remote ECDSA host key
sudo -i -u vcap /var/vcap/jobs/shadow-cpi/bin/accept-ecdsa-host-key.sh


# Create tmp directory for stemcells
/var/vcap/jobs/shadow-cpi/bin/create-remote-tmp-dir.sh
