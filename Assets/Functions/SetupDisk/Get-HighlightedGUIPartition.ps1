function Get-HighlightedGUIPartition {
    param (
        $MouseX,
        $MouseY
    )
    
    # $MouseX = 660
    # $MouseY = 613

    $PartitionInformationtoReturn = [PSCustomObject]@{
        DiskName = $null
        PartitionName = $null
        PartitionType = $null
        PartitionSubType = $null
        ResizeZone = $null
    }

   # $PartitionDetails = Get-AllGUIPartitionBoundaries -Amiga -GPTMBR 
    $PartitionDetails = ($Script:GUICurrentStatus.AmigaPartitionsandBoundaries + $Script:GUICurrentStatus.GPTMBRPartitionsandBoundaries)

    $FoundPartition = $null

    $PixelBuffer = 0
    if ($Script:GUICurrentStatus.SelectedGPTMBRPartition -or $Script:GUICurrentStatus.SelectedAmigaPartition){
        $PixelBuffer = $Script:Settings.PartitionPixelBuffer
    }

    foreach ($Partition in $PartitionDetails) {
        if (($Partition.PartitionName -eq $Script:GUICurrentStatus.SelectedGPTMBRPartition) -or ($Partition.PartitionName -eq $Script:GUICurrentStatus.SelectedAmigaPartition)){
            if ($MouseY -ge $Partition.TopMarginWindow -and $MouseY -le $Partition.BottomMarginWindow -and $MouseX -ge ($Partition.LeftMarginWindow - $PixelBuffer) -and $MouseX -le ($Partition.RightMarginWindow + $PixelBuffer)){   
                $FoundPartition = $true
                $PartitionInformationtoReturn.PartitionName = $Partition.PartitionName
                $PartitionInformationtoReturn.PartitionType = $Partition.PartitionType
                $PartitionInformationtoReturn.PartitionSubType = $Partition.PartitionSubType
                if ($Partition.PartitionType -eq 'MBR'){
                    $PartitionInformationtoReturn.DiskName = 'WPF_DP_Disk_GPTMBR'
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
            if (($Partition.PartitionType -eq 'MBR') -or (($Script:GUICurrentStatus.SelectedGPTMBRPartition) -and $Partition.PartitionType -eq 'Amiga' -and  $Partition.PartitionName -match $Script:GUICurrentStatus.SelectedGPTMBRPartition)){
                if ($MouseY -ge $Partition.TopMarginWindow -and $MouseY -le $Partition.BottomMarginWindow -and $MouseX -ge $Partition.LeftMarginWindow -and $MouseX -le $Partition.RightMarginWindow){
                        $PartitionInformationtoReturn.PartitionName = $Partition.PartitionName
                        $PartitionInformationtoReturn.PartitionType = $Partition.PartitionType
                        if ($Partition.PartitionType -eq 'MBR'){
                            $PartitionInformationtoReturn.DiskName = 'WPF_DP_Disk_GPTMBR'
                        }
                        elseif ($Partition.PartitionType -eq 'Amiga'){
                            $PartitionInformationtoReturn.DiskName =  ($Partition.PartitionName.Substring(0,($Partition.PartitionName.IndexOf('_AmigaDisk_Partition_')+10)))
                        }
                       # Write-host "Highlighted partition is $PartitionInformationtoReturn"
                        return $PartitionInformationtoReturn
                }
            }
        }
    }
    return
}

