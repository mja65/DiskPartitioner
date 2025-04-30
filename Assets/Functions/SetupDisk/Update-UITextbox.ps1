function Update-UITextbox {
    param (
        $NameofPartition,
        $TextBoxControl,
        $DropdownControl,
        $Value,
        $CanChangeParameter
    )
    



    # $NameofPartition = $Script:GUICurrentStatus.SelectedAmigaPartition
    # $TextBoxControl = $WPF_DP_Amiga_Buffers_Input
    # $Value = 'buffers'
    # $CanChangeParameter = 'CanChangeBuffers'
    # $DropdownControl =  $WPF_DP_Amiga_DosType_Input_Dropdown
    # $Value = 'DosType' 
    # $CanChangeParameter = 'CanChangeDosType'
    
    # if (((get-variable -name $NameofPartition).value.PartitionType) -eq 'Amiga' -and ((get-variable -name $NameofPartition).value.ImportedPartition) -eq 'TRUE'){
    #     Write-host  "$NameofPartition"
    #     (get-variable -name $NameofPartition).value.ImportedPartitionUpdatedValues = $true
    # }

    if ($TextBoxControl){
        $TextBoxControl.Text = (get-variable -name $NameofPartition).value.$Value
    }
    elseif ($DropdownControl){
        $DropdownControl.SelectedItem = (get-variable -name $NameofPartition).value.$Value
    }

    if ((get-variable -name $NameofPartition).value.$CanChangeParameter -eq 'True'){
        if ($TextBoxControl){
            $TextBoxControl.IsReadOnly = ''
            $TextBoxControl.Background = 'White'
        }
        elseif ($DropdownControl){
           # $DropdownControl.IsReadOnly = ''
           $WPF_DP_Amiga_DosType_Input_Dropdown.IsEnabled = 'True'
            $DropdownControl.Background = 'White'
        }

    }
    else {
        if ($TextBoxControl){
            $TextBoxControl.IsReadOnly = 'True'
            $TextBoxControl.Background = 'Transparent'
        }
        elseif ($DropdownControl){
            #$DropdownControl.IsReadOnly = 'True'
            $WPF_DP_Amiga_DosType_Input_Dropdown.IsEnabled = ''
            $DropdownControl.Background = 'Transparent'
        }
    }

}

