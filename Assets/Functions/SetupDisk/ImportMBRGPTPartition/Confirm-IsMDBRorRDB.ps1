function Confirm-IsMDBRorRDB {
    param (
        $Path,
        [Switch]$PhysicalDisk,
        [Switch]$Image
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
        #$path = "C:\Users\Matt\OneDrive\Documents\EmuImager2\Pistorm3.2.3.HDF"
        $stream = [System.IO.File]::OpenRead($Path)
        $reader = New-Object System.IO.BinaryReader($stream)
        $mbr = $reader.ReadBytes(512)
        $stream.Close()
    }

    if ("{0:X}" -f $mbr[510] -eq '55' -and "{0:X}" -f $mbr[511] -eq 'AA'){
        return 'MBR'
    }
    elseif ([System.Text.Encoding]::ASCII.GetString($MBR[0..3]) -eq 'RDSK'){
        return 'RDB'
    }
    else {
        return
    }
      
}