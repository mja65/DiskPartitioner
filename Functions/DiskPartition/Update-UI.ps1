function Update-UI {
    param (
        [Switch]$All,
        [Switch]$Emu68Settings,
        [Switch]$HighlightSelectedPartitions,
        [Switch]$ShowGrids,
        [Switch]$UpdateInputBoxes,
        [Switch]$Buttons
    )
   
    if (($All) -or ($Buttons)){
        if ($Script:GUIActions.OutputPath){
            $WPF_DP_Button_SaveImage.Background = 'Green'
            $WPF_DP_Button_SaveImage.Foreground = 'White'
        }
        else{
            $WPF_DP_Button_SaveImage.Background = '#FFDDDDDD'
            $WPF_DP_Button_SaveImage.Foreground = 'Black'          
        }

        

    }

    if (($All) -or ($Emu68Settings)){
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
        if ($Script:GUIActions.ADFLocation){
            $WPF_Setup_ADFPath_Label.Text = Get-FormattedPathforGUI -PathtoTruncate $Script:GUIActions.ADFLocation
            $WPF_Setup_ADFPath_Button.Background = 'Green'
            $WPF_Setup_ADFPath_Button.Foreground = 'White'

        }
        else {           
            $WPF_Setup_ADFPath_Label.Text = 'Using default ADF folder'
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
        
        if ($Script:GUIActions.FoundADFstoUse){
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

    if (($All) -or ($HighlightSelectedPartitions)){
        Get-AllGUIPartitions -PartitionType 'All' | ForEach-Object {
            $TotalChildren = ((Get-Variable -Name $_.Name).Value).Children.Count-1
            for ($i = 0; $i -le $TotalChildren; $i++) {
                if  ((((Get-Variable -Name $_.Name).Value).Children[$i].Name -eq 'TopBorder_Rectangle') -or `
                    (((Get-Variable -Name $_.Name).Value).Children[$i].Name -eq 'BottomBorder_Rectangle') -or `
                    (((Get-Variable -Name $_.Name).Value).Children[$i].Name -eq 'LeftBorder_Rectangle') -or `
                    (((Get-Variable -Name $_.Name).Value).Children[$i].Name -eq 'RightBorder_Rectangle'))
                {
                    if ($Script:GUIActions.SelectedMBRPartition -eq $_.Name -or $Script:GUIActions.SelectedAmigaPartition -eq $_.Name ){
                        ((Get-Variable -Name $_.Name).Value).Children[$i].Stroke='Red'
                    } 
                    else{
                        ((Get-Variable -Name $_.Name).Value).Children[$i].Stroke='Black'
                    }
                }
            
            }  
        }
    }

    if (($All) -or ($ShowGrids)){
        if ($Script:GUIActions.SelectedMBRPartition){
            If ((get-variable -name $Script:GUIActions.SelectedMBRPartition).value.PartitionType -eq 'ID76'){
                $WPF_DP_DiskGrid_Amiga.Visibility ='Visible'
                $WPF_DP_GridAmiga.Visibility ='Visible'
                $TotalChildren = $WPF_DP_DiskGrid_Amiga.Children.Count-1
                for ($i = 0; $i -le $TotalChildren; $i++) {
                    $WPF_DP_DiskGrid_Amiga.Children.Remove($WPF_DP_DiskGrid_Amiga.Children[$i])
                }
                $WPF_DP_DiskGrid_Amiga.AddChild(((Get-Variable -Name ($Script:GUIActions.SelectedMBRPartition+'_AmigaDisk')).value))
            }
            else{
                $WPF_DP_DiskGrid_Amiga.Visibility ='Hidden'
                $WPF_DP_GridAmiga.Visibility ='Hidden'
            }
          
        }
        else{
            $WPF_DP_DiskGrid_Amiga.Visibility ='Hidden'
            $WPF_DP_GridAmiga.Visibility ='Hidden'
        }
    }
    
    if (($All) -or ($UpdateInputBoxes)){
        if ($Script:GUIActions.SelectedMBRPartition){
            if (-not $WPF_DP_SelectedSize_Input.InputEntry -eq $true){
                $SizetoReturn =  (Get-ConvertedSize -Size ((get-variable -name $Script:GUIActions.SelectedMBRPartition).value.PartitionSizeBytes) -ScaleFrom 'B' -AutoScale -NumberofDecimalPlaces 2)
                $WPF_DP_SelectedSize_Input.Background = 'White'
                $WPF_DP_SelectedSize_Input.Text = $SizetoReturn.Size
                $WPF_DP_SelectedSize_Input_SizeScale_Dropdown.SelectedItem = $SizetoReturn.Scale
            }
           
            $PartitionsToCheck = Get-AllGUIPartitionBoundaries -MainPartitionWindowGrid  $WPF_Partition -WindowGridMBR  $WPF_DP_GridMBR -WindowGridAmiga $WPF_DP_GridAmiga -DiskGridMBR $WPF_DP_DiskGrid_MBR -DiskGridAmiga $WPF_DP_DiskGrid_Amiga | Where-Object {$_.PartitionType -eq 'MBR'}
                       
            $PartitionToCheck = $PartitionsToCheck | Where-Object {$_.PartitionName -eq $Script:GUIActions.SelectedMBRPartition}
            $SpaceatBeginning = (Get-ConvertedSize -Size $PartitionToCheck.BytesAvailableLeft -ScaleFrom 'B' -AutoScale -NumberofDecimalPlaces 2)
            $SpaceatEnd = (Get-ConvertedSize -Size $PartitionToCheck.BytesAvailableRight -ScaleFrom 'B' -AutoScale -NumberofDecimalPlaces 2)
            $DiskSize = (Get-ConvertedSize -Size $WPF_DP_Disk_MBR.DiskSizeBytes -ScaleFrom 'B' -AutoScale -NumberofDecimalPlaces 2)
            $DiskFreeSpaceSize = (Get-ConvertedSize -Size (($PartitionsToCheck[$PartitionsToCheck.Count-1]).BytesAvailableRight) -ScaleFrom 'B' -AutoScale -NumberofDecimalPlaces 2)
            
            $WPF_DP_SpaceatBeginning_Input.Background = 'White'
            $WPF_DP_SpaceatBeginning_Input.Text = $SpaceatBeginning.Size
            $WPF_DP_SpaceatBeginning_Input_SizeScale_Dropdown.SelectedItem  = $SpaceatBeginning.Scale
            $WPF_DP_SpaceatEnd_Input.Background = 'White'
            $WPF_DP_SpaceatEnd_Input.Text =  $SpaceatEnd.Size
            $WPF_DP_SpaceatEnd_Input_SizeScale_Dropdown.SelectedItem = $SpaceatEnd.Scale         
            $WPF_DP_MBR_TotalDiskSize.Text = "$($DiskSize.Size) $($DiskSize.Scale)"
            $WPF_DP_MBR_TotalFreeSpaceSize.Text = "$($DiskFreeSpaceSize.Size) $($DiskFreeSpaceSize.Scale)" 

            Update-UITextbox -NameofPartition $Script:GUIActions.SelectedMBRPartition -TextBoxControl $WPF_DP_MBR_VolumeName_Input -Value 'VolumeName' -CanChangeParameter 'CanRenameVolume'

        }
        else {
            if ($WPF_DP_GridMBR.Visibility -eq 'Visible'){
                $DiskSize = (Get-ConvertedSize -Size $WPF_DP_Disk_MBR.DiskSizeBytes -ScaleFrom 'B' -AutoScale -NumberofDecimalPlaces 2)
                $PartitionsToCheck = Get-AllGUIPartitionBoundaries -MainPartitionWindowGrid  $WPF_Partition -WindowGridMBR  $WPF_DP_GridMBR -WindowGridAmiga $WPF_DP_GridAmiga -DiskGridMBR $WPF_DP_DiskGrid_MBR -DiskGridAmiga $WPF_DP_DiskGrid_Amiga | Where-Object {$_.PartitionType -eq 'MBR'}
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
        if ($Script:GUIActions.SelectedAmigaPartition){
            if (-not $WPF_DP_Amiga_SelectedSize_Input.InputEntry -eq $true){
                $SizetoReturn =  (Get-ConvertedSize -Size ((get-variable -name $Script:GUIActions.SelectedAmigaPartition).value.PartitionSizeBytes) -ScaleFrom 'B' -AutoScale -NumberofDecimalPlaces 2)
                $WPF_DP_Amiga_SelectedSize_Input.Background = 'White'
                $WPF_DP_Amiga_SelectedSize_Input.Text = $SizetoReturn.Size
                $WPF_DP_Amiga_SelectedSize_Input_SizeScale_Dropdown.SelectedItem = $SizetoReturn.Scale
            }

            $PartitionsToCheck = Get-AllGUIPartitionBoundaries -MainPartitionWindowGrid  $WPF_Partition -WindowGridMBR  $WPF_DP_GridMBR -WindowGridAmiga $WPF_DP_GridAmiga -DiskGridMBR $WPF_DP_DiskGrid_MBR -DiskGridAmiga $WPF_DP_DiskGrid_Amiga | Where-Object {$_.PartitionType -eq 'Amiga' -and $_.PartitionName -match $Script:GUIActions.SelectedMBRPartition}

            $PartitionToCheck = $PartitionsToCheck | Where-Object {$_.PartitionName -eq $Script:GUIActions.SelectedAmigaPartition}
            $SpaceatBeginning = (Get-ConvertedSize -Size $PartitionToCheck.BytesAvailableLeft -ScaleFrom 'B' -AutoScale -NumberofDecimalPlaces 2)
            $SpaceatEnd = (Get-ConvertedSize -Size $PartitionToCheck.BytesAvailableRight -ScaleFrom 'B' -AutoScale -NumberofDecimalPlaces 2)
            $DiskSize = (Get-ConvertedSize -Size ((Get-Variable -name ($Script:GUIActions.SelectedAmigaPartition.Substring(0,($Script:GUIActions.SelectedAmigaPartition.IndexOf('AmigaDisk_Partition_')+9)))).value).DiskSizeBytes -ScaleFrom 'B' -AutoScale -NumberofDecimalPlaces 2)
            $DiskFreeSpaceSize = (Get-ConvertedSize -Size (($PartitionsToCheck[$PartitionsToCheck.Count-1]).BytesAvailableRight) -ScaleFrom 'B' -AutoScale -NumberofDecimalPlaces 2)
            
            $WPF_DP_Amiga_SpaceatBeginning_Input.Background = 'White'
            $WPF_DP_Amiga_SpaceatBeginning_Input.Text = $SpaceatBeginning.Size
            $WPF_DP_Amiga_SpaceatBeginning_Input_SizeScale_Dropdown.SelectedItem  = $SpaceatBeginning.Scale
            $WPF_DP_Amiga_SpaceatEnd_Input.Background = 'White'
            $WPF_DP_Amiga_SpaceatEnd_Input.Text =  $SpaceatEnd.Size
            $WPF_DP_Amiga_TotalDiskSize.Text = "$($DiskSize.Size) $($DiskSize.Scale)"
            $WPF_DP_Amiga_TotalFreeSpaceSize.Text = "$($DiskFreeSpaceSize.Size) $($DiskFreeSpaceSize.Scale)"
            
            $WPF_DP_Amiga_SpaceatEnd_Input_SizeScale_Dropdown.SelectedItem = $SpaceatEnd.Scale
            if ((get-variable -name $Script:GUIActions.SelectedAmigaPartition).value.Bootable -eq $true){
                $WPF_DP_Amiga_Bootable.IsChecked = 'True'
            }
            elseif ((get-variable -name $Script:GUIActions.SelectedAmigaPartition).value.Bootable -eq $false){
                $WPF_DP_Amiga_Bootable.IsChecked = ''
            }
            if ((get-variable -name $Script:GUIActions.SelectedAmigaPartition).value.Mountable -eq $true){
                $WPF_DP_Amiga_Mountable.IsChecked = 'True'
            }
            if ((get-variable -name $Script:GUIActions.SelectedAmigaPartition).value.Mountable -eq $false){
                $WPF_DP_Amiga_Mountable.IsChecked = ''
            }
            
            
            Update-UITextbox -NameofPartition $Script:GUIActions.SelectedAmigaPartition -TextBoxControl $WPF_DP_Amiga_Buffers_Input -Value 'buffers' -CanChangeParameter 'CanChangeBuffers'      
            Update-UITextbox -NameofPartition $Script:GUIActions.SelectedAmigaPartition -TextBoxControl $WPF_DP_Amiga_DeviceName_Input -Value 'DeviceName' -CanChangeParameter 'CanChangeDeviceName'
            Update-UITextbox -NameofPartition $Script:GUIActions.SelectedAmigaPartition -TextBoxControl $WPF_DP_Amiga_VolumeName_Input -Value 'VolumeName' -CanChangeParameter 'CanRenameVolume'
            Update-UITextbox -NameofPartition $Script:GUIActions.SelectedAmigaPartition -TextBoxControl $WPF_DP_Amiga_MaxTransfer_Input -Value 'MaxTransfer' -CanChangeParameter 'CanChangeMaxTransfer'
            Update-UITextbox -NameofPartition $Script:GUIActions.SelectedAmigaPartition -TextBoxControl $WPF_DP_Amiga_Priority_Input -Value 'Priority' -CanChangeParameter 'CanChangePriority'
            Update-UITextbox -NameofPartition $Script:GUIActions.SelectedAmigaPartition -TextBoxControl $WPF_DP_Amiga_Buffers_Input -Value 'buffers' -CanChangeParameter 'CanChangeBuffers'
            Update-UITextbox -NameofPartition $Script:GUIActions.SelectedAmigaPartition -DropdownControl $WPF_DP_Amiga_DosType_Input_Dropdown -Value 'DosType' -CanChangeParameter 'CanChangeDosType'                     
        }    
        else {
            if ($WPF_DP_GridAmiga.Visibility -eq 'Visible'){
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

}

# foreach ($Child in $WPF_DP_DiskGrid_Amiga.Children) {
#     $WPF_DP_DiskGrid_Amiga.Children.Remove($Child)
# }


# $WPF_UI_DiskPartition_Grid_Amiga.Visibility ='Visible'


# $Script:GUIActions.IsAmigaPartitionShowing = $true
# }
# else{
# $WPF_UI_DiskPartition_Grid_Amiga.Visibility = 'Hidden'