#Module

#Collects all currently logged on users.



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

        Caption  FullName    UserType
        -------  --------    --------
        rasm757j Rasmus Wind Normal Account
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
        #Selects the values: "Caption, FullName and UserType    
         #$CimInstance_LoggedOnUsers = Get-CimInstance -ClassName Win32_networkloginprofile | ? {$_.LastLogon -ne $null} | Select-Object -Property "Caption", "FullName", "UserType"
        
        #Collects the Users session and filters the Negotiate authenticationpackage away from the object and selects "StartTime"
        #$SessionStartTime = Get-CimInstance -ClassName Win32_session | ? {$_.AuthenticationPackage -ne "Negotiate"} | Select-Object -Property "StartTime"
        
        #For each Entry in the list, create a new object and make the new object with the added Session StartTime.
        Get-CimInstance -ClassName Win32_NetworkLoginProfile | ForEach-Object{
            $CimInstance_LoggedOnUsers = Get-CimInstance -ClassName Win32_networkloginprofile | ? {$_.LastLogon -ne $null} | Select-Object -Property "Caption", "FullName", "UserType" 
            $SessionStartTime = Get-CimInstance -ClassName Win32_session | ? {$_.AuthenticationPackage -ne "Negotiate"} | Select-Object -Property "StartTime"
    
            $NewObject = New-Object -TypeName psobject -Property @{
                Caption = $CimInstance_LoggedOnUsers.Caption
                FullName = $CimInstance_LoggedOnUsers.FullName
                UserType = $CimInstance_LoggedOnUsers.UserType
                SessionStartDate = $SessionStartTime.StartTime
                
            }   
        }
        #Select-Object to adjust the columns to be in the right order.
        $NewObject | Select-Object FullName,Caption,UserType,SessionStartDate
        
}



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

    
    #For each Entry in the list, create a new object and make the new object with the added Number of Logons.
    Get-CimInstance -ClassName Win32_NetworkLoginProfile | ForEach-Object{
        $CimInstance_LoggedOnUsers = Get-CimInstance -ClassName Win32_networkloginprofile | ? {$_.LastLogon -ne $null} | Select-Object -Property "Caption", "FullName", "NumberOfLogons" 

        $NewObject = New-Object -TypeName psobject -Property @{
            Caption = $CimInstance_LoggedOnUsers.Caption
            FullName = $CimInstance_LoggedOnUsers.FullName
            NumberOfLogons = $CimInstance_LoggedOnUsers.NumberOfLogons
            
        }
    }
    #Select-Object to adjust the columns to be in the right order.
    $NewObject | Select-Object FullName,Caption,NumberOfLogons
    
}


<#
.SYNOPSIS
    Lists the currently logged on users and the date that they last logged on.
.DESCRIPTION
    This CMDLet lists all currently logged on users, their fullname and their Username.
    It will also list the last logon date.
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
function Get-LastLogon {
    #Gets the CimInstance that shows logged on users
    #? {$_.LastLogon -ne $null} = Excludes the users that has a null value in "LastLogon" (This is usually the user: NT AUTHORITY\System)
    #Selects the values: "Caption, FullName and Last Logon    
     #$CimInstance_LoggedOnUsers = Get-CimInstance -ClassName Win32_networkloginprofile | ? {$_.LastLogon -ne $null} | Select-Object -Property "Caption", "FullName", "LastLogon"
    
    #For each Entry in the list, create a new object and make the new object with the added Last Logon date.
    Get-CimInstance -ClassName Win32_NetworkLoginProfile | ForEach-Object{
        $CimInstance_LoggedOnUsers = Get-CimInstance -ClassName Win32_networkloginprofile | ? {$_.LastLogon -ne $null} | Select-Object -Property "Caption", "FullName", "LastLogon" 

        $NewObject = New-Object -TypeName psobject -Property @{
            Caption = $CimInstance_LoggedOnUsers.Caption
            FullName = $CimInstance_LoggedOnUsers.FullName
            LastLogon = $CimInstance_LoggedOnUsers.LastLogon
            
        }   
    }
    #Select-Object to adjust the columns to be in the right order.
    $NewObject | Select-Object FullName,Caption,LastLogon
    
}

Export-ModuleMember -Function "*"