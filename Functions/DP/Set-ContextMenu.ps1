function Set-ContextMenu {
    param (
        $PartitionName,
        $PartitionType
        
    )
    
    #$PartitionName = 'WPF_DP_Partition_FAT32_1'
    #$PartitionType = 'MBR'

    #$PartitionType = 'Amiga'
    #$PartitionName = 'WPF_DP_Partition_ID76_1_AmigaDisk_Partition_1'


    if ($PartitionType -eq 'Amiga'){
        $AmigaDiskName = ($PartitionName.Substring(0,($PartitionName.IndexOf('_AmigaDisk_Partition_')+10)))    
        $PartitionstoCheck = Get-AllGUIPartitionBoundaries -MainPartitionWindowGrid  $WPF_Partition -WindowGridMBR  $WPF_DP_GridMBR -WindowGridAmiga $WPF_DP_GridAmiga -DiskGridMBR $WPF_DP_DiskGrid_MBR -DiskGridAmiga $WPF_DP_DiskGrid_Amiga | Where-Object {$_.PartitionType -eq $PartitionType -and $_.PartitionName -match $AmigaDiskName }
    }
    elseif ($PartitionType -eq 'MBR'){
        $PartitionstoCheck = Get-AllGUIPartitionBoundaries -MainPartitionWindowGrid  $WPF_Partition -WindowGridMBR  $WPF_DP_GridMBR -WindowGridAmiga $WPF_DP_GridAmiga -DiskGridMBR $WPF_DP_DiskGrid_MBR -DiskGridAmiga $WPF_DP_DiskGrid_Amiga | Where-Object {$_.PartitionType -eq $PartitionType}
    }

    
    if ($PartitionType -eq 'MBR'){
        $DiskGrid = $WPF_DP_DiskGrid_MBR
    }
    elseif ($PartitionType -eq 'Amiga'){
        $DiskGrid = $WPF_DP_DiskGrid_Amiga
    }
    
    
    if ($PartitionName){
        $PartitionToCheck = $PartitionstoCheck | Where-Object {$_.PartitionName -eq $PartitionName}           
    }
    

    for ($i = 0; $i -lt $DiskGrid.ContextMenu.Items.Count; $i++) {
        if ($DiskGrid.ContextMenu.Items[$i].Name -eq 'DeletePartition'){
            if ($PartitionName){
                if ($PartitionToCheck.CanDelete -eq $true){
                    $DiskGrid.ContextMenu.Items[$i].IsEnabled = 'True'
                }
                else{
                    $DiskGrid.ContextMenu.Items[$i].IsEnabled = ''
                }
            }
            else{
                $DiskGrid.ContextMenu.Items[$i].IsEnabled = ''
            }
        }
    }


    if ($PartitionType -eq 'MBR'){
        for ($i = 0; $i -lt $DiskGrid.ContextMenu.Items.Items.Count; $i++) {
            if ($DiskGrid.ContextMenu.Items.Items[$i].Name -eq 'CreateFAT32PartitionLeft'){                  
                if ($PartitionName){
                    if ($PartitionToCheck.BytesAvailableLeft -gt $Script:SDCardMinimumsandMaximums.Fat32Minimum){
                        $DiskGrid.ContextMenu.items.Items[$i].IsEnabled = 'True'
                    }
                    else {
                        $DiskGrid.ContextMenu.items.Items[$i].IsEnabled = ''
                    }  
                }
                else{
                    $DiskGrid.ContextMenu.items.Items[$i].IsEnabled = ''
                }
            }
            if ($DiskGrid.ContextMenu.Items.Items[$i].Name -eq 'CreateFAT32PartitionRight'){
                if ($PartitionName){
                    if ($PartitionToCheck.BytesAvailableRight -gt $Script:SDCardMinimumsandMaximums.Fat32Minimum){
                        $DiskGrid.ContextMenu.items.Items[$i].IsEnabled = 'True'
                    }
                    else {
                        $DiskGrid.ContextMenu.items.Items[$i].IsEnabled = ''
                    }  
                }
                else{
                    $DiskGrid.ContextMenu.items.Items[$i].IsEnabled = ''
                }
            }
            if ($DiskGrid.ContextMenu.Items.Items[$i].Name -eq 'CreateFAT32PartitionEnd'){
                if ($PartitionstoCheck[$PartitionstoCheck.Count-1].BytesAvailableRight -gt $Script:SDCardMinimumsandMaximums.Fat32Minimum){
                    $DiskGrid.ContextMenu.items.Items[$i].IsEnabled = 'True'
                }
                else{
                    $DiskGrid.ContextMenu.items.Items[$i].IsEnabled = ''
                }
            }
            if ($DiskGrid.ContextMenu.Items.Items[$i].Name -eq 'CreateID76PartitionLeft'){
                if ($PartitionName){
                    if ($PartitionToCheck.BytesAvailableLeft -gt $Script:SDCardMinimumsandMaximums.ID76Minimum){
                        $DiskGrid.ContextMenu.items.Items[$i].IsEnabled = 'True'
                    }
                    else {
                        $DiskGrid.ContextMenu.items.Items[$i].IsEnabled = ''
                    }  
                }
                else{
                    $DiskGrid.ContextMenu.items.Items[$i].IsEnabled = ''
                }
            }
            if ($DiskGrid.ContextMenu.Items.Items[$i].Name -eq 'CreateID76PartitionRight'){
                if ($PartitionName){
                    if ($PartitionToCheck.BytesAvailableRight -gt $Script:SDCardMinimumsandMaximums.ID76Minimum){
                        $DiskGrid.ContextMenu.items.Items[$i].IsEnabled = 'True'
                    }
                    else {
                        $DiskGrid.ContextMenu.items.Items[$i].IsEnabled = ''
                    }                      
                }
                else{
                    $DiskGrid.ContextMenu.items.Items[$i].IsEnabled = ''
                }
            }
            if ($DiskGrid.ContextMenu.Items.Items[$i].Name -eq 'CreateID76PartitionEnd'){
                if ($PartitionstoCheck[$PartitionstoCheck.Count-1].BytesAvailableRight -gt $Script:SDCardMinimumsandMaximums.ID76Minimum){
                    $DiskGrid.ContextMenu.items.Items[$i].IsEnabled = 'True'
                }
                else {
                    $DiskGrid.ContextMenu.items.Items[$i].IsEnabled = ''
                }  
            }             
        }
    }
    elseif ($PartitionType -eq 'Amiga'){
        for ($i = 0; $i -lt $DiskGrid.ContextMenu.Items.Items.Count; $i++) {
            if ($DiskGrid.ContextMenu.Items.Items[$i].Name -eq 'CreateAmigaPartitionLeft'){
                if ($PartitionName){
                    if ($PartitionToCheck.BytesAvailableLeft -gt $Script:SDCardMinimumsandMaximums.PFS3Minimum){
                        $DiskGrid.ContextMenu.items.Items[$i].IsEnabled = 'True'
                    }
                    else {
                        $DiskGrid.ContextMenu.items.Items[$i].IsEnabled = ''
                    }  
                }
                else{
                    $DiskGrid.ContextMenu.items.Items[$i].IsEnabled = ''
                }
            }
            if ($DiskGrid.ContextMenu.Items.Items[$i].Name -eq 'CreateAmigaPartitionRight'){
                if ($PartitionName){
                    if ($PartitionToCheck.BytesAvailableRight -gt $Script:SDCardMinimumsandMaximums.PFS3Minimum){
                        $DiskGrid.ContextMenu.items.Items[$i].IsEnabled = 'True'
                    }
                    else {
                        $DiskGrid.ContextMenu.items.Items[$i].IsEnabled = ''
                    }  
                }
                else{
                    $DiskGrid.ContextMenu.items.Items[$i].IsEnabled = ''
                }
            }
            if ($DiskGrid.ContextMenu.Items.Items[$i].Name -eq 'CreateAmigaPartitionEnd'){
                if ($PartitionstoCheck[$PartitionstoCheck.Count-1].BytesAvailableRight -gt $Script:SDCardMinimumsandMaximums.PFS3Minimum){
                    $DiskGrid.ContextMenu.items.Items[$i].IsEnabled = 'True'
                }
                else {
                    $DiskGrid.ContextMenu.items.Items[$i].IsEnabled = ''
                }  
            }       
        }
    }
   
}