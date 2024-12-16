function Confirm-DefaultOSFilesNeeded {
    param (

    )
    
    $AmigaPartitions = Get-AllGUIPartitions -PartitionType 'Amiga'
    $MBRPartitions = Get-AllGUIPartitions -PartitionType 'MBR' 
    
    if (-not ($MBRPartitions) -or -not ($AmigaPartitions)){
        return
    }  
    else {
        $ValuestoReturn = [PSCustomObject]@{
            RomNeeded= $false
            WorkbenchFilesNeeded = 'None'
        }
        
        $AmigaPartitions | ForEach-Object {
           if ($_.value.ImportedPartition -eq $false){
                if ($_.value.DefaultAmigaWorkbenchPartition -eq $true){
                    $ValuestoReturn.WorkbenchFilesNeeded  = 'All'
                }
                if ($_.value.dostype -eq 'DOS\3' -or $_.value.dostype -eq 'DOS\7') {
                    if ($null -eq $ValuestoReturn.WorkbenchFilesNeeded){
                        $ValuestoReturn.WorkbenchFilesNeeded = 'InstallADFOnly'
                    }
                }
           }
        }
        
        $MBRPartitions | ForEach-Object {
            if ($_.value.DefaultMBRPartition -eq $true -and $_.value.PartitionType -eq 'FAT32'){
                $ValuestoReturn.RomNeeded = $true
            }
        }

        return $ValuestoReturn

    }
    
}