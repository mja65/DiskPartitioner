function New-GUIPartition {
    param (
        $PartitionType,
        $DefaultPartition,
        $PartitionTypeAmiga,
        $ImportedPartition,
        $DerivedImportedPartition
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

    if ($DefaultPartition -eq $true){
        if ($PartitionType -eq 'FAT32' -or $PartitionType -eq 'ID76'){
            $DefaultMBRPartition = $true
        }
        elseif ($PartitionType -eq 'Amiga'){
            if ($PartitionTypeAmiga -eq 'Workbench'){
                $DefaultAmigaWorkbenchPartition = $true
            }
            elseif ($PartitionTypeAmiga -eq 'Work'){
                $DefaultAmigaWorkPartition = $true
            }
        }
    }

    [xml]$NewPartition_XAML = $NewPartition_XML -replace 'mc:Ignorable="d"','' -replace "x:N",'N' -replace '^<Win.*', '<Window'
    
    $reader = (New-Object System.Xml.XmlNodeReader $NewPartition_XAML)

    $NewPartition = [Windows.Markup.XamlReader]::Load( $reader)

    $NewPartition | Add-Member -NotePropertyMembers @{
        ImportedPartition = $false
        ImportedPartitionType = $null
        ImportedPartitionPath = $null
        PartitionType = $PartitionType
        StartingPositionBytes = $null
        PartitionSizeBytes = $null  
        PartitionTypeMBRorAmiga = $null
        DefaultMBRPartition = $DefaultMBRPartition
        DefaultAmigaWorkbenchPartition = $DefaultAmigaWorkbenchPartition
        DefaultAmigaWorkPartition = $DefaultAmigaWorkPartition
        CanResizeLeft = $null
        CanResizeRight = $null
        CanMove = $null
        CanDelete = $null
    }

    If ($DefaultMBRPartition -eq $true){
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
    elseif ($DefaultAmigaWorkbenchPartition -eq $true){
        $NewPartition.CanDelete = $false
        $NewPartition.CanResizeRight = $true
        $NewPartition.CanMove = $true
        $NewPartition.CanResizeLeft =$true
    }
    elseif ($DefaultAmigaWorkPartition -eq $true){
        $NewPartition.CanDelete = $false
        $NewPartition.CanResizeRight = $true
        $NewPartition.CanMove = $true
        $NewPartition.CanResizeLeft =$true
    }
    elseif ($ImportedPartition -eq $true){
        if ($DerivedImportedPartition -eq $true){
            $NewPartition.CanDelete = $false
        }
        else {
            $NewPartition.CanDelete = $true

        }
        $NewPartition.CanResizeRight = $false
        $NewPartition.CanResizeLeft =$false
        $NewPartition.CanMove = $true
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

        $NewPartition | Add-Member -NotePropertyMembers @{
            DeviceName =$null
            VolumeName = $null
            Buffers = $null
            DosType = $null
            MaxTransfer = $null
            Bootable = $null
            NoMount = $null
            Priority = $null
            CanChangeBuffers = $null
            CanRenameDevice = $null
            CanRenameVolume = $null
            CanChangeMaxTransfer = $null
            CanChangeBootable = $null
            CanChangeMountable = $null
            CanChangePriority = $null
        }

        $NewPartition.PartitionTypeMBRorAmiga='Amiga'
    }
     
    #$NewPartition.PartitionSizeBytes = $SizeBytes

    $TotalChildren = $NewPartition.Children.Count-1
    
    for ($i = 0; $i -le $TotalChildren; $i++) {
        if ($NewPartition.Children[$i].Name -eq 'FullSpace_Rectangle'){
            if ($DefaultPartition -eq $true){
                if ($PartitionType -eq 'FAT32'){
                    $NewPartition.Children[$i].Fill=$WPF_MainWindow.Resources.DefaultFAT32Brush
                }
                elseif ($PartitionType -eq 'ID76'){
                    $NewPartition.Children[$i].Fill=$WPF_MainWindow.Resources.DefaultID76Brush
                }
                elseif ($DefaultAmigaWorkbenchPartition -eq $true){
                    $NewPartition.Children[$i].Fill=$WPF_MainWindow.Resources.DefaultAmigaWorkbenchPartitionBrush
                }
                elseif ($DefaultAmigaWorkPartition -eq $true){
                    $NewPartition.Children[$i].Fill=$WPF_MainWindow.Resources.DefaultAmigaWorkPartitionBrush
                }
            }
            else {
                if ($ImportedPartition -eq $true){}
                elseif ($PartitionType -eq 'FAT32'){}
                elseif ($PartitionType -eq 'ID76'){}
                elseif ($PartitionType -eq 'Amiga'){
                }

            }
        }
    }

    

    return $NewPartition
}

# $WPF_DP_Partition_ID76_1.Children[4].Fill

# $WPF_DP_Partition_FAT32_2.Children[4].Fill