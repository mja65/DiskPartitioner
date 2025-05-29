$WPF_Disclaimer_Button_Acknowledge_Simple.Add_Click({
    $Script:GUICurrentStatus.OperationMode = 'Simple'
    $WPF_Disclaimer.Close() | out-null
})

