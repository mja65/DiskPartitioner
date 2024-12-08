$WPF_TF_Button_UnselectAllFiles.Add_click({
    if ($WPF_TF_FileSource_DataGrid){
        $WPF_TF_FileSource_DataGrid.SelectedIndex = -1
    }
})