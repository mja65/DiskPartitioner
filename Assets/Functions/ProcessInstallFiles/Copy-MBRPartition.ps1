function Copy-MBRPartition {
    param (
        $SourcePath,
        $SourcePartitionNumber,
        $DestinationPath,
        $DestinationPartitionNumber
    )
    
    # $SourcePath="C:\Users\Matt\Downloads\CaffeineOS_Storm_9311.img"
    # $SourcePartitionNumber = 2
    # $DestinationPath = "C:\Users\Matt\OneDrive\Documents\DiskPartitioner\Programs\HSTImager\test - Copy - Copy.vhd"
    # $DestinationPartitionNumber = 1
    
    $arguments = @("mbr", "part", "clone", $SourcePath, $SourcepartitionNumber, $DestinationPath, $DestinationPartitionNumber)
    
    if ($Script:Settings.HSTDetailedLogEnabled -eq $true){
        "Log entries for: HST Imager ran with the following arguments [mbr part clone `"$SourcePath`" $SourcepartitionNumber `"$DestinationPath`" $DestinationPartitionNumber] - START" | Out-File -FilePath $Script:Settings.HSTDetailedLogLocation -Append
        "" | Out-File -FilePath $Script:Settings.HSTDetailedLogLocation -Append        
    }
    
    & $Script:ExternalProgramSettings.HSTImagerPath $arguments  |
     ForEach-Object {
         if ($_ -match '^\d+(\.\d+)?%') {
             # Write progress on the same console line
             Write-Host -NoNewline "`r$_"
         }
         else {
             # Log to file
             if ($Script:Settings.HSTDetailedLogEnabled -eq $true){
                 Add-Content -Path $Script:Settings.HSTDetailedLogLocation -Value $_
             }
             # Also print normally
             Write-Host $_
         }
     }

    }
 
    # & $Script:ExternalProgramSettings.HSTImagerPath $arguments 
 