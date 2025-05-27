function Import-MBRPartitiontoDisk {
    param (

    )

    $Script:GUICurrentStatus.HSTCommandstoProcess.AdjustParametersonImportedRDBPartitions.Clear()

    $MBRPartitionstoAddtoDisk = $Script:GUICurrentStatus.GPTMBRPartitionsandBoundaries
    
    $MBRPartitionCounter = 1
    
    foreach ($MBRPartition in $MBRPartitionstoAddtoDisk) {
        if ($MBRPartition.Partition.ImportedPartition -eq $true -and $MBRPartition.Partition.ImportedPartitionMethod -eq 'Direct'){
            Write-InformationMessage -Message "Identified MBR Partition #$MBRPartitionCounter for importation"          
            $Startpoint = $MBRPartition.Partition.ImportedPartitionPath.IndexOf("\MBR\")
            $SubstringLength = $MBRPartition.Partition.ImportedPartitionPath.length-($Startpoint+5)
            $MBRPartitionNumbertoImport = $MBRPartition.Partition.ImportedPartitionPath.Substring(($Startpoint+5),$SubstringLength)
            $PathofImage = $MBRPartition.Partition.ImportedPartitionPath.Substring(0,$Startpoint)
            Write-InformationMessage -Message "Running command to import partition from: `"$PathofImage`" MBR Partition #$MBRPartitionNumbertoImport to: MBR Partition #$MBRPartitionCounter"
            Copy-MBRPartition -SourcePath $PathofImage -SourcePartitionNumber $MBRPartitionNumbertoImport -DestinationPath $($Script:GUIActions.OutputPath) -DestinationPartitionNumber $MBRPartitionCounter
            
            $RDBCounter = 0        
            Write-InformationMessage -Message 'Adjusting Amiga disk parameters for imported partitions where required'
            $Script:GUICurrentStatus.AmigaPartitionsandBoundaries  | Where-Object {$_.PartitionName -match $MBRPartition.Partitionname } | ForEach-Object {
                $RDBCounter ++
                $RDBUpdateString = $null
                $RDBUpdateStringUsed = $false
                if ($_.Partition.DeviceName -ne $_.Partition.DeviceNameoriginalimportedvalue){
                    $RDBUpdateString += "--name $($_.Partition.DeviceName) "
                    $RDBUpdateStringUsed = $true                    
                }
                if ($_.Partition.buffers -ne $_.Partition.buffersoriginalimportedvalue){
                    $RDBUpdateString += "--buffers $($_.Partition.buffers) "
                    $RDBUpdateStringUsed = $true
                }
                if ($_.Partition.dostype -ne $_.Partition.dostypeoriginalimportedvalue){
                    $RDBUpdateString += "--dos-type $($_.Partition.dostype) "
                    $RDBUpdateStringUsed = $true
                }
                if ($_.Partition.MaxTransfer -ne $_.Partition.MaxTransferoriginalimportedvalue){
                    $RDBUpdateString += "--max-transfer $($_.Partition.MaxTransfer) "
                    $RDBUpdateStringUsed = $true        
                }
                if ($_.Partition.mask -ne $_.Partition.maskoriginalimportedvalue){
                    $RDBUpdateString += "--mask $($_.Partition.mask) " 
                    $RDBUpdateStringUsed = $true       
                }
                if ($_.Partition.nomount -ne $_.Partition.nomountoriginalimportedvalue){
                    $RDBUpdateStringUsed = $true
                    if ($_.Partition.NoMount -eq 'True'){
                        $RDBUpdateString += "--no-mount True" #Need space in case some partitions don't have flag
                    }
                    elseif ($_.Partition.NoMount -eq 'False'){
                        $RDBUpdateString += "--no-mount False" #Need space in case some partitions don't have flag            
                    }
                }
                if ($_.Partition.bootable -ne $_.Partition.bootableoriginalimportedvalue){
                    $RDBUpdateStringUsed = $true
                    if ($_.Bootable -eq 'True'){
                        $RDBUpdateString += "--bootable True" #Need space in case some partitions don't have flag
                    }
                    elseif ($_.Bootable -eq 'False'){
                        $RDBUpdateString += "--bootable False" #Need space in case some partitions don't have flag
                    }
                }
                if ($_.Partition.priority -ne $_.Partition.priorityoriginalimportedvalue){
                    $RDBUpdateStringUsed = $true
                    $RDBUpdateString += "--bootpriority $($_.Partition.priority) "        
                }    

                if ($RDBUpdateStringUsed -eq $true) {
                    Write-InformationMessage -Message "Adding comamand for parameter changes for RDB partition #$RDBCounter"  
                    $Script:GUICurrentStatus.HSTCommandstoProcess.AdjustParametersonImportedRDBPartition += [PSCustomObject]@{
                        Command = "rdb part update $($Script:GUIActions.OutputPath)\MBR\$MBRPartitionCounter\RDB $RDBCounter $RDBUpdateString"
                        Sequence = 1      
                    }       
                }
                else {
                    Write-InformationMessage -Message "No parameter changes for RDB partition #$RDBCounter"                   
                }                
            }
        }
        $MBRPartitionCounter ++
    }
   

}
    