$WPF_ADFKickstartReporting_OK_Button.Add_Click({
    $WPF_ADFKickstartReporting.Close() | out-null
    remove variable -name 'WPF_ADFKickstartReporting*'
})