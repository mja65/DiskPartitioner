function Get-IconPositionScript {
    param (

    )
    $IconPosScript = @()
    
    $IconPosScript += "echo `"Positioning icons...`""
    Get-InputCSVs -IconPositions | ForEach-Object {
        if ($_.DrawerX){
           $DrawerXtoUse = "DXPOS $($_.DrawerX) "
       }
       if ($_.DrawerY){
           $DrawerYtoUse = "DYPOS $($_.DrawerY) "
       }
       if ($_.DrawerWidth){
           $DrawerWidthToUse = "DWIDTH $($_.DrawerWidth) "
       }
       if ($_.DrawerHeight){
           $DrawerHeightToUse = "DHEIGHT $($_.DrawerHeight)"
       }
       $Remainder = "$DrawerXtoUse$DrawerYtoUse$DrawerWidthToUse$DrawerHeightToUse"
       $IconPosScript += "iconpos >NIL: `"SYS:$($_.File)`" type=$($_.Type) $($_.IconX) $($_.IconY) $Remainder"
    }
    $DefaultDisks = Get-InputCSVs -Diskdefaults
    $ListofDisks = Get-AllGUIPartitions -PartitionType 'Amiga'
    
    $HashTableforDefaultDisks = @{} # Clear Hash
    Get-InputCSVs -Diskdefaults | ForEach-Object {
        $HashTableforDefaultDisks[$_.DeviceName] = @($_.IconX,$_.IconY) 
    }
    
    $IconX = $null
    $IconY = $null
     
    foreach ($Disk in $ListofDisks) {
        if ($HashTableforDefaultDisks.ContainsKey($Disk.value.DeviceName)){
            $IconX = $HashTableforDefaultDisks.($Disk.value.DeviceName)[0]
            $IconY = $HashTableforDefaultDisks.($Disk.value.DeviceName)[1]
        }
        else {
            $IconX = $Script:Settings.AmigaWorkDiskIconXPosition
            if ($IconY) {
                $IconY += $Script:Settings.AmigaWorkDiskIconYPositionSpacing
            }
            else {
                $IconY =  $Script:Settings.AmigaWorkDiskIconYPosition
            }
    
        }
        $IconPosScript += "iconpos >NIL: `"$($Disk.value.DeviceName):disk.info type=DISK $IconX $IconY`""
        
    }
     
    foreach ($Disk in $DefaultDisks) {
        if ($Disk.Disk -eq 'EMU68BOOT'){
            $IconPosScript += "iconpos >NIL: `"$($Disk.DeviceName):disk.info type=DISK $($Disk.IconX) $($Disk.IconY)`""
        }
    }         
     
    return $IconPosScript
     
}


         
        

    
