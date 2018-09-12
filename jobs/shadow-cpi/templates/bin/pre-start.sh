#!/usr/bin/env bash

<%
  require "shellwords"

  def esc(x)
      Shellwords.shellescape(x)
  end
%>


# Restrict access to secrets files
chmod 600 /var/vcap/jobs/shadow-cpi/config/id_rsa


# Accept the remote ECDSA host key
remote_host=<%= esc(p('ssh.remote-host')) %>
if [[ -f ~/.ssh/known_hosts ]]; then
    ssh-keygen -f ~/.ssh/known_hosts -R "$(remote_host)"
fi
ssh-keyscan -t ecdsa "$(remote_host)" 2> /dev/null \
    >> ~/.ssh/known_hosts
