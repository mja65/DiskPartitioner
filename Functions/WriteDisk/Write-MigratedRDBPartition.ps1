function Write-MigratedRDBPartition {
    param (
        $PathtoRDBImageFile,
        $ID76PartitionNumber
    )
    # $Path = "E:\Emu68Imager\Working Folder\HDFImage\Pistorm3.1.HDF"
    # $ID76PartitionNumber = 2
    
    if ((Confirm-NetworkLocalorDisk -PathtoCheck $Script:GUIActions.OutputPath) -eq 'Physical Disk'){
        Write-Host 'Not built!!'
    }
    elseif ((Confirm-NetworkLocalorDisk -PathtoCheck $Script:GUIActions.OutputPath) -eq 'Local'){
        $null = Dismount-DiskImage -ImagePath $Script:GUIActions.OutputPath
        $DeviceDetails = Mount-DiskImage -ImagePath $Script:GUIActions.OutputPath
        $PowershellDiskNumber = $DeviceDetails.Number
    }
    $SectorSize = (Get-WmiObject -Class Win32_DiskPartition | Select-Object -Property DiskIndex, Name, Index, BlockSize, Description, BootPartition | Where-Object DiskIndex -eq $PowershellDiskNumber | where-object Index -eq 0).BlockSize
    
    $OffsetBytes = (Get-Partition -DiskNumber $PowershellDiskNumber | Where-Object {$_.PartitionNumber -eq $ID76PartitionNumber}).Offset
    $Offset = $OffsetBytes/$SectorSize
    
    $ListofPartitions = Get-HSTPartitionInfo -RDBInfo -Path $PathtoRDBImageFile
    
    $PartitionsandOffsets = [System.Collections.Generic.List[PSCustomObject]]::New()
    
    foreach ($Partition in $ListofPartitions) {
        $BeginCrop = (([int64]$Partition.StartOffSet)/$SectorSize)
        $EndCrop = ((([int64]($Partition.EndOffSet))+1)/$SectorSize)
        Write-InformationMessage -Message "Determining start of free space for Partition: $($Partition.Name). Using Starting offset of $BeginCrop and Ending Offset of $EndCrop"
        & $Script:ExternalProgramSettings.FindFreeSpacePath $PathtoRDBImageFile -sectorsize 512 -begincrop $BeginCrop -endcrop $EndCrop -result "$($Script:ExternalProgramSettings.TempFolder)\FindFreeSpaceLog.txt"
        $FreeSpaceSector = (([int64](Get-Content -Path "$($Script:ExternalProgramSettings.TempFolder)\FindFreeSpaceLog.txt"))+$BeginCrop)
        $PartitionsandOffsets += [PSCustomObject]@{
            PartitionNumber = $Partition.Number
            BeginCrop = $BeginCrop
            EndCrop = $FreeSpaceSector
            
        }
        
    }
    
    foreach ($Partition in $PartitionsandOffsets){
        & $Script:ExternalProgramSettings.DDTCPath $PathtoRDBImageFile $PowershellDiskNumber -offset $Offset -sectorsize $sectorsize -begincrop $Partition.BeginCrop -endcrop $Partition.endcrop
    }
}