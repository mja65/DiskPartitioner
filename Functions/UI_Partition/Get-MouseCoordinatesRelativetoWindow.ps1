function Get-MouseCoordinatesRelativetoWindow {
    param (
        $Window,
        $Grid,
        $Disk

    )
    
    # $Window = $Script:WPF_UI_DiskPartition_Window
    # $Grid = $WPF_UI_DiskPartition_Disk_MBR
    # $Disk = $WPF_UI_DiskPartition_PartitionGrid_MBR
    $MicrosoftWindowThicknessHorizontal = 8
    $MicrosoftWindowTitle = 31

    $GUICoordinates = [PSCustomObject]@{
        MousePositionX = $null
        MousePositionY = $null
        MousePositionRelativetoWindowX = $null
        MousePositionRelativetoWindowY = $null
    }

    $GUICoordinates.MousePositionX =  (([System.Windows.Forms.Cursor]::position).x)
    $GUICoordinates.MousePositionY =  (([System.Windows.Forms.Cursor]::position).y)
    $GUICoordinates.MousePositionRelativetoWindowX =  $GUICoordinates.MousePositionX - ($Window.Left) - ($Grid.Margin.Left) - ($Disk.Margin.Left) - $MicrosoftWindowThicknessHorizontal 
    $GUICoordinates.MousePositionRelativetoWindowY =  $GUICoordinates.MousePositionY - ($Window.Top) - $MicrosoftWindowTitle 
    return $GUICoordinates
}
