function Set-GUIPartitionNewSize {
    param (
        $Partition,
        $AmountMoved,
        $ActiontoPerform,
        $PartitionType
    )
    
    # $Partition = $WPF_UI_DiskPartition_Partition_FAT32_1
    # $ActiontoPerform = 'ResizeFromLeft'
    
    $PartitionBoundaries = (Get-GUIPartitionBoundaries -PartitionType $PartitionType -Prefix 'WPF_UI_DiskPartition_Partition_' -ObjecttoCheck $Partition)
    $LeftandRightPartitionBorderWidth = 10
    $CurrentWidth = Get-GUIPartitionWidth -Partition $Partition

    if (($ActiontoPerform -eq 'MBR_ResizeFromLeft') -or ($ActiontoPerform -eq 'Amiga_ResizeFromLeft')) {
        if ($AmountMoved -gt 0){
            if ($AmountMoved -gt ($CurrentWidth - $LeftandRightPartitionBorderWidth)){
                $AmountMoved = ($CurrentWidth - $LeftandRightPartitionBorderWidth)
            }
        }
        
        If ($Partition.Margin.Left + $AmountMoved -lt $PartitionBoundaries.LeftBoundary){
            $AmountMoved = $PartitionBoundaries.LeftBoundary - $Partition.Margin.Left
        }  
        
        $AmounttoSetLeft = $Partition.Margin.Left + $AmountMoved   
        $Partition.Margin = [System.Windows.Thickness]"$AmounttoSetLeft,0,0,0"

        $TotalColumns = $Partition.ColumnDefinitions.Count-1
        for ($i = 0; $i -le $TotalColumns; $i++) {
            if  ($Partition.ColumnDefinitions[$i].Name -eq 'FullSpace'){
                $Partition.ColumnDefinitions[$i].Width = $Partition.ColumnDefinitions[$i].Width.Value - $AmountMoved
            } 
        }
    
    }

    elseif (($ActiontoPerform -eq 'MBR_ResizeFromRight') -or ($ActiontoPerform -eq 'Amiga_ResizeFromRight')){
        # Write-host "Amount Moved: $AmountMoved" 
        # Write-host "Current Width: $CurrentWidth"
        # Write-host "Right Boundary: $($PartitionBoundaries.RightBoundary)"
        # Write-host "Margin Left: $($Partition.Margin.Left)"
        if ($AmountMoved -lt 0){
            if ([math]::abs($AmountMoved) -gt ($CurrentWidth - $LeftandRightPartitionBorderWidth)){
                $AmountMoved = (($CurrentWidth - $LeftandRightPartitionBorderWidth)*-1)
            }
        }

        if ($Partition.Margin.Left + $CurrentWidth + $AmountMoved -gt $PartitionBoundaries.RightBoundary){
            $AmountMoved = $PartitionBoundaries.RightBoundary - $Partition.Margin.Left - $CurrentWidth
        }

        $TotalColumns = $Partition.ColumnDefinitions.Count-1
        for ($i = 0; $i -le $TotalColumns; $i++) {
            if  ($Partition.ColumnDefinitions[$i].Name -eq 'FullSpace'){
                $Partition.ColumnDefinitions[$i].Width = $Partition.ColumnDefinitions[$i].Width.Value + $AmountMoved
            } 
        }

    }

}
