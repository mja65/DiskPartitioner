function Update-UI {
    param (
        [switch]$MainWindowButtons,
        [Switch]$Emu68Settings,
        [Switch]$DiskPartitionWindow,
        [Switch]$HighlightSelectedPartitions,
        [Switch]$UpdateInputBoxes,
        [Switch]$Buttons,
        [Switch]$PhysicalvsImage,
        [Switch]$CheckforRunningImage,
        [Switch]$FreeSpaceAlert
    )
   
    # if (($Emu68Settings) -and (-not ($Script:GUICurrentStatus.CurrentWindow -eq 'Emu68Settings'))){
    #     return
    # }
    # if ((($DiskPartitionWindow) -or ($HighlightSelectedPartitions) -or ($UpdateInputBoxes) -or ($Buttons)) -and (-not ($Script:GUICurrentStatus.CurrentWindow -eq 'DiskPartition'))){
    #     return
    # }

    if ($MainWindowButtons){
        $WPF_Window_Button_LoadSettings.Background = '#FFDDDDDD'
        $WPF_Window_Button_LoadSettings.Foreground = '#FF000000'

        $WPF_Window_Button_SaveSettings.Background = '#FFDDDDDD'
        $WPF_Window_Button_SaveSettings.Foreground = '#FF000000'

        $WPF_Window_Button_PackageSelection.Background = '#FFDDDDDD'
        $WPF_Window_Button_PackageSelection.Foreground = '#FF000000'

        $WPF_Window_Button_SetupDisk.Background = '#FFDDDDDD'
        $WPF_Window_Button_SetupDisk.Foreground = '#FF000000'

        $WPF_Window_Button_StartPage.Background = '#FFDDDDDD'
        $WPF_Window_Button_StartPage.Foreground = '#FF000000'
        
        $WPF_Window_Button_SetupEmu68.Background = '#FFDDDDDD'
        $WPF_Window_Button_SetupEmu68.Foreground = '#FF000000'

        if ($Script:GUICurrentStatus.CurrentWindow -eq "StartPage"){
            $WPF_Window_Button_StartPage.Background = '#FF017998' 
            $WPF_Window_Button_StartPage.Foreground = '#FFFFFFFF'
        }
        elseif ($Script:GUICurrentStatus.CurrentWindow -eq 'PackageSelection'){
            $WPF_Window_Button_PackageSelection.Background = '#FF017998' 
            $WPF_Window_Button_PackageSelection.Foreground = '#FFFFFFFF'
        }
        elseif ($Script:GUICurrentStatus.CurrentWindow -eq 'DiskPartition'){
            $WPF_Window_Button_SetupDisk.Background = '#FF017998' 
            $WPF_Window_Button_SetupDisk.Foreground = '#FFFFFFFF'
        }
        elseif ($Script:GUICurrentStatus.CurrentWindow -eq 'Emu68Settings'){
            $WPF_Window_Button_SetupEmu68.Background = '#FF017998' 
            $WPF_Window_Button_SetupEmu68.Foreground = '#FFFFFFFF'
        }
       
    }

    if (($CheckforRunningImage) -or ($DiskPartitionWindow)){
        $Script:GUICurrentStatus.ProcessImageStatus = $true
        $Script:GUICurrentStatus.IssuesFoundBeforeProcessing.Clear()

        
        If (-not ($Script:GUIActions.KickstartVersiontoUse)){
            $null = $Script:GUICurrentStatus.IssuesFoundBeforeProcessing.Rows.Add("Configure Emu68","No OS selected")
            $Script:GUICurrentStatus.ProcessImageStatus = $false
        }
        If (-not ($Script:GUIActions.FoundKickstarttoUse)){
            $null = $Script:GUICurrentStatus.IssuesFoundBeforeProcessing.Rows.Add("Configure Emu68","Kickstart file has not been located")
            $Script:GUICurrentStatus.ProcessImageStatus = $false
        }
        if ($Script:GUIActions.InstallOSFiles -eq $true){
            If (-not ($Script:GUIActions.FoundInstallMediatoUse)){
                $null = $Script:GUICurrentStatus.IssuesFoundBeforeProcessing.Rows.Add("Configure Emu68","OS file(s) have not been located")
                $Script:GUICurrentStatus.ProcessImageStatus = $false
            }   
        }
        
        If (-not ($Script:GUIActions.OutputPath)){
            $null = $Script:GUICurrentStatus.IssuesFoundBeforeProcessing.Rows.Add("Disk Setup","No Output location has been defined")
            $Script:GUICurrentStatus.ProcessImageStatus = $false
        }
        else {
            if ($Script:GUIActions.OutputType -eq 'Disk'){
                Get-AllGUIPartitions -partitiontype 'MBR' | ForEach-Object {
                    if ($_.value.ImportedPartition -eq $true -and $_.value.ImportedPartitionMethod -eq 'Direct'){
                       if ($_.value.ImportedPartitionPath -match $Script:GUIActions.OutputPath){
                           $null = $Script:GUICurrentStatus.IssuesFoundBeforeProcessing.Rows.Add("Disk Setup","The output location is the same physical disk set for one or more imported partitions")
                           $Script:GUICurrentStatus.ProcessImageStatus = $false
                       }
                    }         
               }
            }
        }
        If (-not ($Script:GUIActions.DiskSizeSelected)){
            $null = $Script:GUICurrentStatus.IssuesFoundBeforeProcessing.Rows.Add("Disk Setup","Disk Partitioning has not been performed")
            $Script:GUICurrentStatus.ProcessImageStatus = $false
        }        

        if ($Script:GUIActions.DiskSizeSelected){

            $AmigaDriveDetailsToTest  = [System.Collections.Generic.List[PSCustomObject]]::New()
            
            $SystemDeviceName = (Get-InputCSVs -Diskdefaults | Where-Object {$_.Disk -eq 'System'}).DeviceName
            $DefaultID76Partition = Get-AllGUIPartitions -PartitionType 'MBR' | Where-Object {$_.value.defaultgptmbrpartition -eq $true -and $_.value.PartitionSubType -eq 'ID76'}
           
            Get-AllGUIPartitions -PartitionType 'Amiga' | ForEach-Object {            
                $AmigaDriveDetailsToTest.add([PSCustomObject]@{
                    Disk = ($_.Name -split '_AmigaDisk_')[0]
                    DeviceName = $_.value.DeviceName
                    VolumeName = $_.value.VolumeName
                    Priority = $_.value.Priority
                    Bootable = $_.value.Bootable
                })
            } 
                
  
            if ($AmigaDriveDetailsToTest) {
                
                $IsBootableFound = $false

                foreach ($drive in $AmigaDriveDetailsToTest) {
                    if ($drive.Bootable -eq $true) {
                        $IsBootableFound = $true
                        break
                    }
                }
                
                if ($IsBootableFound -eq $false){
                     $null = $Script:GUICurrentStatus.IssuesFoundBeforeProcessing.Rows.Add("Disk Setup","There are no Amiga volumes set to be bootable.")
                } 

                $TopPriorityonDefaultDrive = $AmigaDriveDetailsToTest | Where-Object {$_.Disk -eq $DefaultID76Partition.Name} | Sort-Object 'Priority'| Select-Object -first 1
                
                if ($Script:GUIActions.InstallOSFiles -eq $true){

                    if ($TopPriorityonDefaultDrive.DeviceName -ne $SystemDeviceName) {
                        $null = $Script:GUICurrentStatus.IssuesFoundBeforeProcessing.Rows.Add("Disk Setup","The default system device $SystemDeviceName is not the highest priority device on the RDB.")
                        $Script:GUICurrentStatus.ProcessImageStatus = $false
                    }
                    else {
                        $AmigaDriveDetailsToTest | Where-Object {$_.Disk -eq $DefaultID76Partition.Name} | ForEach-Object {
                            if (($_.Disk -eq $TopPriorityonDefaultDrive.Disk) -and ($_.DeviceName -ne $TopPriorityonDefaultDrive.DeviceName)  -and ($_.Priority -eq $TopPriorityonDefaultDrive.Priority)){
                                $null = $Script:GUICurrentStatus.IssuesFoundBeforeProcessing.Rows.Add("Disk Setup","The default system device $SystemDeviceName is set to the same priority as one or more volumes on the same Amiga disk.")
                                $Script:GUICurrentStatus.ProcessImageStatus = $false
                            }
                        }
                    }
                }

        
                $UniqueVolumeNamesPerDisk = $AmigaDriveDetailsToTest | Group-Object 'Disk','VolumeName' 
                
                $UniqueVolumeNamesPerDisk | ForEach-Object {
                    if ($_.Count -gt 1){       
                        $null = $Script:GUICurrentStatus.IssuesFoundBeforeProcessing.Rows.Add("Disk Setup","The same volume name `"$(($_.Name -split ', ')[1])`" has been used accross more than one partition on the same disk")
                        $Script:GUICurrentStatus.ProcessImageStatus = $false
                    }
                }
                
                $UniqueDeviceNames = $AmigaDriveDetailsToTest | group-object 'DeviceName'
                $UniqueDeviceNames | ForEach-Object {
                    if ($_.Count -gt 1){
                        $null = $Script:GUICurrentStatus.IssuesFoundBeforeProcessing.Rows.Add("Disk Setup","The same device name $($_.Name) has been used on more than one device. Note this could be on multiple disks")
                        $Script:GUICurrentStatus.ProcessImageStatus = $false
                    }      
                }

            } 
            else {
                $null = $Script:GUICurrentStatus.IssuesFoundBeforeProcessing.Rows.Add("Disk Setup","No Amiga disks present")
                $Script:GUICurrentStatus.ProcessImageStatus = $false
            }
            
        }
                
        
        if ($Script:GUICurrentStatus.ProcessImageStatus -eq $false){
            $WPF_Window_Button_Run.Background = '#FFFF0000'
            $WPF_Window_Button_Run.foreground = '#FF000000'
            $WPF_Window_Button_Run.Content = 'Missing information in order to run tool! Press button to see further details'    
        }
        elseif ($Script:GUICurrentStatus.ProcessImageStatus -eq $true){
            $WPF_Window_Button_Run.Background = '#FF008000'
            $WPF_Window_Button_Run.foreground = '#FFFFFFFF'
            $WPF_Window_Button_Run.Content = 'Run Tool'    
        }        

    }

    if ($Emu68Settings){
        if ($Script:GUIActions.InstallOSFiles -eq $true){
            $WPF_Setup_OSSelection_GroupBox.Visibility = 'Visible'
            $WPF_Setup_SourceFiles_GroupBox.Visibility = 'Visible'
            $WPF_Setup_ADFpath_Button.Visibility = 'Visible'
            $WPF_Setup_ADFpath_Button_Check.Visibility = 'Visible'
            $WPF_Setup_ADFPath_Label.Visibility = 'Visible'
            $WPF_Setup_Settings_GroupBox.Visibility = 'Visible'
        }
        elseif ($Script:GUIActions.InstallOSFiles -eq $false){
            $WPF_Setup_OSSelection_GroupBox.Visibility = 'Visible'
            $WPF_Setup_SourceFiles_GroupBox.Visibility = 'Visible'
            $WPF_Setup_ADFpath_Button.Visibility = 'Hidden'
            $WPF_Setup_ADFpath_Button_Check.Visibility = 'Hidden'
            $WPF_Setup_ADFPath_Label.Visibility = 'Hidden'
            $WPF_Setup_Settings_GroupBox.Visibility = 'Visible'
        }
        if ($Script:GUIActions.ROMLocation){
            $WPF_Setup_RomPath_Label.Text = Get-FormattedPathforGUI -PathtoTruncate $Script:GUIActions.ROMLocation
            $WPF_Setup_RomPath_Button.Background = 'Green'
            $WPF_Setup_RomPath_Button.Foreground = 'White'
        }
        else {
            $WPF_Setup_RomPath_Label.Text = 'Using default Kickstart folder'
            $WPF_Setup_RomPath_Button.Foreground = 'Black'
            $WPF_Setup_RomPath_Button.Background = '#FFDDDDDD'
        }
        if ($Script:GUIActions.InstallMediaLocation){
            $WPF_Setup_ADFPath_Label.Text = Get-FormattedPathforGUI -PathtoTruncate $Script:GUIActions.InstallMediaLocation
            $WPF_Setup_ADFPath_Button.Background = 'Green'
            $WPF_Setup_ADFPath_Button.Foreground = 'White'

        }
        else {           
            $WPF_Setup_ADFPath_Label.Text = 'Using default install media folder'
            $WPF_Setup_ADFPath_Button.Foreground = 'Black'
            $WPF_Setup_ADFPath_Button.Background = '#FFDDDDDD'       
        }

        if ($Script:GUIActions.FoundKickstarttoUse){
            $WPF_Setup_ROMpath_Button_Check.Background = 'Green'
            $WPF_Setup_ROMpath_Button_Check.Foreground = 'White'
        }
        else{
            $WPF_Setup_Rompath_Button_Check.Background = '#FFDDDDDD'
            $WPF_Setup_Rompath_Button_Check.Foreground = 'Black'
        }
        
        if ($Script:GUIActions.FoundInstallMediatoUse){
            $WPF_Setup_ADFpath_Button_Check.Background = 'Green'
            $WPF_Setup_ADFpath_Button_Check.Foreground = 'White'
        }
        else{
            $WPF_Setup_ADFpath_Button_Check.Background = '#FFDDDDDD'
            $WPF_Setup_ADFpath_Button_Check.Foreground = 'Black'
        }

        if (($Script:GUIActions.SSID) -and (-not ($WPF_Setup_SSID_Textbox.Text))){
            $WPF_Setup_SSID_Textbox.Text = $Script:GUIActions.SSID 
        }
        if (($Script:GUIActions.WifiPassword) -and (-not ($WPF_Setup_Password_Textbox.Text))){
            $WPF_Setup_Password_Textbox.Text = $Script:GUIActions.WifiPassword 
        }
        
        if (($Script:GUIActions.ScreenModetoUseFriendlyName) -and (-not ($WPF_Setup_ScreenMode_Dropdown.SelectedItem))) {
           $WPF_Setup_ScreenMode_Dropdown.SelectedItem = $Script:GUIActions.ScreenModetoUseFriendlyName
        }
    }

    if (($DiskPartitionWindow) -or ($HighlightSelectedPartitions)){
        if ($Script:GUIActions.DiskSizeSelected){
            Get-AllGUIPartitions -PartitionType 'All' | ForEach-Object {
                $TotalChildren = ((Get-Variable -Name $_.Name).Value).Children.Count-1
                for ($i = 0; $i -le $TotalChildren; $i++) {
                    if  ((((Get-Variable -Name $_.Name).Value).Children[$i].Name -eq 'TopBorder_Rectangle') -or `
                        (((Get-Variable -Name $_.Name).Value).Children[$i].Name -eq 'BottomBorder_Rectangle') -or `
                        (((Get-Variable -Name $_.Name).Value).Children[$i].Name -eq 'LeftBorder_Rectangle') -or `
                        (((Get-Variable -Name $_.Name).Value).Children[$i].Name -eq 'RightBorder_Rectangle'))
                    {
                        if ($Script:GUICurrentStatus.SelectedGPTMBRPartition -eq $_.Name -or $Script:GUICurrentStatus.SelectedAmigaPartition -eq $_.Name ){
                           ((Get-Variable -Name $_.Name).Value).Children[$i].Stroke='Red'
                           write-debug "Highlighting Partition"                                      
                        } 
                        else{
                           ((Get-Variable -Name $_.Name).Value).Children[$i].Stroke='Black'
                        }
                    }
                
                }  
            }
    
            if ($Script:GUICurrentStatus.SelectedGPTMBRPartition){
                $MBRPartitionCounter = 1
                Get-AllGUIPartitionBoundaries | Where-Object {$_.PartitionType -eq 'MBR'} | ForEach-Object {
                    If ($Script:GUICurrentStatus.SelectedGPTMBRPartition -eq $_.PartitionName){
                        $WPF_DP_SelectedMBRPartition_Value.text = "Partition #$MBRPartitionCounter"
                    }
                    $MBRPartitionCounter ++
                }

                $WPF_DP_MBRGPTSettings_GroupBox.Visibility = 'Visible'
                If ((get-variable -name $Script:GUICurrentStatus.SelectedGPTMBRPartition).value.PartitionSubType -eq 'ID76'){
                    $AmigaDiskName = "$($Script:GUICurrentStatus.SelectedGPTMBRPartition)_AmigaDisk"
                    if (Get-Variable -name $AmigaDiskName){
                        Set-AmigaDiskSizeOverhangPixels -AmigaDiskName $AmigaDiskName
                    }
                    #$WPF_DP_DiskGrid_Amiga.Visibility ='Visible'
                    $WPF_DP_Amiga_GroupBox.Visibility ='Visible'
                    $WPF_DP_AmigaSettings_GroupBox.Visibility = 'Hidden'
                    $TotalChildren = $WPF_DP_DiskGrid_Amiga.Children.Count-1
                    for ($i = 0; $i -le $TotalChildren; $i++) {
                        $WPF_DP_DiskGrid_Amiga.Children.Remove($WPF_DP_DiskGrid_Amiga.Children[$i])
                    }
                    $WPF_DP_DiskGrid_Amiga.AddChild(((Get-Variable -Name ($Script:GUICurrentStatus.SelectedGPTMBRPartition+'_AmigaDisk')).value))
                }
                else{
                    #$WPF_DP_DiskGrid_Amiga.Visibility ='Hidden'
                    $WPF_DP_Amiga_GroupBox.Visibility ='Hidden'
                }
                $WPF_DP_GPTMBR_GroupBox.Visibility = 'Visible'
              
            }
            else{
                $WPF_DP_SelectedMBRPartition_Value.text = "No partition selected"
               # $WPF_DP_DiskGrid_Amiga.Visibility = 'Hidden'
                $WPF_DP_Amiga_GroupBox.Visibility = 'Hidden'
                $WPF_DP_MBRGPTSettings_GroupBox.Visibility = 'Hidden'
                $WPF_DP_AmigaSettings_GroupBox.Visibility = 'Hidden'
                #$WPF_DP_GPTMBR_GroupBox.Visibility = 'Hidden'
            }
            if ($Script:GUICurrentStatus.SelectedAmigaPartition){
                $WPF_DP_AmigaSettings_GroupBox.Visibility = 'Visible'
            }
        }
        else {
            $WPF_DP_GPTMBR_GroupBox.Visibility = 'Hidden'
            $WPF_DP_Amiga_GroupBox.Visibility = 'Hidden'
            $WPF_DP_MBRGPTSettings_GroupBox.Visibility = 'Hidden'
            $WPF_DP_AmigaSettings_GroupBox.Visibility = 'Hidden'            
        }
   
    }
    
    if (($DiskPartitionWindow) -or ($PhysicalvsImage)){
        if ($Script:GUIActions.OutputType -eq 'Image'){
            $WPF_DP_DiskSizeImage_GroupBox.Visibility = 'Visible'
            $WPF_DP_DiskSizePhysicalDisk_GroupBox.Visibility = 'Hidden'

        }
        elseif ($Script:GUIActions.OutputType -eq 'Disk'){
            $WPF_DP_DiskSizeImage_GroupBox.Visibility = 'Hidden'
            $WPF_DP_DiskSizePhysicalDisk_GroupBox.Visibility = 'Visible'
        }
        else {
            $WPF_DP_DiskSizeImage_GroupBox.Visibility = 'Hidden'
            $WPF_DP_DiskSizePhysicalDisk_GroupBox.Visibility = 'Hidden'
        }

    }

    if (($DiskPartitionWindow) -or ($UpdateInputBoxes)){
        if ($Script:GUICurrentStatus.SelectedGPTMBRPartition){
            if (-not $WPF_DP_SelectedSize_Input.InputEntry -eq $true){
                $SizetoReturn =  (Get-ConvertedSize -Size ((get-variable -name $Script:GUICurrentStatus.SelectedGPTMBRPartition).value.PartitionSizeBytes) -ScaleFrom 'B' -AutoScale -NumberofDecimalPlaces 2)
                $WPF_DP_SelectedSize_Input.Background = 'White'
                $WPF_DP_SelectedSize_Input.Text = $SizetoReturn.Size
                $WPF_DP_SelectedSize_Input_SizeScale_Dropdown.SelectedItem = $SizetoReturn.Scale
            }
           
            $PartitionsToCheck = Get-AllGUIPartitionBoundaries | Where-Object {$_.PartitionType -eq 'MBR'}
                       
            $PartitionToCheck = $PartitionsToCheck | Where-Object {$_.PartitionName -eq $Script:GUICurrentStatus.SelectedGPTMBRPartition}
            $SpaceatBeginning = (Get-ConvertedSize -Size $PartitionToCheck.BytesAvailableLeft -ScaleFrom 'B' -AutoScale -NumberofDecimalPlaces 2)
            $SpaceatEnd = (Get-ConvertedSize -Size $PartitionToCheck.BytesAvailableRight -ScaleFrom 'B' -AutoScale -NumberofDecimalPlaces 2)
            $DiskSize = (Get-ConvertedSize -Size $WPF_DP_Disk_GPTMBR.DiskSizeBytes -ScaleFrom 'B' -AutoScale -NumberofDecimalPlaces 2)
            $DiskFreeSpaceSize = (Get-ConvertedSize -Size (($PartitionsToCheck[$PartitionsToCheck.Count-1]).BytesAvailableRight) -ScaleFrom 'B' -AutoScale -NumberofDecimalPlaces 2)
            
            $WPF_DP_SpaceatBeginning_Input.Background = 'White'
            $WPF_DP_SpaceatBeginning_Input.Text = $SpaceatBeginning.Size
            $WPF_DP_SpaceatBeginning_Input_SizeScale_Dropdown.SelectedItem  = $SpaceatBeginning.Scale
            $WPF_DP_SpaceatEnd_Input.Background = 'White'
            $WPF_DP_SpaceatEnd_Input.Text =  $SpaceatEnd.Size
            $WPF_DP_SpaceatEnd_Input_SizeScale_Dropdown.SelectedItem = $SpaceatEnd.Scale         
            $WPF_DP_MBR_TotalDiskSize.Text = "$($DiskSize.Size) $($DiskSize.Scale)"
            $WPF_DP_MBR_TotalFreeSpaceSize.Text = "$($DiskFreeSpaceSize.Size) $($DiskFreeSpaceSize.Scale)" 

            Update-UITextbox -NameofPartition $Script:GUICurrentStatus.SelectedGPTMBRPartition -TextBoxControl $WPF_DP_MBR_VolumeName_Input -Value 'VolumeName' -CanChangeParameter 'CanRenameVolume'

        }
        else {
            if ($WPF_DP_GPTMBR_GroupBox.Visibility -eq 'Visible'){
                $DiskSize = (Get-ConvertedSize -Size $WPF_DP_Disk_GPTMBR.DiskSizeBytes -ScaleFrom 'B' -AutoScale -NumberofDecimalPlaces 2)
                $PartitionsToCheck = Get-AllGUIPartitionBoundaries | Where-Object {$_.PartitionType -eq 'MBR'}
                $DiskFreeSpaceSize = (Get-ConvertedSize -Size (($PartitionsToCheck[$PartitionsToCheck.Count-1]).BytesAvailableRight) -ScaleFrom 'B' -AutoScale -NumberofDecimalPlaces 2)
                $WPF_DP_SpaceatBeginning_Input.Background = 'White'
                $WPF_DP_SpaceatBeginning_Input.Text =''
                $WPF_DP_SpaceatBeginning_Input_SizeScale_Dropdown.SelectedItem  = ''
                $WPF_DP_SpaceatEnd_Input.Background = 'White'
                $WPF_DP_SpaceatEnd_Input.Text = ''
                $WPF_DP_SpaceatEnd_Input_SizeScale_Dropdown.SelectedItem =''
                $WPF_DP_SelectedSize_Input.Background = 'White' 
                $WPF_DP_SelectedSize_Input.Text = ''
                $WPF_DP_SelectedSize_Input_SizeScale_Dropdown.SelectedItem = ''
                $WPF_DP_MBR_TotalDiskSize.Text = "$($DiskSize.Size) $($DiskSize.Scale)"
                $WPF_DP_MBR_TotalFreeSpaceSize.Text = "$($DiskFreeSpaceSize.Size) $($DiskFreeSpaceSize.Scale)"      
            }
        }
        if ($Script:GUICurrentStatus.SelectedAmigaPartition){
                $RDBPartitionCounter = 1
                Get-AllGUIPartitionBoundaries | Where-Object {$_.PartitionType -eq 'Amiga' -and $_.PartitionName -match $Script:GUICurrentStatus.SelectedGPTMBRPartition} | ForEach-Object {
                    If ($Script:GUICurrentStatus.SelectedAmigaPartition -eq $_.PartitionName){
                        $WPF_DP_SelectedAmigaPartition_Value.text = "Partition #$RDBPartitionCounter"
                    }
                    $RDBPartitionCounter ++
                }
            if ((get-variable -name $Script:GUICurrentStatus.SelectedAmigaPartition).value.ImportedFilesPath){
                $SpaceImportedFilesConverted = (Get-ConvertedSize -Size ((get-variable -name $Script:GUICurrentStatus.SelectedAmigaPartition).value.ImportedFilesSpaceBytes) -ScaleFrom 'B' -AutoScale -NumberofDecimalPlaces 2)
                $WPF_DP_Button_ImportFiles.Background = 'Green'
                $WPF_DP_Button_ImportFiles.Foreground = 'White'
                $WPF_DP_Button_ImportFiles_Label.Text = Get-FormattedPathforGUI -PathtoTruncate ((get-variable -name $Script:GUICurrentStatus.SelectedAmigaPartition).value.ImportedFilesPath) -Length 15
                $WPF_DP_ImportFilesSize_Label.Visibility = 'Visible'
                $WPF_DP_ImportFilesSize_Value.Visibility = 'Visible'
                $WPF_DP_ImportFilesSize_Value.Text = "$($SpaceImportedFilesConverted.Size) $($SpaceImportedFilesConverted.Scale)"
            }
            else {
                $WPF_DP_Button_ImportFiles_Label.Text = 'No imported folder selected'
                $WPF_DP_Button_ImportFiles.Background = "#FFDDDDDD"
                $WPF_DP_Button_ImportFiles.Foreground = 'Black'
                $WPF_DP_ImportFilesSize_Label.Visibility = 'Hidden'
                $WPF_DP_ImportFilesSize_Value.Visibility = 'Hidden'
                $WPF_DP_ImportFilesSize_Value.Text = ''
            }

            if (-not $WPF_DP_Amiga_SelectedSize_Input.InputEntry -eq $true){
                $SizetoReturn =  (Get-ConvertedSize -Size ((get-variable -name $Script:GUICurrentStatus.SelectedAmigaPartition).value.PartitionSizeBytes) -ScaleFrom 'B' -AutoScale -NumberofDecimalPlaces 2)
                $WPF_DP_Amiga_SelectedSize_Input.Background = 'White'
                $WPF_DP_Amiga_SelectedSize_Input.Text = $SizetoReturn.Size
                $WPF_DP_Amiga_SelectedSize_Input_SizeScale_Dropdown.SelectedItem = $SizetoReturn.Scale
            }

            $PartitionsToCheck = Get-AllGUIPartitionBoundaries | Where-Object {$_.PartitionType -eq 'Amiga' -and $_.PartitionName -match $Script:GUICurrentStatus.SelectedGPTMBRPartition}

            $PartitionToCheck = $PartitionsToCheck | Where-Object {$_.PartitionName -eq $Script:GUICurrentStatus.SelectedAmigaPartition}
            $SpaceatBeginning = (Get-ConvertedSize -Size $PartitionToCheck.BytesAvailableLeft -ScaleFrom 'B' -AutoScale -NumberofDecimalPlaces 2)
            $SpaceatEnd = (Get-ConvertedSize -Size $PartitionToCheck.BytesAvailableRight -ScaleFrom 'B' -AutoScale -NumberofDecimalPlaces 2)
            $DiskSize = (Get-ConvertedSize -Size ((Get-Variable -name ($Script:GUICurrentStatus.SelectedAmigaPartition.Substring(0,($Script:GUICurrentStatus.SelectedAmigaPartition.IndexOf('AmigaDisk_Partition_')+9)))).value).DiskSizeBytes -ScaleFrom 'B' -AutoScale -NumberofDecimalPlaces 2)
            $DiskFreeSpaceSize = (Get-ConvertedSize -Size (($PartitionsToCheck[$PartitionsToCheck.Count-1]).BytesAvailableRight) -ScaleFrom 'B' -AutoScale -NumberofDecimalPlaces 2)
            
            $WPF_DP_Amiga_SpaceatBeginning_Input.Background = 'White'
            $WPF_DP_Amiga_SpaceatBeginning_Input.Text = $SpaceatBeginning.Size
            $WPF_DP_Amiga_SpaceatBeginning_Input_SizeScale_Dropdown.SelectedItem  = $SpaceatBeginning.Scale
            $WPF_DP_Amiga_SpaceatEnd_Input.Background = 'White'
            $WPF_DP_Amiga_SpaceatEnd_Input.Text =  $SpaceatEnd.Size
            $WPF_DP_Amiga_TotalDiskSize.Text = "$($DiskSize.Size) $($DiskSize.Scale)"
            $WPF_DP_Amiga_TotalFreeSpaceSize.Text = "$($DiskFreeSpaceSize.Size) $($DiskFreeSpaceSize.Scale)"
            
            $WPF_DP_Amiga_SpaceatEnd_Input_SizeScale_Dropdown.SelectedItem = $SpaceatEnd.Scale
            if ((get-variable -name $Script:GUICurrentStatus.SelectedAmigaPartition).value.Bootable -eq $true){
                write-debug "Bootable is true for partition $($Script:GUICurrentStatus.SelectedAmigaPartition)"
                $WPF_DP_Amiga_Bootable.IsChecked = 'True'
            }
            elseif ((get-variable -name $Script:GUICurrentStatus.SelectedAmigaPartition).value.Bootable -eq $false){
                write-debug "Bootable is false for partition $($Script:GUICurrentStatus.SelectedAmigaPartition)"
                $WPF_DP_Amiga_Bootable.IsChecked = ''
            }
            if ((get-variable -name $Script:GUICurrentStatus.SelectedAmigaPartition).value.NoMount -eq $true){
                write-debug "NoMount is true for partition $($Script:GUICurrentStatus.SelectedAmigaPartition)"
                $WPF_DP_Amiga_Mountable.IsChecked = ''
            }
            elseif ((get-variable -name $Script:GUICurrentStatus.SelectedAmigaPartition).value.NoMount -eq $false){
                write-debug "NoMount is false for partition $($Script:GUICurrentStatus.SelectedAmigaPartition)"
                $WPF_DP_Amiga_Mountable.IsChecked = 'True'
            }
            if ((get-variable -name $Script:GUICurrentStatus.SelectedAmigaPartition).value.CanChangeMountable -eq $true){
                $WPF_DP_Amiga_Mountable.IsEnabled = 'True'
            }
            else {
                $WPF_DP_Amiga_Mountable.IsEnabled = ''
            }            
            if ((get-variable -name $Script:GUICurrentStatus.SelectedAmigaPartition).value.CanChangeBootable -eq $true){
                $WPF_DP_Amiga_Bootable.IsEnabled = 'True'
            }
            else {
                $WPF_DP_Amiga_Bootable.IsEnabled = ''
            }

            Update-UITextbox -NameofPartition $Script:GUICurrentStatus.SelectedAmigaPartition -TextBoxControl $WPF_DP_Amiga_Buffers_Input -Value 'buffers' -CanChangeParameter 'CanChangeBuffers'      
            Update-UITextbox -NameofPartition $Script:GUICurrentStatus.SelectedAmigaPartition -TextBoxControl $WPF_DP_Amiga_DeviceName_Input -Value 'DeviceName' -CanChangeParameter 'CanRenameDevice'
            Update-UITextbox -NameofPartition $Script:GUICurrentStatus.SelectedAmigaPartition -TextBoxControl $WPF_DP_Amiga_VolumeName_Input -Value 'VolumeName' -CanChangeParameter 'CanRenameVolume'
            Update-UITextbox -NameofPartition $Script:GUICurrentStatus.SelectedAmigaPartition -TextBoxControl $WPF_DP_Amiga_MaxTransfer_Input -Value 'MaxTransfer' -CanChangeParameter 'CanChangeMaxTransfer'
            Update-UITextbox -NameofPartition $Script:GUICurrentStatus.SelectedAmigaPartition -TextBoxControl $WPF_DP_Amiga_Priority_Input -Value 'Priority' -CanChangeParameter 'CanChangePriority'
            Update-UITextbox -NameofPartition $Script:GUICurrentStatus.SelectedAmigaPartition -TextBoxControl $WPF_DP_Amiga_Buffers_Input -Value 'buffers' -CanChangeParameter 'CanChangeBuffers'
            Update-UITextbox -NameofPartition $Script:GUICurrentStatus.SelectedAmigaPartition -TextBoxControl $WPF_DP_Amiga_DosType_Input -Value 'DosType' -CanChangeParameter 'CanChangeDosType'  
            Update-UITextbox -NameofPartition $Script:GUICurrentStatus.SelectedAmigaPartition -TextBoxControl $WPF_DP_Amiga_Mask_Input -Value 'Mask' -CanChangeParameter 'CanChangeMask'  

        }    
        else {
            $WPF_DP_SelectedAmigaPartition_Value.text = "No partition selected"
            $WPF_DP_ImportFilesSize_Label.Visibility = 'Hidden'
            $WPF_DP_ImportFilesSize_Value.Visibility = 'Hidden'
            $WPF_DP_ImportFilesSize_Value.Text = ''                            
            if ($WPF_DP_Amiga_GroupBox.Visibility -eq 'Visible'){
                $WPF_DP_Amiga_SpaceatBeginning_Input.Background = 'White'
                $WPF_DP_Amiga_SpaceatBeginning_Input.Text =''
                $WPF_DP_Amiga_SpaceatBeginning_Input_SizeScale_Dropdown.SelectedItem  = ''
                $WPF_DP_Amiga_SpaceatEnd_Input.Background = 'White'
                $WPF_DP_Amiga_SpaceatEnd_Input.Text = ''
                $WPF_DP_Amiga_SpaceatEnd_Input_SizeScale_Dropdown.SelectedItem =''
                $WPF_DP_Amiga_SelectedSize_Input.Background = 'White' 
                $WPF_DP_Amiga_SelectedSize_Input.Text = ''
                $WPF_DP_Amiga_SelectedSize_Input_SizeScale_Dropdown.SelectedItem = ''
                $WPF_DP_Amiga_TotalDiskSize.Text = ''
                $WPF_DP_Amiga_TotalFreeSpaceSize.Text = ''             
            }
        }    
    }

    if (($DiskPartitionWindow) -or ($Buttons)){
        if ($Script:GUIActions.OutputPath){
            $WPF_DP_Button_SaveImage.Background = 'Green'
            $WPF_DP_Button_SaveImage.Foreground = 'White'
        }
        else{
            $WPF_DP_Button_SaveImage.Background = '#FFDDDDDD'
            $WPF_DP_Button_SaveImage.Foreground = "Black"         
        }
    }

    If ($FreeSpaceAlert){
        $FreeSpaceBytes_MBR = 0
        $FreeSpaceBytes_Amiga = 0
        Get-AllGUIPartitionBoundaries | ForEach-Object {
            if ($_.PartitionType -eq 'MBR'){
                $FreeSpaceBytes_MBR += $_.BytesAvailableLeft
           }
           elseif ($_.PartitionType -eq 'Amiga'){
               $FreeSpaceBytes_Amiga += $_.BytesAvailableLeft               
           }
        }

        If ($FreeSpaceBytes_MBR -eq 0){
            write-debug "No free space - MBR"
            $WPF_DP_MBR_FreeSpaceBetweenPartitions_Label.Visibility = 'hidden'
        }
        else {
            write-debug "Free space MBR is:$FreeSpaceBytes_MBR"
            $WPF_DP_MBR_FreeSpaceBetweenPartitions_Label.Visibility = 'visible'
        }
        
        If ($FreeSpaceBytes_Amiga -eq 0){
            write-debug "No free space - Amiga"
            $WPF_DP_Amiga_FreeSpaceBetweenPartitions_Label.Visibility = 'hidden'
        }
        else {
            write-debug "Free space Amiga is:$FreeSpaceBytes_Amiga"
            $WPF_DP_Amiga_FreeSpaceBetweenPartitions_Label.Visibility = 'visible'
        }

    }   
    
}
