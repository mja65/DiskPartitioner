function Get-AllGUIDiskBoundaries {
    param (
        $MainPartitionWindowGrid,
        $WindowGridMBR,
        $WindowGridAmiga,
        $DiskGridMBR,
        $DiskGridAmiga

    )
    # $MainPartitionWindowGrid = $WPF_Partition
    # $WindowGridMBR = $WPF_DP_GridMBR
    # $WindowGridAmiga = $WPF_DP_GridAmiga
    # $DiskGridMBR = $WPF_DP_DiskGrid_MBR
    # $DiskGridAmiga = $WPF_DP_DiskGrid_Amiga

    $AllDiskBoundaries = [System.Collections.Generic.List[PSCustomObject]]::New()

    $LeftMarginWindow = ($MainPartitionWindowGrid.Margin.Left + $WindowGridMBR.Margin.Left + $DiskGridMBR.Margin.Left)
    $TopMarginWindow = ($MainPartitionWindowGrid.Margin.Top + $WindowGridMBR.Margin.Top + $DiskGridMBR.Margin.Top)

    Get-Variable | Where-Object {($_.Name -eq 'WPF_DP_Disk_MBR')} | ForEach-Object {
        $AllDiskBoundaries += [PSCustomObject]@{
            DiskName = $_.Name
            DiskType = $_.Value.DiskType 
            LeftMarginDisk = $LeftMarginWindow + $_.Value.LeftDiskBoundary
            RightMarginDisk = $LeftMarginWindow + $_.Value.RightDiskBoundary
            TopMarginDisk = $TopMarginWindow 
            BottomMarginDisk = $TopMarginWindow + $_.Value.ActualHeight
        }
    }
    
    $LeftMarginWindow = ($MainPartitionWindowGrid.Margin.Left + $WindowGridAmiga.Margin.Left + $DiskGridAmiga.Margin.Left)
    $TopMarginWindow = ($MainPartitionWindowGrid.Margin.Top + $WindowGridAmiga.Margin.Top + $DiskGridAmiga.Margin.Top)

    Get-Variable | Where-Object {$_.Name -match '_AmigaDisk' -and $_.Value.DiskType -eq 'Amiga'} | ForEach-Object {
        $AllDiskBoundaries += [PSCustomObject]@{
            DiskName = $_.Name
            DiskType = $_.Value.DiskType 
            LeftMarginDisk = $LeftMarginWindow + $_.Value.LeftDiskBoundary
            RightMarginDisk = $LeftMarginWindow + $_.Value.RightDiskBoundary
            TopMarginDisk = $TopMarginWindow 
            BottomMarginDisk = $TopMarginWindow + $_.Value.ActualHeight
        }
            
    }
    
    return $AllDiskBoundaries 
}
    

