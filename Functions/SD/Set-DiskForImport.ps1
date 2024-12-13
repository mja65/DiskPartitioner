function Set-DiskForImport {
    param (

    )
    
    Remove-Variable -Name 'WPF_SD_*'
    
    $Script:GUIActions.ActionToPerform = 'ImportMBRPartition'

    $WPF_SelectDiskWindow = Get-XAML -WPFPrefix 'WPF_SD_' -XMLFile '.\Assets\WPF\Window_SelectDiskMBR.xaml' -ActionsPath '.\UIActions\SD\' -AddWPFVariables

    if ($WPF_DP_ImportMBRPartition_DropDown.SelectedItem -eq 'At end of disk'){
        $AddType = 'AtEnd'        
    }
    elseif ($WPF_DP_ImportMBRPartition_DropDown.SelectedItem -eq 'Left of selected partition'){
        $AddType = 'Left'   
    }
    elseif ($WPF_DP_ImportMBRPartition_DropDown.SelectedItem -eq 'Right of selected partition'){
        $AddType = 'Right'   
    }
    
    $Script:GUIActions.AvailableSpaceforImportedPartitionBytes = (Get-MBRDiskFreeSpace -Disk $WPF_DP_Disk_MBR -Position $AddType -PartitionNameNextto $Script:GUIActions.SelectedMBRPartition)
    $WPF_SD_FreeSpace_Value.Text = "$((Get-ConvertedSize -Size $Script:GUIActions.AvailableSpaceforImportedPartitionBytes -ScaleFrom 'B' -AutoScale -NumberofDecimalPlaces 2).Size) $((Get-ConvertedSize -Size $Script:GUIActions.AvailableSpaceforImportedPartitionBytes -ScaleFrom 'B' -AutoScale -NumberofDecimalPlaces 2).Scale)"
    $WPF_SD_FreeSpaceRemaining_Value.Text = $WPF_SD_FreeSpace_Value.Text

    Set-BrowseforDiskDropdown -ImportPartition

    $WPF_SelectDiskWindow.ShowDialog() | out-null
   
 
}

