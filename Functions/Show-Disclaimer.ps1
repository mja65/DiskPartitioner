function Show-Disclaimer {
    param (
        
    )

    $WPF_Disclaimer = Get-XAML -WPFPrefix 'WPF_Disclaimer_' -XMLFile '.\Assets\WPF\Window_Disclaimer.xaml' -ActionsPath '.\UIActions\Disclaimer\' -AddWPFVariables
    $WPF_Disclaimer_TextBox_Header.Text = "Emu68 Imager v$($Script:Settings.Version)"
    $WPF_Disclaimer.ShowDialog()

    if (-not ($Script:GUIActions.IsDisclaimerAccepted -eq $true)){
        Write-ErrorMessage 'Exiting - Disclaimer Not Accepted'
        exit    
    }
}


