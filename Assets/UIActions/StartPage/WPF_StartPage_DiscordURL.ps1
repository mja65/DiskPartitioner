$WPF_StartPage_DiscordURL.add_RequestNavigate({
    param($sender, $e)
    Start-Process $e.Uri.AbsoluteUri
    $e.Handled = $true
})