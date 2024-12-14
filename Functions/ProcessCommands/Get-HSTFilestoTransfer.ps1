function Get-HSTFilestoTransfer {
    param (
       
    )
    
    $FileDetails = [System.Collections.Generic.List[PSCustomObject]]::New()
    $AmigaPartitions = Get-AllGUIPartitions -PartitionType 'Amiga' 
    
    $HSTImagerCommand = 'fs copy '
    
    foreach ($Partition in $AmigaPartitions){
        if ($Partition.Value.ImportedFiles){
            foreach ($File in $Partition.Value.ImportedFiles) {
                if ($File.PathHeader){
                    $SourcePath = "$($File.PathHeader)$($File.FullPath)"
                }
                else {
                    $SourcePath = $File.FullPath
                }
                $FileDetails += [PSCustomObject]@{
                    HSTImagerCommand = $HSTImagerCommand
                    SourcePath =  $SourcePath 
                    DestinationPath = 'TOBECOMPLETED'
                }

            }
        }

    }

    return $FileDetails 
}