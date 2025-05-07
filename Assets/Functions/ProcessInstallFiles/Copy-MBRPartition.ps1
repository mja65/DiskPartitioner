function Copy-MBRPartition {
    param (
        $SourcePath,
        $SourcePartitionNumber,
        $DestinationPath,
        $DestinationPartitionNumber
    )
    
    $arguments = @("mbr", "part", "clone", $SourcePath, $SourcepartitionNumber, $DestinationPath, $DestinationPartitionNumber)

    & $Script:ExternalProgramSettings.HSTImagerPath $arguments

}