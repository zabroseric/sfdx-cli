# Anytime you use the commands below, the default user will be automatically injected.
commands=("force:source:retrieve force:source:pull force:source:push")
if [[ " ${commands[*]} " =~ " $1 " ]]; then
  /usr/local/lib/node_modules/sfdx-cli/bin/run $@ -u default-user
else
  /usr/local/lib/node_modules/sfdx-cli/bin/run $@
fi