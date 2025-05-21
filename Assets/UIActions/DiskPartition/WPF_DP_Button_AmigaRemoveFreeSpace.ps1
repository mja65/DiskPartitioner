$WPF_DP_Button_AmigaRemoveFreeSpace.add_click({
  
    Remove-AmigaDiskFreeSpaceBetweenPartitions
    
    update-ui -FreeSpaceAlert

})