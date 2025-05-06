function Get-OptionsBeforeRunningImage.ps1 {
    param (
       
    )
    
    Remove-Variable -Name 'WPF_RunWindow_*'

    $WPF_RunWindow = Get-XAML -WPFPrefix 'WPF_RunWindow_' -XMLFile '.\Assets\WPF\Window_RunOptions.xaml' -ActionsPath '.\Assets\UIActions\RunWindow\' -AddWPFVariables
    
    
    $Script:GUICurrentStatus.RunOptionstoReport.Clear()
    $null = $Script:GUICurrentStatus.RunOptionstoReport.Rows.Add("OS to be Installed",$Script:GUIActions.KickstartVersiontoUseFriendlyName)
    $null = $Script:GUICurrentStatus.RunOptionstoReport.Rows.Add("Disk or Image",$Script:GUIActions.OutputType)
    $null = $Script:GUICurrentStatus.RunOptionstoReport.Rows.Add("Location to be installed",$Script:GUIActions.OutputPath)

    $WPF_RunWindow_RunOptions_Datagrid.ItemsSource = $Script:GUICurrentStatus.RunOptionstoReport.DefaultView
    
    $WPF_RunWindow.ShowDialog() | out-null
    
\
    

}