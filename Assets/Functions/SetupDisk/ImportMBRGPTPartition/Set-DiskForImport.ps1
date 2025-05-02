function Set-DiskForImport {
    param (

    )
    
    Remove-Variable -Name 'WPF_DP_ID_*'
    $Script:GUICurrentStatus.ImportedPartitionType = $null
    #$Script:GUIActions.ActionToPerform = 'ImportMBRPartition'

    $WPF_SelectDiskWindow = Get-XAML -WPFPrefix 'WPF_DP_ID_' -XMLFile '.\Assets\WPF\ImportDisk\Window_SelectDiskMBR.xaml' -ActionsPath '.\Assets\UIActions\DiskPartitionImportDisk\' -AddWPFVariables

    if ($WPF_DP_ImportMBRPartition_DropDown.SelectedItem -eq 'At end of disk'){
        $AddType = 'AtEnd'
    }
    elseif ($WPF_DP_ImportMBRPartition_DropDown.SelectedItem -eq 'Left of selected partition'){
        $AddType = 'Left'   
    }
    elseif ($WPF_DP_ImportMBRPartition_DropDown.SelectedItem -eq 'Right of selected partition'){
        $AddType = 'Right'   
    }
        
    $Script:GUICurrentStatus.AvailableSpaceforImportedMBRGPTPartitionBytes = (Get-MBRDiskFreeSpace -Disk $WPF_DP_Disk_GPTMBR -Position $AddType -PartitionNameNextto $Script:GUICurrentStatus.SelectedGPTMBRPartition)
    $WPF_DP_ID_FreeSpace_Value.Text = "$((Get-ConvertedSize -Size $Script:GUICurrentStatus.AvailableSpaceforImportedMBRGPTPartitionBytes -ScaleFrom 'B' -AutoScale -NumberofDecimalPlaces 2).Size) $((Get-ConvertedSize -Size $Script:GUICurrentStatus.AvailableSpaceforImportedMBRGPTPartitionBytes -ScaleFrom 'B' -AutoScale -NumberofDecimalPlaces 2).Scale)"
    $WPF_DP_ID_FreeSpaceRemaining_Value.Text = $WPF_DP_ID_FreeSpace_Value.Text

    Set-BrowseforDiskDropdown -ImportPartition

    $WPF_DP_ID_SourceofPartition_Label.Visibility = 'Hidden'
    $WPF_DP_ID_SourceofPartition_Value.Visibility = 'Hidden'
    $WPF_DP_ID_TypeofPartition_Label.Visibility = 'Hidden'
    $WPF_DP_ID_MBR_DataGrid.Visibility = 'Hidden'
    $WPF_DP_ID_RDB_DataGrid.Visibility = 'Hidden'

    $WPF_SelectDiskWindow.ShowDialog() | out-null
    #  $WPF_SelectDiskWindow.Close()
 
}
