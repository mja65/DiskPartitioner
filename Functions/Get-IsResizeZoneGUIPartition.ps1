function Get-IsResizeZoneGUIPartition {
    param (
        $ObjectName,
        $MouseX
    )

    #$ObjectName = 'WPF_UI_DiskPartition_Partition_ID76_2'
    #$MouseX = 199
    $PixelThreshold = 5
    $InResizeZone = $null

    if (-not ($ObjectName)){
        return $InResizeZone 
    }

    if (($MouseX -gt ((Get-Variable -Name $ObjectName).Value.Margin.Left - $PixelThreshold)) -and `
        ($MouseX -lt  ((Get-Variable -Name $ObjectName).Value.Margin.Left + $PixelThreshold)))
    {
        $InResizeZone = 'ResizeFromLeft'
    } 
    elseif  (($MouseX -gt ((Get-Variable -Name $ObjectName).Value.Margin.Left + (Get-GUIPartitionWidth -Partition (Get-Variable -Name $ObjectName).Value) - $PixelThreshold)) -and `
            ($MouseX -lt ((Get-Variable -Name $ObjectName).Value.Margin.Left + (Get-GUIPartitionWidth -Partition (Get-Variable -Name $ObjectName).Value) + $PixelThreshold)))
    {
        $InResizeZone = 'ResizeFromRight'
    }  

    return $InResizeZone 

}
