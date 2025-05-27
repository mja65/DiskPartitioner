function Set-AmigaDiskSizeOverhangPixels {
    param (
        $AmigaDiskName
    )
    
    # $AmigaDiskName = 'WPF_DP_Partition_MBR_2_AmigaDisk'
    
   #Write-debug "AmigaDiskName is: $AmigaDiskName"

   if (-not ($Script:GUICurrentStatus.AmigaPartitionsandBoundaries)){
    return
   } 


    $TotalPartitions = ($Script:GUICurrentStatus.AmigaPartitionsandBoundaries | Where-Object {$_.PartitionName -match $AmigaDiskName}).Count
    
    $PartitionstoCheck = ($Script:GUICurrentStatus.AmigaPartitionsandBoundaries | Where-Object {$_.PartitionName -match $AmigaDiskName })

    $AmounttoMovePartitionPixelsAccumulated = 0

    $Changes = $false

    $PartitionstoCheck | ForEach-Object {
        if ($_.OverhangPixels -ge 0){
            $NewWidth = $_.ExpectedWidth - 4
            if ([math]::Round($AmounttoMovePartitionPixelsAccumulated,4) -ne 0){
                $AmounttoSetLeft = $_.Partition.Margin.Left + $AmounttoMovePartitionPixelsAccumulated 
                $Changes = $true
                #Write-debug "Amount to shift $AmounttoMovePartitionPixelsAccumulated. Setting left to $AmounttoSetLeft from $($_.Partition.Margin.Left)"
                $_.Partition.Margin = [System.Windows.Thickness]"$AmounttoSetLeft,0,0,0"

            }
            if ($NewWidth -gt 0){  
                $AmounttoMovePartitionPixelsAccumulated -= $_.OverhangPixels  
                $Difference = [math]::Round([math]::Abs($NewWidth -  $($_.Partition.ColumnDefinitions[1].Width.Value)),4)   
                if ($Difference -ne 0){
                    $Changes = $true
                    #Write-debug "Old width is: $($_.Partition.ColumnDefinitions[$i].Width) New width to set is: $NewWidth. Difference is $Difference"
                    $_.Partition.ColumnDefinitions[1].Width = $NewWidth
                }            
            }
            
        }
    }

    if ($Changes -eq  $true){
        $Script:GUICurrentStatus.AmigaPartitionsandBoundaries = @(Get-AllGUIPartitionBoundaries -Amiga)
    }

    $PartitionstoCheck = ($Script:GUICurrentStatus.AmigaPartitionsandBoundaries | Where-Object {$_.PartitionName -match $AmigaDiskName })

    $OverhangPixels = $PartitionstoCheck[$TotalPartitions-1].OverhangPixelsAccumulated

    $Changes = $false
    
    if ($OverhangPixels -gt 0){
        $Changes = $true
        $NewWidth = $Script:Settings.DiskWidthPixels + $OverhangPixels    
        #Write-debug "Old width of disk is: $(((Get-Variable -name $AmigaDiskName).Value).Children[0].Width) New Width is: $NewWidth "
        ((Get-Variable -name $AmigaDiskName).Value).Children[0].Width = $NewWidth       
        (Get-Variable -name $AmigaDiskName).Value.RightDiskBoundary = $NewWidth 
    }
    else {
        #Write-debug "No overhang of pixels"
    }

    if ($Changes -eq  $true){
        $Script:GUICurrentStatus.AmigaPartitionsandBoundaries = @(Get-AllGUIPartitionBoundaries -Amiga)
    }

    
}

