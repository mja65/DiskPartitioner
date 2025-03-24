<#PSScriptInfo
.VERSION 1.1
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

Get-ChildItem -Path '.\Variables\' -Recurse | Where-Object { $_.PSIsContainer -eq $false } | ForEach-Object {
    . ($_).fullname
}

Get-ChildItem -Path '.\Functions\' -Recurse | Where-Object { $_.PSIsContainer -eq $false } | ForEach-Object {
    . ($_).fullname
}
$Script:Settings.Version = 1.1

$Script:GUIActions.ScriptPath = (Split-Path -Path $PSScriptRoot -Parent)

Write-Emu68ImagerLog -start

# Show-Disclaimer

# Confirm-Prerequisites

Confirm-DefaultPaths 

# Get-HSTImagerandHSTAmiga
# Get-InputFiles

Remove-Variable -Name 'WPF_*'

$WPF_MainWindow = Get-XAML -WPFPrefix 'WPF_Window_' -XMLFile '.\Assets\WPF\Main_Window.xaml' -ActionsPath '.\UIActions\MainWindow\' -AddWPFVariables
$WPF_Partition = Get-XAML -WPFPrefix 'WPF_DP_' -XMLFile '.\Assets\WPF\Grid_DiskPartition.xaml' -ActionsPath '.\UIActions\DiskPartition\' -AddWPFVariables
$WPF_SetupEmu68 = Get-XAML -WPFPrefix 'WPF_Setup_' -XMLFile '.\Assets\WPF\Grid_SetupEmu68.xaml' -ActionsPath '.\UIActions\SetupEmu68\' -AddWPFVariables

Set-PartitionGridActions

$WPF_MainWindow.ShowDialog() | out-null

# # # $WPF_MainWindow.Close()
# # # [System.Windows.Controls.Slider].GetEvents() | Select-Object Name, *Method, EventHandlerType
# # # Get-variable -name WPF_SetupEmu68

