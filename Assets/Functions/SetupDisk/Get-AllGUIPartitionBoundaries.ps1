function Get-AllGUIPartitionBoundaries {
    param (

    )
    
    $DiskPartitionGridMargins = $WPF_Partition.Margin

    $GroupBoxGPTMBRMargins = $WPF_DP_GPTMBR_GroupBox.Margin
    $DiskGridGPTMBRMargins = $WPF_DP_DiskGrid_GPTMBR.Margin

    $GroupBoxAmigaMargins = $WPF_DP_Amiga_GroupBox.Margin
    $DiskGridAmigaMargins = $WPF_DP_DiskGrid_Amiga.Margin

    $GPTMBRLeftMargin = $DiskPartitionGridMargins.Left + $GroupBoxGPTMBRMargins.Left + $DiskGridGPTMBRMargins.Left
    $GPTMBRTopMargin = $DiskPartitionGridMargins.Top + $GroupBoxGPTMBRMargins.Top + $DiskGridGPTMBRMargins.Top

    $AmigaLeftMargin = $DiskPartitionGridMargins.Left + $GroupBoxAmigaMargins.Left + $DiskGridAmigaMargins.Left 
    $AmigaTopMargin = $DiskPartitionGridMargins.Top + $GroupBoxAmigaMargins.Top + $DiskGridAmigaMargins.Top 

    $AllPartitionBoundaries_MBR = [System.Collections.Generic.List[PSCustomObject]]::New()
    $AllPartitionBoundaries_Amiga = [System.Collections.Generic.List[PSCustomObject]]::New()
    $AllPartitionBoundaries = [System.Collections.Generic.List[PSCustomObject]]::New()

    Get-AllGUIPartitions -PartitionType 'Amiga' | ForEach-Object {
        $PartitionType = 'Amiga'
        $LeftMarginWindow = $AmigaLeftMargin + $_.Value.Margin.Left
        $TopMarginWindow = $AmigaTopMargin 
        $RightMarginWindow = $AmigaLeftMargin + $_.Value.Margin.Left + (Get-GUIPartitionWidth -Partition $_.Value)
        $BottomMarginWindow = $AmigaTopMargin  + $_.Value.ActualHeight

        $AllPartitionBoundaries_Amiga += [PSCustomObject]@{
            PartitionName = $_.Name
            PartitionType = $PartitionType
            ImportedPartition = $_.Value.ImportedPartition
            ImportedPartitionMethod = $_.Value.ImportedPartitionMethod
            ImportedFilesPath = $_.Value.ImportedFilesPath 
            ImportedPartitionPath = $_.Value.ImportedPartitionPath
            CanMove = $_.Value.CanMove
            CanDelete = $_.Value.CanDelete
            CanResizeLeft = $_.Value.CanResizeLeft
            CanResizeRight = $_.Value.CanResizeRight
            BytesAvailableLeft = $null
            BytesAvailableRight = $null
            PixelsAvailableLeft = $null
            PixelsAvailableRight = $null
            StartingPositionBytes = $_.Value.StartingPositionBytes
            PartitionSizeBytes = $_.Value.PartitionSizeBytes
            EndingPositionBytes = $_.Value.StartingPositionBytes + $_.Value.PartitionSizeBytes
            LeftMargin = $_.Value.Margin.Left
            LeftMarginWindow = $LeftMarginWindow
            Width = Get-GUIPartitionWidth -Partition $_.Value 
            RightMargin = ($_.Value.Margin.Left) + (Get-GUIPartitionWidth -Partition $_.Value)
            RightMarginWindow = $RightMarginWindow
            TopMargin = $_.Value.Margin.Top
            TopMarginWindow = $TopMarginWindow
            Height = $_.Value.ActualHeight
            BottomMargin = $_.Value.Margin.Top + $_.Value.ActualHeight
            BottomMarginWindow = $BottomMarginWindow
        }
    }

    Get-AllGUIPartitions -PartitionType 'MBR' | ForEach-Object {   
        $PartitionType = 'MBR'
        $LeftMarginWindow = $GPTMBRLeftMargin + $_.Value.Margin.Left
        $TopMarginWindow = $GPTMBRTopMargin 
        $RightMarginWindow = $GPTMBRLeftMargin + $_.Value.Margin.Left + (Get-GUIPartitionWidth -Partition $_.Value)
        $BottomMarginWindow = $GPTMBRTopMargin  + $_.Value.ActualHeight

        $AllPartitionBoundaries_MBR += [PSCustomObject]@{
            PartitionName = $_.Name
            PartitionType = $PartitionType
            PartitionSubType = $_.Value.PartitionSubType
            ImportedPartition = $_.Value.ImportedPartition
            ImportedPartitionMethod = $_.Value.ImportedPartitionMethod
            ImportedFilesPath = $_.Value.ImportedFilesPath 
            ImportedPartitionPath = $_.Value.ImportedPartitionPath
            CanMove = $_.Value.CanMove
            CanDelete = $_.Value.CanDelete
            CanResizeLeft = $_.Value.CanResizeLeft
            CanResizeRight = $_.Value.CanResizeRight
            BytesAvailableLeft = $null
            BytesAvailableRight = $null
            PixelsAvailableLeft = $null
            PixelsAvailableRight = $null
            StartingPositionBytes = $_.Value.StartingPositionBytes
            StartingPositionSector = $_.Value.StartingPositionSector
            PartitionSizeBytes = $_.Value.PartitionSizeBytes
            EndingPositionBytes = $_.Value.StartingPositionBytes + $_.Value.PartitionSizeBytes
            LeftMargin = $_.Value.Margin.Left
            LeftMarginWindow = $LeftMarginWindow
            Width = Get-GUIPartitionWidth -Partition $_.Value 
            RightMargin = ($_.Value.Margin.Left) + (Get-GUIPartitionWidth -Partition $_.Value)
            RightMarginWindow = $RightMarginWindow
            TopMargin = $_.Value.Margin.Top
            TopMarginWindow = $TopMarginWindow
            Height = $_.Value.ActualHeight
            BottomMargin = $_.Value.Margin.Top + $_.Value.ActualHeight
            BottomMarginWindow = $BottomMarginWindow
        }
    }


    $AllPartitionBoundaries_MBR = @($AllPartitionBoundaries_MBR | Sort-Object {$_.LeftMargin} | Sort-Object {$_.PartitionName})

    for ($i = 0; $i -lt $AllPartitionBoundaries_MBR.Count; $i++) {
        if ($i -eq 0){
            $AllPartitionBoundaries_MBR[$i].BytesAvailableLeft = $AllPartitionBoundaries_MBR[$i].StartingPositionBytes
            $AllPartitionBoundaries_MBR[$i].PixelsAvailableLeft = $AllPartitionBoundaries_MBR[$i].LeftMargin
        }
        else{
            $AllPartitionBoundaries_MBR[$i].BytesAvailableLeft = $AllPartitionBoundaries_MBR[$i].StartingPositionBytes - $AllPartitionBoundaries_MBR[$i-1].EndingPositionBytes
            $AllPartitionBoundaries_MBR[$i].PixelsAvailableLeft = $AllPartitionBoundaries_MBR[$i].LeftMargin - $AllPartitionBoundaries_MBR[$i-1].RightMargin
        }
        if (($i+1) -lt $AllPartitionBoundaries_MBR.Count){
            $AllPartitionBoundaries_MBR[$i].PixelsAvailableRight = $AllPartitionBoundaries_MBR[$i+1].LeftMargin-$AllPartitionBoundaries_MBR[$i].RightMargin
            $AllPartitionBoundaries_MBR[$i].BytesAvailableRight = $AllPartitionBoundaries_MBR[$i+1].StartingPositionBytes-$AllPartitionBoundaries_MBR[$i].EndingPositionBytes
        }
        else{
            $AllPartitionBoundaries_MBR[$i].PixelsAvailableRight = $WPF_DP_Disk_GPTMBR.RightDiskBoundary - $AllPartitionBoundaries_MBR[$i].RightMargin
            $AllPartitionBoundaries_MBR[$i].BytesAvailableRight =  $WPF_DP_Disk_GPTMBR.DiskSizeBytes - $WPF_DP_Disk_GPTMBR.MBROverheadBytes - $AllPartitionBoundaries_MBR[$i].EndingPositionBytes
        }                  
     }


    $AllPartitionBoundaries_Amiga = @($AllPartitionBoundaries_Amiga | Sort-Object {$_.LeftMargin} | Sort-Object {$_.PartitionName})

    $AmigaDisks = (get-variable | Where-Object {$_.Value.DiskType -eq 'Amiga'}).Name  
    
    foreach ($AmigaDisk in $AmigaDisks) {
        $FirstPartition_Amiga = $true
        for ($i = 0; $i -lt $AllPartitionBoundaries_Amiga.Count; $i++){
            if ($AllPartitionBoundaries_Amiga[$i].PartitionName -match $AmigaDisk){
                if ($FirstPartition_Amiga -eq $true){
                    $AllPartitionBoundaries_Amiga[$i].BytesAvailableLeft = $AllPartitionBoundaries_Amiga[$i].StartingPositionBytes
                    $AllPartitionBoundaries_Amiga[$i].PixelsAvailableLeft = $AllPartitionBoundaries_Amiga[$i].LeftMargin
                    $FirstPartition_Amiga = $false
                }
                else{
                    $AllPartitionBoundaries_Amiga[$i].BytesAvailableLeft = $AllPartitionBoundaries_Amiga[$i].StartingPositionBytes - $AllPartitionBoundaries_Amiga[$i-1].EndingPositionBytes
                    $AllPartitionBoundaries_Amiga[$i].PixelsAvailableLeft = $AllPartitionBoundaries_Amiga[$i].LeftMargin - $AllPartitionBoundaries_Amiga[$i-1].RightMargin
                }
                if ((($i+1) -lt $AllPartitionBoundaries_Amiga.Count) -and ($AllPartitionBoundaries_Amiga[$i+1].PartitionName -match $AmigaDisk)){
                    $AllPartitionBoundaries_Amiga[$i].PixelsAvailableRight = $AllPartitionBoundaries_Amiga[$i+1].LeftMargin-$AllPartitionBoundaries_Amiga[$i].RightMargin
                    $AllPartitionBoundaries_Amiga[$i].BytesAvailableRight = $AllPartitionBoundaries_Amiga[$i+1].StartingPositionBytes-$AllPartitionBoundaries_Amiga[$i].EndingPositionBytes
                }
                else{
                    $AllPartitionBoundaries_Amiga[$i].PixelsAvailableRight = (Get-Variable -name $AmigaDisk).Value.RightDiskBoundary - $AllPartitionBoundaries_Amiga[$i].RightMargin
                    $AllPartitionBoundaries_Amiga[$i].BytesAvailableRight =  (Get-Variable -name $AmigaDisk).Value.DiskSizeBytes - $AllPartitionBoundaries_Amiga[$i].EndingPositionBytes
                }
            }
        }
    }

    $AllPartitionBoundaries += $AllPartitionBoundaries_MBR
    $AllPartitionBoundaries += $AllPartitionBoundaries_Amiga
  
    return $AllPartitionBoundaries

}

# Get-AllGUIPartitionBoundaries 
