function Set-AmigaDiskSizeOverhangPixels {
    param (
        $AmigaDisk
    )
    # $AmigaDisk = $WPF_DP_Partition_MBR_2_AmigaDisk

    $OverhangPixels = Get-AmigaDiskPixelOverhang -AmigaDisk $AmigaDisk

    if ($OverhangPixels -gt 1){

        $AmigaDisk.Children[0].Width += $OverhangPixels
        $AmigaDisk.RightDiskBoundary =  $AmigaDisk.Children[0].Width
    }
    
}