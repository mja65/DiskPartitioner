$WPF_NewPartitionWindow_OK_Button.Add_Click({
    if (-not ($WPF_NewPartitionWindow_Input_PartitionSize_Value.Text)){
        $WPF_NewPartitionWindow_ErrorMessage_Label.Text = "No value entered!"
        return
    }
    if ((Get-IsValueNumber -TexttoCheck $WPF_NewPartitionWindow_Input_PartitionSize_Value.Text) -eq $false){
        $WPF_NewPartitionWindow_ErrorMessage_Label.Text = "Size of partition must be a number!"
        return
    }
    if  ((Get-IsValueNumber -TexttoCheck $WPF_NewPartitionWindow_Input_PartitionSize_Value.Text) -eq $true){
        $WPF_NewPartitionWindow_ErrorMessage_Label.Text = ""
        $ValuetoCheck = (Get-ConvertedSize -Size $WPF_NewPartitionWindow_Input_PartitionSize_Value.Text -ScaleFrom $WPF_NewPartitionWindow_Input_PartitionSize_SizeScale_Dropdown.Text -Scaleto 'B').size 
        # Write-debug "Textbox is: $($WPF_NewPartitionWindow_Input_PartitionSize_Value.Text) Value input is: $ValuetoCheck Maximum allowed size is: $($Script:GUICurrentStatus.NewPartitionMaximumSizeBytes)"  
        if (-not (($ValuetoCheck -le $Script:GUICurrentStatus.NewPartitionMaximumSizeBytes) -and $ValuetoCheck -ge ($Script:GUICurrentStatus.NewPartitionMinimumSizeBytes))){
            $WPF_NewPartitionWindow_ErrorMessage_Label.Text = "Size of partition must be less than maximum size and greater than the minimum size!"
            return
        }
        else {
            $Script:GUICurrentStatus.NewPartitionAcceptedNewValue = $true
            $null = $WPF_NewPartitionWindow.Close()
        }
    }

})
 