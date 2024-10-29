function Get-SelectedGUIPartition {
    param (
        $MouseX,
        $Prefix
    )
    
    #$Prefix = 'WPF_UI_DiskPartition_Partition_'
    #$MouseX = 199

    $ListofVariables = Get-Variable | Where-Object {$_.Name -match $Prefix} | Sort-Object -Property 'Name'
    Foreach ($Variable in $ListofVariables){
        if (($MouseX -ge $Variable.Value.Margin.Left) -and ($MouseX -le $Variable.Value.Margin.Left + (Get-MBRPartitionWidth -MBRPartition $Variable.Value))){
            return $Variable.Name
        } 
    }

}


