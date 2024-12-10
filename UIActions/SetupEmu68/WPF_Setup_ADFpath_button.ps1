$WPF_Setup_ADFPath_Button.Add_Click({
    $PathtoPopulate = Get-FolderPath -Message 'Select path to ADFs' -InitialDirectory $Script:Settings.DefaultADFLocation 
    if ($PathtoPopulate){
        if ($PathtoPopulate -ne $Script:GUIActions.ADFLocation) {
            $Script:GUIActions.ADFLocation = $PathtoPopulate
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