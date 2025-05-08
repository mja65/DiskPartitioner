function Initialize-MBRDisk {
    param (
        $OutputLocationType
    )
    
    if ($OutputLocationType -eq 'VHDImage'){
        Write-InformationMessage -Message "Initialising MBR for .vhd image at path: $($Script:GUIActions.OutputPath)"
        if ($Script:GUIActions.OutputPath.Substring($Script:GUIActions.OutputPath.Length-3) -eq 'vhd'){
            $IsMounted = (Get-DiskImage -ImagePath $Script:GUIActions.OutputPath -ErrorAction Ignore).Attached
            if ($IsMounted -eq $false){
                $DeviceDetails = Mount-DiskImage -ImagePath $Script:GUIActions.OutputPath -NoDriveLetter
                $PowershellDiskNumber = $DeviceDetails.Number                
            }
            else {
                $PowershellDiskNumber = (Get-DiskImage -ImagePath $Script:GUIActions.OutputPath -ErrorAction Ignore).Number
            }
            $null = Initialize-Disk -Number $PowershellDiskNumber -PartitionStyle MBR
        }
        
        $null = Dismount-DiskImage -ImagePath $Script:GUIActions.OutputPath 

    }
    elseif (($OutputLocationType -eq 'ImgImage') -or ($OutputLocationType -eq 'Physical Disk')){
        if ($OutputLocationType -eq 'ImgImage'){
            Write-InformationMessage -Message "Adding command to initialise disk for disk image file at path: $($Script:GUIActions.OutputPath)"
        }
        elseif ($OutputLocationType -eq 'Physical Disk'){
            Write-InformationMessage -Message "Adding command to initialise disk for disk at path: $($Script:GUIActions.OutputPath)"
        }
        $Script:GUICurrentStatus.HSTCommandstoProcess.NewDiskorImage += [PSCustomObject]@{
            Command = "mbr init $($Script:GUIActions.OutputPath)"
            Sequence = 3           
        }   
    }
    # elseif ($OutputLocationType -eq 'Physical Disk'){
    #     $PowershellDiskNumber = $Script:GUIActions.OutputPath.Substring(5,($Script:GUIActions.OutputPath.Length-5))
    #     Write-InformationMessage -Message "Initialising MBR for physical disk at path: $($Script:GUIActions.OutputPath) - Disk number $PowershellDiskNumber"
    #     $null = Initialize-Disk -Number $PowershellDiskNumber -PartitionStyle MBR
    # }

}
