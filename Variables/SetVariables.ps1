Remove-Variable -name WPF_UI_DiskPartition*

$Script:Options = [PSCustomObject]@{
    LogLocation = '.\Logs\Log.txt'
    LogFolder = '.\Logs\'
    LogDateTime = (Get-Date -Format yyyyMMddHHmmss).tostring()
    HSTLocation = 'E:\Emu68Imager\Working Folder\Programs\HST-Imager'
    TempFolder = '.\Temp\'
}


$Script:GUIActions = [PSCustomObject]@{
    MouseStatus = $null
    ActionToPerform = $null
    SelectedMBRPartition = $null
    SelectedAmigaPartition = $null
    MousePositionRelativetoWindowXatTimeofPress = $null
    MousePositionRelativetoWindowYatTimeofPress = $null
    IsAmigaPartitionShowing = $false
}

$Script:GUIUIInput = [PSCustomObject]@{
    DiskSizeBytes = $null
}

$Script:PistormSDCard = [PSCustomObject]@{
    FAT32MinimumSizePixels = 100
    ID76MinimumSizePixels = 100 
    AmigaMinimumSizePixels = 100
}

