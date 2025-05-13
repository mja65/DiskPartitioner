$WPF_Setup_RomPath_Button.Add_Click({
        If ($Script:GUICurrentStatus.FileBoxOpen -eq $true){
        return
    }
    $Script:GUICurrentStatus.FileBoxOpen = $true
    $PathtoPopulate = Get-FolderPath -Message 'Select path to Kickstart' -InitialDirectory "$([System.IO.Path]::GetFullPath($Script:Settings.DefaultROMLocation))\"  
    if ($PathtoPopulate){
        if ($PathtoPopulate -ne $Script:Settings.DefaultROMLocation) {
            $Script:GUIActions.ROMLocation = $PathtoPopulate
        }
        $Script:GUICurrentStatus.FileBoxOpen = $false
        $null = Update-UI -Emu68Settings
    }
    else {
        $Script:GUICurrentStatus.FileBoxOpen = $false                
    }

})

# $CheckifLocalDrive = (Get-LocalvsNetwork -PathtoCheck $PathtoPopulate -PreventNetworkPath 'LocalandMappedDrivesOnly') 
# if (($CheckifLocalDrive -eq 'Local') -or ($CheckifLocalDrive -eq 'Network-MappedDrive')){