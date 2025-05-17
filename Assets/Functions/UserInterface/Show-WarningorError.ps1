function Show-WarningorError {
    param (
        $Msg_Body,
        $Msg_Header,
        [Switch]$BoxTypeNone,
        [Switch]$BoxTypeError,
        [Switch]$BoxTypeQuestion,
        [Switch]$BoxTypeWarning,
        [Switch]$BoxTypeAsterisk,
        [Switch]$ButtonType_OK,
        [Switch]$ButtonType_OKCancel,
        [Switch]$ButtonType_YesNoCancel,
        [Switch]$ButtonType_YesNo
    )

    if ($BoxTypeNone){
        $BoxType = 0
    }
    elseif ($BoxTypeError){
        $BoxType = 16
    }
    elseif($BoxTypeQuestion){
        $BoxType = 32
    }
    elseif($BoxTypeWarning){
        $BoxType = 48
    }
    elseif($BoxTypeAsterisk){
        $BoxType = 64
    }

    if($ButtonType_OK){
        $ButtonType = 0
    }
    elseif($ButtonType_OKCancel){
        $ButtonType = 1
    }
    elseif($ButtonType_YesNoCancel){
        $ButtonType = 3
    }
    elseif($ButtonType_YesNo){
        $ButtonType = 4
    }

    $ValueofAction = [System.Windows.MessageBox]::Show($Msg_Body, $Msg_Header,$ButtonType,$BoxType)

    return ($ValueofAction)
}
