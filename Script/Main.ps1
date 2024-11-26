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

$WPF_MainWindow = Get-XAML -WPFPrefix 'WPF_Window_' -XMLFile '.\Assets\WPF\Main_Window.xaml' -ActionsPath '.\UIActions\MainWindow\'
$WPF_Partition = Get-XAML -WPFPrefix 'WPF_DP_' -XMLFile '.\Assets\WPF\Grid_DiskPartition.xaml' -ActionsPath '.\UIActions\GridPartition\' -AddWPFVariables

Set-PartitionGridActions

$WPF_MainWindow.AddChild($WPF_Partition)

$WPF_MainWindow.ShowDialog() | out-null

# [System.Windows.Controls.DataGrid].GetEvents() | Select-Object Name, *Method, EventHandlerType
# Get-variable
