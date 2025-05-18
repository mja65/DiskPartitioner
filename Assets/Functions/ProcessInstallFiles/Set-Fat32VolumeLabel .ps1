function Set-Fat32VolumeLabel {
    param (
        $Path
    )
    
    #$Path = "C:\Users\Matt\Downloads\CaffeineOS_Storm_9311.img"
    $PartitionStart = $Script:Settings.MBRFirstPartitionStartSector * $Script:Settings.MBRSectorSizeBytes
    $offsettoLabel = 71
    $LabelLength = 11
    $NewLabel = ("$((Get-InputCSVs -Diskdefaults | Where-Object {$_.Disk -eq "Emu68Boot"}).VolumeName)           ").Substring(0,$LabelLength)
    $LabelNewbytes = [System.Text.Encoding]::UTF8.GetBytes($NewLabel)
    
    $stream = [System.IO.File]::Open($Path, [System.IO.FileMode]::Open, [System.IO.FileAccess]::ReadWrite)
    $stream.seek(($PartitionStart+$offsettoLabel), 'Begin') | Out-Null
    $stream.Write($LabelNewbytes, 0, $LabelNewbytes.Length)
    Write-InformationMessage -Message "Volume label updated to $NewLabel"
    $stream.close()
    return
    
    #$stream.seek(($PartitionStart+$offsettoLabel), 'Begin') | Out-Null
    #$reader = New-Object System.IO.BinaryReader($stream)
    #$LabelBytes = $reader.ReadBytes($LabelLength)
    #Write-host "Current label is: $([System.Text.Encoding]::ASCII.GetString($LabelBytes))"

}