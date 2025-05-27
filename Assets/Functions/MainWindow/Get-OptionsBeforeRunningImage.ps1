function Get-OptionsBeforeRunningImage {
    param (
       
    )
    
    Remove-Variable -Name 'WPF_RunWindow_*'

    $WPF_RunWindow = Get-XAML -WPFPrefix 'WPF_RunWindow_' -XMLFile '.\Assets\WPF\Window_RunOptions.xaml' -ActionsPath '.\Assets\UIActions\RunWindow\' -AddWPFVariables

    $DiskSizetoReport = (Get-ConvertedSize -Size $WPF_DP_Disk_GPTMBR.DiskSizeBytes -ScaleFrom 'B' -AutoScale)
    $NumberofMBRPartitions = ($Script:GUICurrentStatus.GPTMBRPartitionsandBoundaries).Count
    if ($Script:GUIActions.WifiPassword){
        $WifiPassword = "Password has been set"
    }
    else{
        $WifiPassword = "Not Configured"
    }
    if ($Script:GUIActions.SSID){
        $SSID = $Script:GUIActions.SSID
    }
    else{
        $SSID  = "Not Configured"
    }

    if ($Script:GUIActions.InstallOSFiles -eq $true){
        $InstallType = "Full Install"
    }    
    else {
        $InstallType = "Partition disk and Emu68 install only"
    }
    
    $Script:GUICurrentStatus.RunOptionstoReport.Clear()
    
    $null = $Script:GUICurrentStatus.RunOptionstoReport.Rows.Add("Type of Install",$InstallType)

    If ($Script:GUIActions.InstallOSFiles -eq $true){
        $null = $Script:GUICurrentStatus.RunOptionstoReport.Rows.Add("OS to be Installed",$Script:GUIActions.KickstartVersiontoUseFriendlyName)
    }
    $null = $Script:GUICurrentStatus.RunOptionstoReport.Rows.Add("Disk or Image",$Script:GUIActions.OutputType)
    $null = $Script:GUICurrentStatus.RunOptionstoReport.Rows.Add("Location to be installed",$Script:GUIActions.OutputPath)
    $null = $Script:GUICurrentStatus.RunOptionstoReport.Rows.Add("ScreenMode to Use",$Script:GUIActions.ScreenModetoUseFriendlyName)
    $null = $Script:GUICurrentStatus.RunOptionstoReport.Rows.Add("Disk Size","$($DiskSizetoReport.Size) $($DiskSizetoReport.Scale) `($($WPF_DP_Disk_GPTMBR.DiskSizeBytes) bytes`)")
    $null = $Script:GUICurrentStatus.RunOptionstoReport.Rows.Add("Number of MBR Partitions to Write",$NumberofMBRPartitions)
    If ($Script:GUIActions.InstallOSFiles -eq $true){
        $null = $Script:GUICurrentStatus.RunOptionstoReport.Rows.Add("SSID to configure:",$SSID)
        $null = $Script:GUICurrentStatus.RunOptionstoReport.Rows.Add("Wifi Password to set:",$WifiPassword)
    }
    

    $WPF_RunWindow_RunOptions_Datagrid.ItemsSource = $Script:GUICurrentStatus.RunOptionstoReport.DefaultView
    
     $WPF_RunWindow.ShowDialog() | out-null
    
#$WPF_RunWindow.Width
# $WPF_RunWindow_RunOptions_Datagrid.Columns

}

