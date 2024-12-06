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
    AvailableSpaceforImportedPartitionBytes = $null 
    ImportPartitionWindowStatus = $null
    SelectedPhysicalDiskforImport = $null
    ImportedImagePath = $null
    TransferFilesImagePath = $null
    TransferSourceLocation = $null
    TransferSourceType = $null
    TransferAmigaSourceType = $null
    SelectedPhysicalDiskforTransfer = $null
    ScriptPath = $null
    DiskSizeSelected = $null
    MouseStatus = $null
    OutputPath = $null
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
    ColourID76 = "#FF7B7B7B"
    ColourWorkbench = "#FFFFA997"
    ColourWork = "#FFAA907C" 
    ColourImported = "#FFAFAFAF"
}

$Script:SDCardMinimumsandMaximums = $null

$Script:ExternalProgramSettings = [PSCustomObject]@{
    HSTImagePath = 'C:\Users\Matt\OneDrive\Documents\hst-imager\hst-imager\src\Hst.Imager.ConsoleApp\bin\Debug\net8.0\Hst.Imager.ConsoleApp.exe'
    PFS3AIOPath= 'C:\Users\Matt\Downloads\hst-imager_v1.2.396-2cc164a_console_windows_x64\pfs3aio'
    TempFolder = '.\Temp'
}