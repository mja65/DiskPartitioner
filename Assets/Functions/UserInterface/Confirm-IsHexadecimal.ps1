function Confirm-IsHexadecimal(
    [string]$value
    ) 
    {
    return $value -match "^0x[0-9a-fA-F]+$"
  }
