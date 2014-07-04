# Get Accepted Domains 
get-accepteddomain|fl domainname > C:\temp\Exch-AcceptedDomains.txt 


if ($host.version.major -ge 4) { #Powershell 4.0 only
    #Do a whois of each domain, exclude anything with .local
    $domain = get-AcceptedDomain |% {$_.domainname.domain}
    $domain = $domain | ? { $_ -notlike "*.local*"}

    foreach($domain in $domain){
    $web = New-WebServiceProxy ‘http://www.webservicex.net/whois.asmx?WSDL’  
    $whois= $web.GetWhoIs($domain) 
    $whois.Substring(0,$whois.IndexOf(">>>"))  # Removes extra fluff from whois record
    }
}
else { write-host "New-WebServiceProxy does not support <4 " }

#Get a list of Mailboxes and their sizes
Get-MailboxStatistics | where {$_.ObjectClass -eq "Mailbox"} | Sort-Object DisplayName | ft @{label="User";expression={$_.DisplayName}},@{label="Total Size (MB)";expression={$_.TotalItemSize.Value.ToMB()}},@{label="Items";expression={$_.ItemCount}},@{label="Storage Limit";expression={$_.StorageLimitStatus}} -auto

#Get the mailboxes and aliases and exports them as CSV
Get-Mailbox -ResultSize Unlimited | Select-Object DisplayName,ServerName,PrimarySmtpAddress, @{Name="EmailAddresses";Expression={[string]::join("`",", ($_.EmailAddresses |Where-Object {$_.PrefixString -ceq "smtp"} | ForEach-Object {$_.SmtpAddress}))}} | Sort-object DisplayName | Export-Csv c:\temp\Exch-mailbox_alias.csv

#Format the CSV file, since otherwise the CSV file won't have multiple rows
(Get-Content c:\temp\Exch-mailbox_alias.csv) | Foreach-Object {$_ -replace "`"`",", "`",`""} | Set-Content c:\temp\Exch-mailbox_alias_export.csv

#Get Internal Autodiscover record
Get-ClientAccessServer | fl identity,autodiscoverserviceinternaluri > C:\temp\Exch-autodiscover.txt