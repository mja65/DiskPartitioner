$WPF_Disclaimer_Button_Acknowledge.Add_Click({
    $Script:GUIActions.IsDisclaimerAccepted = $True
    $WPF_Disclaimer.Close() | out-null
})

