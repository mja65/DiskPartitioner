function Update-RDBonImportedPartition {
    param (
        $DestinationPath,
        $DestinationPartitionNumber,
        $Parameters
    )

    $arguments = @("rdb", "part", "update", $DestinationPath, $DestinationPartitionNumber, $Parameters)

    & $Script:ExternalProgramSettings.HSTImagerPath $arguments
}