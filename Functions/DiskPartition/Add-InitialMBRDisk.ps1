function Add-InitialMBRDisk {
    param (
        $DiskSizeBytes
    )
    if (-not $WPF_DP_Disk_MBR){
        $Script:WPF_DP_Disk_MBR = New-GUIDisk -DiskType 'MBR'
        $Script:WPF_DP_DiskGrid_MBR.AddChild($WPF_DP_Disk_MBR)
        
        $Script:WPF_DP_Disk_MBR.LeftDiskBoundary = 0 
        $Script:WPF_DP_Disk_MBR.RightDiskBoundary = $LeftDiskBoundary + $Script:WPF_DP_Disk_MBR.Children[0].Width
        $Script:WPF_DP_Disk_MBR.DiskSizePixels =  $WPF_DP_Disk_MBR.RightDiskBoundary-$WPF_DP_Disk_MBR.LefttDiskBoundary
        $Script:WPF_DP_Disk_MBR.DiskSizeBytes =  $DiskSizeBytes       
        $Script:WPF_DP_Disk_MBR.BytestoPixelFactor = ($Script:WPF_DP_Disk_MBR.DiskSizeBytes -$Script:WPF_DP_Disk_MBR.MBROverheadBytes) /$Script:WPF_DP_Disk_MBR.DiskSizePixels
    }
}
