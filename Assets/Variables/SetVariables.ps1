$Script:DP_Settings = [PSCustomObject]@{
    PartitionPrefix = 'WPF_DP_Partition_'
}

$Script:Settings = [PSCustomObject]@{
    PartitionPixelBuffer = 5 # To account for not exact mouse pointer precision
    DebugMode = $false
    Version = $null
    PowershellVersion = ((($PSVersionTable.PSVersion).Major).ToString()+'.'+(($PSVersionTable.PSVersion).Minor))
    NetFrameworkrelease = Get-ItemPropertyValue -LiteralPath 'HKLM:SOFTWARE\Microsoft\NET Framework Setup\NDP\v4\Full' -Name Release
    WindowsLocale = ((((Get-WinSystemLocale).Name).Tostring())+' ('+(((Get-WinSystemLocale).DisplayName).Tostring())+')')
    WindowsVersion = (Get-WmiObject -class Win32_OperatingSystem).Caption
    Architecture = (Get-WmiObject win32_operatingsystem | Select-Object osarchitecture).osarchitecture
    TempFolder = '.\Temp'
    InterimAmigaDrives = '.\Temp\InterimAmigaDrives' 
    WebPackagesDownloadLocation = '.\Temp\WebPackagesDownload'
    LocalPackagesDownloadLocation = '.\Temp\LocalPackagesDownload'
    StartupFiles = '.\Temp\StartupFiles'
    LocationofAmigaFiles = '.\Assets\AmigaFiles'
    DefaultSettingsLocation = '.\Settings'
    DefaultOutputImageLocation = '.\UserFiles\SavedOutputImages'
    DefaultInstallMediaLocation = '.\UserFiles\InstallMedia'
    DefaultImportLocation = '.\UserFiles\ImportFiles'
    DefaultROMLocation = '.\UserFiles\Kickstarts'
    DownloadedFileSystems = '.\UserFiles\FileSystems'
    DefaultAmigaFileSystemLocation = '.\Assets\AmigaFileSystems'
    InputFiles = [PSCustomObject]@{
        Path = '.\InputFiles'
        InputFileSpreadsheetURL = 'https://docs.google.com/spreadsheets/d/12UcKD7INDH9y7Tw_w1q3ebQOUS9JtARIs8Z9JWfLUWg/'
    }
    AminetMirrorsCSV = [PSCustomObject]@{
        Path = '.\InputFiles\AminetMirrors.CSV'
        GID = '1378987830'
    }
    StartupFilesCSV = [PSCustomObject]@{
        Path = '.\InputFiles\StartupFiles.CSV'
        GID = '704643152'
    }
    OSVersionstoInstallCSV = [PSCustomObject]@{
        Path = '.\InputFiles\OSVersionstoInstall.CSV'
        GID = '280506415'
    }
    ROMHashesCSV = [PSCustomObject]@{
        Path = '.\InputFiles\RomHashes.CSV'
        GID = '1439711656'
    }
    InstallMediaHashesCSV = [PSCustomObject]@{
        Path = '.\InputFiles\InstallMediaHashes.CSV'
        GID = '0'
    }
    ListofPackagestoInstallCSV = [PSCustomObject]@{
        Path = '.\InputFiles\ListofPackagestoInstall.CSV'
        GID = '322661130'
    }
    ScreenModesCSV = [PSCustomObject]@{
        Path = '.\InputFiles\ScreenModes.CSV'
        GID = '860542576'
    }
    FileSystemsCSV = [PSCustomObject]@{
        Path = '.\InputFiles\FileSystems.CSV'
        GID = '379284989'
    }
    DiskDefaultsCSV = [PSCustomObject]@{
        Path = '.\InputFiles\DiskDefaults.CSV'
        GID = '784658683'
    }
    TotalNumberofTasks = 2
    CurrentTaskNumber = 0
    CurrentTaskName = $null
    TotalNumberofSubTasks = $null
    CurrentSubTaskNumber = $null
    CurrentSubTaskName = $null
    LogFolder = '.\Logs'
    LogLocation = $null
    QuickStart_URL = "https://mja65.github.io/Emu68-Imager/quickstart.html"
    Documentation_URL = "https://mja65.github.io/Emu68-Imager/"
    #DefaultImageLocation = 
    # LogDateTime = (Get-Date -Format yyyyMMddHHmmss).tostring()
    # TempFolder = '.\Temp\'
}

