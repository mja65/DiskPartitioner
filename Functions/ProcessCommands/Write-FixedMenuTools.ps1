function Write-FixedMenuTools {
    param (
        $AmigaTempDrivetoUse
    )
    $WBStartup = Import-TextFileforAmiga -SystemType 'Amiga' -ImportFile "$AmigaTempDrivetoUse\WBStartup\Menutools" 
    $WBStartup = Edit-AmigaScripts -ScripttoEdit $WBStartup -Action 'inject' -Name 'Add Wait' -Injectionpoint 'after' -Startpoint 'ADDRESS WORKBENCH' -LinestoAdd (Import-TextFileforAmiga -SystemType 'PC' -ImportFile "$($Script:Settings.LocationofAmigaFiles)\WBStartup\Menutools_1") -ArexxFlag 'AREXX'
    $WBStartup = Edit-AmigaScripts -ScripttoEdit $WBStartup -Action 'inject' -Name 'Add Offline and Online Menus' -Injectionpoint 'before' -Startpoint 'EXIT' -LinestoAdd (Import-TextFileforAmiga -SystemType 'PC' -ImportFile "$($Script:Settings.LocationofAmigaFiles)\WBStartup\Menutools_2") -ArexxFlag 'AREXX'
    
    Export-TextFileforAmiga -ExportFile "$($Script:Settings.LocationofAmigaFiles)\WBStartup\Menutools" -DatatoExport $WBStartup -AddLineFeeds 'TRUE'
    
}
