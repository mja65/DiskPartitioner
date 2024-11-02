function Get-AllGUIPartitionBoundaries {
    param (
        $Prefix,
        $PartitionType
    )
    
    # $Prefix = 'WPF_UI_DiskPartition_Partition_'
    # $PartitionType = 'MBR'

    $AllPartitionBoundaries = [System.Collections.Generic.List[PSCustomObject]]::New()

    $ListofVariables = Get-Variable | Where-Object {$_.Name -match $Prefix -and $_.Value.PartitionTypeMBRorAmiga -eq $PartitionType}
    Foreach ($Variable in $ListofVariables){
        $AllPartitionBoundaries += [PSCustomObject]@{
            PartitionName = $Variable.Name
            LeftMargin = $Variable.Value.Margin.Left
            RightMargin = (Get-GUIPartitionWidth -Partition $Variable.Value) + ($Variable.Value.Margin.Left)
        }
    }

    $AllPartitionBoundaries = $AllPartitionBoundaries | Sort-Object -Property 'LeftMargin'

    return $AllPartitionBoundaries

}