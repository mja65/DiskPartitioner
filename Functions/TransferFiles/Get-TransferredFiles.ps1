function Get-TransferredFiles {
    param (
        
    )

    Remove-Variable -Name 'WPF_TF_*'

    $Script:GUIActions.ActionToPerform = 'TransferFiles'
    $WPF_SelectDiskWindow = Get-XAML -WPFPrefix 'WPF_TF_' -XMLFile '.\Assets\WPF\Window_BrowseFiles.xaml' -ActionsPath '.\UIActions\TF\' -AddWPFVariables

    $AvailableSpace = (Get-Variable -name $Script:GUIActions.SelectedAmigaPartition).Value.PartitionSizeBytes - (Get-Variable -name $Script:GUIActions.SelectedAmigaPartition).Value.ImportedFilesSpaceBytes

    $WPF_TF_FreeSpaceRemaining_Value.Text = "$((Get-ConvertedSize -Size $AvailableSpace -ScaleFrom 'B' -AutoScale -NumberofDecimalPlaces 2).Size) $((Get-ConvertedSize -Size $AvailableSpace -ScaleFrom 'B' -AutoScale -NumberofDecimalPlaces 2).Scale)"
    $WPF_TF_SelectedFilesSpace_Value.Text = '0 KiB'

    $WPF_TF_CopiedFilesSpace_Value.Text = "$((Get-ConvertedSize -Size ((Get-variable -name $Script:GUIActions.SelectedAmigaPartition).ImportedFilesSpaceBytes) -ScaleFrom 'B' -AutoScale -NumberofDecimalPlaces 2).Size) $((Get-ConvertedSize -Size ((Get-variable -name $Script:GUIActions.SelectedAmigaPartition).ImportedFilesSpaceBytes) -ScaleFrom 'B' -AutoScale -NumberofDecimalPlaces 2).Scale)"
    
    $WPF_SelectDiskWindow.ShowDialog() | out-null
    
}
