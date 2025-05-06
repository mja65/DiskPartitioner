$Script:GUIActions.AvailableKickstarts =  Get-InputCSVs -OSestoInstall | Select-Object 'Kickstart_Version','Kickstart_VersionFriendlyName','InstallMedia'

foreach ($Kickstart in $Script:GUIActions.AvailableKickstarts) {
    $WPF_Setup_KickstartVersion_Dropdown.AddChild(($Kickstart.Kickstart_VersionFriendlyName).tostring())
}

 $WPF_Setup_KickstartVersion_Dropdown.Add_SelectionChanged({
     foreach ($Kickstart in $Script:GUIActions.AvailableKickstarts) {
         if ($Kickstart.Kickstart_VersionFriendlyName -eq $WPF_Setup_KickstartVersion_Dropdown.SelectedItem){
             if ($Kickstart.Kickstart_Version -ne $Script:GUIActions.KickstartVersiontoUse){
                 $Script:GUIActions.KickstartVersiontoUse = $Kickstart.Kickstart_Version 
                 $Script:GUIActions.KickstartVersiontoUseFriendlyName = $WPF_Setup_KickstartVersion_Dropdown.SelectedItem
                 $Script:GUIActions.OSInstallMediaType = $Kickstart.InstallMedia
                 $Script:GUIActions.FoundInstallMediatoUse = $null
                 $Script:GUIActions.FoundKickstarttoUse = $null
                 $Script:GUICurrentStatus.AvailablePackagesNeedingGeneration = $true
             }
             break
         }
     }

})

