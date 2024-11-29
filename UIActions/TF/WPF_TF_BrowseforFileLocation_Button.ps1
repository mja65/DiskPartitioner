$WPF_TF_BrowseforFileLocation_Button.Add_Click({
    Write-host 'Wib'
    $Script:GUIActions.TransferSourceLocation = Get-FolderPath -Message 'Select Source'
    

    $TabletoPopulate = [System.Collections.Generic.List[PSCustomObject]]::New()

    (Get-ChildItem -Path $Script:GUIActions.TransferSourceLocation -Recurse) | ForEach-Object {
        $TabletoPopulate += [PSCustomObject]@{
            FullPath = $_.FullName
            Size = $_.Length
            LastWriteTime = $_.LastWriteTime
            CreationTime = $_.CreationTime
            Type = $_.Attributes
        }
    }
    
    if ($TabletoPopulate){
        $WPF_TF_FileSource_DataGrid.ItemsSource = $TabletoPopulate 
    }

})