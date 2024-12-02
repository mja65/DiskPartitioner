function Update-UI {
    param (
        [Switch]$All,
        [Switch]$HighlightSelectedPartitions,
        [Switch]$ShowGrids,
        [Switch]$UpdateInputBoxes
    )
   
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
                $WPF_DP_SelectedSize_Label.Text = "Selected Partition Size ($($SizetoReturn.Scale))"
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
            

        }
        if ($Script:GUIActions.SelectedAmigaPartition){
            if (-not $WPF_DP_Amiga_SelectedSize_Input.InputEntry -eq $true){
                $SizetoReturn =  (Get-ConvertedSize -Size ((get-variable -name $Script:GUIActions.SelectedAmigaPartition).value.PartitionSizeBytes) -ScaleFrom 'B' -AutoScale -NumberofDecimalPlaces 2)
                $WPF_DP_Amiga_SelectedSize_Input.Background = 'White'
                $WPF_DP_Amiga_SelectedSize_Input.Text = $SizetoReturn.Size
                $WPF_DP_Amiga_SelectedSize_Label.Text = "Selected Partition Size ($($SizetoReturn.Scale))"
                $WPF_DP_Amiga_SelectedSize_Input_SizeScale_Dropdown.SelectedItem = $SizetoReturn.Scale
            }

            $PartitionToCheck = Get-AllGUIPartitionBoundaries -MainPartitionWindowGrid  $WPF_Partition -WindowGridMBR  $WPF_DP_GridMBR -WindowGridAmiga $WPF_DP_GridAmiga -DiskGridMBR $WPF_DP_DiskGrid_MBR -DiskGridAmiga $WPF_DP_DiskGrid_Amiga | Where-Object {$_.PartitionName -eq $Script:GUIActions.SelectedAmigaPartition}
            $SpaceatBeginning = (Get-ConvertedSize -Size $PartitionToCheck.BytesAvailableLeft -ScaleFrom 'B' -AutoScale -NumberofDecimalPlaces 2)
            $SpaceatEnd = (Get-ConvertedSize -Size $PartitionToCheck.BytesAvailableRight -ScaleFrom 'B' -AutoScale -NumberofDecimalPlaces 2)
            $WPF_DP_Amiga_SpaceatBeginning_Input.Background = 'White'
            $WPF_DP_Amiga_SpaceatBeginning_Input.Text = $SpaceatBeginning.Size
            $WPF_DP_Amiga_SpaceatBeginning_Input_SizeScale_Dropdown.SelectedItem  = $SpaceatBeginning.Scale
            $WPF_DP_Amiga_SpaceatEnd_Input.Background = 'White'
            $WPF_DP_Amiga_SpaceatEnd_Input.Text =  $SpaceatEnd.Size
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
            Update-UITextbox -NameofPartition $Script:GUIActions.SelectedAmigaPartition -TextBoxControl $WPF_DP_Amiga_VolumeName_Input -Value 'VolumeName' -CanChangeParameter 'CanChangeVolumeName'
            Update-UITextbox -NameofPartition $Script:GUIActions.SelectedAmigaPartition -TextBoxControl $WPF_DP_Amiga_MaxTransfer_Input -Value 'MaxTransfer' -CanChangeParameter 'CanChangeMaxTransfer'
            Update-UITextbox -NameofPartition $Script:GUIActions.SelectedAmigaPartition -TextBoxControl $WPF_DP_Amiga_Priority_Input -Value 'Priority' -CanChangeParameter 'CanChangePriority'
            Update-UITextbox -NameofPartition $Script:GUIActions.SelectedAmigaPartition -TextBoxControl $WPF_DP_Amiga_Buffers_Input -Value 'buffers' -CanChangeParameter 'CanChangeBuffers'
            Update-UITextbox -NameofPartition $Script:GUIActions.SelectedAmigaPartition -DropdownControl $WPF_DP_Amiga_DosType_Input_Dropdown -Value 'DosType' -CanChangeParameter 'CanChangeDosType'                     
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