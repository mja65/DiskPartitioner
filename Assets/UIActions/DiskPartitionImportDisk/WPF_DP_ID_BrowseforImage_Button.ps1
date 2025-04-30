$WPF_DP_ID_BrowseforImage_Button.add_click({
    $Script:GUICurrentStatus.SelectedPhysicalDiskforImport = $null
    $Script:GUICurrentStatus.ImportedImagePath = Get-ImagePath
    if (-not ($Script:GUICurrentStatus.ImportedImagePath)){
        return
    }
    else {

        Get-MBRandRDBPartitionsforSelection -Image
      
    }
         
})


