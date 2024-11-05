function Get-DiskSizefromRemovableMedia {
    param (
        $DisktoFind
    )
    
    foreach ($Disk in $Script:RemovableMediaList){
        if ($Disk.FriendlyName -eq $DisktoFind){
            return $Disk.SizeofDiskBytes
        }
    }
}