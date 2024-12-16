$WPF_TF_FileSource_DataGrid.add_selectionChanged({

    $TotalSize = 0
    $WPF_TF_FileSource_DataGrid.SelectedItems | ForEach-Object {
        if ($_.type -ne 'Directory'){
            $TotalSize += $_.SizeBytes 
        }
    }

    $WPF_TF_SelectedFilesSpace_Value.Text = "$((Get-ConvertedSize -Size $TotalSize -ScaleFrom 'B' -AutoScale -NumberofDecimalPlaces 2).Size) $((Get-ConvertedSize -Size $TotalSize -ScaleFrom 'B' -AutoScale -NumberofDecimalPlaces 2).Scale)"

})