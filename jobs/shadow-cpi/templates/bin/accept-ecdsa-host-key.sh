#!/usr/bin/env bash

<%
  require "shellwords"

  def esc(x)
      Shellwords.shellescape(x)
  end
%>

remote_host=<%= esc(p('ssh.remote-host')) %>
if [[ -f ~/.ssh/known_hosts ]]; then
    ssh-keygen -f ~/.ssh/known_hosts -R "${remote_host}"
fi
mkdir -p ~/.ssh
chmod 700 ~/.ssh
ssh-keyscan -t ecdsa "${remote_host}" 2> /dev/null \
    >> ~/.ssh/known_hosts
