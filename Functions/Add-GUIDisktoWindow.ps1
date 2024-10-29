function Add-GUIDisktoWindow {
    param (

    $TopMargin,
    $DiskType

    )
    $NewDisk = New-Object System.Windows.Shapes.Rectangle
    $NewDisk.HorizontalAlignment = "Left" 
    $NewDisk.VerticalAlignment = "Top"
    $NewDisk.Height="100" 
    $NewDisk.Stroke="Black"
    $NewDisk.Fill="White"
    $NewDisk.Width="759"

    if ($DiskType -eq 'MBR'){
        $NewDisk | Add-Member -NotePropertyName NumberofPartitionsFAT32 -NotePropertyValue 0
        $NewDisk | Add-Member -NotePropertyName NumberofPartitionsID76 -NotePropertyValue 0
        $NewDisk | Add-Member -NotePropertyName NextPartitionFAT32Number -NotePropertyValue 1
        $NewDisk | Add-Member -NotePropertyName NextPartitionID76Number -NotePropertyValue 1
    }
    
    $NewDisk | Add-Member -NotePropertyName NumberofPartitionsTotal -NotePropertyValue 0
    $NewDisk | Add-Member -NotePropertyName DiskSizeBytes -NotePropertyValue $null  
    #$NewDisk.Margin = [System.Windows.Thickness]"0,$TopMargin,0,0"

    return $NewDisk

}