function Get-MinimumPartitionSizes {
    param (
        $SizeofDiskBytes,
        $EMU68BOOTDivider,
        $EMU68BOOTMinimum,
        $MBRMinimum,
        $GPTMinimum,
        $ID76Minimum,
        $PFS3Maximum,
        $SystemMinimum,
        $PFS3Minimum, 
        $DefaultAddMBRSize, 
        $DefaultAddGPTSize,   
        $DefaultAddID76Size,  
        $DefaultAddPFS3Size,  
        $DiskType,
        $EMU68BOOTDefaultMaximum,
        $WorkbenchDefaultMaximum, 
        $WorkbenchDivider     
    )

    if  (-not ($DiskType)){
        Write-Host "Error in coding - Set-MinimumPartitionSizes!"
        $WPF_MainWindow.Close()
        exit
    } 

    # $FAT32Divider = 15
    # $Fat32DefaultMaximum = 1024*1024*1024
    # $WorkbenchDefaultMaximum = 1024*1024*1024
    # $WorkbenchDivider = 15
    # $Fat32Minimum = 35840*1024
    # $PFS3Maximum = 101*1024*1024*1024
    # $SystemMinimum = 100*1024*1024
    # $PFS3Minimum = 10*1024*1024*1024


    $DiskMinimumSizesBytes = [PSCustomObject]@{
        EMU68BOOTMinimum = $EMU68BOOTMinimum
        MBRMinimum = $MBRMinimum
        GPTMinimum = $GPTMinimum
        ID76Minimum = $ID76Minimum
        PFS3Maximum = $PFS3Maximum 
        SystemMinimum = $SystemMinimum
        PFS3Minimum = $PFS3Minimum 
        EMU68BOOTDefault = $null
        WorkbenchDefault = $null
        DefaultAddMBRSize = $DefaultAddMBRSize 
        DefaultAddGPTSize = $DefaultAddGPTSize   
        DefaultAddID76Size = $DefaultAddID76Size  
        DefaultAddPFS3Size = $DefaultAddPFS3Size  
    }


    if ($DiskType -eq 'PiStorm - MBR'){
        if ($SizeofDiskBytes/$EMU68BOOTDivider -ge $EMU68BOOTDefaultMaximum){
            $DiskMinimumSizesBytes.EMU68BOOTDefault =  $EMU68BOOTDefaultMaximum
        }
        else {
            $DiskMinimumSizesBytes.EMU68BOOTDefault =  $SizeofDiskBytes/$EMU68BOOTDivider
        }
    }
    elseif ($DiskType -eq 'PiStorm - GPT'){
        Write-Host "Error in coding - PiStorm - GPT!"
        $WPF_MainWindow.Close()
        exit
    }
    elseif ($DiskType -eq 'Amiga - RDB'){
        Write-Host "Error in coding - Amiga - RDB!"
        $WPF_MainWindow.Close()
        exit
    }

    if ($SizeofDiskBytes/$WorkbenchDivider -ge $WorkbenchDefaultMaximum){
        $DiskMinimumSizesBytes.WorkbenchDefault =  $WorkbenchDefaultMaximum
    }
    else {
        $DiskMinimumSizesBytes.WorkbenchDefault =  $SizeofDiskBytes/$WorkbenchDivider 
    }

    return $DiskMinimumSizesBytes
}
