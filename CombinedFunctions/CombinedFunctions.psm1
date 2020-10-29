#Module
#Collects all currently logged on users.



# ██████╗ ███████╗████████╗   ██╗      ██████╗  ██████╗  ██████╗ ███████╗██████╗  ██████╗ ███╗   ██╗██╗   ██╗███████╗███████╗██████╗ ███████╗
#██╔════╝ ██╔════╝╚══██╔══╝   ██║     ██╔═══██╗██╔════╝ ██╔════╝ ██╔════╝██╔══██╗██╔═══██╗████╗  ██║██║   ██║██╔════╝██╔════╝██╔══██╗██╔════╝
#██║  ███╗█████╗     ██║█████╗██║     ██║   ██║██║  ███╗██║  ███╗█████╗  ██║  ██║██║   ██║██╔██╗ ██║██║   ██║███████╗█████╗  ██████╔╝███████╗
#██║   ██║██╔══╝     ██║╚════╝██║     ██║   ██║██║   ██║██║   ██║██╔══╝  ██║  ██║██║   ██║██║╚██╗██║██║   ██║╚════██║██╔══╝  ██╔══██╗╚════██║
#╚██████╔╝███████╗   ██║      ███████╗╚██████╔╝╚██████╔╝╚██████╔╝███████╗██████╔╝╚██████╔╝██║ ╚████║╚██████╔╝███████║███████╗██║  ██║███████║
# ╚═════╝ ╚══════╝   ╚═╝      ╚══════╝ ╚═════╝  ╚═════╝  ╚═════╝ ╚══════╝╚═════╝  ╚═════╝ ╚═╝  ╚═══╝ ╚═════╝ ╚══════╝╚══════╝╚═╝  ╚═╝╚══════╝
                                                                                                                                            
#region "Get-LoggedOnUsers"
    <#
    .SYNOPSIS
        Lists the currently logged on users and the time of their session.
    .DESCRIPTION
        This CMDLet lists all currently logged on users, their fullname, UserType and their Username.
        It will also list the session time, therefore showing how long their session has been running for.
    .EXAMPLE
         Get-LoggedOnUsers

        See if specific user is logged in (Use wildcard (*) If the whole name is not known.)
        Get-LoggedonUsers | ?{$_.FullName -like "Rasmus*"}
    .EXAMPLE
        N/A
    .INPUTS
        N/A
    .OUTPUTS
        Output of the CMDLet: Get-LoggedOnUsers | ?{$_.FullName -like "Rasmus*"} (This will include all the users that has a fullname that starts with "Rasmus")

        Caption  FullName    LastLogon
        -------  --------    ---------
        rasm757j Rasmus Wind 28-10-2020 13:53:59
    .NOTES
        This is a get CMDLet, therefore no system changes are being made while running
    .COMPONENT
        N/A
    .ROLE
        N/A
    .FUNCTIONALITY
        This CMDLet runs different lines of code to list the currently logged on users, and their session time start date.
    #>
    function Get-LoggedOnUsers {


        #Gets the CimInstance that shows logged on users
        #? {$_.LastLogon -ne $null} = Excludes the users that has a null value in "LastLogon" (This is usually the user: NT AUTHORITY\System)
        #Selects the values: Caption, FullName, UserType and the date when the password expires
        $CimInstance_LoggedOnUsers = Get-CimInstance -ClassName Win32_networkloginprofile | ? {$_.LastLogon -ne $null} | Select-Object -Property "Caption", "FullName", "UserType","PasswordExpires"

  

        #For each entry (Item) in $CimInstance_LoggedOnUsers - Create new object and insert the following values for each item, in that object
        $LoggedOnUsers = @()

        foreach ($item in $CimInstance_LoggedOnUsers)
                         {
        
                                        
                             $CustomObject = New-Object PSCustomObject
                             $CustomObject | Add-Member -Type NoteProperty -Name Caption -Value $Item.Caption
                             $CustomObject | Add-Member -Type NoteProperty -Name FullName -Value $Item.FullName
                             $CustomObject | Add-Member -Type NoteProperty -Name UserType -Value $Item.UserType
                             $CustomObject | Add-Member -Type NoteProperty -Name PasswordExpires -Value $item.PasswordExpires
                            
                             #Adds the $CustomObject values to the $LoggedOnUsers variable
                             $LoggedOnUsers += $CustomObject
                             Clear-Variable -Name CustomObject
                        } 
    $LoggedOnUsers
}

#endregion


