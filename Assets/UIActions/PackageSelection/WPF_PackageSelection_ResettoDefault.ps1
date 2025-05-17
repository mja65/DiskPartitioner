$WPF_PackageSelection_ResettoDefault.Add_Click({
    if ((Show-WarningorError -BoxTypeQuestion -Msg_Header "Confirm reset of packages" -Msg_Body "Are you sure you want to reset the packages to the default?" -ButtonType_YesNo) -eq "Yes"){
        Get-SelectablePackages
    }
})
