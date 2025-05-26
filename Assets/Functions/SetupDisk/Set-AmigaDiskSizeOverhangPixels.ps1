function Set-AmigaDiskSizeOverhangPixels {
    param (
        $AmigaDiskName
    )
    
    # #$AmigaDiskName = 'WPF_DP_Partition_MBR_3_AmigaDisk'
    
    # # Write-debug "AmigaDiskName is: $AmigaDiskName"

    # $TotalPartitions = (Get-AllGUIPartitions -PartitionType 'Amiga' | Where-Object {$_.Name -match $AmigaDiskName}).Count
    
    # $PartitionstoCheck = (Get-AllGUIPartitionBoundaries -GPTMBR -Amiga | Where-Object {$_.PartitionName -match $AmigaDiskName })

    # $AmounttoMovePartitionPixelsAccumulated = 0

    # $PartitionstoCheck | ForEach-Object {
    #     if ($_.OverhangPixels -ge 0){
    #         $NewWidth = $_.ExpectedWidth - 4
    #         $AmounttoSetLeft = (Get-Variable -Name $_.PartitionName).value.Margin.Left + $AmounttoMovePartitionPixelsAccumulated 
    #         # Write-debug "Amount to shift $AmounttoMovePartitionPixelsAccumulated. Setting left to $AmounttoSetLeft from $((Get-Variable -Name $_.PartitionName).value.Margin.Left)"
    #         (Get-Variable -Name $_.PartitionName).value.Margin = [System.Windows.Thickness]"$AmounttoSetLeft,0,0,0"
    #         if ($NewWidth -gt 0){  
    #             $AmounttoMovePartitionPixelsAccumulated -= $_.OverhangPixels    
    #             $TotalColumns = (Get-Variable -Name $_.PartitionName).value.ColumnDefinitions.Count-1
    #             for ($i = 0; $i -le $TotalColumns; $i++) {
    #                 if  ((Get-Variable -Name $_.PartitionName).value.ColumnDefinitions[$i].Name -eq 'FullSpace'){
    #                     # Write-debug "Old width is: $((Get-Variable -Name $_.PartitionName).value.ColumnDefinitions[$i].Width) New width to set is: $NewWidth"
    #                     (Get-Variable -Name $_.PartitionName).value.ColumnDefinitions[$i].Width = $NewWidth
    #                 }
    #             }
    #         }
            
    #     }
    # }

    # $PartitionstoCheck = (Get-AllGUIPartitionBoundaries -GPTMBR -Amiga | Where-Object {$_.PartitionName -match $AmigaDiskName})

    # $OverhangPixels = $PartitionstoCheck[$TotalPartitions-1].OverhangPixelsAccumulated
    
    # if ($OverhangPixels -gt 0){
    #     $NewWidth = $Script:Settings.DiskWidthPixels + $OverhangPixels    
    #     # Write-debug "Old width of disk is: $(((Get-Variable -name $AmigaDiskName).Value).Children[0].Width) New Width is: $NewWidth "
    #     ((Get-Variable -name $AmigaDiskName).Value).Children[0].Width = $NewWidth       
    #     (Get-Variable -name $AmigaDiskName).Value.RightDiskBoundary = $NewWidth 
    # }
    # else {
    #     # Write-debug "No overhang of pixels"
    # }

}