# ██████╗ ███████╗████████╗   ███╗   ██╗██╗   ██╗███╗   ███╗██████╗ ███████╗██████╗  ██████╗ ███████╗██╗      ██████╗  ██████╗  ██████╗ ███╗   ██╗███████╗
#██╔════╝ ██╔════╝╚══██╔══╝   ████╗  ██║██║   ██║████╗ ████║██╔══██╗██╔════╝██╔══██╗██╔═══██╗██╔════╝██║     ██╔═══██╗██╔════╝ ██╔═══██╗████╗  ██║██╔════╝
#██║  ███╗█████╗     ██║█████╗██╔██╗ ██║██║   ██║██╔████╔██║██████╔╝█████╗  ██████╔╝██║   ██║█████╗  ██║     ██║   ██║██║  ███╗██║   ██║██╔██╗ ██║███████╗
#██║   ██║██╔══╝     ██║╚════╝██║╚██╗██║██║   ██║██║╚██╔╝██║██╔══██╗██╔══╝  ██╔══██╗██║   ██║██╔══╝  ██║     ██║   ██║██║   ██║██║   ██║██║╚██╗██║╚════██║
#╚██████╔╝███████╗   ██║      ██║ ╚████║╚██████╔╝██║ ╚═╝ ██║██████╔╝███████╗██║  ██║╚██████╔╝██║     ███████╗╚██████╔╝╚██████╔╝╚██████╔╝██║ ╚████║███████║
# ╚═════╝ ╚══════╝   ╚═╝      ╚═╝  ╚═══╝ ╚═════╝ ╚═╝     ╚═╝╚═════╝ ╚══════╝╚═╝  ╚═╝ ╚═════╝ ╚═╝     ╚══════╝ ╚═════╝  ╚═════╝  ╚═════╝ ╚═╝  ╚═══╝╚══════╝
                                                                                                                                                         
#region "Get-NumberOfLogons"
<#
    .SYNOPSIS
        Lists the currently logged on users and the Number of Logons for each user.
    .DESCRIPTION
        This CMDLet lists all currently logged on users, their fullname and their Username.
        It will also list the number of logons.
    .EXAMPLE
         Get-NumberOfLogons

        See if specific user is logged in (Use wildcard (*) If the whole name is not known.)
        Get-LoggedonUsers | ?{$_.FullName -like "Rasmus*"}
    .EXAMPLE
        N/A
    .INPUTS
        N/A
    .OUTPUTS
        Output of the CMDLet: Get-NumberOfLogons | ?{$_.FullName -like "Rasmus*"} (This will include all the users that has a fullname that starts with "Rasmus")

        FullName    Caption  NumberOfLogons
        --------    -------  --------------
        Rasmus Wind rasm757j            270
    .NOTES
        This is a 'Get' CMDLet, therefore no system changes are being made while running
    .COMPONENT
        N/A
    .ROLE
        N/A
    .FUNCTIONALITY
        This CMDLet runs different lines of code to list the currently logged on users, and their number of logons.
    #>
    function Get-NumberOfLogons {

            #Gets the CimInstance that shows logged on users
            #? {$_.LastLogon -ne $null} = Excludes the users that has a null value in "LastLogon" (This is usually the user: NT AUTHORITY\System)
            #Selects the values: "Caption, FullName and NumberOfLogons    
            #$CimInstance_LoggedOnUsers = Get-CimInstance -ClassName Win32_networkloginprofile | ? {$_.LastLogon -ne $null} | Select-Object -Property "Caption", "FullName", "NumberOfLogons"
            $CimInstance_LoggedOnUsers = Get-CimInstance -ClassName Win32_networkloginprofile | ? {$_.LastLogon -ne $null} | Select-Object -Property "Caption", "FullName", "NumberOfLogons" 
    
            #For each Entry in the list, create a new object and make the new object with the added Number of Logons.
            $NumberOfLogons = @()

            foreach ($item in $CimInstance_LoggedOnUsers)
                             {
            
                                            
                                 $CustomObject = New-Object PSCustomObject
                                 $CustomObject | Add-Member -Type NoteProperty -Name Caption -Value $Item.Caption
                                 $CustomObject | Add-Member -Type NoteProperty -Name FullName -Value $Item.FullName
                                 $CustomObject | Add-Member -Type NoteProperty -Name UserType -Value $Item.UserType
                                 $CustomObject | Add-Member -Type NoteProperty -Name NumberOfLogons -Value $Item.NumberOfLogons
                                
                                 #Adds the $CustomObject values to the $NumberOfLogons variable
                                 $NumberOfLogons += $CustomObject
                                 Clear-Variable -Name CustomObject
                            } 
       $NumberOfLogons
}

