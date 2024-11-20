function New-GUIPartition {
    param (
        $PartitionType,
        $DefaultPartition
    )
    
    if ($PartitionType -eq 'FAT32'){
        $NewPartition_XML = get-content '.\Assets\WPF\PartitionFAT32.xaml'
    }
    elseif ($PartitionType -eq 'ID76'){
        $NewPartition_XML = get-content '.\Assets\WPF\PartitionID76.xaml'
    }
    elseif ($PartitionType -eq 'Amiga'){
        $NewPartition_XML = get-content '.\Assets\WPF\PartitionAmiga.xaml'
    }

    [xml]$NewPartition_XAML = $NewPartition_XML -replace 'mc:Ignorable="d"','' -replace "x:N",'N' -replace '^<Win.*', '<Window'
    
    $reader = (New-Object System.Xml.XmlNodeReader $NewPartition_XAML)

    $NewPartition = [Windows.Markup.XamlReader]::Load( $reader)

    $NewPartition | Add-Member -NotePropertyMembers @{
        PartitionType = $PartitionType
        StartingPositionBytes = $null
        PartitionSizeBytes = $null  
        PartitionTypeMBRorAmiga = $null
        DefaultPartition = $DefaultPartition
        CanResizeLeft = $null
        CanResizeRight = $null
        CanMove = $null
        CanDelete = $null
    }

    If ($DefaultPartition){
        $NewPartition.CanDelete = $false
        $NewPartition.CanResizeRight = $true
        if ($PartitionType -eq 'FAT32'){
            $NewPartition.CanMove = $false
            $NewPartition.CanResizeLeft =$false
        }
        else{
            $NewPartition.CanMove = $true
            $NewPartition.CanResizeLeft =$true
        }
    }
    else{
        $NewPartition.CanDelete = $true
        $NewPartition.CanResizeRight = $true
        $NewPartition.CanResizeLeft =$true
        $NewPartition.CanMove = $true
    }


    if ($PartitionType -eq 'FAT32'){
        $NewPartition.PartitionTypeMBRorAmiga='MBR'
    } 
    elseif ($PartitionType -eq 'ID76'){
        $NewPartition | Add-Member -NotePropertyName AmigaDiskName -NotePropertyValue $null  
        $NewPartition.PartitionTypeMBRorAmiga='MBR'
    }
    elseif ($PartitionType -eq 'Amiga'){
        $NewPartition.PartitionTypeMBRorAmiga='Amiga'
    }
     
    #$NewPartition.PartitionSizeBytes = $SizeBytes

    if ($DefaultPartition -eq $true){
        $TotalChildren = $NewPartition.Children.Count-1
        
        for ($i = 0; $i -le $TotalChildren; $i++) {
            if ($NewPartition.Children[$i].Name -eq 'FullSpace_Rectangle'){
                if ($PartitionType -eq 'FAT32'){
                    $NewPartition.Children[$i].Fill=$WPF_MainWindow.Resources.DefaultFAT32Brush
                }
                elseif ($PartitionType -eq 'ID76'){
                    $NewPartition.Children[$i].Fill=$WPF_MainWindow.Resources.DefaultID76Brush
                }
                elseif ($PartitionType -eq 'Amiga'){
                    $NewPartition.Children[$i].Fill=$WPF_MainWindow.Resources.DefaultAmigaPartitionBrush
                }
            }
        }
    }

    return $NewPartition
}
