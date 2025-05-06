$WPF_PackageSelection_Datagrid_IconSets.add_SelectedCellsChanged({
    $Script:GUIActions.SelectedIconSet = $WPF_PackageSelection_Datagrid_IconSets.SelectedItem.IconSet
    $WPF_PackageSelection_CurrentlySelectedIconSet_Value.text = $WPF_PackageSelection_Datagrid_IconSets.SelectedItem.IconSet
})
