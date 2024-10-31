function Get-SelectedGUIPartition {
    param (
        $MouseX,
        $Prefix,
        $PartitionType
    )
    
    # $Prefix = 'WPF_UI_DiskPartition_Partition_'
    # $MouseX = 64
    # $PartitionType = 'Amiga'

    $ListofVariables = Get-Variable | Where-Object {$_.Name -match $Prefix -and $_.Value.PartitionTypeMBRorAmiga -eq $PartitionType} 
    Foreach ($Variable in $ListofVariables){
        if (($MouseX -ge $Variable.Value.Margin.Left) -and ($MouseX -le $Variable.Value.Margin.Left + (Get-GUIPartitionWidth -Partition $Variable.Value))){
            return $Variable.Name
        } 
    }

}
