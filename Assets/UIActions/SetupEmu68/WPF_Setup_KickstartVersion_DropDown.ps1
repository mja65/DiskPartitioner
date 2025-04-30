$Script:GUIActions.AvailableKickstarts =  Get-InputCSVs -OSestoInstall | Select-Object 'Kickstart_Version','Kickstart_VersionFriendlyName','InstallMedia'

foreach ($Kickstart in $Script:GUIActions.AvailableKickstarts) {
    $WPF_Setup_KickstartVersion_Dropdown.AddChild(($Kickstart.Kickstart_VersionFriendlyName).tostring())
}

 $WPF_Setup_KickstartVersion_Dropdown.Add_SelectionChanged({
     foreach ($Kickstart in $Script:GUIActions.AvailableKickstarts) {
         if ($Kickstart.Kickstart_VersionFriendlyName -eq $WPF_Setup_KickstartVersion_Dropdown.SelectedItem){
             if ($Kickstart.Kickstart_Version -ne $Script:GUIActions.KickstartVersiontoUse){
                 $Script:GUIActions.KickstartVersiontoUse  = $Kickstart.Kickstart_Version 
                 $Script:GUIActions.KickstartVersiontoUseFriendlyName = $WPF_Setup_KickstartVersion_Dropdown.SelectedItem
                 $Script:GUIActions.OSInstallMediaType = $Kickstart.InstallMedia
                 $Script:GUIActions.FoundInstallMediatoUse = $null
                 $Script:GUIActions.FoundKickstarttoUse = $null
             }
             break
         }
     }

     $Script:GUIActions.AvailablePackages = New-Object System.Data.DataTable
     
     $UserSelectablePackageswithSourceLocation = Get-InputCSVs -PackagestoInstall | Where-Object {$_.PackageMandatory -eq 'FALSE'} | Select-Object 'Source','SourceLocation',@{Name='PackageNameUserSelected';Expression = 'PackageNameDefaultInstall'},'PackageNameDefaultInstall','PackageNameFriendlyName','PackageNameGroup','PackageNameDescription' -Unique    
     
     $DatatoPopulate = $UserSelectablePackageswithSourceLocation | Select-Object 'PackageNameUserSelected','PackageNameDefaultInstall','PackageNameFriendlyName','PackageNameGroup','PackageNameDescription' -Unique
     
     $Fields =  ($DatatoPopulate | Get-Member -MemberType NoteProperty).Name
 
     [void]$Script:GUIActions.AvailablePackages.Columns.AddRange($Fields)

     # $Script:GUIActions.AvailablePackages.Columns

     for ($i = 0; $i -lt $Script:GUIActions.AvailablePackages.Columns.Count; $i++) {
        # if (($Script:GUIActions.AvailablePackages.Columns[$i].ColumnName) -eq 'PackageName'){
        #     $Script:GUIActions.AvailablePackages.Columns[$i].ColumnMapping= [System.Data.MappingType]::Hidden
        # }
        if (($Script:GUIActions.AvailablePackages.Columns[$i].ColumnName) -eq 'PackageNameFriendlyName'){
            $Script:GUIActions.AvailablePackages.Columns[$i].ReadOnly = $true
        }
        if (($Script:GUIActions.AvailablePackages.Columns[$i].ColumnName) -eq 'PackageNameGroup'){
            $Script:GUIActions.AvailablePackages.Columns[$i].ReadOnly = $true
        }
        if (($Script:GUIActions.AvailablePackages.Columns[$i].ColumnName) -eq 'PackageNameDescription'){
            $Script:GUIActions.AvailablePackages.Columns[$i].ReadOnly = $true
        }
        if (($Script:GUIActions.AvailablePackages.Columns[$i].ColumnName) -eq 'PackageNameDefaultInstall'){
           # $Script:GUIActions.AvailablePackages.Columns[$i].ReadOnly = $false
            $Script:GUIActions.AvailablePackages.Columns[$i].DataType = [type]'boolean'
        }
        if (($Script:GUIActions.AvailablePackages.Columns[$i].ColumnName) -eq 'PackageNameUserSelected'){
            $Script:GUIActions.AvailablePackages.Columns[$i].ReadOnly = $false
            $Script:GUIActions.AvailablePackages.Columns[$i].DataType = [type]'boolean'
        }
    }

     foreach ($line in $DatatoPopulate)
     {
         $Array = @()
         Foreach ($Field in $Fields)
         {
             $array += $line.$Field
         }
         [void]$Script:GUIActions.AvailablePackages.Rows.Add($array)
     }
     
     $Script:GUICurrentStatus.InstallMediaRequiredFromUserSelectablePackages = Confirm-RequiredSources | Where-Object {$_.Source -eq 'ADF' -and $_.RequiredFlagUserSelectable -eq 'True'} | Select-Object 'SourceLocation','Source' -Unique
     
})

