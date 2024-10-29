function Get-MainWindow {
    param (
        # $Title,
        # $WindowWidth, 
        # $WindowHeight,
        # $WindowLeft,
        $WPFPrefix 
    )

    Add-Type -AssemblyName PresentationFramework
    Add-Type -AssemblyName System.Windows.Forms

    $MainWindowVariables = @{
        Title = $Title
        WindowWidth = $WindowWidth
        WindowHeight = $WindowHeight
        WindowLeft = $WindowLeft
    
    }

    $MainWindow_XML = get-content 'WPF\Main_Window.xaml'
    $MainWindow_XML = $MainWindow_XML -replace 'mc:Ignorable="d"','' -replace "x:N",'N' -replace '^<Win.*', '<Window'

    # foreach ($Variable in $MainWindowVariables.GetEnumerator() ){
    #     $pattern = '#{0}#' -f $Variable.key
    #     $MainWindow_XML = $MainWindow_XML -replace $pattern, $Variable.Value
    # }        
    
    [xml]$MainWindow_XAML = $MainWindow_XML

    $MainWindow = Read-XAML -xaml $MainWindow_XAML

    Set-WPFVariables -XAMLtoUse $MainWindow_XAML -WPFPrefix $WPFPrefix -Form $MainWindow 

    return $MainWindow

} 
