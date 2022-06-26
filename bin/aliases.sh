# sfdx aliases
alias pull="sfdx force:source:pull -u default-user"
alias push="sfdx force:source:push -u default-user"
alias retrieve="sfdx force:source:retrieve -u default-user"
alias deploy="sfdx force:source:deploy -u default-user"
alias login="sfdx auth:device:login -u default-user"
alias runtest="sfdx force:apex:test:run -u default-user"
alias soql="sfdx force:data:soql:query -u default-user"
alias open="sfdx force:org:open -u default-user -r 2> /dev/null | grep \"Access org\""

# sfdx aliases (short-hand)
alias op="open"

# Other aliases
alias ll="ls -lash"