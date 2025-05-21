    $WPF_NewPartitionWindow_Cancel_Button.Add_Click({
    $WPF_NewPartitionWindow_Input_PartitionSize_Value.Text = $null  
    $Script:GUICurrentStatus.NewPartitionAcceptedNewValue = $false 
    $null = $WPF_NewPartitionWindow.close()
})