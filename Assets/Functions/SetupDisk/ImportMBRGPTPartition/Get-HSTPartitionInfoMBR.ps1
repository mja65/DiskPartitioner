function Get-HSTPartitionInfoMBR {
    param (
        $Path,
        [Switch]$PhysicalDisk,
        [Switch]$Image

    ) 

    $MBRInformation = [System.Collections.Generic.List[PSCustomObject]]::New()
    
    if ($PhysicalDisk){
        # $path = '\disk6'

        $DiskNumber = ($Path -split ("disk"))[1]
       
        (Get-Partition -DiskNumber $DiskNumber) | ForEach-Object {
            $PartitionType = "0x$([string]("{0:X}" -f $_.MbrType))"
            if ($PartitionType -eq '0x76'){
                $PartitionTypeFriendlyName = 'Amiga MBR Partition'
            }
            elseif ($PartitionType -eq '0xC'){
                $PartitionTypeFriendlyName = 'FAT32 Partition'
            }
            $MBRInformation  += [PSCustomObject]@{
                PartitionNumber = $_.PartitionNumber
                PartitionType = $PartitionType
                PartitionTypeFriendlyName = $PartitionTypeFriendlyName
                OffsetBytes = $_.Offset
                OffsetSector = $_.Offset/512
                SizeBytes = $_.Size
            }                       
        }

        return $MBRInformation

    }

    elseif ($Image){
       
        # $path = "C:\Users\Matt\Downloads\CaffeineOS_Storm_9311.img"

        $MBR_SIZE = 512
        $PARTITION_ENTRY_OFFSET = 446
        $PARTITION_ENTRY_SIZE = 16
        $PARTITION_ENTRY_COUNT = 4
        #$BOOT_SIGNATURE_OFFSET = 510
        #$BOOT_SIGNATURE = 0xAA55
        
        $stream = [System.IO.File]::OpenRead($Path)
        $reader = New-Object System.IO.BinaryReader($stream)
        
        # Read the MBR (first 512 bytes)
        $mbr = $reader.ReadBytes($MBR_SIZE)
        
        $MBRInformation = [System.Collections.Generic.List[PSCustomObject]]::New()

        for ($i = 0; $i -lt $PARTITION_ENTRY_COUNT; $i++) {
            $offset = $PARTITION_ENTRY_OFFSET + ($i * $PARTITION_ENTRY_SIZE)
            $entry = $mbr[$offset..($offset + $PARTITION_ENTRY_SIZE - 1)]
        
            #$bootFlag = $entry[0]
            #$startCHS = $entry[1..3]
            #$partitionType = $entry[4]
            #$endCHS = $entry[5..7]
            $startLBA = [BitConverter]::ToUInt32($entry, 8)
            $sizeSectors = [BitConverter]::ToUInt32($entry, 12)
            #$sizeMB = [math]::Round(($sizeSectors * 512) / 1MB, 2)
        
            #$bootable = if ($bootFlag -eq 0x80) { "Yes" } else { "No" }
            #$typeName = Get-PartitionTypeName $partitionType
            #$startCHSStr = Convert-CHS $startCHS
            #$endCHSStr = Convert-CHS $endCHS
            $SizeBytes = $sizeSectors * 512

            $PartitionType = "0x$([string]("{0:X}" -f $entry[4]))"
            if ($PartitionType -eq '0x0'){
                break
            }
            if ($PartitionType -eq '0x76'){
                $PartitionTypeFriendlyName = 'Amiga MBR Partition'
            }
            elseif ($PartitionType -eq '0xC'){
                $PartitionTypeFriendlyName = 'FAT32 Partition'
            }
            $MBRInformation  += [PSCustomObject]@{
                PartitionNumber = $i+1
                PartitionType = $PartitionType
                PartitionTypeFriendlyName = $PartitionTypeFriendlyName
                OffsetBytes = $startLBA*512
                OffsetSector = $startLBA
                SizeBytes = $SizeBytes
            }

        }
        $stream.Close()
        return $MBRInformation
    }
}   