#endregion



# ██████╗ ███████╗████████╗   ██╗      █████╗ ███████╗████████╗██╗      ██████╗  ██████╗  ██████╗ ███╗   ██╗██████╗  █████╗ ████████╗███████╗
#██╔════╝ ██╔════╝╚══██╔══╝   ██║     ██╔══██╗██╔════╝╚══██╔══╝██║     ██╔═══██╗██╔════╝ ██╔═══██╗████╗  ██║██╔══██╗██╔══██╗╚══██╔══╝██╔════╝
#██║  ███╗█████╗     ██║█████╗██║     ███████║███████╗   ██║   ██║     ██║   ██║██║  ███╗██║   ██║██╔██╗ ██║██║  ██║███████║   ██║   █████╗  
#██║   ██║██╔══╝     ██║╚════╝██║     ██╔══██║╚════██║   ██║   ██║     ██║   ██║██║   ██║██║   ██║██║╚██╗██║██║  ██║██╔══██║   ██║   ██╔══╝  
#╚██████╔╝███████╗   ██║      ███████╗██║  ██║███████║   ██║   ███████╗╚██████╔╝╚██████╔╝╚██████╔╝██║ ╚████║██████╔╝██║  ██║   ██║   ███████╗
# ╚═════╝ ╚══════╝   ╚═╝      ╚══════╝╚═╝  ╚═╝╚══════╝   ╚═╝   ╚══════╝ ╚═════╝  ╚═════╝  ╚═════╝ ╚═╝  ╚═══╝╚═════╝ ╚═╝  ╚═╝   ╚═╝   ╚══════╝
                                                                                                                                            
#region "Get-LastLogonDate"
    <#
    .SYNOPSIS
        Lists the currently logged on users and the date that their password will expire.
    .DESCRIPTION
        This CMDLet lists all currently logged on users, their fullname and their Username.
        It will also list their password expire date.
    .EXAMPLE
         Get-LastLogon

        See if specific user is logged in (Use wildcard (*) If the whole name is not known.)
        Get-LastLogon | ?{$_.FullName -like "Rasmus*"}
    .EXAMPLE
        N/A
    .INPUTS
        N/A
    .OUTPUTS
        Output of the CMDLet: Get-LastLogon | ?{$_.FullName -like "Rasmus*"} (This will include all the users that has a fullname that starts with "Rasmus")

        FullName    Caption  LastLogon
        --------    -------  ---------
        Rasmus Wind rasm757j 27-10-2020 12:28:20
    .NOTES
        This is a get CMDLet, therefore no system changes are being made while running
    .COMPONENT
        N/A
    .ROLE
        N/A
    .FUNCTIONALITY
        This CMDLet runs different lines of code to list the currently logged on users, and their last logon date.
    #>
    function Get-LastLogonDate {

            #Gets the CimInstance that shows logged on users
            #? {$_.LastLogon -ne $null} = Excludes the users that has a null value in "LastLogon" (This is usually the user: NT AUTHORITY\System)
            #Selects the values: "Caption, FullName and Last Logon    
            #$CimInstance_LoggedOnUsers = Get-CimInstance -ClassName Win32_networkloginprofile | ? {$_.LastLogon -ne $null} | Select-Object -Property "Caption", "FullName", "LastLogon"
            $CimInstance_LoggedOnUsers = Get-CimInstance -ClassName Win32_networkloginprofile | ? {$_.LastLogon -ne $null} | Select-Object -Property "Caption", "FullName", "LastLogon", "Usertype" 
    
            #For each Entry in the list, create a new object and make the new object with the added Last Logon date.
            $LastLogon = @()

            foreach ($item in $CimInstance_LoggedOnUsers)
                             {
            
                                            
                                 $CustomObject = New-Object PSCustomObject
                                 $CustomObject | Add-Member -Type NoteProperty -Name Caption -Value $Item.Caption
                                 $CustomObject | Add-Member -Type NoteProperty -Name FullName -Value $Item.FullName
                                 $CustomObject | Add-Member -Type NoteProperty -Name UserType -Value $Item.UserType
                                 $CustomObject | Add-Member -Type NoteProperty -Name LastLogon -Value $Item.LastLogon
                                
                                 #Adds the $CustomObject values to the $LastLogon variable
                                 $LastLogon += $CustomObject
                                 Clear-Variable -Name CustomObject
                            } 
       $LastLogon
}

#endregion

Export-ModuleMember -Function "*"
