$WPF_StartPage_Emu68GithubURL.add_RequestNavigate({
    param($sender, $e)
    Start-Process $e.Uri.AbsoluteUri
    $e.Handled = $true
})