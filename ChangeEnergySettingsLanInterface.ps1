function Write-Log 
{ 
    [CmdletBinding()] 
    Param 
    ( 
        [Parameter(Mandatory=$true, 
                   ValueFromPipelineByPropertyName=$true)] 
        [ValidateNotNullOrEmpty()] 
        [Alias("LogContent")] 
        [string]$Message, 
 
        [Parameter(Mandatory=$false)] 
        [Alias('LogPath')] 
        [string]$Path='C:\windows\temp\ChangeEngergySettingsLanInterface.log', 
         
        [Parameter(Mandatory=$false)] 
        [ValidateSet("Error","Warn","Info")] 
        [string]$Level="Info", 
         
        [Parameter(Mandatory=$false)] 
        [switch]$NoClobber 
    ) 
 
    Begin 
    { 
        # Set VerbosePreference to Continue so that verbose messages are displayed. 
        $VerbosePreference = 'Continue' 
    } 
    Process 
    { 
         
        # If the file already exists and NoClobber was specified, do not write to the log. 
        if ((Test-Path $Path) -AND $NoClobber) { 
            Write-Error "Log file $Path already exists, and you specified NoClobber. Either delete the file or specify a different name." 
            Return 
            } 
 
        # If attempting to write to a log file in a folder/path that doesn't exist create the file including the path. 
        elseif (!(Test-Path $Path)) { 
            Write-Verbose "Creating $Path." 
            $NewLogFile = New-Item $Path -Force -ItemType File 
            } 
 
        else { 
            # Nothing to see here yet. 
            } 
 
        # Format Date for our Log File 
        $FormattedDate = Get-Date -Format "yyyy-MM-dd HH:mm:ss" 
 
        # Write message to error, warning, or verbose pipeline and specify $LevelText 
        switch ($Level) { 
            'Error' { 
                Write-Error $Message 
                $LevelText = 'ERROR:' 
                } 
            'Warn' { 
                Write-Warning $Message 
                $LevelText = 'WARNING:' 
                } 
            'Info' { 
                Write-Verbose $Message 
                $LevelText = 'INFO:' 
                } 
            } 
         
        # Write log entry to $Path 
        "$FormattedDate $LevelText $Message" | Out-File -FilePath $Path -Append 
    } 
    End 
    { 
    } 
}


$tmpAdapter = Get-NetAdapter -Physical
foreach ($Adapter in $tmpAdapter)
{
    if ($Adapter.InterfaceDescription -eq 'Intel(R) Ethernet Connection I219-LM')
        {
        Write-Log "Found Adapter:$Adapter.Name $Adapter.InterfaceDescription"
        $AdapterNetCfgInstanceId = $Adapter.DeviceID
        Write-Log "Found DeviceID:$DeviceID"
        }
}
	
#check whether the registry path exists.
$KeyPath = "HKLM:\SYSTEM\CurrentControlSet\Control\Class\{4D36E972-E325-11CE-BFC1-08002bE10318}"
if(Test-Path -Path $KeyPath)
{
#NetCfgInstanceId -eq $DeviceID
Write-Log "exists"
$tmpItems = Get-ChildItem $KeyPath | Select-Object name
    foreach ($RegPath in $tmpItems)
    {
        #Write-Log "paths:" $RegPath.Name
        $tmpRegPath = $RegPath.Name.Replace('HKEY_LOCAL_MACHINE','HKLM:')
        #Write-Log "tmpRegPath:" $tmpRegPath
     
        try{
            $tmpNetCfgInstanceId = (Get-ItemProperty $tmpRegPath).NetCfgInstanceId
            Write-Log "NetCfgInstanceId:$tmpNetCfgInstanceId"
        
            if ($AdapterNetCfgInstanceId -eq $tmpNetCfgInstanceId )
            {
                Write-Log "AdapterNetCfgInstanceId: FOUND"
                $PnPCapabilitiesValue = (Get-ItemProperty -Path $tmpRegPath).PnPCapabilities

                Write-Log "PnPCapabilitiesValue:$PnPCapabilitiesValue"
            
            
                if ($PnPCapabilitiesValue -eq 256) {
                #is still set
                    Write-Log "Key Exists 256"
                }
                else {
                #Set Value
                New-ItemProperty -Path $tmpRegPath -Name "PnPCapabilities" -Value 256 -PropertyType DWord -Force | Out-Null
                Write-Log "Value set! 256"
                }
            
                break
            }

        }
        catch {
            Write-Log "not_found" -Level Warn
        }
        
    } # foreach
} # end if
