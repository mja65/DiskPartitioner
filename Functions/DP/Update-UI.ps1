function Update-UI {
    param (
    )

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
        $SizetoReturn =  (Get-ConvertedSize -Size ((get-variable -name $Script:GUIActions.SelectedMBRPartition).value.PartitionSizeBytes) -ScaleFrom 'B' -AutoScale -NumberofDecimalPlaces 2)
        $WPF_DP_SelectedSize_Value.Text = $SizetoReturn.Size
        $WPF_DP_SelectedSize_Label.Text = "Selected Partition Size ($($SizetoReturn.Scale))"
        $WPF_DP_SelectedSize_Input_DiskSizeScale_Dropdown.SelectedItem = $SizetoReturn.Scale

        $PartitionToCheck = Get-AllGUIPartitionBoundaries -MainPartitionWindowGrid  $WPF_Partition -WindowGridMBR  $WPF_DP_GridMBR -WindowGridAmiga $WPF_DP_GridAmiga -DiskGridMBR $WPF_DP_DiskGrid_MBR -DiskGridAmiga $WPF_DP_DiskGrid_Amiga | Where-Object {$_.PartitionName -eq $Script:GUIActions.SelectedMBRPartition}
        $SpaceatBeginning = (Get-ConvertedSize -Size $PartitionToCheck.BytesAvailableLeft -ScaleFrom 'B' -AutoScale -NumberofDecimalPlaces 2)
        $WPF_DP_SpaceatBeginning_Input.Text = $SpaceatBeginning.Size
        $WPF_DP_SpaceatBeginning_Input_DiskSizeScale_Dropdown.SelectedItem  = $SpaceatBeginning.Scale

    }
    else{
        $WPF_DP_DiskGrid_Amiga.Visibility ='Hidden'
        $WPF_DP_GridAmiga.Visibility ='Hidden'
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