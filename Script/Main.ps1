<#PSScriptInfo
.VERSION 2.0
.GUID 73d9401c-ab81-4be5-a2e5-9fc0834be0fc
.AUTHOR SupremeTurnip
.COMPANYNAME
.COPYRIGHT
.TAGS
.LICENSEURI https://github.com/mja65/Emu68-Imager/blob/main/LICENSE
.PROJECTURI https://github.com/mja65/Emu68-Imager
.ICONURI
.EXTERNALMODULEDEPENDENCIES 
.REQUIREDSCRIPTS
.EXTERNALSCRIPTDEPENDENCIES
.RELEASENOTES
.PRIVATEDATA
#>

<# 
.DESCRIPTION 
Script for Emu68Imager 
#> 
Add-Type -AssemblyName PresentationFramework
Add-Type -AssemblyName System.Windows.Forms

Set-Location -Path (Split-Path -Path $PSScriptRoot -Parent)

Get-ChildItem -Path '.\Assets\Variables\' -Recurse | Where-Object { $_.PSIsContainer -eq $false } | ForEach-Object {
    . ($_).fullname
}

Get-ChildItem -Path '.\Assets\Functions\' -Recurse | Where-Object { $_.PSIsContainer -eq $false } | ForEach-Object {
    . ($_).fullname
}

$Script:Settings.Version = [system.version]'2.0'

$Script:GUIActions.ScriptPath = (Split-Path -Path $PSScriptRoot -Parent)

Write-Emu68ImagerLog -start

Show-Disclaimer

$Script:Settings.CurrentTaskNumber += 1
$Script:Settings.CurrentTaskName = "Checking Prerequisites for Using Emu68 Imager"
Write-StartTaskMessage

# Confirm-Prerequisites

Write-TaskCompleteMessage

$Script:Settings.CurrentTaskNumber += 1
$Script:Settings.CurrentTaskName = "Startup Checks"
Write-StartTaskMessage

$Script:Settings.TotalNumberofSubTasks = 3
$Script:Settings.CurrentSubTaskName = "Creating Default Folders"
$Script:Settings.CurrentSubTaskNumber = 1
Write-StartSubTaskMessage

Confirm-DefaultPaths 

$Script:Settings.CurrentSubTaskName = "Creating Input Files"
$Script:Settings.CurrentSubTaskNumber = 2
Write-StartSubTaskMessage

Get-InputFiles

$Script:Settings.CurrentSubTaskName = "Getting Startup Files"
$Script:Settings.CurrentSubTaskNumber = 3
Write-StartSubTaskMessage

if (-not (Get-StartupFiles)){
     exit
}

Write-TaskCompleteMessage

Remove-Variable -Name 'WPF_*'

$WPF_MainWindow = Get-XAML -WPFPrefix 'WPF_Window_' -XMLFile '.\Assets\WPF\Main_Window.xaml' -ActionsPath '.\Assets\UIActions\MainWindow\' -AddWPFVariables
$WPF_StartPage = Get-XAML -WPFPrefix 'WPF_StartPage_' -XMLFile '.\Assets\WPF\Grid_StartPage.xaml' -ActionsPath '.\Assets\UIActions\StartPage\' -AddWPFVariables
$WPF_Partition = Get-XAML -WPFPrefix 'WPF_DP_' -XMLFile '.\Assets\WPF\Grid_DiskPartition.xaml' -ActionsPath '.\Assets\UIActions\DiskPartition\' -AddWPFVariables
$WPF_SetupEmu68 = Get-XAML -WPFPrefix 'WPF_Setup_' -XMLFile '.\Assets\WPF\Grid_SetupEmu68.xaml' -ActionsPath '.\Assets\UIActions\SetupEmu68\' -AddWPFVariables
$WPF_PackageSelection = Get-XAML -WPFPrefix 'WPF_PackageSelection_' -XMLFile '.\Assets\WPF\Grid_PackageSelection.xaml' -ActionsPath '.\Assets\UIActions\PackageSelection\' -AddWPFVariables

Set-PartitionGridActions

$Script:GUICurrentStatus.ProcessImageStatus = $false

$WPF_Window_Main.AddChild($WPF_StartPage)
$Script:GUICurrentStatus.CurrentWindow = 'StartPage'

update-ui -MainWindowButtons

$WPF_MainWindow.ShowDialog() | out-null

# # $WPF_MainWindow.Close()
# # [System.Windows.Controls.DataGrid].GetEvents() | Select-Object Name, *Method, EventHandlerType >test.txt
