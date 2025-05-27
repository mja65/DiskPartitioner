function Import-RDBPartitiontoDisk {
    param (

    )
    
    # $Script:GUIActions.OutputPath = "C:\Users\Matt\OneDrive\Documents\DiskPartitioner\UserFiles\SavedOutputImages\Newtest.vhd"

    $FreeSpacePartitionMap = [System.Collections.Generic.List[PSCustomObject]]::New()

    $MBRPartitionstoAddtoDisk = $Script:GUICurrentStatus.GPTMBRPartitionsandBoundaries
    
    $MBRPartitionCounter = 1
    
    foreach ($MBRPartition in $MBRPartitionstoAddtoDisk) {
        if ($MBRPartition.Partition.ImportedPartition -eq $true -and $MBRPartition.Partition.ImportedPartitionMethod -eq 'Derived'){
            Write-InformationMessage -Message "Identified MBR Partition #$MBRPartitionCounter for importation of Amiga Partitions"
            $RDBPartitionCounter = 1
            $Script:GUICurrentStatus.AmigaPartitionsandBoundaries | Where-Object {$_.PartitionName -match $MBRPartition.name } | ForEach-Object {
                $FreeSpacePartitionMap.add([PSCustomObject]@{
                    PartitionName = [String]$_.Name
                    ID76Parent = [string]$MBRPartition.Name
                    ID76ParentOffset = [int64]$MBRPartition.Partition.StartingPositionBytes  
                    SourcePartitionPath = [string]$MBRPartition.Partition.ImportedPartitionPath
                    MBRPartitionNumber = [int]$MBRPartitionCounter
                    RDBPartitionNumber = [int]$RDBPartitionCounter
                    StartingOffset = [int64]$_.Partition.ImportedPartitionOffsetBytes
                    EndingOffset = [int64]$_.Partition.ImportedPartitionEndBytes
                    FreeSpaceStart = [int64](Get-FreeSpaceStartingByte -Path $MBRPartition.Partition.ImportedPartitionPath -RDBPartitionNumber $RDBPartitionCounter -EndingOffset ($_.Partition.ImportedPartitionEndBytes))
                })
                $RDBPartitionCounter ++                
            }
        }
        $MBRPartitionCounter ++
    }
    
    foreach ($Partition in $FreeSpacePartitionMap) {
        if ($Partition.RDBPartitionNumber -eq 1){
            $StartingOffsettoUse = 0
        }
        else {
            $StartingOffsettoUse = $Partition.StartingOffset 
        }
        $EndingOffsettoUse = [int]([math]::Ceiling($Partition.FreeSpaceStart / $Script:Settings.AmigaRDBBlockSize ) * $Script:Settings.AmigaRDBBlockSize )

        Write-InformationMessage -Message "Writing RDB Partition #$($Partition.RDBPartitionNumber) with starting offset of $StartingOffsettoUse and ending offset of $EndingOffsettoUse"
        Write-AmigaPartiontoID76 -DestinationPath $Script:GUIActions.OutputPath -SourcePartitionPath $Partition.SourcePartitionPath -StartingOffsetRead $StartingOffsettoUse -EndingOffsetRead $EndingOffsettoUse -StartingOffsetWrite $Partition.ID76ParentOffset

        $RDBUpdateString = $null
        $RDBUpdateStringUsed = $false
        
        if ((Get-Variable -Name $Partition.PartitionName).value.DeviceName -ne (Get-Variable -Name $Partition.PartitionName).value.DeviceNameoriginalimportedvalue){
            $RDBUpdateString += "--name $((Get-Variable -Name $Partition.PartitionName).value.DeviceName) "
            $RDBUpdateStringUsed = $true                    
        }
        if ((Get-Variable -Name $Partition.PartitionName).value.buffers -ne (Get-Variable -Name $Partition.PartitionName).value.buffersoriginalimportedvalue){
            $RDBUpdateString += "--buffers $((Get-Variable -Name $Partition.PartitionName).value.buffers) "
            $RDBUpdateStringUsed = $true
        }
        if ((Get-Variable -Name $Partition.PartitionName).value.dostype -ne (Get-Variable -Name $Partition.PartitionName).value.dostypeoriginalimportedvalue){
            $RDBUpdateString += "--dos-type $((Get-Variable -Name $Partition.PartitionName).value.dostype) "
            $RDBUpdateStringUsed = $true
        }
        if ((Get-Variable -Name $Partition.PartitionName).value.MaxTransfer -ne (Get-Variable -Name $Partition.PartitionName).value.MaxTransferoriginalimportedvalue){
            $RDBUpdateString += "--max-transfer $((Get-Variable -Name $Partition.PartitionName).value.MaxTransfer) "
            $RDBUpdateStringUsed = $true        
        }
        if ((Get-Variable -Name $Partition.PartitionName).value.mask -ne (Get-Variable -Name $Partition.PartitionName).value.maskoriginalimportedvalue){
            $RDBUpdateString += "--mask $((Get-Variable -Name $Partition.PartitionName).value.mask) " 
            $RDBUpdateStringUsed = $true       
        }
        if ((Get-Variable -Name $Partition.PartitionName).value.nomount -ne (Get-Variable -Name $Partition.PartitionName).value.nomountoriginalimportedvalue){
            $RDBUpdateStringUsed = $true
            if ((Get-Variable -Name $Partition.PartitionName).value.NoMount -eq 'True'){
                $RDBUpdateString += "--no-mount True" #Need space in case some partitions don't have flag
            }
            elseif ((Get-Variable -Name $Partition.PartitionName).value.NoMount -eq 'False'){
                $RDBUpdateString += "--no-mount False" #Need space in case some partitions don't have flag            
            }
        }
        if ((Get-Variable -Name $Partition.PartitionName).value.bootable -ne (Get-Variable -Name $Partition.PartitionName).value.bootableoriginalimportedvalue){
            $RDBUpdateStringUsed = $true
            if ($_.Bootable -eq 'True'){
                $RDBUpdateString += "--bootable True" #Need space in case some partitions don't have flag
            }
            elseif ($_.Bootable -eq 'False'){
                $RDBUpdateString += "--bootable False" #Need space in case some partitions don't have flag
            }
        }
        if ((Get-Variable -Name $Partition.PartitionName).value.priority -ne (Get-Variable -Name $Partition.PartitionName).value.priorityoriginalimportedvalue){
            $RDBUpdateStringUsed = $true
            $RDBUpdateString += "--bootpriority $((Get-Variable -Name $Partition.PartitionName).value.priority) "        
        }    
        
                if ($RDBUpdateStringUsed -eq $true) {
                    Write-InformationMessage -Message "Adding comamand for parameter changes for RDB partition #$($Partition.RDBPartitionNumber)"  
                    $Script:GUICurrentStatus.HSTCommandstoProcess.AdjustParametersonImportedRDBPartition += [PSCustomObject]@{
                        Command = "rdb part update $($Script:GUIActions.OutputPath)\MBR\$($Partition.MBRPartitionNumber)\RDB $($Partition.RDBPartitionNumber) $RDBUpdateString"
                        Sequence = 2      
                    }       
                }
                else {
                    Write-InformationMessage -Message "No parameter changes for RDB partition #$($Partition.RDBPartitionNumber)"                   
                }                
            
        }

    }



    