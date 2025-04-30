function Get-ModifiedToolTypes {
    param (
        $OriginalToolTypes,
        $ModifiedToolTypes
    )
    $Tooltypes_Revised = New-Object System.Collections.Generic.List[System.Object]
    $HashTableforOldandNewToolTypes = @{} # Clear Hash
    foreach ($ModifiedToolType in $ModifiedTooltypes){
        if ($ModifiedToolType.OldValue -ne ""){
            $HashTableforOldandNewToolTypes.Add($ModifiedToolType.OldValue,$ModifiedToolType.NewValue) 
        }
        else{
            $Tooltypes_Revised.Add($ModifiedTooltype.NewValue)            
        }        
    }
    foreach ($OriginalToolType in $OriginalToolTypes){
        if ($HashTableforOldandNewToolTypes[$OriginalToolType]){
            $Tooltypes_Revised.Add($HashTableforOldandNewToolTypes[$OriginalToolType])
        }
        else{
            $Tooltypes_Revised.Add($OriginalToolType)
        }
    }
    return $Tooltypes_Revised    
}  