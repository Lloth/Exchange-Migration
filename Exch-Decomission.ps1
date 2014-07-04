import-module activedirectory

#Remove the Mailbox created earlier
Remove-Mailbox -Identity "ExchMigrate"

#Remove the AD user created earlier
Remove-ADUser -Identity "ExchMigrate"

#Stop Exchange Services
Get-Service | where{$_.Name –Like ‘MSExchange*’} | stop-Service –Force

#Set exchange services to disabled
Get-Service | where{$_.Name –Like ‘MSExchange*’} | set-Service –StartupType ‘Disabled’