$Script:GUICurrentStatus = [PSCustomObject]@{
    HSTCommandstoProcess = [PSCustomObject]@{
        NewDiskorImage = @()
        DiskStructures = @()
        CopyImportedFiles = @()
        WriteFilestoDisk = @()
    }
    IssuesFoundBeforeProcessing = New-Object System.Data.DataTable
    ProcessImageStatus = $false
    PathstoRDBPartitions = [System.Collections.Generic.List[PSCustomObject]]::New()
    InstallMediaRequiredFromUserSelectablePackages = @()
    StartTimeForRunningInstall = $null
    EndTimeForRunningInstall  = $null
    ImportedPartitionType = $null
    SelectedPhysicalDiskforImport = $null
    ImportedImagePath = $null
    TransferSourceLocation  = $null
    TransferSourceType = $null
    LastCommandTime = $null
    CurrentWindow = $null
    MouseStatus = $null
    CurrentMousePositionX = $null
    MousePositionXatTimeofPress = $null
    CurrentMousePositionY = $null
    MousePositionYatTimeofPress = $null
    SelectedGPTMBRPartition = $null
    ActionToPerform = $null
    SelectedAmigaPartition = $null
    PartitionHoveredOver = $null
    AvailableSpaceforImportedMBRGPTPartitionBytes = $null
    MBRPartitionstoImportDataTable = New-Object System.Data.DataTable
    RDBPartitionstoImportDataTable = New-Object System.Data.DataTable
#   MBRPartitionContextMenuEnabled = $false
#    AmigaPartitionContextMenuEnabled = $false
}
$Script:GUICurrentStatus.IssuesFoundBeforeProcessing.Columns.Add((New-Object System.Data.DataColumn "Area",([string])))
$Script:GUICurrentStatus.IssuesFoundBeforeProcessing.Columns.Add((New-Object System.Data.DataColumn "Issue",([string])))
$Script:GUICurrentStatus.MBRPartitionstoImportDataTable.Columns.Add((New-Object System.Data.DataColumn "PartitionNumber",([string])))
$Script:GUICurrentStatus.MBRPartitionstoImportDataTable.Columns.Add((New-Object System.Data.DataColumn "PartitionType",([string])))
$Script:GUICurrentStatus.MBRPartitionstoImportDataTable.Columns.Add(( New-Object System.Data.DataColumn "Size",([string])))
$Script:GUICurrentStatus.MBRPartitionstoImportDataTable.Columns.Add(( New-Object System.Data.DataColumn "SizeBytes",([Int64])))

for ($i = 0; $i -lt $Script:GUICurrentStatus.MBRPartitionstoImportDataTable.Columns.Count; $i++) {
    if (($Script:GUICurrentStatus.MBRPartitionstoImportDataTable.Columns[$i].ColumnName) -eq 'SizeBytes'){
        $Script:GUICurrentStatus.MBRPartitionstoImportDataTable.Columns[$i].ColumnMapping= [System.Data.MappingType]::Hidden
    }
}


$Script:GUICurrentStatus.RDBPartitionstoImportDataTable.Columns.Add((New-Object System.Data.DataColumn ”MBRPartitionNumber”,([string])))
$Script:GUICurrentStatus.RDBPartitionstoImportDataTable.Columns.Add((New-Object System.Data.DataColumn ”DeviceName”,([string]))) 
$Script:GUICurrentStatus.RDBPartitionstoImportDataTable.Columns.Add((New-Object System.Data.DataColumn ”VolumeName”,([string]))) 
$Script:GUICurrentStatus.RDBPartitionstoImportDataTable.Columns.Add((New-Object System.Data.DataColumn ”LowCylinder”,([string]))) 
$Script:GUICurrentStatus.RDBPartitionstoImportDataTable.Columns.Add((New-Object System.Data.DataColumn ”HighCylinder”,([string]))) 
$Script:GUICurrentStatus.RDBPartitionstoImportDataTable.Columns.Add((New-Object System.Data.DataColumn ”Size”,([string]))) 
$Script:GUICurrentStatus.RDBPartitionstoImportDataTable.Columns.Add((New-Object System.Data.DataColumn ”StartOffset”,([string]))) 
$Script:GUICurrentStatus.RDBPartitionstoImportDataTable.Columns.Add((New-Object System.Data.DataColumn ”EndOffset”,([string]))) 
$Script:GUICurrentStatus.RDBPartitionstoImportDataTable.Columns.Add((New-Object System.Data.DataColumn ”Buffers”,([string]))) 
$Script:GUICurrentStatus.RDBPartitionstoImportDataTable.Columns.Add((New-Object System.Data.DataColumn ”DosType”,([string]))) 
$Script:GUICurrentStatus.RDBPartitionstoImportDataTable.Columns.Add((New-Object System.Data.DataColumn ”MaxTransfer”,([string]))) 
$Script:GUICurrentStatus.RDBPartitionstoImportDataTable.Columns.Add((New-Object System.Data.DataColumn ”Bootable”,([string]))) 
$Script:GUICurrentStatus.RDBPartitionstoImportDataTable.Columns.Add((New-Object System.Data.DataColumn ”NoMount”,([string]))) 
$Script:GUICurrentStatus.RDBPartitionstoImportDataTable.Columns.Add((New-Object System.Data.DataColumn ”Priority”,([string]))) 
$Script:GUICurrentStatus.RDBPartitionstoImportDataTable.Columns.Add((New-Object System.Data.DataColumn ”SizeBytes”,([int64]))) 

