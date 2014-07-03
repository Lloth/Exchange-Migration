
#Creates user and prompts for Password
import-module activedirectory
$TempPassword = Read-Host -Prompt "Enter Your Password" -AsSecureString 
NEW-ADUSER "ExchMigrate" –Givenname "Exchange" –Surname "MigrationUser" –AccountPassword $TempPassword
Enable-ADAccount -Identity "ExchMigrate"  #Since it disabled it by default, need to enable mailbox

#Enables Mail
Enable-Mailbox -Identity "ExchMigrate" -Alias 'ExchMigrate'

#Gives user full access to mailbox
Get-Mailbox -ResultSize Unlimited | Add-MailboxPermission -AccessRights FullAccess -User ExchMigrate