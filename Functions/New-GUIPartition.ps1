function New-GUIPartition {
    param (
        $PartitionType,
        $SizePixels,
        $LeftMargin,
        $TopMargin,
        $RightMargin,
        $BottomMargin,
        $DefaultPartition
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
    $NewPartition |Add-Member -NotePropertyName PartitionTypeMBRorAmiga -NotePropertyValue $null

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

    $TotalColumns = $NewPartition.ColumnDefinitions.Count-1
    for ($i = 0; $i -le $TotalColumns; $i++) {
        if  ($NewPartition.ColumnDefinitions[$i].Name -eq 'FullSpace'){
            $NewPartition.ColumnDefinitions[$i].Width = $SizePixels
        } 
    }

    $NewPartition.Margin = [System.Windows.Thickness]"$LeftMargin,$TopMargin,$RightMargin,$BottomMargin"

    if ($DefaultPartition -eq 'TRUE'){
        $TotalChildren = $NewPartition.Children.Count-1
        
        for ($i = 0; $i -le $TotalChildren; $i++) {
            if ($NewPartition.Children[$i].Name -eq 'FullSpace_Rectangle'){
                if ($PartitionType -eq 'FAT32'){
                    $NewPartition.Children[$i].Fill=$WPF_UI_DiskPartition_Window.Resources.DefaultFAT32Brush
                }
                elseif ($PartitionType -eq 'ID76'){
                    $NewPartition.Children[$i].Fill=$WPF_UI_DiskPartition_Window.Resources.DefaultID76Brush
                }
                elseif ($PartitionType -eq 'Amiga'){
                    Write-host "Wibble"
                    $NewPartition.Children[$i].Fill='Black'
                    $NewPartition.Children[$i].Fill=$WPF_UI_DiskPartition_Window.Resources.DefaultAmigaPartitionBrush
                }
            }

        }
    }

    return $NewPartition
}

