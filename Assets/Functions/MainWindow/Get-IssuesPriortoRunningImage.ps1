function Get-IssuesPriortoRunningImage {
    param (
   
    )
    
    Remove-Variable -Name 'WPF_Window_Issues_*'
    
    $WPF_WindowIssues = Get-XAML -WPFPrefix 'WPF_Window_Issues_' -XMLFile '.\Assets\WPF\Window_IssuesFoundBeforeProcessing.xaml'  -ActionsPath '.\Assets\UIActions\IssueReporting\' -AddWPFVariables
    
    if ($Script:GUICurrentStatus.ProcessImageStatus -eq $false){
        $WPF_Window_Issues_Datagrid.ItemsSource  = $Script:GUICurrentStatus.IssuesFoundBeforeProcessing.DefaultView
        $WPF_WindowIssues.ShowDialog() | out-null
    }
    
}

