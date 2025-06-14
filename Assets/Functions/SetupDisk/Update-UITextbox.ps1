function Update-UITextbox {
    param (
        $Partition,
        $TextBoxControl,
        $DropdownControl,
        $Value,
        $CanChangeParameter
    )
    
    # $NameofPartition = $Script:GUICurrentStatus.SelectedAmigaPartition
    # $TextBoxControl = $WPF_DP_Amiga_VolumeName_Input
    # $Value = 'VolumeName'
    # $CanChangeParameter = 'CanRenameVolume'

    
    # $NameofPartition = $Script:GUICurrentStatus.SelectedAmigaPartition
    # $TextBoxControl = $WPF_DP_Amiga_DosType_Input
    # $Value = 'DosType' 
    # $CanChangeParameter = 'CanChangeDosType'
    
    if ($TextBoxControl){
        $TextBoxControl.Text = $Partition.$Value
    }
    elseif ($DropdownControl){
        $DropdownControl.SelectedItem = $Partition.$Value
    }

    if ($Partition.$CanChangeParameter -eq 'True'){
        if ($TextBoxControl){
            $TextBoxControl.IsReadOnly = ''
            $TextBoxControl.Background = 'White'
            if (($TextBoxControl.EntryType -eq 'Numeric') -and ((Get-IsValueNumber -TexttoCheck $TextBoxControl.Text) -eq $false)) {
                $TextBoxControl.Background = 'Red'
            }
            elseif (($TextBoxControl.EntryType -eq 'Hexadecimal') -and ((Confirm-IsHexadecimal -value $TextBoxControl.Text) -eq $false -or $TextBoxControl.Text.Length -ne $TextBoxControl.EntryLength)) {
                $TextBoxControl.Background = 'Red'
            }
            elseif (($TextBoxControl.EntryType -eq 'AlphaNumeric') -and (((Get-IsValueAlphaNumeric -ValueToTest $TextBoxControl.Text) -eq $false) -or ($TextBoxControl.Text.Length -gt $TextBoxControl.EntryLength))) {
                $TextBoxControl.Background = 'Red'
            }
            elseif (($TextBoxControl.EntryType -eq 'Alpha') -and ((Get-IsValueAlpha -ValueToTest $TextBoxControl.Text) -eq $false -or $TextBoxControl.Text.Length -gt $TextBoxControl.EntryLength)) {
                $TextBoxControl.Background = 'Red'
            }   
            elseif (($TextBoxControl.EntryType -eq 'AlphaNumericDosType') -and ((Get-IsValueAlphaNumeric -DosType -ValueToTest $TextBoxControl.Text) -eq $false -or $TextBoxControl.Text.Length -gt $TextBoxControl.EntryLength)) {
                $TextBoxControl.Background = 'Red'
            }   
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

