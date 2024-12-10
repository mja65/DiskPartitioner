$WPF_Setup_ROMpath_Button_Check.Add_Click({
    if ($Script:GUIActions.KickstartVersiontoUse){
        if ($Script:GUIActions.ROMLocation){
            $RomPathtoUse = $Script:GUIActions.ROMLocation
        } 
        else{
            $RomPathtoUse = $Script:Settings.DefaultROMLocation
        }
        $Script:GUIActions.FoundKickstarttoUse = Compare-KickstartHashes -PathtoKickstartHashes $Script:Settings.RomHashes -PathtoKickstartFiles $RomPathtoUse -KickstartVersion $Script:GUIActions.KickstartVersiontoUse
        if (-not ($Script:GUIActions.FoundKickstarttoUse)){
            $null = Show-WarningorError -Msg_Header 'Error - No Kickstart found!' -Msg_Body 'No valid Kickstart file was found at the location you specified. Select a location with a valid Kickstart file.' -BoxTypeWarning -ButtonType_OK 
        }
        else{
            $Title = 'Kickstarts to be used'
            $Text = 'The following Kickstart will be used:'
            $DatatoPopulate = $Script:GUIActions.FoundKickstarttoUse | Select-Object @{Name='Kickstart';Expression='FriendlyName'},@{Name='Path';Expression='KickstartPath'}         
            Get-GUIADFKickstartReport -Title $Title -Text $Text -DatatoPopulate $DatatoPopulate -WindowWidth 700 -WindowHeight 300 -DataGridWidth 570 -DataGridHeight 80 -GridLinesVisibility 'None'    
        }
    }
    else{
        $null = Show-WarningorError -Msg_Header 'Error - No OS Chosen!'  -Msg_Body 'Cannot check Kickstarts as you have not yet chosen the OS!' -BoxTypeWarning -ButtonType_OK 
    }
    #$null = Confirm-UIFields
})

