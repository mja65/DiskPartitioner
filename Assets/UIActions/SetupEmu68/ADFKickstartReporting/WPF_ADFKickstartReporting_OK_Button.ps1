
$WPF_ADFKickstartReporting_OK_Button.Add_Click({
    $WPF_ADFKickstartReporting.Close() | out-null
    Remove-Variable -name 'WPF_ADFKickstartReporting*'
})