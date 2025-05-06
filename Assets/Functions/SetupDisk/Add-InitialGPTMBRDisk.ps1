function Add-InitialGPTMBRDisk {
    param (
        $DiskSizeBytes,
        $DiskType
    )
    
    if ($DiskType -eq 'PiStorm - MBR'){
        $DiskTypetouse = 'MBR'
    } 
    elseif ($DiskType -eq 'PiStorm - GPT'){
        $DiskTypetouse = 'GPT'        
    }
    else {
        Write-Host "Error in coding - Add-InitialGPTMBRDisk!"
        $WPF_MainWindow.Close()
        exit
    }

    if (-not $WPF_DP_Disk_GPTMBR){

        $MBRSectorAdjustmentBytes = $DiskSizeBytes - (Get-MBRNearestSizeBytes -RoundDown -SizeBytes $DiskSizeBytes) 
        If ($Script:Settings.DebugMode){
            Write-Host "Rounded down disksize by: $MBRSectorAdjustmentBytes"

        }
        $Script:WPF_DP_Disk_GPTMBR = New-GUIDisk -DiskType $DiskTypetouse
        $Script:WPF_DP_DiskGrid_GPTMBR.AddChild($WPF_DP_Disk_GPTMBR)      
        $Script:WPF_DP_Disk_GPTMBR.LeftDiskBoundary = 0 
        $Script:WPF_DP_Disk_GPTMBR.RightDiskBoundary = $LeftDiskBoundary + $Script:WPF_DP_Disk_GPTMBR.Children[0].Width
        $Script:WPF_DP_Disk_GPTMBR.DiskSizePixels =  $WPF_DP_Disk_GPTMBR.RightDiskBoundary-$WPF_DP_Disk_GPTMBR.LefttDiskBoundary
        $Script:WPF_DP_Disk_GPTMBR.DiskSizeBytes =  $DiskSizeBytes 
        $Script:WPF_DP_Disk_GPTMBR.MBROverheadBytes += $MBRSectorAdjustmentBytes 
        $Script:WPF_DP_Disk_GPTMBR.BytestoPixelFactor = ($Script:WPF_DP_Disk_GPTMBR.DiskSizeBytes - $Script:WPF_DP_Disk_GPTMBR.MBROverheadBytes) /$Script:WPF_DP_Disk_GPTMBR.DiskSizePixels
    }
}
