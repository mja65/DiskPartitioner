function Get-DeviceandVolumeNametoUse {
    param (

    )
    
    $OutputtoReturn  = [PSCustomObject]@{
        DeviceName = $null
        VolumeName = $null
    }
    
    $VolumeNamePrefix = "$((Get-InputCSVs -Diskdefaults | Where-Object {$_.Disk -eq "Work"}).VolumeName)_"
    $DeviceNamePrefix = (Get-InputCSVs -Diskdefaults | Where-Object {$_.Disk -eq "Work"}).devicename -replace "\d", "" 
    $DeviceNumbertoUse = 0
    $VolumeNameCountertoUse = 0
    
    $Script:GUICurrentStatus.AmigaPartitionsandBoundaries | ForEach-Object {
        $DevicetoCheck = $_.Partition.devicename 
        $VolumeNametoCheck = $_.Partition.VolumeName 
        if ($VolumeNametoCheck -match "Work_"){
            if (([int]($VolumeNametoCheck -replace "Work_","")) -gt $VolumeNameCountertoUse){
                $VolumeNameCountertoUse = [int]($VolumeNametoCheck -replace "Work_","")
            }
        }
        if (($DevicetoCheck -replace "\d", "") -eq $DeviceNamePrefix){
            if ([int]($DevicetoCheck -replace "\D", "") -gt $DeviceNumbertoUse){
                $DeviceNumbertoUse = [int]($DevicetoCheck -replace "\D")
            }
    
        } 
    }
    
    $DeviceNumbertoUse ++
    $VolumeNameCountertoUse ++
    
    $OutputtoReturn.DeviceName = "$DeviceNamePrefix$DeviceNumbertoUse"
    $OutputtoReturn.VolumeName = "$VolumeNamePrefix$VolumeNameCountertoUse"

    return $OutputtoReturn
}