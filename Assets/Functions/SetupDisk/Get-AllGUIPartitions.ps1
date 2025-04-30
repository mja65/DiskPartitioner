function Get-AllGUIPartitions {
    param (
        $PartitionType
    )
    
    #$PartitionType = 'MBR'
    If ($PartitionType -eq 'All'){
        $ListofPartitions = (Get-Variable | Where-Object {$_.Name -match $Script:DP_Settings.PartitionPrefix -and ($_.Value.PartitionTypeGPTMBRorAmiga -eq 'GPTMBR' -or $_.Value.PartitionType -eq 'Amiga')})
    }
    else {
        $ListofPartitions = (Get-Variable | Where-Object {$_.Name -match $Script:DP_Settings.PartitionPrefix -and $_.Value.PartitionType -eq $PartitionType})
    }
    
    return $ListofPartitions    

}
