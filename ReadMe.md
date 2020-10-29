## Move the module
Move CombinedFunctions folder to:
```
C:\Program Files\WindowsPowerShell\Modules\
```
after you move the module you might need to set the Execution Policy
```
Set-ExecutionPolicy Unrestricted
```
to use the module you need to import the module

```
Import-Module
```
The module commands: 
```
Get-LoggedOnUser
Get-NumberOfLogons
Get-LastLogon
```
