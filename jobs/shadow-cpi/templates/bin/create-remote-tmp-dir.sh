#!/usr/bin/env bash

<%
  require "shellwords"

  def esc(x)
      Shellwords.shellescape(x)
  end
%>

set -e

remote_user=<%= esc(p('ssh.remote-user')) %>
remote_host=<%= esc(p('ssh.remote-host')) %>

ssh -x \
    -i /var/vcap/jobs/shadow-cpi/config/id_rsa \
    -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null \
    "${remote_user}@${remote_host}" \
    "sudo mkdir -p /var/vcap/data/shadow-cpi/tmp \
    && sudo chown root:vcap /var/vcap/data/shadow-cpi/tmp \
    && sudo chmod 770 /var/vcap/data/shadow-cpi/tmp"