for ($i = 0; $i -lt $Script:GUICurrentStatus.RDBPartitionstoImportDataTable.Columns.Count; $i++) {
    if (($Script:GUICurrentStatus.RDBPartitionstoImportDataTable.Columns[$i].ColumnName) -eq 'MBRPartitionNumber'){
        $Script:GUICurrentStatus.RDBPartitionstoImportDataTable.Columns[$i].ColumnMapping= [System.Data.MappingType]::Hidden
    }
    if (($Script:GUICurrentStatus.RDBPartitionstoImportDataTable.Columns[$i].ColumnName) -eq 'SizeBytes'){
        $Script:GUICurrentStatus.RDBPartitionstoImportDataTable.Columns[$i].ColumnMapping= [System.Data.MappingType]::Hidden
    }
}

$Script:GUIActions = [PSCustomObject]@{
    # Not in GUI - Start
    #InstallType = $null
    InstallType = 'PiStorm'
    #Not in GUI - End
    ScreenModetoUse = $null
    ScreenModetoUseFriendlyName =$null
    AvailableKickstarts = $null
    AvailableScreenModes = $null
    AvailablePackages = $null
    KickstartVersiontoUse = $null
    KickstartVersiontoUseFriendlyName = $null
    OSInstallMediaType = $null
    UseGlowIcons = $null
    SSID = $null
    WifiPassword = $null
    FoundInstallMediatoUse = $null
    FoundKickstarttoUse = $null
    IsDisclaimerAccepted = $null
    ListofRemovableMedia = $null
    ImportPartitionWindowStatus = $null

    # TransferFilesImagePath = $null
    # TransferSourceLocation = $null
    # TransferSourceType = $null
    # TransferAmigaSourceType = $null
    SelectedPhysicalDiskforTransfer = $null
    ScriptPath = $null
    DiskTypeSelected = $null
    DiskSizeSelected = $null
    OutputPath = $null
    InstallMediaLocation = $null
    ROMLocation = $null
    # SelectedGPTMBRPartitionforImport = $null
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

$Script:SDCardMinimumsandMaximums = [PSCustomObject]@{
    EMU68BOOTMinimum  = $null
    GPTMinimum = $null
    MBRMinimum = $null
    ID76Minimum = $null  
    PFS3Maximum = $null
    SystemMinimum = $null  
    PFS3Minimum = $null
    EMU68BOOTDefault = $null   
    WorkbenchDefault = $null
    DefaultAddMBRSize = $null
    DefaultAddGPTSize = $null
    DefaultAddID76Size = $null
    DefaultAddPFS3Size  = $null
}

$Script:ExternalProgramSettings = [PSCustomObject]@{
    SevenZipFilePath = '.\Programs\7z.exe'
    UnlzxFilePath = '.\Programs\unlzx.exe'
    FindFreeSpacePath = '.\Programs\FindFreeSpace.exe'
    DDTCPath = '.\Programs\ddtc.exe'
    HSTImagerPath = '.\Programs\HSTImager\hst.imager.exe'
    HSTAmigaPath =  '.\Programs\HSTAmiga\Hst.amiga.exe'
}
