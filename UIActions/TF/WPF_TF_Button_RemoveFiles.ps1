$WPF_TF_Button_RemoveFiles.Add_Click({

    $RevisedTabletoPopulate = [System.Collections.Generic.List[PSCustomObject]]::New()

    $Script:FilesDestinationTabletoPopulate | ForEach-Object {
        $Match = $null
        foreach ($File in $WPF_TF_FileDestination_DataGrid.SelectedItems){
            if ($_.FullPath -eq $File.FullPath){
                #Write-Host "Existing file is: $($_.FullPath) File to remove is: $($File.FullPath)"
                $Match = $true
                break
            }
        }
        if (-not ($Match)){
            Write-Host 'Wib'
            $RevisedTabletoPopulate  += $_
        }
    }
    
    (Get-variable -name $Script:GUIActions.SelectedAmigaPartition).Value.ImportedFiles = $RevisedTabletoPopulate 
    $WPF_TF_FileDestination_DataGrid.ItemsSource = (Get-variable -name $Script:GUIActions.SelectedAmigaPartition).Value.ImportedFiles

    if ((Get-variable -name $Script:GUIActions.SelectedAmigaPartition).Value.ImportedFiles){
        (Get-variable -name $Script:GUIActions.SelectedAmigaPartition).ImportedFilesSpaceBytes = ((Get-variable -name $Script:GUIActions.SelectedAmigaPartition).Value.ImportedFiles | Measure-Object -Property 'Size' -Sum).sum
    }
    else {
        (Get-variable -name $Script:GUIActions.SelectedAmigaPartition).ImportedFilesSpaceBytes = 0
    }
    $WPF_TF_CopiedFilesSpace_Value.Text = "$((Get-ConvertedSize -Size ((Get-variable -name $Script:GUIActions.SelectedAmigaPartition).ImportedFilesSpaceBytes) -ScaleFrom 'B' -AutoScale -NumberofDecimalPlaces 2).Size) $((Get-ConvertedSize -Size ((Get-variable -name $Script:GUIActions.SelectedAmigaPartition).ImportedFilesSpaceBytes) -ScaleFrom 'B' -AutoScale -NumberofDecimalPlaces 2).Scale)"

})

