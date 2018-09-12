#!/usr/bin/env bash

<%
  require "shellwords"

  def esc(x)
      Shellwords.shellescape(x)
  end
%>

set -x

remote_user=jumpbox
remote_host=192.168.50.7
remote_cpi_bin=/var/vcap/jobs/warden_cpi/bin/cpi

request=$(cat <&0)

echo -e "\n$(date +%F_%T): REQ '$request'" \
    >> /var/vcap/sys/log/shadow-cpi/cpi.log

echo -e "\n$(date +%F_%T)\n" \
    >> /var/vcap/sys/log/shadow-cpi/shadow-cpi-ssh.log

response=$(ssh -v -E /var/vcap/sys/log/shadow-cpi/shadow-cpi-ssh.log \
    -x \
    -i /var/vcap/jobs/shadow-cpi/config/id_rsa \
    "${remote_user}@${remote_host}" \
    "${remote_cpi_bin}" \
    <<< "$request" \
    2>> /var/vcap/sys/log/shadow-cpi/cpi.log \
)
status=$?

echo -e "\n$(date +%F_%T): RESP '$response' status=$status\n" \
    >> /var/vcap/sys/log/shadow-cpi/cpi.log

echo -n "$response"

exit $status
