function Add-GUIPartitiontoDisk {
    param (
        $Prefix,
        $PartitionType,
        $AddType,
        $SizePixels
    )
    
    #$Prefix = 'WPF_UI_DiskPartition_Partition_'
    #$PartitionType = 'FAT32'
    #$PartitionType = 'ID76'
    #$NewPartitionNumber = '1'
    #$SizePixels = 100
    
    $PrefixtoUse = ($Prefix+$PartitionType)

    if ($PartitionType -eq 'FAT32'){
        $MinimumSize = $Script:PistormSDCard.FAT32MinimumSizePixels
    }
    elseif ($PartitionType -eq 'ID76'){
        $MinimumSize = $Script:PistormSDCard.ID76MinimumSizePixels
    }

    if ($PartitionType -eq 'FAT32'){
        $NewPartitionNumber = $Script:WPF_UI_DiskPartition_Disk_MBR.NextPartitionFAT32Number
        $Script:WPF_UI_DiskPartition_Disk_MBR.NextPartitionFAT32Number += 1
        $Script:WPF_UI_DiskPartition_Disk_MBR.NumberofPartitionsFAT32 += 1
    }
    elseif ($PartitionType -eq 'ID76'){
        $NewPartitionNumber = $Script:WPF_UI_DiskPartition_Disk_MBR.NextPartitionID76Number
        $Script:WPF_UI_DiskPartition_Disk_MBR.NextPartitionID76Number += 1
        $Script:WPF_UI_DiskPartition_Disk_MBR.NumberofPartitionsID76 += 1
    }
    $Script:WPF_UI_DiskPartition_Disk_MBR.NumberofPartitionsTotal += 1
    
    $NewPartitionName = ($PrefixtoUse+'_'+$NewPartitionNumber) 
    
    if ($PartitionType -eq 'FAT32'){
        $NewPartition_XML = get-content 'WPF\PartitionFAT32.xaml'
    }
    
    if ($PartitionType -eq 'ID76'){
        $NewPartition_XML = get-content 'WPF\PartitionID76.xaml'
    }
    $NewPartition_XML = $NewPartition_XML -replace 'mc:Ignorable="d"','' -replace "x:N",'N' -replace '^<Win.*', '<Window'
    [xml]$NewPartition_XAML = $NewPartition_XML
    
    $reader = (New-Object System.Xml.XmlNodeReader $NewPartition_XAML)

    $NewPartition = [Windows.Markup.XamlReader]::Load( $reader)
    $NewPartition | Add-Member -NotePropertyName PartitionType -NotePropertyValue $PartitionType
    $NewPartition | Add-Member -NotePropertyName PartitionSizeBytes -NotePropertyValue $null  

    if ($AddType -eq 'Initial'){
        $LeftMargin = (Get-MBRPartitionStartEnd -Prefix $Prefix).EndingPosition
    }
    elseif ($AddType -eq 'Right'){
        $CoordinatestoCheck = Get-GUIPartitionBoundaries -Prefix 'WPF_UI_DiskPartition_Partition_' -ObjecttoCheck (Get-Variable -name $Script:GUIActions.SelectedPartition).value 
        if ($CoordinatestoCheck.RightBoundary - $CoordinatestoCheck.RightEdgeofObject -gt $MinimumSize){
            Write-Host $MinimumSize
            Write-Host $CoordinatestoCheck
            $LeftMargin = $CoordinatestoCheck.RightEdgeofObject
        }
        else{
            return
        }
    }
    elseif ($AddType -eq 'Left'){
        $CoordinatestoCheck = Get-GUIPartitionBoundaries -Prefix 'WPF_UI_DiskPartition_Partition_' -ObjecttoCheck (Get-Variable -name $Script:GUIActions.SelectedPartition).value 
        if ($CoordinatestoCheck.LeftEdgeofObject - $CoordinatestoCheck.LeftBoundary -gt $MinimumSize){
            $LeftMargin = $CoordinatestoCheck.LeftEdgeofObject-$MinimumSize
        }
        else{
            return
        }
    }
    

    #Write-host $LeftMargin
    $RightMargin = 0
    $TopMargin = 0
    $BottomMargin = 0
    $NewPartition.Margin = [System.Windows.Thickness]"$LeftMargin,$TopMargin,$RightMargin,$BottomMargin"

    $TotalColumns = $NewPartition.ColumnDefinitions.Count-1
    for ($i = 0; $i -le $TotalColumns; $i++) {
        if  ($NewPartition.ColumnDefinitions[$i].Name -eq 'FullSpace'){
            $NewPartition.ColumnDefinitions[$i].Width = $SizePixels
        } 
    }

    Set-Variable -name $NewPartitionName -Scope Script -Value ((Get-Variable -Name NewPartition).Value)
    (Get-Variable -Name $NewPartitionName).Value.Name = $NewPartitionName
 
    $PSCommand = @"

        `$Script:WPF_UI_DiskPartition_PartitionGrid_MBR.AddChild(`$$NewPartitionName)
        `$$NewPartitionName.ContextMenu.add_Opened({
            if (-not `$Script:GUIActions.SelectedPartition){
                `$$NewPartitionName.ContextMenu.IsOpen = ""
            }
        })
"@

    Invoke-Expression $PSCommand  

    $PSCommand = @"

    for (`$i = 0; `$i -le `$$NewPartitionName.ContextMenu.Items.Count-1; `$i++) {
        if (`$$NewPartitionName.ContextMenu.Items[`$i].Name -eq 'DeletePartition'){
            `$$NewPartitionName.ContextMenu.Items[`$i].add_click({
                Remove-GUIPartition -PartitionName '$NewPartitionName'
            })
        }
    }

    for (`$i = 0; `$i -le `$$NewPartitionName.ContextMenu.Items.Items.Count-1; `$i++) {
    
        if (`$$NewPartitionName.ContextMenu.Items.Items[`$i].Name -eq 'CreateID76Right'){
            `$$NewPartitionName.ContextMenu.Items.Items[`$i].add_click({
                Add-GUIPartitiontoDisk -Prefix 'WPF_UI_DiskPartition_Partition_' -PartitionType 'ID76' -AddType 'Right' -SizePixels `$Script:PistormSDCard.ID76MinimumSizePixels                
            })
        }
    
        if (`$$NewPartitionName.ContextMenu.Items.Items[`$i].Name -eq 'CreateFAT32Left'){
            `$$NewPartitionName.ContextMenu.Items.Items[`$i].add_click({
                Add-GUIPartitiontoDisk -Prefix 'WPF_UI_DiskPartition_Partition_' -PartitionType 'FAT32' -AddType 'Left' -SizePixels `$Script:PistormSDCard.FAT32MinimumSizePixels   
            })
        }

        if (`$$NewPartitionName.ContextMenu.Items.Items[`$i].Name -eq 'CreateFAT32Right'){
            `$$NewPartitionName.ContextMenu.Items.Items[`$i].add_click({
                Add-GUIPartitiontoDisk -Prefix 'WPF_UI_DiskPartition_Partition_' -PartitionType 'FAT32' -AddType 'Right' -SizePixels `$Script:PistormSDCard.FAT32MinimumSizePixels        
            })
        }
        
        if (`$$NewPartitionName.ContextMenu.Items.Items[`$i].Name -eq 'CreateID76Left'){
            `$$NewPartitionName.ContextMenu.Items.Items[`$i].add_click({
                Add-GUIPartitiontoDisk -Prefix 'WPF_UI_DiskPartition_Partition_' -PartitionType 'ID76' -AddType 'Left' -SizePixels `$Script:PistormSDCard.ID76MinimumSizePixels     
            })
        }

    }


"@

    Invoke-Expression $PSCommand  

}



