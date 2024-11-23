$Script:DP_Settings = [PSCustomObject]@{
    PartitionPrefix = 'WPF_DP_Partition_'
}


# $Script:Settings = [PSCustomObject]@{
#     LogLocation = '.\Logs\Log.txt'
#     LogFolder = '.\Logs\'
#     LogDateTime = (Get-Date -Format yyyyMMddHHmmss).tostring()
#     HSTLocation = 'E:\Emu68Imager\Working Folder\Programs\HST-Imager'
#     TempFolder = '.\Temp\'
# }

$Script:GUIActions = [PSCustomObject]@{
    DiskSizeSelected = $null
    MouseStatus = $null
    CurrentMousePositionX = $null
    MousePositionXatTimeofPress = $null
    CurrentMousePositionY = $null
    MousePositionYatTimeofPress = $null
    SelectedMBRPartition = $null
    ActionToPerform = $null
    SelectedAmigaPartition = $null
    PartitionHoveredOver = $null
    MBRPartitionContextMenuEnabled = $false
    AmigaPartitionContextMenuEnabled = $false
    # MBRPartitionIsSelectedAction = $false
    # MBRPartitionIsUnselectedAction =$false
    # AmigaPartitionIsSelectedAction = $false
    # AmigaPartitionIsUnselectedAction =$false
    # IsAmigaPartitionShowing = $false
}

$Script:SDCardMinimumsandMaximums = $null