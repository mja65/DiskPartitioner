function Confirm-RequiredSources {
    param (
    )
    
    If ($Script:GUIActions.AvailablePackages.Rows.Count -eq 0){
        Get-SelectablePackages
    }

    $OSandPackagesSources = Get-InputCSVs -PackagestoInstall | Where-Object {$_.KickstartVersion -eq $Script:GUIActions.KickstartVersiontoUse } | Select-Object 'SourceLocation','Source','PackageNameFriendlyName' -Unique # Unique Source files Required
    $OSandPackagesSources  | Add-Member -NotePropertyName 'RequiredFlagUserSelectable' -NotePropertyValue $null
    $HashTableforSelectedPackages = @{} # Clear Hash
    $Script:GUIActions.AvailablePackages | ForEach-Object {
        $HashTableforSelectedPackages[$_.PackageNameFriendlyName] = @($_.PackageNameUserSelected)
    }

    $OSandPackagesSources | ForEach-Object {
        if ($HashTableforSelectedPackages.ContainsKey($_.PackageNameFriendlyName)){
            $_.RequiredFlagUserSelectable = $HashTableforSelectedPackages.($_.PackageNameFriendlyName)[0]
        }
        else {
            $_.RequiredFlagUserSelectable = 'Mandatory'
        }        
    }

    return ($OSandPackagesSources | Select-Object 'Source','SourceLocation','RequiredFlagUserSelectable' -Unique)

}

#-and $_.PackageName -match "OS Install"

#@{label='ADF_Name';expression={$_.SourceLocation}},'PackageNameFriendlyName' 