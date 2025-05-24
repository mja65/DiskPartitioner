function Confirm-IsMDBRorRDB {
    param (
        $Path,
        [Switch]$PhysicalDisk,
        [Switch]$Image,
        [Switch]$PartitionList
    )
    
    if ($PhysicalDisk){
        # $path = '\disk6'
        $DiskNumber = ($Path -split ("disk"))[1]

        $MBR = [byte[]]::new(512)
        $DiskPathtouse = "\\.\PhysicalDrive$DiskNumber"
        $stream = [IO.File]::Open($DiskPathtouse, [IO.FileMode]::Open, [IO.FileAccess]::Read, [IO.FileShare]::ReadWrite)
        $null = $stream.Read($MBR, 0, 512)
        $stream.Close()

    }
    elseif ($Image){    
        # $path = "C:\Users\Matt\Downloads\CaffeineOS_Storm_9311.img"
        # $path = "C:\Users\Matt\OneDrive\Documents\EmuImager2\Pistorm3.2.3.HDF"
        $stream = [System.IO.File]::OpenRead($Path)
        $reader = New-Object System.IO.BinaryReader($stream)
        $mbr = $reader.ReadBytes(512)
        $stream.Close()
    }

    # if ("{0:X}" -f $mbr[510] -eq '55' -and "{0:X}" -f $mbr[511] -eq 'AA'){
    if ([BitConverter]::ToUInt16($mbr, 510) -eq 0xAA55) {
        $IsMBR = $true
        $IsRDB = $false
    }
    else {
        $IsMBR = $false
        if ([System.Text.Encoding]::ASCII.GetString($MBR[0..3]) -eq 'RDSK'){
            $IsRDB = $true
        }
        else {
            $IsRDB = $false
        }            
    }
 
    if ($PartitionList){
        if ($IsMBR -eq $true){
            $numPartitions = 4 
            $sectorSize = 512
            $partitionEntrySize = 16
            $partitionTableOffset = 446
            $PartitionMap = New-Object System.Collections.ArrayList

            for ($i = 0; $i -lt $numPartitions; $i++) {
                $offset = $partitionTableOffset + ($i * $partitionEntrySize)
            
                $bootFlag = $mbr[$offset]
                $partitionType = $mbr[$offset + 4]
                $startSector = [BitConverter]::ToUInt32($mbr, $offset + 8)
                $totalSectors = [BitConverter]::ToUInt32($mbr, $offset + 12)
            
                if ($partitionType -ne 0 -and $totalSectors -gt 0) {
                   $null = $PartitionMap.add([PSCustomObject]@{
                        PartitionNumber = $i + 1
                        Bootable     = ($bootFlag -eq 0x80)
                        Type         = ('0x{0:X2}' -f $partitionType)
                        StartSector  = $startSector
                        StartingOffsetBytes = $startSector * $sectorSize
                        EndingOffsetBytes = ($startSector * $sectorSize) + ($totalSectors * $sectorSize)
                        TotalSectors = $totalSectors
                        SizeBytes = $totalSectors * $sectorSize
                    })
                }
            }

            return $PartitionMap
        }
        else {
            return $false
        }

    }
    else {
        if ($IsMBR -eq $true){
            return 'MBR'
        }
        elseif ($IsRDB -eq $true){
            return 'RDB'
        }
        else {
            return
        }
    }
}

