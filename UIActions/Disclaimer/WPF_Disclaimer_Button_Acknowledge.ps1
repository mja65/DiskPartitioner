$WPF_Disclaimer_Button_Acknowledge.Add_Click({
    $WPF_Disclaimer.Close() | out-null
    $Script:GUISettings.IsDisclaimerAccepted = $True
})