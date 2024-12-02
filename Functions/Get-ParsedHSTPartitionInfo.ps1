function Get-ParsedHSTPartitionInfo {
    param (
        $DataToParse,
        $FirstHeader,
        $SecondHeader,
        $HeadertoUse
   
    )    

    $PartitionDetails = @()
    $StartRow = 0
    $EndRow = 0    

    for ($i = 0; $i -lt $DataToParse.Count; $i++) {
        if ($DataToParse[$i] -match $FirstHeader){
            $StartRow = $i+2
        }
        if ($DataToParse[$i] -match $SecondHeader){
            $EndRow = $i-2
            break
        }
    }

    for ($i = $StartRow ; $i -le $EndRow; $i++) {
        $PartitionDetails += ConvertFrom-Csv -InputObject $DataToParse[$i] -Delimiter '|' -Header $HeadertoUse   
    }

    return $PartitionDetails

}