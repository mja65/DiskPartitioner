function Get-AllGUIPartitions {
    param (
        $PartitionType
    )
    
    #$PartitionType = 'MBR'
    If ($PartitionType -eq 'All'){
        $ListofPartitions = (Get-Variable | Where-Object {$_.Name -match $Script:DP_Settings.PartitionPrefix -and ($_.Value.PartitionTypeMBRorAmiga -eq 'MBR' -or $_.Value.PartitionTypeMBRorAmiga -eq 'Amiga')})
    }
    else {
        $ListofPartitions = (Get-Variable | Where-Object {$_.Name -match $Script:DP_Settings.PartitionPrefix -and $_.Value.PartitionTypeMBRorAmiga -eq $PartitionType})
    }
    
    return $ListofPartitions    

}
