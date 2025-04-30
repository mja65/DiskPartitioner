$WPF_Window_Issues_OK_Button.Add_Click({
    $WPF_WindowIssues.Close() | out-null
    Remove-Variable -Name 'WPF_Window_Issues_*'
})
