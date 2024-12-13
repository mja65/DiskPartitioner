$WPF_DP_Button_DeleteAmigaPartition.add_click({
    if ($Script:GUIActions.SelectedAmigaPartition){
        if ((Get-Variable -name $Script:GUIActions.SelectedAmigaPartition).value.DefaultAmigaWorkbenchPartition -eq $true){
            if ((Show-WarningorError -Msg_Header 'Default Amiga partition selected for deletion' -Msg_Body 'You have selected the default amiga partition to be deleted. If you proceed then no default install will be made!' -BoxTypeWarning -ButtonType_OKCancel) -eq 'OK'){
                $ProceedtoDelete = $true
            }
        }
        else{
            $ProceedtoDelete = $true
        }
        if ($ProceedtoDelete -eq $true){
            if ((Remove-AmigaGUIPartition -PartitionName $Script:GUIActions.SelectedAmigaPartition) -eq $false){
                Show-WarningorError -Msg_Header 'Cannot Delete Partition' -Msg_Body 'Amiga Partition cannot be deleted.' -BoxTypeError -ButtonType_OK
            }
        }
    }
})