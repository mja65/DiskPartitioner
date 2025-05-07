$WPF_RunWindow_Cancel_Button.Add_Click({
    $Script:GUICurrentStatus.ProcessImageConfirmedbyUser = $false
    $WPF_RunWindow.Close()
})
