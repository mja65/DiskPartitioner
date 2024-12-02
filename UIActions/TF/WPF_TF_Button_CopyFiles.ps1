$WPF_TF_Button_CopyFiles.Add_Click({
    $WPF_TF_FileSource_DataGrid.SelectedItems | ForEach-Object {
        $Match = $null
        foreach ($File in $WPF_TF_FileDestination_DataGrid.ItemsSource) {
            if ($_.FullPath -eq $File.FullPath){
                $Match = $true
                break
            }
        }
        if (-not ($Match)){
            (Get-variable -name $Script:GUIActions.SelectedAmigaPartition).Value.ImportedFiles+= [PSCustomObject]@{
                FullPath = $_.FullPath
                Size = $_.Size
                CreationTime = $_.CreationTime
                Source = $_.Source
                PathHeader = $_.PathHeader
            }
        }
    }

    $WPF_TF_FileDestination_DataGrid.ItemsSource = (Get-variable -name $Script:GUIActions.SelectedAmigaPartition).Value.ImportedFiles

    if ((Get-variable -name $Script:GUIActions.SelectedAmigaPartition).Value.ImportedFiles){
        (Get-variable -name $Script:GUIActions.SelectedAmigaPartition).Value.ImportedFilesSpaceBytes = ((Get-variable -name $Script:GUIActions.SelectedAmigaPartition).Value.ImportedFiles | Measure-Object -Property 'Size' -Sum).sum
    }
    else {
        (Get-variable -name $Script:GUIActions.SelectedAmigaPartition).Value.ImportedFilesSpaceBytes = 0
    }
    $WPF_TF_CopiedFilesSpace_Value.Text = "$((Get-ConvertedSize -Size ((Get-variable -name $Script:GUIActions.SelectedAmigaPartition).Value.ImportedFilesSpaceBytes) -ScaleFrom 'B' -AutoScale -NumberofDecimalPlaces 2).Size) $((Get-ConvertedSize -Size ((Get-variable -name $Script:GUIActions.SelectedAmigaPartition).Value.ImportedFilesSpaceBytes) -ScaleFrom 'B' -AutoScale -NumberofDecimalPlaces 2).Scale)"
    

})

