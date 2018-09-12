#!/usr/bin/env bash

# Restrict access to secrets files
chmod 600 /var/vcap/jobs/shadow-cpi/config/id_rsa

# Accept the remote ECDSA host key
sudo -i -u vcap /var/vcap/jobs/shadow-cpi/bin/accept-ecdsa-host-key.sh
