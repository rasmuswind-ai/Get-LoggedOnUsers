#powershell docko

#region "Del 1"

#Del 1: Avanceret Remoting
#Eleven skal lave en opstilling af 2 domæner med routing i mellem.
    #Der skal oprettes en klient-maskine der tilmeldes det ene domæne og eleven skal være i stand til at kunne remote mellem dens egen domæne server og den anden domæneserver.

    #Aktiver PSRemote
    Enable-PSRemoting
    winrm quickconfig

    #tilføj TrustedHosts fra det andet domain
    set-Item wsman:\localhost\Client\TrustedHosts -Value *.domain2.local
    set-Item wsman:\localhost\Client\TrustedHosts -Value 10.0.2.* 

    #opret en PSSession til en server fra det andet domain
    Enter-PSSession -ComputerName server2 -Credential domain2\administrator

#Udfordring:

#Kommunikationen skal være SSL-krypteret

    #opretter et certifikat
    $Cert = New-SelfSignedCertificate -CertstoreLocation Cert:\LocalMachine\My -DnsName "server2.domain2.local"

    #Exporterer det opdateret certifikat
    Export-Certificate -Cert $Cert -FilePath C:\temp\cert

    #slet  WSMan http listeners
    Get-ChildItem WSMan:\Localhost\listener | Where-Object -Property Keys -eq "Transport=HTTP" | Remove-Item -Recurse

    #tilføj WSMan https listeners
    New-Item -Path WSMan:\LocalHost\Listener -Transport HTTPS -Address * -CertificateThumbPrint $Cert.Thumbprint –Force

    #add https fierwall rules på port 5986 TCP
    New-NetFirewallRule -DisplayName "Windows Remote Management (HTTPS-In)" -Name "Windows Remote Management (HTTPS-In)" -Profile Any -LocalPort 5986 -Protocol TCP

    #WSMan Enable Compatibility Https Listener
    Set-Item WSMan:\localhost\Service\EnableCompatibilityHttpsListener -Value true

    #Set Network Category
    Set-NetConnectionProfile -NetworkCategory Private

    #Disable http fierwall rule
    Disable-NetFirewallRule -DisplayName "Windows Remote Management (HTTP-In)"

    #On the local computer
    #Import Certificate
    Import-Certificate -Filepath "C:\temp\cert" -CertStoreLocation "Cert:\LocalMachine\Root"

    #opret en PSSession til en server 
    $Server2Session = New-PSSession  -ComputerName server2.domain2.local -UseSSL -Credential domain2\administrator
    Enter-PSSession -Session $Server2Session

#Udfordring 2:

#Opsæt Powershell Web Access
    #Install PowerShell Web Access med et certifikat
    Install-WindowsFeature –Name WindowsPowerShellWebAccess -IncludeManagementTools 

    #installer web access service
    Install-PswaWebApplication -UseTestCertificate

    #tilføjer PowerShell Web Access Authorization Rule
    Add-PswaAuthorizationRule -Rulename 'Admin Connection' -ConfigurationName 'microsoft.powershell' -UserGroupName 'Domain1\Domain Admins' -Computername 'server1.domain1.local'

#endregion

#region "Del 2"

#Del 2: Avanceret CMDLets
#Der skal laves et (eller flere) modul(er) der kan importeres og eksekveres I powershell
#   Eleven skal opnå forståelse for de forskellige dele af et modul
#       Manifest
#       Scriptmodule
#       Functions

#   Modulet skal bestå af mindst 3 forskellige funktioner eller CMDLets
#   Bør bestå af verb-noun semantik
#   Eks.vis Get-Function, Set-Function eller New-Function
#   Bør indeholde hjælpe kommenteringer

#Modulen er blevet lagt op på github; https://github.com/rasmuswind-ai/Get-LoggedOnUsers
#Og ligger under "CombinedFunctions"



    #
#Udfordring:
#Installer en af serverne med en webservice og skab jeres eget repository hvor i kan gemme og hente moduler fra ved hjælp af PowershellGet eller NuGet
    #Repository er lavet som et simpelthen netværks share

#endregion

#region "Del 3"

#Del 3: Profiles, user autonomy og GPO
    #Der skal laves et profilescript for de forskellige brugere af domænet.
    #   Der skal oprettes OU’er for forskellige typer brugere med forskellige profilescripts
            #profilescript for Domain Admin
            
            Set-ExecutionPolicy Unrestricted -Force

            Copy-Item "\\server1\PS SH\CombinedFunctions" -Destination "C:\Program Files\WindowsPowerShell\Modules" -Force -Recurse
            Import-Module CombinedFunctions
            
            Write-Output "Nuværende Bruger"
            ([adsi]"WinNT://$env:userdomain/$env:username,user").fullname
            Write-Output " "

            #profilescript for Back
            
            Set-ExecutionPolicy Unrestricted -Force

            Write-Output "Nuværende Bruger"
            ([adsi]"WinNT://$env:userdomain/$env:username,user").fullname
            Write-Output " "
            
            #profilescript for front

            Write-Output "Nuværende Bruger"
            ([adsi]"WinNT://$env:userdomain/$env:username,user").fullname
            Write-Output " "

#Sørg for at PSRemoting er slået til, med en GPO, som standard på alle maskiner i domænet
    #jeg har lavet en GPO det aktiver PSRemoting via WinRM Service gpo tilfogerj osse firewall reler og activer WinRM Service

#Ekstra opgaver:
#Opsæt en Database og sørg for at der kan foretages udtræk fra denne.
    #https://github.com/rasmuswind-ai/Get-LoggedOnUsers

#endregion