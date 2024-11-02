Set-Location -Path (Split-Path -Path $PSScriptRoot -Parent)

Get-ChildItem -Path '.\Functions\' -Recurse | Where-Object { $_.PSIsContainer -eq $false } | ForEach-Object {
    . ($_).fullname
}
Get-ChildItem -Path '.\Variables\' -Recurse | Where-Object { $_.PSIsContainer -eq $false } | ForEach-Object {
    . ($_).fullname
}

$MainWindow = (Get-MainWindow -WPFPrefix 'WPF_UI_DiskPartition_') 

#Get-Variable

#[System.Windows.Window].GetEvents() | Select-Object Name, *Method, EventHandlerType

$WPF_UI_DiskPartition_Disk_MBR = New-GUIDisk -Prefix 'WPF_UI_DiskPartition_' -DiskType 'MBR'
$Script:WPF_UI_DiskPartition_PartitionGrid_MBR.AddChild($WPF_UI_DiskPartition_Disk_MBR)

Set-DiskCoordinates -prefix 'WPF_UI_DiskPartition_' -PartitionPrefix 'Partition_' -PartitionType 'MBR'

Add-GUIPartitiontoMBRDisk -Prefix 'WPF_UI_DiskPartition_Partition_' -DefaultPartition 'TRUE' -PartitionType 'FAT32' -AddType 'Initial'-SizePixels 100
Add-GUIPartitiontoMBRDisk -Prefix 'WPF_UI_DiskPartition_Partition_' -DefaultPartition 'TRUE' -PartitionType 'ID76' -AddType 'Initial' -SizePixels 100

Add-AmigaPartitiontoDisk -DiskName 'WPF_UI_DiskPartition_Partition_ID76_1_AmigaDisk' -DefaultPartition 'TRUE' -SizePixels 100 -AddType 'Initial' 
Add-AmigaPartitiontoDisk -DiskName 'WPF_UI_DiskPartition_Partition_ID76_1_AmigaDisk' -SizePixels 100 -AddType 'Initial' 

Set-PartitionWindowActions 
Set-MBRDiskActions
Set-AmigaDiskActions 

$MainWindow.ShowDialog() | out-null

#$MainWindow.close() | out-null