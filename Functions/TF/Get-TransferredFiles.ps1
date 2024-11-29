function Get-TransferredFiles {
    param (
        
    )

    Remove-Variable -Name 'WPF_TF_*'

    $Script:GUIActions.ActionToPerform = 'TransferFiles'
    $WPF_SelectDiskWindow = Get-XAML -WPFPrefix 'WPF_TF_' -XMLFile '.\Assets\WPF\Window_BrowseFiles.xaml' -ActionsPath '.\UIActions\TF\' -AddWPFVariables
    $WPF_SelectDiskWindow.ShowDialog() | out-null
    


}

