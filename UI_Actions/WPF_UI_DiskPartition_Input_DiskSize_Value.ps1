$WPF_UI_DiskPartition_Input_DiskSize_Value.add_LostFocus({
    if ($WPF_UI_DiskPartition_Input_DiskSize_Value.Text){
        $WPF_UI_DiskPartition_Grid_Amiga.Visibility = 'Visible'
        $WPF_UI_DiskPartition_Grid_MBR.Visibility = 'Visible'
        Update-MBRDiskSizes
    }
    else{
        $WPF_UI_DiskPartition_Grid_Amiga.Visibility = 'Hidden'
        $WPF_UI_DiskPartition_Grid_MBR.Visibility = 'Hidden'
    }
})

