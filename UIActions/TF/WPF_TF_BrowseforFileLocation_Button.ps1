$WPF_TF_BrowseforFileLocation_Button.Add_Click({

    if ($WPF_TF_PhysicalvsImage_Dropdown.SelectedItem -eq 'Local Drive'){
        $Script:GUIActions.TransferSourceLocation = Get-FolderPath -Message 'Select Source'
        $Script:GUIActions.TransferSourceType = 'Windows'
    }

    else {
        Remove-Variable -Name 'WPF_TFRDB_*'

        $WPF_SelectRDBSourceWindow = Get-XAML -WPFPrefix 'WPF_TFRDB_' -XMLFile '.\Assets\WPF\Window_BrowseFilesRDBSelection.xaml' -ActionsPath '.\UIActions\TFRDB\' -AddWPFVariables
        
        if ($WPF_TFRDB_BrowseforDisk_DropDown){
            foreach ($Disk in $Script:GUIActions.ListofRemovableMedia){
                $WPF_TFRDB_BrowseforDisk_DropDown.AddChild($Disk.FriendlyName)       
            }
        }

        $WPF_SelectRDBSourceWindow.ShowDialog() | out-null
    }
    
    if ($Script:GUIActions.TransferSourceLocation){
        $WPF_TF_FileSource_DataGrid.Visibility = 'Visible'
        $TabletoPopulate = [System.Collections.Generic.List[PSCustomObject]]::New()

        if ($Script:GUIActions.TransferSourceType -eq 'Amiga'){
            Get-DirectoryListingAmiga -Path $Script:GUIActions.TransferSourceLocation | Where-Object {$_.Type -eq 'File'} | ForEach-Object {
                $FormattedSize = (Get-ConvertedSize -Size $_.Length -ScaleFrom 'B' -AutoScale -NumberofDecimalPlaces 2)    
                $TabletoPopulate += [PSCustomObject]@{
                    FullPath = $_.Name
                    Size = "$($FormattedSize.Size) $($FormattedSize.Scale)" 
                    SizeBytes = $_.Length
                    CreationTime = ([datetime]$_.Date).ToString("dd/MM/yyyy")
                    Attributes = $_.Attributes
                    Comment = $_.Comment
                    Source = $_.Source
                    PathHeader = $_.PathHeader 

                }
            }
        }

        # (Get-ChildItem -Path $Script:GUIActions.TransferSourceLocation -Recurse) | Where-Object { $_.PSIsContainer -eq $false } | ForEach-Object {
        #     (Get-ConvertedSize -Size $_.Length -ScaleFrom 'B' -AutoScale -NumberofDecimalPlaces 2)    
        # }
        
        elseif($Script:GUIActions.TransferSourceType -eq 'Windows'){            
            Get-ChildItem -Path $Script:GUIActions.TransferSourceLocation  | ForEach-Object {
                if ($_.mode -match "d"){
                    $SizeBytes = (Get-ChildItem -path $_.FullName -force -recurse | Where-Object { $_.PSIsContainer -eq $false }  | Measure-Object -property Length -sum).sum
                    $FileType = 'Folder'
                }
                else{
                    $SizeBytes = $_.Length
                    $FileType = 'File'
                }
                $FormattedSize = (Get-ConvertedSize -Size $SizeBytes -ScaleFrom 'B' -AutoScale -NumberofDecimalPlaces 2)    
                $TabletoPopulate += [PSCustomObject]@{
                    FullPath = $_.FullName
                    FileType = $FileType
                    Size = "$($FormattedSize.Size) $($FormattedSize.Scale)"
                    SizeBytes = $SizeBytes
                    CreationTime = ([datetime]$_.CreationTime).ToString("dd/MM/yyyy")
                    Source = 'PC'
                    PathHeader = $null
                }
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

        
        # $Script:FilesDestinationTabletoPopulate = [System.Collections.Generic.List[PSCustomObject]]::New()
        
        # $Script:FilesDestinationTabletoPopulate += [PSCustomObject]@{
        #     FullPath = $null
        #     Size = $null
        #     LastWriteTime = $null
        #     CreationTime = $null
        #     Type = $null
        # }
    
        $WPF_TF_FileDestination_DataGrid.ItemsSource = (Get-variable -name $Script:GUIActions.SelectedAmigaPartition).Value.ImportedFiles
        if (($WPF_TF_FileDestination_DataGrid.ItemsSource) -or ($WPF_TF_FileSource_DataGrid.ItemsSource)){
            $WPF_TF_FileDestination_DataGrid.Visibility = 'Visible'
        }
    }    
})

