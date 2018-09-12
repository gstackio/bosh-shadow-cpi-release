#!/usr/bin/env bash

<%
  require "shellwords"

  def esc(x)
      Shellwords.shellescape(x)
  end
%>

remote_user=<%= esc(p('ssh.remote-user')) %>
remote_host=<%= esc(p('ssh.remote-host')) %>
remote_cpi_bin=<%= esc(p('remote-cpi-binary')) %>

ssh -v -E /var/vcap/sys/log/shadow-cpi/shadow-cpi-ssh.log \
    -x \
    -i /var/vcap/jobs/shadow-cpi/config/id_rsa \
    "${remote_user}@${remote_host}" \
    "${remote_cpi_bin}" \
    2> /dev/null
exit $?
