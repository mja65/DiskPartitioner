function Convert-HexToDecimal {
    param (
        [Parameter(Mandatory = $true)]
        [ValidatePattern('^[0-9A-Fa-f]+$')]
        [string]$HexString,

        [switch]$LittleEndian
    )

    # Ensure even number of hex digits (pad if needed)
    if ($HexString.Length % 2 -ne 0) {
        throw "Hex string must contain an even number of characters (full bytes)."
    }

    # Split into byte pairs
    $bytes = ($HexString -split '(.{2})' | Where-Object { $_ -ne '' })

    # Reverse byte order if little-endian
    if ($LittleEndian) {
        [Array]::Reverse($bytes)
    }

    # Join bytes into a single string and convert
    $normalizedHex = ($bytes -join '')
    return [Convert]::ToInt64($normalizedHex, 16)
}