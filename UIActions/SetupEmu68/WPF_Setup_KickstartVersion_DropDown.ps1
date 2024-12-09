# $AvailableKickstarts =  Get-ListofInstallFiles -ListofInstallFilesCSV ($Script:InputFolder+'ListofInstallFiles.csv') | Where-Object 'Kickstart_VersionFriendlyName' -ne "" | Select-Object 'Kickstart_Version','Kickstart_VersionFriendlyName' -unique 

# foreach ($Kickstart in $AvailableKickstarts) {
#     $WPF_UI_KickstartVersion_Dropdown.AddChild(($Kickstart.Kickstart_VersionFriendlyName).tostring())
# }

# $WPF_UI_KickstartVersion_Dropdown.Add_SelectionChanged({    
#     foreach ($Kickstart in $AvailableKickstarts) {
#         if ($Kickstart.Kickstart_VersionFriendlyName -eq $WPF_UI_KickstartVersion_Dropdown.SelectedItem){
#             if ($Kickstart.Kickstart_Version -ne $Script:KickstartVersiontoUse){
#                 $Script:KickstartVersiontoUse  = $Kickstart.Kickstart_Version 
#                 $Script:KickstartVersiontoUseFriendlyName = $WPF_UI_KickstartVersion_Dropdown.SelectedItem
#                 $Script:AvailableADFs = $null
#                 $Script:FoundKickstarttoUse = $null
#             } 
#         }
#    }

#    $null = Confirm-UIFields
   
# })

