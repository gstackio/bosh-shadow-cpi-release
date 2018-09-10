BOSH Shadow CPI Release
=======================

This BOSH Release provides a shadow CPI to be deployed by a BOSH Director.

A shadow CPI is the local view of a remote CPI, that actually is located on
another distant host.

A CPI is usually just an executable binary. The shadow CPI uses an SSH
connection to transmit requests to the actual distant CPI and output responses
back to the caller.

This was designed in order to allow BOSH to control a distant `warden_cpi`
that has the requirement to reside on the exact same host as the Garden-runC
backend it is using.
