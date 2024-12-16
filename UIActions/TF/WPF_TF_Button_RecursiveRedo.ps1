$WPF_TF_Button_RecursiveRedo.add_click({
    $TabletoPopulate = [System.Collections.Generic.List[PSCustomObject]]::New()
    (Get-ChildItem -Path $Script:GUIActions.TransferSourceLocation -Recurse -Depth $Script:GUIActions.TransferFilesRecurseDepth) | Where-Object { $_.PSIsContainer -eq $false } | ForEach-Object {
        $FormattedSize = (Get-ConvertedSize -Size $_.Length -ScaleFrom 'B' -AutoScale -NumberofDecimalPlaces 2)    
        $TabletoPopulate += [PSCustomObject]@{
            FullPath = $_.FullName
            Size = "$($FormattedSize.Size) $($FormattedSize.Scale)"
            SizeBytes = $_.Length
            CreationTime = ([datetime]$_.CreationTime).ToString("dd/MM/yyyy")
            Source = 'PC'
            PathHeader = $null
        }
    }
    if ($TabletoPopulate){
        $WPF_TF_FileSource_DataGrid.ItemsSource = $TabletoPopulate
        for ($i = 0; $i -lt $WPF_TF_FileSource_DataGrid.Columns.count ; $i++) {
            $WPF_TF_FileSource_DataGrid.Columns[$i].CanUserSort = 'True'
            if ($WPF_TF_FileSource_DataGrid.Columns[$i].Header -eq 'PathHeader'){
                $WPF_TF_FileSource_DataGrid.Columns[$i].Visibility = 'Hidden'
            }
            elseif ($WPF_TF_FileSource_DataGrid.Columns[$i].Header -eq 'Attributes'){
                $WPF_TF_FileSource_DataGrid.Columns[$i].Visibility = 'Hidden'
            }
            elseif ($WPF_TF_FileSource_DataGrid.Columns[$i].Header -eq 'Comment'){
                $WPF_TF_FileSource_DataGrid.Columns[$i].Visibility = 'Hidden'
            }  
            elseif ($WPF_TF_FileSource_DataGrid.Columns[$i].Header -eq 'SizeBytes'){
                $WPF_TF_FileSource_DataGrid.Columns[$i].Visibility = "Hidden"
            }          
        }
    }
})