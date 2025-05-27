function Get-NewPartitionSize {
    param (
    $DefaultScale,
    $MaximumSizeBytes,
    $MinimumSizeBytes
    )

    #$DefaultScale = "GiB" 
    #$MaximumSizeBytes = 332365824
    #$MinimumSizeBytes = 10*1024*1024    
    #$WPF_NewPartitionWindow_Input_PartitionSize_Value.Text = '5000' 

    $MinimumSizeBytestoUse = (Get-ConvertedSize -Size $MinimumSizeBytes -ScaleFrom 'B' -AutoScale -NumberofDecimalPlaces 2)
    $MaximumSizeBytestoUse = (Get-ConvertedSize -Size $MaximumSizeBytes -ScaleFrom 'B' -AutoScale -NumberofDecimalPlaces 2 -Truncate)

    $Script:GUICurrentStatus.NewPartitionDefaultScale = $DefaultScale
    $Script:GUICurrentStatus.NewPartitionMinimumSizeBytes = $MinimumSizeBytes
    $Script:GUICurrentStatus.NewPartitionMaximumSizeBytes = $MaximumSizeBytes

    Remove-Variable -Name 'WPF_NewPartitionWindow_*'
    
    $WPF_NewPartitionWindow = Get-XAML -WPFPrefix 'WPF_NewPartitionWindow_' -XMLFile '.\Assets\WPF\Window_Add_Partition.xaml'  -ActionsPath '.\Assets\UIActions\NewPartitionWindow\' -AddWPFVariables

    $WPF_NewPartitionWindow_PartitionSizeMax_Value.Text = "$($MaximumSizeBytestoUse.Size) $($MaximumSizeBytestoUse.Scale)"
    $WPF_NewPartitionWindow_PartitionSizeMin_Value.Text = "$($MinimumSizeBytestoUse.Size) $($MinimumSizeBytestoUse.Scale)"

    $WPF_NewPartitionWindow_Input_PartitionSize_Value.Text = "$($MaximumSizeBytestoUse.Size)"
    $WPF_NewPartitionWindow_Input_PartitionSize_SizeScale_Dropdown.SelectedItem = $MaximumSizeBytestoUse.Scale
        
    $null = $WPF_NewPartitionWindow_Input_PartitionSize_Value.Focus()
    $WPF_NewPartitionWindow_Input_PartitionSize_Value.SelectionLength = $WPF_NewPartitionWindow_Input_PartitionSize_Value.Text.Length
    $WPF_NewPartitionWindow_Input_PartitionSize_Value.SelectionStart = 0
    
    $WPF_NewPartitionWindow.ShowDialog() | out-null

    $Script:GUICurrentStatus.NewPartitionDefaultScale = $null
    $Script:GUICurrentStatus.NewPartitionMaximumSizeBytes = $null
    $Script:GUICurrentStatus.NewPartitionMinimumSizeBytes = $null

    if ($Script:GUICurrentStatus.NewPartitionAcceptedNewValue -eq $true){
        if ($WPF_NewPartitionWindow_Input_PartitionSize_Value.Text){
            $ValuetoReturn = (Get-ConvertedSize -Size $WPF_NewPartitionWindow_Input_PartitionSize_Value.Text -ScaleFrom $WPF_NewPartitionWindow_Input_PartitionSize_SizeScale_Dropdown.SelectedItem -Scaleto 'B').size  
            Remove-Variable -Name 'WPF_NewPartitionWindow_*'
            $Script:GUICurrentStatus.NewPartitionAcceptedNewValue = $false
            return $ValuetoReturn
        }
        else {
            Remove-Variable -Name 'WPF_NewPartitionWindow_*'
            return 
        }                          
    }
    else {
        Remove-Variable -Name 'WPF_NewPartitionWindow_*'
        return 
    }
    
}
