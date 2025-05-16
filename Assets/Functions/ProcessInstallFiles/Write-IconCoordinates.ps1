function Write-IconCoordinates {
    param (
        $PathtoIcon,
        $PathtoNewIcon,
        $IconXNew,
        $IconYNew,
        $IconWidth,
        $IconHeight,
        $DrawerXNew,
        $DrawerYNew,
        $DrawerWidthNew,
        $DrawerHeightNew
    )
    
   # $PathtoIcon = "C:\Users\Matt\OneDrive\Documents\DiskPartitioner\Temp\InterimAmigaDrives\System\PiStorm\Documentation.info"
   # $PathtoNewIcon = "C:\Users\Matt\OneDrive\Documents\DiskPartitioner\Temp\InterimAmigaDrives\System\PiStorm\Documentation.info"
    #$IconYNew = 412

    $bytes = [System.IO.File]::ReadAllBytes($PathtoIcon)

    if ($IconXNew){      
        $bytes[60] = (Get-IconCoordinatesToWrite -CoordinateValue $IconXNew)[0] 
        $bytes[61] = (Get-IconCoordinatesToWrite -CoordinateValue $IconXNew)[1] 
     #   $bytes[62] = (Get-IconCoordinatesToWrite -CoordinateValue 00)[0]
        $bytes[63] = (Get-IconCoordinatesToWrite -CoordinateValue 00)[0]

    }
    if ($IconYNew){      
        $bytes[64] = (Get-IconCoordinatesToWrite -CoordinateValue $IconYNew)[0] 
        $bytes[65] = (Get-IconCoordinatesToWrite -CoordinateValue $IconYNew)[1] 
    }
    if ($IconWidth){
        $bytes[12] = (Get-IconCoordinatesToWrite -CoordinateValue $IconWidthNew)[0] 
        $bytes[13] = (Get-IconCoordinatesToWrite -CoordinateValue $IconWidthNew)[1] 
    }
    if ($IconHeight){
        $bytes[14] = (Get-IconCoordinatesToWrite -CoordinateValue $IconWidthNew)[0] 
        $bytes[15] = (Get-IconCoordinatesToWrite -CoordinateValue $IconWidthNew)[1] 
    }
    if ($DrawerXNew){      
        $bytes[78] = (Get-IconCoordinatesToWrite -CoordinateValue $DrawerXNew)[0] 
        $bytes[79] = (Get-IconCoordinatesToWrite -CoordinateValue $DrawerXNew)[1] 
    }
    if ($DrawerYNew){      
        $bytes[80] = (Get-IconCoordinatesToWrite -CoordinateValue $DrawerYNew)[0] 
        $bytes[81] = (Get-IconCoordinatesToWrite -CoordinateValue $DrawerYNew)[1] 
    }
    if ($DrawerWidthNew){
        $bytes[82] = (Get-IconCoordinatesToWrite -CoordinateValue $DrawerWidthNew)[0] 
        $bytes[83] = (Get-IconCoordinatesToWrite -CoordinateValue $DrawerWidthNew)[1] 
    }
    if ($DrawerHeightNew){
        $bytes[84] = (Get-IconCoordinatesToWrite -CoordinateValue $DrawerHeightNew)[0] 
        $bytes[85] = (Get-IconCoordinatesToWrite -CoordinateValue $DrawerHeightNew)[1] 
    }
    
    [IO.File]::WriteAllBytes($PathtoNewIcon,$bytes)

    #$OldCoordinates = Get-IconCoordinates -PathtoIcon $PathtoIcon
    #$NewCoordinates = Get-IconCoordinates -PathtoIcon $PathtoNewIcon      

    #Write-host "Updated $(Split-Path -path $PathtoIcon -Leaf) to $(Split-Path -path $PathtoNewIcon -Leaf)"
    
}
