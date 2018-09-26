#!/usr/bin/env bash

<%
  require "shellwords"

  def esc(x)
      Shellwords.shellescape(x)
  end
%>

set -x

remote_user=<%= esc(p('ssh.remote-user')) %>
remote_host=<%= esc(p('ssh.remote-host')) %>
remote_cpi_bin=<%= esc(p('remote-cpi-binary')) %>

request=$(cat <&0)

echo -e "\n$(date +%F_%T): REQ '$request'" \
    >> /var/vcap/sys/log/shadow-cpi/cpi.log

echo -e "\n$(date +%F_%T)\n" \
    >> /var/vcap/sys/log/shadow-cpi/shadow-cpi-ssh.log

if [[ $request == '{"method":"create_stemcell",'* ]]; then
    # Copy the stemcell image file to the remote host
    stemcell_path=$(sed -e 's/^.*,"arguments":\["\([^"]*\)",.*$/\1/' <<< "$request")
    target_path=$(sed -e 's|/var/vcap/data/director/tmp/\(stemcell[^/]*\)/image|/var/vcap/data/shadow-cpi/tmp/\1-image|' <<< "$stemcell_path")
    scp -q -i /var/vcap/jobs/shadow-cpi/config/id_rsa \
        "${stemcell_path}" \
        "${remote_user}@${remote_host}:${target_path}"

    # Translate stemcell path in request and log the resulting translated
    # request
    request=$(sed -e "s|${stemcell_path}|${target_path}|" <<< "${request}")
    echo -e "\n$(date +%F_%T): TR-REQ '$request'" \
        >> /var/vcap/sys/log/shadow-cpi/cpi.log
fi

response=$(ssh -v -E /var/vcap/sys/log/shadow-cpi/shadow-cpi-ssh.log \
    -x \
    -i /var/vcap/jobs/shadow-cpi/config/id_rsa \
    "${remote_user}@${remote_host}" \
    "${remote_cpi_bin}" \
    <<< "$request" \
    2>> /var/vcap/sys/log/shadow-cpi/cpi.log \
)
status=$?

if [[ -n $target_path ]]; then
    # Remove the temporary stemcell image file
    ssh -x \
        -i /var/vcap/jobs/shadow-cpi/config/id_rsa \
        "${remote_user}@${remote_host}" \
        rm -f "$target_path" \
        2> /dev/null
fi

echo -e "\n$(date +%F_%T): RESP '$response' status=$status\n" \
    >> /var/vcap/sys/log/shadow-cpi/cpi.log

echo -n "$response"

exit $status
