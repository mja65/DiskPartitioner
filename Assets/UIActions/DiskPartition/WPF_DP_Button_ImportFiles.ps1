$WPF_DP_Button_ImportFiles.add_click({
    if ($Script:GUICurrentStatus.SelectedAmigaPartition){
        $PartitionSizeByes = (get-variable -name $Script:GUICurrentStatus.SelectedAmigaPartition).value.PartitionSizeBytes 
        if ((Get-Variable -Name $Script:GUICurrentStatus.SelectedAmigaPartition).Value.DefaultAmigaWorkbenchPartition -eq $true){
            Show-WarningorError -Msg_Header 'Default Workbench Partition Selected' -Msg_Body 'Cannot transfer files to the default Workbench partition!' -BoxTypeError -ButtonType_OK
        }
        elseif ((Get-Variable -Name $Script:GUICurrentStatus.SelectedAmigaPartition).Value.CanImportFiles -eq $false){
            Show-WarningorError -Msg_Header 'Imported Partition Selected' -Msg_Body 'Cannot transfer files to the this partition!' -BoxTypeError -ButtonType_OK
        }
        else {
            $PathtoPopulate = Get-FolderPath -Message 'Select path to files to import' -InitialDirectory ([System.IO.Path]::GetFullPath($Script:Settings.DefaultInstallMediaLocation)) 
            if ($PathtoPopulate){
                $SpaceofFolderBytes = (Get-ChildItem -Path $PathtoPopulate -recurse | Measure-Object -Property Length -Sum).Sum
                if ($SpaceofFolderBytes -gt $PartitionSizeByes){
                    Show-WarningorError -Msg_Header 'Insufficient Space' -Msg_Body 'Insufficient space on partition for files!' -BoxTypeError -ButtonType_OK
                }
                else {
                    (get-variable -name $Script:GUICurrentStatus.SelectedAmigaPartition).value.ImportedFilesPath = $PathtoPopulate 
                    Update-UI -UpdateInputBoxes
                }
            }
            else {
                return
            }

        }
    }
    else{
        Show-WarningorError -Msg_Header 'No Partition Selected' -Msg_Body 'Cannot transfer files without selecting partition!' -BoxTypeError -ButtonType_OK
    }
})

