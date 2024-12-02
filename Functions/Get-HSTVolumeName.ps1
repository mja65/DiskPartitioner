function Get-HSTVolumeName {
    param (
        $Path
    )
    
    #$Path = "\disk6\mbr\2\rdb"

    $DatatoParse = & $Script:ExternalProgramSettings.HSTImagePath fs dir $Path

    $HeadertoUse = 'Name','Size','Date','Attributes','DosType','FileSystemFree','FileSystemSize','FileSystemUsed','VolumeName'

    $HeadertoCheck = 'File system free'
    $Footertocheck = 'directories, '

    $PartitionDetails = @()
    $StartRow = 0
    $EndRow = 0    

    for ($i = 0; $i -lt $DataToParse.Count; $i++) {
        if ($DataToParse[$i] -match $HeadertoCheck){
            $StartRow = $i+2
        }
        if ($DataToParse[$i] -match $FootertoCheck){
            $EndRow = $i-2
            break
        }
    }
    
    for ($i = $StartRow ; $i -le $EndRow; $i++) {
        $PartitionDetails += ConvertFrom-Csv -InputObject $DataToParse[$i] -Delimiter '|' -Header $HeadertoUse   
    }

    return $PartitionDetails

}