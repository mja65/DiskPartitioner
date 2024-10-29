function New-GUIPartition {
    param (
        $PartitionType,
        $SizePixels,
        $LeftMargin,
        $TopMargin,
        $RightMargin,
        $BottomMargin
    )
    
    if ($PartitionType -eq 'FAT32'){
        $NewPartition_XML = get-content 'WPF\PartitionFAT32.xaml'
    }
    elseif ($PartitionType -eq 'ID76'){
        $NewPartition_XML = get-content 'WPF\PartitionID76.xaml'
    }
    elseif ($PartitionType -eq 'Amiga'){
        $NewPartition_XML = get-content 'WPF\PartitionAmiga.xaml'
    }

    $NewPartition_XML = $NewPartition_XML -replace 'mc:Ignorable="d"','' -replace "x:N",'N' -replace '^<Win.*', '<Window'
    [xml]$NewPartition_XAML = $NewPartition_XML
    
    $reader = (New-Object System.Xml.XmlNodeReader $NewPartition_XAML)

    $NewPartition = [Windows.Markup.XamlReader]::Load( $reader)
    $NewPartition | Add-Member -NotePropertyName PartitionType -NotePropertyValue $PartitionType
    $NewPartition | Add-Member -NotePropertyName PartitionSizeBytes -NotePropertyValue $null  

    if ($PartitionType -eq 'ID76'){
        $NewPartition | Add-Member -NotePropertyName AmigaDiskName -NotePropertyValue $null  
    }

    $TotalColumns = $NewPartition.ColumnDefinitions.Count-1
    for ($i = 0; $i -le $TotalColumns; $i++) {
        if  ($NewPartition.ColumnDefinitions[$i].Name -eq 'FullSpace'){
            $NewPartition.ColumnDefinitions[$i].Width = $SizePixels
        } 
    }

    $NewPartition.Margin = [System.Windows.Thickness]"$LeftMargin,$TopMargin,$RightMargin,$BottomMargin"

    return $NewPartition
}