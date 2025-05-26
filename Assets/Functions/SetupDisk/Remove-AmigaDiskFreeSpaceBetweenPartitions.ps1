function Remove-AmigaDiskFreeSpaceBetweenPartitions {
    param (

    )
    
    $PartitionstoAdjust = $Script:GUICurrentStatus.AmigaPartitionsandBoundaries | Where-Object {$_.PartitionName -match $Script:GUICurrentStatus.SelectedGPTMBRPartition.PartitionName} | Sort-Object {[int64]$_.StartingPositionBytes}

    $EndingPositionBytesLastPartition = $null
   
    foreach ($Partition in $PartitionstoAdjust){        
        if ($null -ne $EndingPositionBytesLastPartition){
            $StartingPositiontoCheckAgainst = $EndingPositionBytesLastPartition 
        }
        else {
            $StartingPositiontoCheckAgainst = 0
        }
        $AmounttoMoveBytes = $StartingPositiontoCheckAgainst - $Partition.StartingPositionBytes 
        if ($AmounttoMoveBytes -ne 0){
            Set-GUIPartitionNewPosition -Partition $Partition -PartitionType 'Amiga' -AmountMovedBytes $AmounttoMoveBytes
        }
        $EndingPositionBytesLastPartition = (Get-Variable -Name $Partition.PartitionName).value.StartingPositionBytes + (Get-Variable -Name $Partition.PartitionName).value.PartitionSizeBytes
    }

    if ($WPF_DP_Amiga_GroupBox.Visibility -eq 'Visible'){      
        $WPF_DP_DiskGrid_Amiga.UpdateLayout()
        $Script:GUICurrentStatus.AmigaPartitionsandBoundaries = Get-AllGUIPartitionBoundaries -Amiga
    }

}