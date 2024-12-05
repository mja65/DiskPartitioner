Set-Location -Path (Split-Path -Path $PSScriptRoot -Parent)

Get-ChildItem -Path '.\Functions\' -Recurse | Where-Object { $_.PSIsContainer -eq $false } | ForEach-Object {
    . ($_).fullname
}


Get-ChildItem -Path '.\Variables\' -Recurse | Where-Object { $_.PSIsContainer -eq $false } | ForEach-Object {
    . ($_).fullname
}

$Script:GUIActions.ScriptPath = (Split-Path -Path $PSScriptRoot -Parent)

Remove-Variable -Name 'WPF_*'

Add-Type -AssemblyName PresentationFramework
Add-Type -AssemblyName System.Windows.Forms

$WPF_MainWindow = Get-XAML -WPFPrefix 'WPF_Window_' -XMLFile '.\Assets\WPF\Main_Window.xaml' -ActionsPath '.\UIActions\MainWindow\' -AddWPFVariables
$WPF_Partition = Get-XAML -WPFPrefix 'WPF_DP_' -XMLFile '.\Assets\WPF\Grid_DiskPartition.xaml' -ActionsPath '.\UIActions\DiskPartition\' -AddWPFVariables
$WPF_SetupEmu68 = Get-XAML -WPFPrefix 'WPF_Setup_' -XMLFile '.\Assets\WPF\Grid_SetupEmu68.xaml' -ActionsPath '.\UIActions\SetupEmu68\' -AddWPFVariables
Set-PartitionGridActions

$WPF_MainWindow.ShowDialog() | out-null
# $WPF_MainWindow.Close()
# [System.Windows.Controls.ComboBox].GetEvents() | Select-Object Name, *Method, EventHandlerType
# Get-variable

# $WPF_DP_Partition_ID76_1_AmigaDisk_Partition_1
