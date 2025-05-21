function Write-AmigaPartiontoID76 {
    param (
        $SourcePartitionPath,
        $DestinationPath,
        $StartingOffsetRead,
        $EndingOffsetRead,
        $StartingOffsetWrite
    )
     
     Add-TypesDiskAccess

    # $DestinationPath = "\disk8"
    # $DestinationPath = "C:\Users\Matt\OneDrive\Documents\DiskPartitioner\UserFiles\SavedOutputImages\Newtest.vhd"
    # $StartingOffsetWrite = 3528759808
    # $SourcePartitionPath = "C:\Users\Matt\OneDrive\Documents\DiskPartitioner\Pistorm3.2.3.HDF"   
    # $StartingOffsetRead = 0
    # $EndingOffsetRead = 53294288

    $StartingOffsetWritetoUse = $StartingOffsetWrite + $StartingOffsetRead
    $chunkSize = 1048576 
    $BlankSpaceSizeBytes = 10485760-512
    
    if ($WriteStream){
        $WriteStream.Close()
    }
    if ($Readstream) {
        $Readstream.Close()
    }
   
    # Mount VHD if needed

    if ($DestinationPath.ToLower().EndsWith(".vhd")){
        $diskImage = Get-DiskImage -ImagePath $DestinationPath -ErrorAction Ignore
        if (-not $diskImage) {
            Write-ErrorMessage "VHD not found: $DestinationPath"
            return
        }
        if (-not $diskImage.Attached) {
            Mount-DiskImage -ImagePath $DestinationPath | Out-Null
            Start-Sleep -Seconds 2
        }
        $DiskNumberDestination = (Get-DiskImage -ImagePath $DestinationPath).Number
    }

    # Determine destination stream
    if ($DestinationPath -match '\\disk(\d+)$') {
        $DiskNumberDestination = [int]($DestinationPath -replace '^.*\\disk', '')
    }
    
    if ($null -ne $DiskNumberDestination) {
        $targetDiskPath = "\\.\PhysicalDrive$DiskNumberDestination"
        #$WriteStream = New-Object System.IO.FileStream($targetDiskPath, [System.IO.FileMode]::Open, [System.IO.FileAccess]::ReadWrite)
        $Writestream = [DiskAccess]::OpenForWrite($targetDiskPath)
    } 
    else {
        $Writestream = [FileAccessWrapper]::OpenFile($DestinationPath )
        #$WriteStream = [System.IO.File]::Open($DestinationPath, [System.IO.FileMode]::Open, [System.IO.FileAccess]::ReadWrite)
    }

    # Read from source and write to target
    
    $ReadStream = [System.IO.File]::Open($SourcePartitionPath, [System.IO.FileMode]::Open, [System.IO.FileAccess]::Read)
    $reader = New-Object System.IO.BinaryReader($ReadStream)
    
    # Seek start position in write stream
    
    Write-InformationMessage -Message "Navigating to starting offset in destination ($StartingOffsetWritetoUse bytes)"
    
    $WriteStream.Seek($StartingOffsetWritetoUse, [System.IO.SeekOrigin]::Begin) | Out-Null
    
    #Write Blank space at start of partition
    
    $BlankSpace = New-Object byte[] $BlankSpaceSizeBytes
    
    Write-InformationMessage -Message "Writing blank space to start of partition"
    
    $WriteStream.Write($BlankSpace, 0, $BlankSpaceSizeBytes)
    
    Write-InformationMessage -Message "Navigating back to starting offset in destination ($StartingOffsetWritetoUse bytes)"
    $WriteStream.Seek($StartingOffsetWritetoUse, [System.IO.SeekOrigin]::Begin) | Out-Null
    
    # Start read at position 0 in source
    $ReadStream.Position = $StartingOffsetRead
    
    # Total bytes to copy
    $remaining = $EndingOffsetRead - $StartingOffsetRead
    $TotalBytes = $remaining
   
    $sectorSize = 512  # or get actual sector size from disk info
    
    while ($remaining -gt 0) {
        $toRead = [Math]::Min($chunkSize, $remaining)
        $BytesRead = $reader.ReadBytes($toRead)
    
        if ($BytesRead.Length -eq 0) {
            # Reached end of source stream unexpectedly
            break
        }
        
        # If writing to physical disk and last chunk smaller than sector size, pad it
        if (($DiskNumberDestination) -and ($BytesRead.Length % $sectorSize -ne 0)) {
        $padSize = $sectorSize - ($BytesRead.Length % $sectorSize)
        $padding = New-Object byte[] $padSize
        $BytesRead += $padding
        }
    
        # Write only the bytes actually read
        #Write-InformationMessage -Message "Chunk $ChunkCounter to be written ($($BytesRead.Length) bytes), $remaining bytes remaining"
        $WriteStream.Write($BytesRead, 0, $BytesRead.Length)
        
        $remaining -= $BytesRead.Length
    
         $percentComplete = [math]::Round((($TotalBytes - $remaining) / $TotalBytes) * 100, 2)

         Write-Progress -Activity "Writing data..." -Status "($percentComplete% complete)" -PercentComplete $percentComplete

    }
        
    if ($WriteStream){
        $WriteStream.Close()
    }
    if ($Readstream){
        $Readstream.Close()
    }
    # Clear the progress bar when done
    Write-Progress -Activity "Writing data..." -Completed
    

}

    # # Determine source type
    # if ($SourcePartitionPath -match '\\disk(\d+)$') {
    #     $diskNumber = [int]($SourcePartitionPath -replace '^.*\\disk', '')
    #     $targetDiskPath = "\\.\PhysicalDrive$diskNumber"
    # } 
    