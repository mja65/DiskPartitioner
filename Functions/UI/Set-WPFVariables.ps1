function Set-WPFVariables {
    param (
        $XAMLtoUse,
        $WPFPrefix,
        $Form
    )
    
    $XAMLtoUse.SelectNodes("//*[@Name]") | ForEach-Object{
        #    "Trying item $($_.Name)";
            try {
                Set-Variable -Scope Script -Name "$WPFPrefix$($_.Name)" -Value $Form.FindName($_.Name) -ErrorAction Stop
            }
            catch{
                throw
            }
        }    
}
