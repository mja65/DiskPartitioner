function Set-AmigaDiskSizeOverhangPixels {
    param (
        $AmigaDiskName
    )
    
    # $AmigaDiskName = 'WPF_DP_Partition_MBR_2_AmigaDisk'
    
    # Write-debug "AmigaDiskName is: $AmigaDiskName"

    $TotalPartitions = ($Script:GUICurrentStatus.AmigaPartitionsandBoundaries | Where-Object {$_.PartitionName -match $AmigaDiskName}).Count
    
    $PartitionstoCheck = ($Script:GUICurrentStatus.AmigaPartitionsandBoundaries | Where-Object {$_.PartitionName -match $AmigaDiskName })

    $AmounttoMovePartitionPixelsAccumulated = 0

    $PartitionstoCheck | ForEach-Object {
        if ($_.OverhangPixels -ge 0){
            $NewWidth = $_.ExpectedWidth - 4
            $AmounttoSetLeft = $_.Partition.Margin.Left + $AmounttoMovePartitionPixelsAccumulated 
            # Write-debug "Amount to shift $AmounttoMovePartitionPixelsAccumulated. Setting left to $AmounttoSetLeft from $($_.Partition.Margin.Left)"
            $_.Partition.Margin = [System.Windows.Thickness]"$AmounttoSetLeft,0,0,0"
            if ($NewWidth -gt 0){  
                $AmounttoMovePartitionPixelsAccumulated -= $_.OverhangPixels    
                $TotalColumns = $_.Partition.ColumnDefinitions.Count-1
                for ($i = 0; $i -le $TotalColumns; $i++) {
                    if  ($_.Partition.ColumnDefinitions[$i].Name -eq 'FullSpace'){
                        # Write-debug "Old width is: $($_.Partition.ColumnDefinitions[$i].Width) New width to set is: $NewWidth"
                        $_.Partition.ColumnDefinitions[$i].Width = $NewWidth
                    }
                }
            }
            
        }
    }

    $Script:GUICurrentStatus.AmigaPartitionsandBoundaries = Get-AllGUIPartitionBoundaries -Amiga

    $PartitionstoCheck = ($Script:GUICurrentStatus.AmigaPartitionsandBoundaries | Where-Object {$_.PartitionName -match $AmigaDiskName })

    $OverhangPixels = $PartitionstoCheck[$TotalPartitions-1].OverhangPixelsAccumulated
    
    if ($OverhangPixels -gt 0){
        $NewWidth = $Script:Settings.DiskWidthPixels + $OverhangPixels    
        # Write-debug "Old width of disk is: $(((Get-Variable -name $AmigaDiskName).Value).Children[0].Width) New Width is: $NewWidth "
        ((Get-Variable -name $AmigaDiskName).Value).Children[0].Width = $NewWidth       
        (Get-Variable -name $AmigaDiskName).Value.RightDiskBoundary = $NewWidth 
    }
    else {
        # Write-debug "No overhang of pixels"
    }

    $Script:GUICurrentStatus.AmigaPartitionsandBoundaries = Get-AllGUIPartitionBoundaries -Amiga
    
}

