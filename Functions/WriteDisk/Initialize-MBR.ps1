function Initialize-MBR {
    param (
        $DiskNumber
    
    )
    # $Command = @()
    # $Command += "mbr init $Path"

    # return $Command

    Write-InformationMessage -Message "Initialising Disk. Disk Number: $DiskNumber"
    Initialize-Disk -Number $DiskNumber -PartitionStyle MBR

}