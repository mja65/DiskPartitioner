function Import-MBRPartitiontoDisk {
    param (

    )

    $Script:GUICurrentStatus.HSTCommandstoProcess.AdjustParametersonImportedRDBPartitions.Clear()

    $MBRPartitionstoAddtoDisk = Get-AllGUIPartitions -partitiontype 'MBR'
    
    $MBRPartitionCounter = 1
    
    foreach ($MBRPartition in $MBRPartitionstoAddtoDisk) {
        if ($MBRPartition.value.ImportedPartition -eq $true -and $MBRPartition.value.ImportedPartitionMethod -eq 'Direct'){
            Write-InformationMessage -Message "Identified MBR Partition #$MBRPartitionCounter for importation"          
            $Startpoint = $MBRPartition.value.ImportedPartitionPath.IndexOf("\MBR\")
            $SubstringLength = $MBRPartition.value.ImportedPartitionPath.length-($Startpoint+5)
            $MBRPartitionNumbertoImport = $MBRPartition.value.ImportedPartitionPath.Substring(($Startpoint+5),$SubstringLength)
            $PathofImage = $MBRPartition.value.ImportedPartitionPath.Substring(0,$Startpoint)
            Write-InformationMessage -Message "Running command to import partition from: `"$PathofImage`" MBR Partition #$MBRPartitionNumbertoImport to: MBR Partition #$MBRPartitionCounter"
            Copy-MBRPartition -SourcePath $PathofImage -SourcePartitionNumber $MBRPartitionNumbertoImport -DestinationPath $($Script:GUIActions.OutputPath) -DestinationPartitionNumber $MBRPartitionCounter
            
            $RDBCounter = 0        
            Write-InformationMessage -Message 'Adjusting Amiga disk parameters for imported partitions where required'
            Get-AllGUIPartitions -PartitionType 'Amiga' | Where-Object {$_.Name -match $MBRPartition.name } | ForEach-Object {
                $RDBCounter ++
                $RDBUpdateString = $null
                $RDBUpdateStringUsed = $false
                if ($_.value.DeviceName -ne $_.value.DeviceNameoriginalimportedvalue){
                    $RDBUpdateString += "--name $($_.value.DeviceName) "
                    $RDBUpdateStringUsed = $true                    
                }
                if ($_.value.buffers -ne $_.value.buffersoriginalimportedvalue){
                    $RDBUpdateString += "--buffers $($_.value.buffers) "
                    $RDBUpdateStringUsed = $true
                }
                if ($_.value.dostype -ne $_.value.dostypeoriginalimportedvalue){
                    $RDBUpdateString += "--dos-type $($_.value.dostype) "
                    $RDBUpdateStringUsed = $true
                }
                if ($_.value.MaxTransfer -ne $_.value.MaxTransferoriginalimportedvalue){
                    $RDBUpdateString += "--max-transfer $($_.value.MaxTransfer) "
                    $RDBUpdateStringUsed = $true        
                }
                if ($_.value.mask -ne $_.value.maskoriginalimportedvalue){
                    $RDBUpdateString += "--mask $($_.value.mask) " 
                    $RDBUpdateStringUsed = $true       
                }
                if ($_.value.nomount -ne $_.value.nomountoriginalimportedvalue){
                    $RDBUpdateStringUsed = $true
                    if ($_.value.NoMount -eq 'True'){
                        $RDBUpdateString += "--no-mount True" #Need space in case some partitions don't have flag
                    }
                    elseif ($_.value.NoMount -eq 'False'){
                        $RDBUpdateString += "--no-mount False" #Need space in case some partitions don't have flag            
                    }
                }
                if ($_.value.bootable -ne $_.value.bootableoriginalimportedvalue){
                    $RDBUpdateStringUsed = $true
                    if ($_.Bootable -eq 'True'){
                        $RDBUpdateString += "--bootable True" #Need space in case some partitions don't have flag
                    }
                    elseif ($_.Bootable -eq 'False'){
                        $RDBUpdateString += "--bootable False" #Need space in case some partitions don't have flag
                    }
                }
                if ($_.value.priority -ne $_.value.priorityoriginalimportedvalue){
                    $RDBUpdateStringUsed = $true
                    $RDBUpdateString += "--bootpriority $($_.value.priority) "        
                }    

                if ($RDBUpdateStringUsed -eq $true) {
                    Write-InformationMessage -Message "Adding comamand for parameter changes for RDB partition #$RDBCounter"  
                    $Script:GUICurrentStatus.HSTCommandstoProcess.AdjustParametersonImportedRDBPartition += [PSCustomObject]@{
                        Command = "rdb part update $($Script:GUIActions.OutputPath)\MBR\$MBRPartitionCounter $RDBCounter $RDBUpdateString"
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
    
    $HSTCommandstoRun = $Script:GUICurrentStatus.HSTCommandstoProcess.AdjustParametersonImportedRDBPartition
    if ($HSTCommandstoRun){
        Start-HSTCommands -HSTScript $HSTCommandstoRun 'Processing commands'
    }

}
    