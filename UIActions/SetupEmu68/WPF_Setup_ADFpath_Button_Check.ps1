$WPF_Setup_ADFpath_Button_Check.Add_Click({
    if ($Script:GUIActions.KickstartVersiontoUse){
        if ($Script:GUIActions.ADFLocation){
            $ADFPathtoUse = $Script:GUIActions.ADFLocation
        } 
        else{
            $ADFPathtoUse = $Script:Settings.DefaultADFLocation
        }
        $Script:GUIActions.FoundADFstoUse = Compare-ADFHashes -PathtoADFFiles $ADFPathtoUse -PathtoADFHashes $Script:Settings.ADFHashes -KickstartVersion $Script:GUIActions.KickstartVersiontoUse -PathtoListofInstallFiles $Script:Settings.ListofInstallFiles  
        
        if (($Script:GUIActions.FoundADFstoUse | Select-Object 'IsMatched' -unique).IsMatched -eq 'FALSE'){
            $Title = 'Missing ADFs'
            $Text = 'You have missing ADFs. You need to correct this before you can run the tool. List of ADFs located and missing is below'
        }
        else {                         
            $Title = 'ADFs to be used'
            $Text = 'The following ADFs will be used:'
            $Script:GUIActions.FoundADFStoUseType = $Script:GUIActions.WorkbenchFilesNeeded 
            $Script:GUIActions.StorageADFPath = 'TBC'
        }
        
         $DatatoPopulate = $Script:GUIActions.FoundADFstoUse | Select-Object @{Name='Status';Expression='IsMatched'},@{Name='Source';Expression='Source'},@{Name='ADF Name';Expression='FriendlyName'},@{Name='Path';Expression='Path'},@{Name='MD5 Hash';Expression='Hash'} | Sort-Object -Property 'Status'
    
         $FieldsSorted = ('Status','Source','ADF Name','Path','MD5 Hash')
    
         foreach ($ADF in $DatatoPopulate ){
             if ($ADF.Status -eq 'TRUE'){
                 $ADF.Status = 'Located'
             }
             else{
                 $ADF.Status = 'Missing!'
             }
         }

         Get-GUIADFKickstartReport -Title $Title -Text $Text -DatatoPopulate $DatatoPopulate -WindowWidth 800 -WindowHeight 350 -DataGridWidth 670 -DataGridHeight 200 -GridLinesVisibility 'None' -FieldsSorted $FieldsSorted    
         Update-UI -Emu68Settings
    }
    else{
        $null = Show-WarningorError -Msg_Body 'Cannot check ADFs as you have not yet chosen the OS!' -Msg_Header 'Error - No OS Chosen!'  -BoxTypeWarning -ButtonType_OK
    }
})

#$Script:GUIActions.AvailableKickstarts



    # if ($Script:KickstartVersiontoUse){
    #     $Script:AvailableADFs = Compare-ADFHashes -PathtoADFFiles $Script:ADFPath -PathtoADFHashes ($InputFolder+'ADFHashes.csv') -KickstartVersion $Script:KickstartVersiontoUse -PathtoListofInstallFiles ($InputFolder+'ListofInstallFiles.csv')            
        
    #     Update-ListofInstallFiles



    #     Get-GUIADFKickstartReport -Title $Title -Text $Text -DatatoPopulate $DatatoPopulate -WindowWidth 800 -WindowHeight 350 -DataGridWidth 670 -DataGridHeight 200 -GridLinesVisibility 'None' -FieldsSorted $FieldsSorted                    
    # }
    
    # else {
    #     Write-GUINoOSChosen -Type 'ADFs'
    # }
    # $null = Confirm-UIFields 
