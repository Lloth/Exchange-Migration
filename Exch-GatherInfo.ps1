# Get Accepted Domains 
get-accepteddomain|fl domainname > C:\temp\Exch-AcceptedDomains.txt 

#Get a list of Mailboxes and their sizes
Get-MailboxStatistics | where {$_.ObjectClass -eq "Mailbox"} | Sort-Object DisplayName | ft @{label="User";expression={$_.DisplayName}},@{label="Total Size (MB)";expression={$_.TotalItemSize.Value.ToMB()}},@{label="Items";expression={$_.ItemCount}},@{label="Storage Limit";expression={$_.StorageLimitStatus}} -auto

#Get the mailboxes and aliases and exports them as CSV
Get-Mailbox -ResultSize Unlimited | Select-Object DisplayName,ServerName,PrimarySmtpAddress, @{Name="EmailAddresses";Expression={[string]::join("`",", ($_.EmailAddresses |Where-Object {$_.PrefixString -ceq "smtp"} | ForEach-Object {$_.SmtpAddress}))}} | Sort-object DisplayName | Export-Csv c:\temp\Exch-mailbox_alias.csv

#Format the CSV file, since otherwise the CSV file won't have multiple rows
(Get-Content c:\temp\Exch-mailbox_alias.csv) | Foreach-Object {$_ -replace "`"`",", "`",`""} | Set-Content c:\temp\Exch-mailbox_alias_export.csv

#Get Internal Autodiscover record
Get-ClientAccessServer | fl identity,autodiscoverserviceinternaluri > C:\temp\Exch-autodiscover.txt