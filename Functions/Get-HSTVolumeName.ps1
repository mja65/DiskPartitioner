function Get-HSTVolumeName {
    param (
        $Path
    )
    
    # $Path = "\disk6\mbr\2\rdb"
    # $Path = "E:\Emulators\Amiga Files\Shared\hdf\workbench-311.hdf\rdb"

    $DatatoParse = & $Script:ExternalProgramSettings.HSTImagerPath fs dir $Path

    $HeadertoUse = 'Name','Size','Date','Attributes','DosType','FileSystemFree','FileSystemSize','FileSystemUsed','VolumeName'

    $HeadertoCheck = 'File system free'
    $Footertocheck = 'directories, '
    $FootertoCheck2 = 'directory, '

    $PartitionDetails = @()
    $StartRow = 0
    $EndRow = 0    

    for ($i = 0; $i -lt $DataToParse.Count; $i++) {
        if ($DataToParse[$i] -match $HeadertoCheck){
            $StartRow = $i+2
        }
        if (($DataToParse[$i] -match $FootertoCheck) -or ($DataToParse[$i] -match $FootertoCheck2)){
            $EndRow = $i-2
            break
        }
    }
    
    if ($StartRow -eq 0 -and $EndRow -eq 0){
        return
    }

    for ($i = $StartRow ; $i -le $EndRow; $i++) {
        $PartitionDetails += ConvertFrom-Csv -InputObject $DataToParse[$i] -Delimiter '|' -Header $HeadertoUse   
    }

    return $PartitionDetails

}