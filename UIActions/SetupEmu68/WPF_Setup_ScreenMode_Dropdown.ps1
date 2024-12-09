# $AvailableScreenModes = Import-Csv ($InputFolder+'ScreenModes.csv') -delimiter ';' | Where-Object 'Include' -eq 'TRUE'

# foreach ($ScreenMode in $AvailableScreenModes) {
#     $WPF_UI_ScreenMode_Dropdown.AddChild($ScreenMode.FriendlyName)
# }

# $Script:ScreenModetoUseFriendlyName = 'Automatic'
# $WPF_UI_ScreenMode_Dropdown.SelectedItem = $Script:ScreenModetoUseFriendlyName 
# $Script:ScreenModetoUse = 'Auto'

# $WPF_UI_ScreenMode_Dropdown.Add_SelectionChanged({
#     foreach ($ScreenMode in $AvailableScreenModes) {
#         if ($ScreenMode.FriendlyName -eq $WPF_UI_ScreenMode_Dropdown.SelectedItem){
#             $Script:ScreenModetoUse = $ScreenMode.Name
#             $Script:ScreenModetoUseFriendlyName = $WPF_UI_ScreenMode_Dropdown.SelectedItem           
#         }
#     }

#     $null = Confirm-UIFields
    
# })