$WPF_Window_Button_PackageSelection.Add_Click({
    if ($Script:GUICurrentStatus.FileBoxOpen -eq $true){
        return
    }

        if (-not ($Script:GUIActions.KickstartVersiontoUse)){
            $null = Show-WarningorError -Msg_Header 'No OS Selected' -Msg_Body 'You cannot select the packages to install or uninstall until you have selected an OS! Please return to this screen after you have selected the OS' -BoxTypeError -ButtonType_OK
            return
        }
    
        $Script:GUICurrentStatus.CurrentWindow = 'PackageSelection' 
    
        if ($Script:GUICurrentStatus.AvailablePackagesNeedingGeneration -eq $true){
            # Write-debug "Populating Available Packages"
            Get-SelectablePackages 
            $Script:GUICurrentStatus.AvailablePackagesNeedingGeneration = $false
        }
       
        # if (-not ($Script:WPF_PackageSelection)){
        #     $Script:WPF_PackageSelection = Get-XAML -WPFPrefix 'WPF_PackageSelection_' -XMLFile '.\Assets\WPF\Grid_PackageSelection.xaml' -ActionsPath '.\Assets\UIActions\PackageSelection\' -AddWPFVariables
        # }
    
        for ($i = 0; $i -lt $WPF_Window_Main.Children.Count; $i++) {        
            if ($WPF_Window_Main.Children[$i].Name -eq $WPF_Partition.Name){
                $WPF_Window_Main.Children.Remove($WPF_Partition)
            }
            if ($WPF_Window_Main.Children[$i].Name -eq $WPF_SetupEmu68.Name){
                $WPF_Window_Main.Children.Remove($WPF_SetupEmu68)
            }
            if ($WPF_Window_Main.Children[$i].Name -eq $WPF_StartPage.Name){
                $WPF_Window_Main.Children.Remove($WPF_StartPage)
            }
        }
        
        for ($i = 0; $i -lt $WPF_Window_Main.Children.Count; $i++) {        
            if ($WPF_Window_Main.Children[$i].Name -eq $WPF_PackageSelection.Name){
                $IsChild = $true
                break
            }
        }
        
        if ($IsChild -ne $true){
            $WPF_Window_Main.AddChild($WPF_PackageSelection)
        }
        
        $WPF_PackageSelection_Datagrid_Packages.ItemsSource = $Script:GUIActions.AvailablePackages.DefaultView  
        $WPF_PackageSelection_Datagrid_IconSets.ItemsSource = $Script:GUIActions.AvailableIconSets.DefaultView
        
         if (-not ($WPF_PackageSelection_Datagrid_IconSets.SelectedItem)){
    
             for ($i = 0; $i -lt $Script:GUIActions.AvailableIconSets.DefaultView.Count; $i++) {
                 if ($Script:GUIActions.AvailableIconSets.DefaultView[$i].IconSetDefaultInstall -eq $true){
                     $DefaultRowNumber = $i
                 }
             }  
             
    
             $WPF_PackageSelection_Datagrid_IconSets.SelectedItem = $Script:GUIActions.AvailableIconSets.DefaultView[$DefaultRowNumber]
    
         }
        
        update-ui -MainWindowButtons

})


    # $DatatoPopulate = Get-InputCSVs -PackagestoInstall | Where-Object {$_.PackageMandatory -eq 'FALSE'} | Select-Object 'PackageNameFriendlyName','PackageNameGroup' -Unique
    
    # #$DatatoPopulate | Add-Member -NotePropertyName 'Test' -NotePropertyValue $false

    # $Fields =  ($DatatoPopulate | Get-Member -MemberType NoteProperty).Name
 
    # $Datatable = New-Object System.Data.DataTable
    # [void]$Datatable.Columns.AddRange($Fields)
    # foreach ($line in $DatatoPopulate)
    # {
    #     $Array = @()
    #     Foreach ($Field in $Fields)
    #     {
    #         $array += $line.$Field
    #     }
    #     [void]$Datatable.Rows.Add($array)
    # }
    
    # if (-not $DataTable.Columns.Contains("Select Package")) {
    #     $selectedColumn = New-Object System.Data.DataColumn("Select Package", [bool])
    #     $selectedColumn.DefaultValue = $false
    #     $DataTable.Columns.Add($selectedColumn)
    # }
  
    # for ($i = 0; $i -lt $DataTable.Columns.Count; $i++) {
    #     if (($DataTable.Columns[$i].ColumnName) -eq 'Select Package'){
    #         #$DataTable.Columns[$i].ReadOnly 
    #         $DataTable.Columns[$i].ReadOnly = $false
    #     }
    #     else {
    #         #$DataTable.Columns[$i].ReadOnly
    #         $DataTable.Columns[$i].ReadOnly = $true
    #     }
    # }


    
    #| Select-Object 'Select Package for Installation','Name of Package', 'Description', 'Package Type'

    #     for ($i = 0; $i -lt $WPF_PackageSelection_Datagrid.Columns.Count; $i++) {
    #     if (($WPF_PackageSelection_Datagrid.Columns[$i].Header) -eq 'PackageName'){
    #         $WPF_PackageSelection_Datagrid.Columns[$i].Visibility 
    #        # $WPF_PackageSelection_Datagrid.Columns[$i].Visibility = 'Hidden' 
    #     }
    # }


    


    
  #  $WPF_PackageSelection_Datagrid.Columns[3].ElementStyle=[type]'System.Windows.Controls.CheckBox'


    # $checkBoxColumn = New-Object System.Windows.Controls.DataGridCheckBoxColumn
    # $checkBoxColumn.Header = "Select" 
    # $checkBoxColumn.Binding = New-Object System.Windows.Data.Binding("Test") # Replace "PropertyName" with the name of the boolean property in your data source
    # $WPF_PackageSelection_Datagrid.Columns.Add($checkBoxColumn)


    # $checkBoxColumn = New-Object System.Windows.Controls.DataGridCheckBoxColumn
    # $checkBoxColumn.Header = "Select Package"
    # $checkBoxColumn.IsReadOnly='FALSE'
    # $checkBoxColumn.Binding = New-Object System.Windows.Data.Binding("Test") # Replace "PropertyName" with the name of the boolean property in your data source
    # $checkBoxColumn.Binding.Mode = [System.Windows.Data.BindingMode]::TwoWay 
    # $WPF_PackageSelection_Datagrid.Columns.Add($checkBoxColumn)

# New-Object System.Windows.Data.Binding -Property
#     $datatable = New-Object System.Data.DataTable
#     $datatable.Columns.Add("ID", [int].type)
#     $datatable.Columns.Add("Name", [string].type)
#     $datatable.Columns.Add("Active", [bool].type)
#     $datatable.Rows.Add(1, "Item 1", $false)
#     $datatable.Rows.Add(2, "Item 2", $true)
#     # Create a DataGrid
#     $dataGrid = New-Object System.Windows.Controls.DataGrid -Property @{
#         ItemsSource = $datatable.DefaultView
#     }
#     # Add a checkbox column
#     $dataGrid.Columns.Add(New-Object System.Windows.Controls.DataGridTextColumn -Property @{
#         Header = "Active";
#         Binding = New-Object System.Windows.Data.Binding -Property @{
#             Path = "Active";
#             Mode = [System.Windows.Data.BindingMode]::TwoWay # For two-way binding
#         }
#         # You can customize the style of the CheckBox if needed
#         }
#     )



