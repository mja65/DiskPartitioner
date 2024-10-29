Set-Location -Path (Split-Path -Path $PSScriptRoot -Parent)

Get-ChildItem -Path '.\GenericFunctions\' -Recurse | ForEach-Object {
   . ($_).fullname
    
}

Get-ChildItem -Path '.\Functions\' -Recurse | ForEach-Object {
    . ($_).fullname
}

Remove-Variable -name WPF_UI_DiskPartition*

$Script:GUIActions = [PSCustomObject]@{
    MouseStatus = $null
    ActionToPerform = $null
    SelectedPartition = $null
    MousePositionRelativetoWindowXatTimeofPress = $null
    MousePositionRelativetoWindowYatTimeofPress = $null
}

$Script:PistormSDCard = [PSCustomObject]@{
    FAT32MinimumSizePixels = 100
    ID76MinimumSizePixels = 100 
}

$MainWindow = (Get-MainWindow -WPFPrefix 'WPF_UI_DiskPartition_') 

#Get-Variable

#[System.Windows.Controls.Grid].GetEvents() | Select-Object Name, *Method, EventHandlerType

$WPF_UI_DiskPartition_Disk_MBR = New-GUIDisk -Prefix 'WPF_UI_DiskPartition_' -DiskType 'MBR'
$Script:WPF_UI_DiskPartition_PartitionGrid_MBR.AddChild($WPF_UI_DiskPartition_Disk_MBR)

# $WPF_UI_DiskPartition_Disk = Add-GUIDisktoWindow -Prefix 'WPF_UI_DiskPartition_' -DiskType 'Amiga'
# $Script:WPF_UI_DiskPartition_PartitionGrid_Amiga.AddChild($WPF_UI_DiskPartition_Disk_Amiga)

Add-GUIPartitiontoMBRDisk -Prefix 'WPF_UI_DiskPartition_Partition_' -PartitionType 'FAT32' -AddType 'Initial'-SizePixels 100
Add-GUIPartitiontoMBRDisk -Prefix 'WPF_UI_DiskPartition_Partition_' -PartitionType 'ID76' -AddType 'Initial' -SizePixels 100
Add-GUIPartitiontoMBRDisk -Prefix 'WPF_UI_DiskPartition_Partition_' -PartitionType 'ID76' -AddType 'Initial' -SizePixels 100

Set-DiskCoordinates -prefix 'WPF_UI_DiskPartition_' -PartitionPrefix 'Partition_'

Set-PartitionWindowActions 
Set-DiskActions

$MainWindow.ShowDialog() | out-null

#$MainWindow.close() | out-null

