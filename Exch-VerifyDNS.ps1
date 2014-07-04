
$domain = get-AcceptedDomain |% {$_.domainname.domain}
$domain = $domain | ? { $_ -notlike "*.local*"}


if ($host.version.major -ge 4) { #Powershell 4.0 only
	foreach($domain in $domain){

    write-host "--------------- MX ---------------"
	Resolve-DnsName -Name $domain -DnsOnly -Type MX
    Start-Sleep -m 10

    write-host "--------------- Other ---------------"
    Resolve-DnsName -Name  ("mail."+ $domain) -DnsOnly -Type A
    Start-Sleep -m 10

    write-host "--------------- Autodiscover ---------------"
    Resolve-DnsName -Name  ("autodiscover."+ $domain) -DnsOnly -type CNAME
    Resolve-DnsName -Name  ("_autodiscover._tcp"+ $domain) -type SRV
    Start-Sleep -m 10

    write-host "--------------- SPF ---------------"
    Resolve-DnsName -Name  ($domain) -type TXT
    Start-Sleep -m 10

    write-host "--------------- Lync Online ---------------"
    Resolve-DnsName -Name  ("_sip._tls."+ $domain) -type SRV
    Resolve-DnsName -Name  ("_sipfederationtls._tcp."+ $domain) -type SRV
    Resolve-DnsName -Name  ("sip."+ $domain) -DnsOnly -type CNAME
    Start-Sleep -m 10
    Resolve-DnsName -Name  ("lyncdiscover."+ $domain) -DnsOnly -type CNAME
    Resolve-DnsName -Name  ("msoid."+ $domain) -DnsOnly -type CNAME
    Start-Sleep -m 10
	}
} 
elseif ($host.version.major -ge 3) { #Powershell 3.0 only


}
else {
write-host "Does not support powershell"
}

