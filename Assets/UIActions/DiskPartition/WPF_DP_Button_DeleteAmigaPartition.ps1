$WPF_DP_Button_DeleteAmigaPartition.add_click({
    if ($Script:GUICurrentStatus.SelectedAmigaPartition){
        if ($Script:GUICurrentStatus.SelectedAmigaPartition.DefaultAmigaWorkbenchPartition -eq $true){
$MessageBody = 
            @"
            You have selected the default Amiga Partition for deletion! If you really want to do this you will not be installing ANY OS files! 
            
            All currently selected Kickstart ROMs, Workbench install files, and user selected packages will be unselected. If you change your mind after deleting and want to create an image with an installed OS you will need to restart the Imager and repeform those steps. 
            
            Press OK to continue otherwise cancel
"@              
            if ((Show-WarningorError -Msg_Header 'Default Amiga partition selected for deletion' -Msg_Body $MessageBody -BoxTypeWarning -ButtonType_OKCancel) -eq 'Cancel'){
                return
            }
            else {
                $DeleteDefaultAmigaPartition = $true
            }
        }

        if ((Remove-AmigaGUIPartition -PartitionName $Script:GUICurrentStatus.SelectedAmigaPartition) -eq $false){
            Show-WarningorError -Msg_Header 'Cannot Delete Partition' -Msg_Body 'Amiga Partition cannot be deleted.' -BoxTypeError -ButtonType_OK
        }

        if ($DeleteDefaultAmigaPartition -eq $true){
            $Script:GUIActions.InstallOSFiles = $false
            $Script:GUIActions.InstallMediaLocation = $null
            $Script:GUIActions.ROMLocation = $null
            $Script:GUIActions.KickstartVersiontoUse = $null
            $Script:GUIActions.KickstartVersiontoUseFriendlyName = $null
            $Script:GUIActions.OSInstallMediaType = $null
            $Script:GUIActions.FoundInstallMediatoUse = $null
            $Script:GUIActions.FoundKickstarttoUse = $null
        }
    }
    else {
        Show-WarningorError -Msg_Header 'Cannot Delete Partition' -Msg_Body "No partititon is selected!" -BoxTypeError -ButtonType_OK
        return
    }
})