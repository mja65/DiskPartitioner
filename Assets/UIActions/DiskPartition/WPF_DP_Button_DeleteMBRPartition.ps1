$WPF_DP_Button_DeleteMBRPartition.add_click({
    # $Script:GUICurrentStatus.SelectedGPTMBRPartition = 'WPF_DP_Partition_MBR_2'
    if ($Script:GUICurrentStatus.SelectedGPTMBRPartition){
        If (((Get-variable -name $Script:GUICurrentStatus.SelectedGPTMBRPartition).value.DefaultGPTMBRPartition -eq $true) -and ((Get-variable -name $Script:GUICurrentStatus.SelectedGPTMBRPartition).value.PartitionSubType -eq 'ID76')){

$MessageBody = 
@"
You have selected the default ID 0x76 Amiga Partition for deletion! If you really want to do this you will not be installing ANY OS files! 

All currently selected Kickstart ROMs, Workbench install files, and user selected packages will be unselected. If you change your mind after deleting and want to create an image with an installed OS you will need to restart the Imager and repeform those steps. 

Press OK to continue otherwise cancel
"@   

            if ((Show-WarningorError -Msg_Header 'Deleting Default Amiga Partition' -BoxTypeWarning -ButtonType_OKCancel  -Msg_Body $MessageBody) -eq 'Cancel'){
                return
            }
            else {
                $DeleteDefaultAmigaPartition = $true
            }
       
        }

        if ((Get-variable -name $Script:GUICurrentStatus.SelectedGPTMBRPartition).value.PartitionSubType -eq 'ID76'){
            $DeleteUnderlyingAmigaPartitions = $true
        }
        else {
            $DeleteUnderlyingAmigaPartitions = $false
        }


        if ((Remove-MBRGUIPartition -PartitionName $Script:GUICurrentStatus.SelectedGPTMBRPartition) -eq $false){
            Show-WarningorError -Msg_Header 'Cannot Delete Partition' -Msg_Body 'MBR Partition is default partition. Cannot delete.' -BoxTypeError -ButtonType_OK
            return
        }
    
        if ($DeleteUnderlyingAmigaPartitions -eq $true){
            $ListofPartitionstoDelete = (Get-AllGUIPartitions -PartitionType 'Amiga' | Where-Object {$_.Name -match $Script:GUICurrentStatus.SelectedGPTMBRPartition} ).Name
            $ListofPartitionstoDelete  | ForEach-Object {
                Remove-Variable -Name $_
            }
    
            Remove-Variable -Name  "$($Script:GUICurrentStatus.SelectedGPTMBRPartition)_AmigaDisk"
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

        $Script:GUICurrentStatus.SelectedGPTMBRPartition = $null
        Update-UI -DiskPartitionWindow
        
    }
    else {
        Show-WarningorError -Msg_Header 'Cannot Delete Partition' -Msg_Body "No partititon is selected!" -BoxTypeError -ButtonType_OK
        return
    }
})
