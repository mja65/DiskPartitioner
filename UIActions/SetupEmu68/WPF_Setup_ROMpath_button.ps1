$WPF_Setup_RomPath_Button.Add_Click({
    $PathtoPopulate = Get-FolderPath -Message 'Select path to Kickstart' -InitialDirectory $Script:Settings.DefaultROMLocation 
    if ($PathtoPopulate){
        if ($PathtoPopulate -ne $Script:Settings.DefaultROMLocation) {
            $Script:GUIActions.ROMLocation = $PathtoPopulate
        }
        $null = Update-UI -Emu68Settings
    }                
})

# $CheckifLocalDrive = (Get-LocalvsNetwork -PathtoCheck $PathtoPopulate -PreventNetworkPath 'LocalandMappedDrivesOnly') 
# if (($CheckifLocalDrive -eq 'Local') -or ($CheckifLocalDrive -eq 'Network-MappedDrive')){