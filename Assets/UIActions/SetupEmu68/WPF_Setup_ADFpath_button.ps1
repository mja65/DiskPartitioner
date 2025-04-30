$WPF_Setup_ADFPath_Button.Add_Click({
    $PathtoPopulate = Get-FolderPath -Message 'Select path to installation files' -InitialDirectory "$([System.IO.Path]::GetFullPath($Script:Settings.DefaultInstallMediaLocation))\"  
    if ($PathtoPopulate){
        if ($PathtoPopulate -ne $Script:GUIActions.InstallMediaLocation) {
            $Script:GUIActions.InstallMediaLocation = $PathtoPopulate
        }


    #     else{
    #         if ($Script:ADFPath -ne $Script:UserLocation_ADFs){
    #             $Script:ADFPath = $Script:UserLocation_ADFs   
    #             $Script:AvailableADFs = $null
    #         }
    #     }
    # }
    # else{
    #     if ($Script:ADFPath -ne $Script:UserLocation_ADFs){
    #         $Script:ADFPath = $Script:UserLocation_ADFs   
    #         $Script:AvailableADFs = $null
    #     }
    # }
    }
    $null = Update-UI -Emu68Settings
})

       # $CheckifLocalDrive = (Get-LocalvsNetwork -PathtoCheck $PathtoPopulate -PreventNetworkPath 'LocalandMappedDrivesOnly') 
       # if (($CheckifLocalDrive -eq 'Local') -or ($CheckifLocalDrive -eq 'Network-MappedDrive')){