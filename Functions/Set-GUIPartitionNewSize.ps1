function Set-GUIPartitionNewSize {
    param (
        $Partition,
        $AmountMoved,
        $ActiontoPerform
    )
    
    # $Partition = $WPF_UI_DiskPartition_Partition_FAT32_1
    # $ActiontoPerform = 'ResizeFromLeft'
    
    $PartitionBoundaries = (Get-GUIPartitionBoundaries -Prefix 'WPF_UI_DiskPartition_Partition_' -ObjecttoCheck $Partition)
    $LeftandRightPartitionBorderWidth = 10
    $CurrentWidth = Get-MBRPartitionWidth -MBRPartition $Partition

    if ($ActiontoPerform -eq 'ResizeFromLeft'){
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

    elseif ($ActiontoPerform -eq 'ResizeFromRight'){
        Write-host 'ResizeFromRight'
        if ($AmountMoved -lt 0){
            if ([math]::abs($AmountMoved) -gt ($CurrentWidth - $LeftandRightPartitionBorderWidth)){
                $AmountMoved = (($CurrentWidth - $LeftandRightPartitionBorderWidth)*-1)
            }
        }

        if ($Partition.Margin.Left + $CurrentWidth + $AmountMoved -gt $PartitionBoundaries.RightBoundary){
            $AmountMoved = $PartitionBoundaries.LeftBoundary - $Partition.Margin.Left - $CurrentWidth
        }

        $TotalColumns = $Partition.ColumnDefinitions.Count-1
        for ($i = 0; $i -le $TotalColumns; $i++) {
            if  ($Partition.ColumnDefinitions[$i].Name -eq 'FullSpace'){
                $Partition.ColumnDefinitions[$i].Width = $Partition.ColumnDefinitions[$i].Width.Value + $AmountMoved
            } 
        }

    }

}
