function Confirm-DiskFreeSpace {
    param (
        $AddType,
        $MBRDisk,
        $PartitionNameNextto
    )
    
    if ($AddType -eq 'AtEnd'){
        $AvailableFreeSpace = (Get-DiskFreeSpace -Disk $MBRDisk -Position $AddType)
       # Write-host "Available Free Space is: $AvailableFreeSpace."
    }
    else{
        $AvailableFreeSpace = (Get-DiskFreeSpace -Disk $MBRDisk -Position $AddType -PartitionNameNextto $PartitionNameNextto)
    }
    if ($AvailableFreeSpace -lt $SizeBytes){
        #Write-host "Insufficient free Space!"
        $null = Show-WarningorError -Msg_Header 'No Free Space' -Msg_Body 'Insufficient freespace to create partition!' -BoxTypeError -ButtonType_OK
        return $false
    }
    else{
        return $true
    }
}