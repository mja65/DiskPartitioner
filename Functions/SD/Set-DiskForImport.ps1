function Set-DiskForImport {
    param (
        [Switch]$MBR

    )
    
    Remove-Variable -Name 'WPF_SD_*'

    if ($MBR){
        $Script:GUIActions.ActionToPerform = 'ImportMBRPartition'

        $WPF_SelectDiskWindow = Get-XAML -WPFPrefix 'WPF_SD_' -XMLFile '.\Assets\WPF\Window_SelectDiskMBR.xaml' -ActionsPath '.\UIActions\SD\' -AddWPFVariables

        if ($WPF_DP_ImportMBRPartition_DropDown.SelectedItem -eq 'At end of disk'){
            $AddType = 'AtEnd'        
        }
        elseif ($WPF_DP_ImportMBRPartition_DropDown.SelectedItem -eq 'Left of selected partition'){
            $AddType= 'Left'   
        }
        elseif ($WPF_DP_ImportMBRPartition_DropDown.SelectedItem -eq 'Right of selected partition'){
            $AddType= 'Right'   
        }
        
        $Script:GUIActions.AvailableSpaceforImportedPartitionBytes = (Get-DiskFreeSpace -Disk $WPF_DP_Disk_MBR -Position $AddType -PartitionNameNextto $Script:GUIActions.SelectedMBRPartition)
        $WPF_SD_FreeSpace_Value.Text = "$((Get-ConvertedSize -Size $Script:GUIActions.AvailableSpaceforImportedPartitionBytes -ScaleFrom 'B' -AutoScale -NumberofDecimalPlaces 2).Size) $((Get-ConvertedSize -Size $Script:GUIActions.AvailableSpaceforImportedPartitionBytes -ScaleFrom 'B' -AutoScale -NumberofDecimalPlaces 2).Scale)"
        $WPF_SD_FreeSpaceRemaining_Value.Text = $WPF_SD_FreeSpace_Value.Text

        $WPF_SelectDiskWindow.ShowDialog() | out-null
    }
 
}



# Get-HSTPartitionInfo -RDBInfo -Path "$($Script:GUIActions.SelectedPhysicalDisk)\mbr\2"

# $WPF_SelectDiskWindow.Close() 

# Get-HSTPartitionInfo -MBRInfo -Path $Script:GUIActions.SelectedPhysicalDisk

# function Get-GUIADFKickstartReport {
#     param (
#         $Text,
#         $Title,
#         $DatatoPopulate,
#         $WindowWidth,
#         $WindowHeight,
#         $DataGridWidth,
#         $DataGridHeight,
#         $GridLinesVisibility,
#         $FieldsSorted
#     )
     
#     # $Title = 'ADFs to be used'
#     # $Text = 'The following ADFs will be used:'
#     # $DatatoPopulate = $Script:AvailableADFs 
#     # $WindowWidth =700 
#     # $WindowHeight =350 
#     # $DataGridWidth =570 
#     # $DataGridHeight =200 
#     # $GridLinesVisibility ='None' 
#     # $FieldsSorted = ('Status','ADF Name','Path')


#     $inputXML_ADFKickstartReporting = 
# @"
# <Window x:Name="Window" 
#             xmlns="http://schemas.microsoft.com/winfx/2006/xaml/presentation"
#             xmlns:x="http://schemas.microsoft.com/winfx/2006/xaml"
#             xmlns:d="http://schemas.microsoft.com/expression/blend/2008"
#             xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006"
#             xmlns:local="clr-namespace:WpfApp14"
#             mc:Ignorable="d"
#                Title="$Title" Height="$WindowHeight" Width="$WindowWidth" HorizontalAlignment="Center" VerticalAlignment="Center" Topmost="True" WindowStartupLocation="CenterOwner">
#     <Grid Background="#FFE5E5E5">
#         <DataGrid Name="Datagrid" IsReadOnly="True"  HorizontalAlignment="Center" Margin="5,40,0,0" Height="200" VerticalAlignment="Top" HorizontalScrollBarVisibility="Auto" GridLinesVisibility="$GridLinesVisibility" HorizontalGridLinesBrush="#FF505050" VerticalGridLinesBrush="#FF505050" >

#         </DataGrid>
#         <Button x:Name="OK_Button" Content="OK" HorizontalAlignment="Center" Margin="5,5,5,5" VerticalAlignment="Bottom" Width="40"/>
#         <TextBox x:Name="TextBox" HorizontalAlignment="Center"  Margin="7,0,0,0" TextWrapping="Wrap" Text="TextBox" VerticalAlignment="Top" BorderBrush="Transparent" Background="Transparent" IsReadOnly="True" IsUndoEnabled="False" IsTabStop="False" IsHitTestVisible="False" Focusable="False"/>
#     </Grid>

# </Window>
# "@

#     $XAML_ADFKickstartReporting = Format-XMLtoXAML -inputXML $inputXML_ADFKickstartReporting
#     $Form_ADFKickstartReporting = Read-XAML -xaml $XAML_ADFKickstartReporting 
#     Remove-Variable -Scope Script -Name WPF_UI_ADF_*
#     $XAML_ADFKickstartReporting.SelectNodes("//*[@Name]") | ForEach-Object{
#     #    "Trying item $($_.Name)";
#         try {
#             Set-Variable -Scope Script -Name "WPF_UI_ADF_$($_.Name)" -Value $Form_ADFKickstartReporting.FindName($_.Name) -ErrorAction Stop
#         }
#         catch{
#             throw
#         }
#     }
   
#     $Form_ADFKickstartReporting.Top=300
#     $Form_ADFKickstartReporting.Left=300

#     If ($FieldsSorted){
#         $Fields = $FieldsSorted
#     }
#     else{
#         $Fields = (($DatatoPopulate | Get-Member -MemberType NoteProperty).Name)
#     }


#     $Datatable = New-Object System.Data.DataTable
#     [void]$Datatable.Columns.AddRange($Fields)
#     foreach ($line in $DatatoPopulate)
#     {
#         $Array = @()
#         Foreach ($Field in $Fields)
#         {
#             $array += $line.$Field
#         }
#         [void]$Datatable.Rows.Add($array)
#     }
     
#     $WPF_UI_ADF_TextBox.Text = $Text
    
#     $WPF_UI_ADF_Datagrid.ItemsSource = $Datatable.DefaultView
#     if ($DataGridWidth){
#         $WPF_UI_ADF_Datagrid.Width = "$DataGridWidth"
#     }
#     if($DataGridHeight){
#         $WPF_UI_ADF_Datagrid.Height = "$DataGridHeight"
#     }
   

#     $WPF_UI_ADF_OK_Button.Add_Click({
#         $Form_ADFKickstartReporting.Close() | out-null
#     })
    
#     $Form_ADFKickstartReporting.ShowDialog() | out-null

# }
