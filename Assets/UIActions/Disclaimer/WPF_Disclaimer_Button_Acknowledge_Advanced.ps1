$WPF_Disclaimer_Button_Acknowledge_Advanced.Add_Click({
    Write-Host "Wibble"
    $Script:GUICurrentStatus.OperationMode = 'Advanced'
    $WPF_Disclaimer.Close() | out-null
})


