$Script:DP_Settings = [PSCustomObject]@{
    PartitionPrefix = 'WPF_DP_Partition_'
}


$Script:Settings = [PSCustomObject]@{
    Version = $null
    PowershellVersion = ((($PSVersionTable.PSVersion).Major).ToString()+'.'+(($PSVersionTable.PSVersion).Minor))
    NetFrameworkrelease = Get-ItemPropertyValue -LiteralPath 'HKLM:SOFTWARE\Microsoft\NET Framework Setup\NDP\v4\Full' -Name Release
    WindowsLocale = ((((Get-WinSystemLocale).Name).Tostring())+' ('+(((Get-WinSystemLocale).DisplayName).Tostring())+')')
    WindowsVersion = (Get-WmiObject -class Win32_OperatingSystem).Caption
    Architecture = (Get-WmiObject win32_operatingsystem | Select-Object osarchitecture).osarchitecture
    DefaultADFLocation = '.\UserFiles\ADFs'
    DefaultROMLocation = '.\UserFiles\Kickstarts'
    InputFiles = '.\InputFiles'
    ListofInstallFiles = '.\InputFiles\ListofInstallFiles.CSV'
    ListofPackagestoInstall = '.\InputFiles\ListofPackagestoInstall.CSV'
    RomHashes = '.\InputFiles\RomHashes.CSV'
    ADFHashes = '.\InputFiles\ADFHashes.CSV'
    ScreenModes = '.\InputFiles\ScreenModes.CSV'
    PathtoInputFileSpreadsheet = 'https://docs.google.com/spreadsheets/d/12UcKD7INDH9y7Tw_w1q3ebQOUS9JtARIs8Z9JWfLUWg/'
    LogFolder = '.\Logs'
    LogLocation = $null
    AmigaTempDrive = '.\Temp\AmigaDrives'
    LocationofAmigaFiles = '.\AmigaFiles'
    QuickStart_URL = "https://mja65.github.io/Emu68-Imager/quickstart.html"
    Documentation_URL = "https://mja65.github.io/Emu68-Imager/"
    #DefaultImageLocation = 
    # LogDateTime = (Get-Date -Format yyyyMMddHHmmss).tostring()
    # TempFolder = '.\Temp\'
}

$Script:GUIActions = [PSCustomObject]@{
    RomNeeded = $false
    WorkbenchFilesNeeded = $null
    ScreenModetoUse = $null
    ScreenModetoUseFriendlyName =$null
    AvailableKickstarts = $null
    AvailableScreenModes = $null
    KickstartVersiontoUse = $null
    KickstartVersiontoUseFriendlyName = $null
    UseGlowIcons = $null
    SSID = $null
    WifiPassword = $null
    FoundADFstoUse = $null
    FoundADFStoUseType = $null 
    FoundKickstarttoUse = $null
    StorageADFPath = $null
    GlowIconsADFPath = $null
    IsDisclaimerAccepted = $null
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
    ADFLocation = $null
    ROMLocation = $null
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
    # HSTLocation = 'E:\Emu68Imager\Working Folder\Programs\HST-Imager'
    SevenZipFilePath = '.\Programs\7z.exe'
    FindFreeSpacePath = '.\Programs\FindFreeSpace.exe'
    DDTCPath = '.\Programs\ddtc.exe'
    HSTImagerPath = '.\Programs\HSTImager\hst.imager.exe'
    HSTImagerReleaseVersion = '1.2.396'
    HSTAmigaPath =  '.\Programs\HSTAmiga\Hst.amiga.exe'
    HSTAmigaReleaseVersion = '0.3.163'
    PFS3AIOPath= '.\Programs\HSTImager\pfs3aio'
    TempFolder = '.\Temp'
    HSTImagerURL = 'https://api.github.com/repos/henrikstengaard/hst-imager/releases'
    HSTAmigaURL = 'https://api.github.com/repos/henrikstengaard/hst-amiga/releases'
    Emu68URL = 'https://api.github.com/repos/michalsc/Emu68/releases'
    Emu68ToolsURL = 'https://api.github.com/repos/michalsc/Emu68-tools/releases'
}
