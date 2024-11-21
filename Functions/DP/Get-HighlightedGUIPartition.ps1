function Get-HighlightedGUIPartition {
    param (
        $MouseX,
        $MouseY
    )
    
    # $MouseX = 344
    # $MouseY = 470

    $PartitionInformationtoReturn = [PSCustomObject]@{
        DiskName = $null
        PartitionName = $null
        PartitionType = $null
        ResizeZone = $null
    }
    
    $PartitionDetails = Get-AllGUIPartitionBoundaries -MainPartitionWindowGrid  $WPF_Partition -WindowGridMBR  $WPF_DP_GridMBR -WindowGridAmiga $WPF_DP_GridAmiga -DiskGridMBR $WPF_DP_DiskGrid_MBR -DiskGridAmiga $WPF_DP_DiskGrid_Amiga 
    $FoundPartition = $null

    if ($Script:GUIActions.SelectedMBRPartition -or $Script:GUIActions.SelectedAmigaPartition){
        $PixelBuffer = 5
    }

    foreach ($Partition in $PartitionDetails) {
        if (($Partition.PartitionName -eq $Script:GUIActions.SelectedMBRPartition) -or ($Partition.PartitionName -eq $Script:GUIActions.SelectedAmigaPartition)){
            if ($MouseY -ge $Partition.TopMarginWindow -and $MouseY -le $Partition.BottomMarginWindow -and $MouseX -ge ($Partition.LeftMarginWindow - $PixelBuffer) -and $MouseX -le ($Partition.RightMarginWindow + $PixelBuffer)){   
                $FoundPartition = $true
                $PartitionInformationtoReturn.PartitionName = $Partition.PartitionName
                $PartitionInformationtoReturn.PartitionType = $Partition.PartitionType
                if ($Partition.PartitionType -eq 'MBR'){
                    $PartitionInformationtoReturn.DiskName = 'WPF_DP_Disk_MBR'
                }
                elseif ($Partition.PartitionType -eq 'Amiga'){
                    $PartitionInformationtoReturn.DiskName =  ($Partition.PartitionName.Substring(0,($Partition.PartitionName.IndexOf('_AmigaDisk_Partition_')+10)))
                }
                if (($MouseX -ge ($Partition.LeftMarginWindow - $PixelBuffer)) -and ($MouseX -le ($Partition.LeftMarginWindow + $PixelBuffer))){
                    $PartitionInformationtoReturn.ResizeZone = 'ResizeFromLeft'
                }
                elseif($MouseX -ge ($Partition.RightMarginWindow - $PixelBuffer) -and $MouseX -le ($Partition.RightMarginWindow + $PixelBuffer)){
                    $PartitionInformationtoReturn.ResizeZone = 'ResizeFromRight'
                }
            }
            
        }        
    }

    if ($FoundPartition -eq $true){
        return $PartitionInformationtoReturn
    }
    else{
        foreach ($Partition in $PartitionDetails) {
            if (($Partition.PartitionType -eq 'MBR') -or (($Script:GUIActions.SelectedMBRPartition) -and $Partition.PartitionType -eq 'Amiga' -and  $Partition.PartitionName -match $Script:GUIActions.SelectedMBRPartition)){
                if ($MouseY -ge $Partition.TopMarginWindow -and $MouseY -le $Partition.BottomMarginWindow -and $MouseX -ge $Partition.LeftMarginWindow -and $MouseX -le $Partition.RightMarginWindow){
                        $PartitionInformationtoReturn.PartitionName = $Partition.PartitionName
                        $PartitionInformationtoReturn.PartitionType = $Partition.PartitionType
                        if ($Partition.PartitionType -eq 'MBR'){
                            $PartitionInformationtoReturn.DiskName = 'WPF_DP_Disk_MBR'
                        }
                        elseif ($Partition.PartitionType -eq 'Amiga'){
                            $PartitionInformationtoReturn.DiskName =  ($Partition.PartitionName.Substring(0,($Partition.PartitionName.IndexOf('_AmigaDisk_Partition_')+10)))
                        }
                        return $PartitionInformationtoReturn
                }
            }
        }
    }
    return
}

