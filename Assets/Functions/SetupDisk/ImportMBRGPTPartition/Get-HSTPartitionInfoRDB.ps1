function Get-HSTPartitionInfoRDB {
    param (
        $Path,
        $MBRPartitionNumber

    ) 
    
    # $Path = "C:\Users\Matt\Downloads\CaffeineOS_Storm_9311.img"
    # $path = '\disk6'
    # $MBRPartitionNumber = '2'
    
    $HSTCommandScriptPath = "$($Script:Settings.TempFolder)\HSTCommandstoRun.txt"
    $HSTCommandstoProcess = @()
    
    if ($MBRPartitionNumber){
        $HSTCommandstoProcess += "rdb info $Path\mbr\$MBRPartitionNumber"
        $HSTCommandstoProcess += "fs dir $Path\mbr\$MBRPartitionNumber\rdb"
    }
    else{
        $HSTCommandstoProcess += "rdb info $Path`n"
        $HSTCommandstoProcess += "fs dir $Path\rdb`n"
    }
        

    if ($HSTCommandstoProcess){
        $HSTCommandstoProcess | Out-File -FilePath $HSTCommandScriptPath -Force
        Write-InformationMessage -Message "Running HST Imager to determine RDB partitions"
        $Logoutput = & $Script:ExternalProgramSettings.HSTImagerPath script $HSTCommandScriptPath
    
    }
    if ((Confirm-HSTNoErrors -Logoutput $Logoutput -HSTImager -KeepLog) -eq $false){
        exit
    }
    
    $RDBDiskInfo = @()
    #$RDBFileSystems =  @()
    $RDBPartitions = @()
    $RDBOverview = @()
    $RDBEntries = @()
    
    for ($i = 0; $i -lt $Logoutput.count; $i++) {
        if ($Logoutput[$i] -match 'No Rigid Disk Block present'){
            $null = Remove-Item ($Logoutput) -Force
            $null = Remove-Item $HSTCommandScriptPath -Force
            return
        }
        if ($Logoutput[$i] -eq 'Rigid Disk Block:'){
            $RDBDiskInfoRowStart = $i+4
        }
        # elseif ($Logoutput[$i] -eq 'File systems:'){
        #     $RDBFileSystemsRowStart = $i+4
        # }
       elseif ($Logoutput[$i] -eq 'Partitions:'){
        #     $RDBFileSystemsRowEnd = $i-2   
            $RDBPartitionsStart = $i+4
        }
        elseif ($Logoutput[$i] -eq 'Partition table overview:'){
            $RDBPartitionsEnd = $i-2
            $RDBPartitionsOverviewStart = $i+7 
        }
        elseif ($Logoutput[$i] -eq 'Entries:'){
            $RDBEntriesStart = $i+4
            $RDBPartitionsOverviewEnd = $i-6
    
        }
        elseif ($Logoutput[$i] -match ' directories, '){
            $RDBEntriesEnd = $i-2
        }
    }
    
    $RDBDiskInfo = $Logoutput[$RDBDiskInfoRowStart]
   # $RDBFileSystems = $Logoutput[$RDBFileSystemsRowStart..$RDBFileSystemsRowEnd]
    $RDBPartitions = $Logoutput[$RDBPartitionsStart..$RDBPartitionsEnd]
    
    $RDBOverview = $Logoutput[$RDBPartitionsOverviewStart..$RDBPartitionsOverviewEnd]
    $RDBEntries = $Logoutput[$RDBEntriesStart..$RDBEntriesEnd]

    $RDBPartitionTable = [System.Collections.Generic.List[PSCustomObject]]::New()
    
    $RDBPartitions | ForEach-Object {
        $RDBPartitionTable += [PSCustomObject]@{
            Product = $null
            Vendor = $null
            Revision = $null
            DiskSize = $null
            DiskSizeCalculated = [int]$null
            Cylinders = [int]$null
            Heads = [int]$null
            Sectors = [int]$null
            BlockSizeDisk = [int]$null
            Flags = $null
            HostID = $null
            RDBBlockLow = $null
            RDBBlockHigh = $null
            PartitionNumber = $_.Split("|")[0].Trim()
            Name = $_.Split("|")[1].Trim()
            Size = $_.Split("|")[2].Trim()
            SizeCalculated = [int]$null
            LowCylinder = $_.Split("|")[3].Trim()
            HighCylinder = $_.Split("|")[4].Trim()
            Reserved = $_.Split("|")[5].Trim()
            PreAlloc = $_.Split("|")[6].Trim()
            BlockSizePartition = $_.Split("|")[7].Trim()
            Buffers = $_.Split("|")[8].Trim()
            DosType = $_.Split("|")[9].Trim()
            Mask = $_.Split("|")[10].Trim()
            MaxTransfer = $_.Split("|")[11].Trim().replace("0x00","0x")
            Bootable = $_.Split("|")[12].Trim()
            NoMount = $_.Split("|")[13].Trim()
            Priority = $_.Split("|")[14].Trim()
            StartOffset = $null
            EndOffset = $null
            DeviceName = $null
            VolumeName = $null
    
        }
    
    }
    
    foreach ($RDBPartition in $RDBPartitionTable ) {
        $RDBPartition.Product = $RDBDiskInfo.Split("|")[0].Trim()
        $RDBPartition.Vendor = $RDBDiskInfo.Split("|")[1].Trim()
        $RDBPartition.Revision = $RDBDiskInfo.Split("|")[2].Trim()
        $RDBPartition.DiskSize = $RDBDiskInfo.Split("|")[3].Trim()
        $RDBPartition.Cylinders = $RDBDiskInfo.Split("|")[4].Trim()
        $RDBPartition.Heads = $RDBDiskInfo.Split("|")[5].Trim()
        $RDBPartition.Sectors = $RDBDiskInfo.Split("|")[6].Trim()
        $RDBPartition.BlockSizeDisk = $RDBDiskInfo.Split("|")[7].Trim()
        $RDBPartition.Flags = $RDBDiskInfo.Split("|")[8].Trim()
        $RDBPartition.HostID = $RDBDiskInfo.Split("|")[9].Trim()
        $RDBPartition.RDBBlockLow = $RDBDiskInfo.Split("|")[10].Trim()
        $RDBPartition.RDBBlockHigh = $RDBDiskInfo.Split("|")[11].Trim()
        foreach ($RDBPartitionOffsetInfo in $RDBOverview) {
            If ($RDBPartition.PartitionNumber -eq $RDBPartitionOffsetInfo.split("|")[0].Trim()){
                $RDBPartition.StartOffset = $RDBPartitionOffsetInfo.split("|")[3].Trim()
                $RDBPartition.EndOffset = $RDBPartitionOffsetInfo.split("|")[4].Trim()
                break
            }
        }
        foreach ($RDBEntry in $RDBEntries) {
            If ($RDBPartition.PartitionNumber -eq $RDBEntry.split("|")[0].Trim()){
                $RDBPartition.DeviceName = $RDBEntry.split("|")[4].Trim()
                $RDBPartition.VolumeName = $RDBEntry.split("|")[9].Trim()
                break
            }
        }
    
    }

    $RDBPartitionTable | ForEach-Object {
        $_.DiskSizeCalculated = [int]$_.Cylinders*[int]$_.Heads*[int]$_.Sectors*[int]$_.BlockSizeDisk
        $_.SizeCalculated = [int64](([int]$_.HighCylinder+1-[int]$_.LowCylinder)*[int]$_.BlockSizePartition*[int]$_.Heads*[int]$_.Sectors)
    }

    return $RDBPartitionTable

}
# Get-HSTPartitionInfoRDB -Path "C:\Users\Matt\Downloads\CaffeineOS_Storm_9311.img" -MBRPartitionNumber 2