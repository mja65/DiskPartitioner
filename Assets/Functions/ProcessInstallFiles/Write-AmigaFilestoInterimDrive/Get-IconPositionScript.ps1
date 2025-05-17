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

         return $IconPosScript
    }