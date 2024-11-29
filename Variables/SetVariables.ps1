$Script:DP_Settings = [PSCustomObject]@{
    PartitionPrefix = 'WPF_DP_Partition_'
}


$Script:Settings = [PSCustomObject]@{

    PowershellVersion = ((($PSVersionTable.PSVersion).Major).ToString()+'.'+(($PSVersionTable.PSVersion).Minor))
    #DefaultImageLocation = 
    # LogLocation = '.\Logs\Log.txt'
    # LogFolder = '.\Logs\'
    # LogDateTime = (Get-Date -Format yyyyMMddHHmmss).tostring()
    # HSTLocation = 'E:\Emu68Imager\Working Folder\Programs\HST-Imager'
    # TempFolder = '.\Temp\'
}

$Script:GUIActions = [PSCustomObject]@{
    ListofRemovableMedia = $null
    SelectedPhysicalDisk = $null
    AvailableSpaceforImportedPartitionBytes = $null 
    ImportedImagePath = $null
    TransferSourceLocation =$null
    ScriptPath = $null
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
    # SelectedMBRPartitionforImport = $null
    # MBRPartitionIsSelectedAction = $false
    # MBRPartitionIsUnselectedAction =$false
    # AmigaPartitionIsSelectedAction = $false
    # AmigaPartitionIsUnselectedAction =$false
    # IsAmigaPartitionShowing = $false
}

$Script:GUIVisuals = [PSCustomObject]@{
    ColourFAT32 = "#FF3B67A2"
    ColourID76 = "Green"
    ColourWorkbench = "#FFFFA997"
    ColourWork = "#FFAA907C" 
}

$Script:SDCardMinimumsandMaximums = $null

$Script:ExternalProgramSettings = [PSCustomObject]@{
    HSTImagePath = 'C:\Users\Matt\OneDrive\Documents\hst-imager\src\Hst.Imager.ConsoleApp\bin\Debug\net8.0\Hst.Imager.ConsoleApp.exe'
}