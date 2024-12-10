$Script:GUIActions.AvailableKickstarts =  Get-ListofInstallFiles -ListofInstallFilesCSV $Script:Settings.ListofInstallFiles | Where-Object 'Kickstart_VersionFriendlyName' -ne "" | Select-Object 'Kickstart_Version','Kickstart_VersionFriendlyName' -unique 

foreach ($Kickstart in $Script:GUIActions.AvailableKickstarts) {
    $WPF_Setup_KickstartVersion_Dropdown.AddChild(($Kickstart.Kickstart_VersionFriendlyName).tostring())
}

 $WPF_Setup_KickstartVersion_Dropdown.Add_SelectionChanged({
     foreach ($Kickstart in $Script:GUIActions.AvailableKickstarts) {
         if ($Kickstart.Kickstart_VersionFriendlyName -eq $WPF_Setup_KickstartVersion_Dropdown.SelectedItem){
             if ($Kickstart.Kickstart_Version -ne $Script:GUIActions.KickstartVersiontoUse){
                Write-Host 'Wibble'
                 $Script:GUIActions.KickstartVersiontoUse  = $Kickstart.Kickstart_Version 
                 $Script:GUIActions.KickstartVersiontoUseFriendlyName = $WPF_Setup_KickstartVersion_Dropdown.SelectedItem
                 $Script:GUIActions.AvailableADFs = $null
                 $Script:GUIActions.FoundKickstarttoUse = $null
             }
             break
         }
     }
 })
