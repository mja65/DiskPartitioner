function Get-FreeSpaceStartingByte {
    param (
        $Path,
        $RDBPartitionNumber,
        $EndingOffset
    )
    
    Add-TypesScanningFreeSpace 
    $chunkSize = 1048576 
    
    # Determine source type and last used byte
    if ($Path -match '\\disk(\d+)$') {
        $diskNumber = [int]($Path -replace '^.*\\disk', '')
        $disk = Get-Disk -Number $diskNumber
        $diskSize = $disk.Size
        $targetDiskPath = "\\.\PhysicalDrive$diskNumber"
        $lastUsedByte = [EmptySpaceScanDisk]::FindLastNonZeroByteReverse($targetDiskPath, $chunkSize, $EndingOffset)
    } 
    else {
        $lastUsedByte = [EmptySpaceScanFile]::FindLastNonZeroByteReverse($Path, $chunkSize, $EndingOffset)
    }
    
    Write-InformationMessage -Message "Scanned $Path for RDB Partition #$RDBPartitionNumber and last written byte is: $lastUsedByte"
    return $lastUsedByte
}