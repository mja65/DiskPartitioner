function Get-SelectablePackages {
    param (
        [Switch]$PackagesOnly
    )

    $Script:GUIActions.AvailablePackages.Clear()

    $UserSelectablePackageswithSourceLocation = Get-InputCSVs -PackagestoInstall | Where-Object {$_.PackageMandatory -eq 'FALSE'} | Select-Object 'Source','SourceLocation',@{Name='PackageNameUserSelected';Expression = 'PackageNameDefaultInstall'},'PackageNameDefaultInstall','PackageNameFriendlyName','PackageNameGroup','PackageNameDescription' -Unique    
    $DatatoPopulate = $UserSelectablePackageswithSourceLocation | Select-Object 'PackageNameUserSelected','PackageNameDefaultInstall','PackageNameFriendlyName','PackageNameGroup','PackageNameDescription' -Unique

    foreach ($line in $DatatoPopulate){
        $Array = @()
        $array += $line.PackageNameUserSelected
        $array += $line.PackageNameDefaultInstall
        $array += $line.PackageNameFriendlyName
        $array += $line.PackageNameGroup
        $array += $line.PackageNameDescription
        [void]$Script:GUIActions.AvailablePackages.Rows.Add($array)
    }

    If (-not ($PackagesOnly)){ 
            $Script:GUIActions.AvailableIconSets.Clear()
           # $UserSelectableIconSets  = Get-InputCSVs -IconSets | Select-Object @{Name='IconSet';Expression = 'IconSetName'},'IconSetDescription',@{Name='IconSetUserSelected';Expression = 'IconsDefaultInstall'},@{Name='IconSetDefaultInstall';Expression = 'IconsDefaultInstall'}
            $UserSelectableIconSets  = Get-InputCSVs -IconSets | Select-Object @{Name='IconSet';Expression = 'IconSetName'},'IconSetDescription',@{Name='IconSetDefaultInstall';Expression = 'IconsDefaultInstall'}
           
            foreach ($line in  $UserSelectableIconSets){
               $Array = @()
               $array += $line.IconSet
               $array += $line.IconSetDescription
               $array += $line.IconSetDefaultInstall
              # $array += $line.IconSetUserSelected
               [void]$Script:GUIActions.AvailableIconSets.Rows.Add($array)
            }
            
            $UserSelectableIconSets | ForEach-Object {
                if ($_.IconSetDefaultInstall -eq $true){
                    $Script:GUIActions.SelectedIconSet = $_.IconSet
                    $WPF_PackageSelection_CurrentlySelectedIconSet_Value.text = $_.IconSet
                }
            }
    }


    $Script:GUICurrentStatus.AvailablePackagesNeedingGeneration = $false

    if ($Script:GUICurrentStatus.InstallMediaRequiredFromUserSelectablePackages){
        
        if ($Script:GUIActions.FoundInstallMediatoUse){
            $HashTableforInstallMedia = @{} # Clear Hash
            $Script:GUICurrentStatus.InstallMediaRequiredFromUserSelectablePackages | ForEach-Object {
                $HashTableforInstallMedia[$_.SourceLocation]  = @()
            }
            $NewADFsRequiredFromPackages =  Confirm-RequiredSources | Where-Object {$_.Source -eq 'ADF' -and $_.RequiredFlagUserSelectable -eq 'True'} | Select-Object 'SourceLocation','Source' -Unique
            $NewADFsRequiredFromPackages | ForEach-Object {
                 if (-not ($HashTableforInstallMedia.ContainsKey($_.SourceLocation))){
                    $null = Show-WarningorError -BoxTypeWarning -Msg_Header "New Install Media Required" -Msg_Body "Resetting packages to defaults has identified new install media requirements. You will need to re run this check." -ButtonType_OK
                    $Script:GUIActions.FoundInstallMediatoUse =$null
                    break
                 }
            }

        }
 
    }
   
    $Script:GUICurrentStatus.InstallMediaRequiredFromUserSelectablePackages = Confirm-RequiredSources | Where-Object {$_.Source -eq 'ADF' -and $_.RequiredFlagUserSelectable -eq 'True'} | Select-Object 'SourceLocation','Source' -Unique

}

