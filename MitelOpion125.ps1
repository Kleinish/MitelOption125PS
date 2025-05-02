# Fixed Mitel code
$mitelCode = "00000403"

# Prompt for user inputs
$callServers = Read-Host "Enter IP addresses for call servers (comma-separated, e.g., 192.168.1.1,192.168.1.2)"
$swTftp = Read-Host "Enter IP address for TFTP server (e.g., 192.168.1.3)"
$useVlan = Read-Host "Is Voice VLAN configured on the connected switch? (yes/no)"
$vlan = ""
if ($useVlan -eq "yes" -or $useVlan -eq "y") {
    $vlan = Read-Host "Enter VLAN number"
}

# Convert call servers to ASCII hex (uppercase)
$callServersHex = [System.Text.Encoding]::ASCII.GetBytes($callServers) | ForEach-Object { "{0:X2}" -f $_ } | Join-String -Separator "" | ForEach-Object { $_.ToUpper() }

# Convert TFTP server IP address to ASCII hex (uppercase)
$swTftpHex = [System.Text.Encoding]::ASCII.GetBytes($swTftp) | ForEach-Object { "{0:X2}" -f $_ } | Join-String -Separator "" | ForEach-Object { $_.ToUpper() }

# Convert VLAN to ASCII hex (if provided, uppercase)
$vlanHex = ""
if ($vlan) {
    $vlanHex = [System.Text.Encoding]::ASCII.GetBytes($vlan) | ForEach-Object { "{0:X2}" -f $_ } | Join-String -Separator "" | ForEach-Object { $_.ToUpper() }
}

# Fixed strings in hex (uppercase)
$idHex = "696470686F6E652E6D6974656C2E636F6D3B" # id:ipphone.mitel.com;
$callSrvPrefix = "63616C6C5F7372763D" # call_srv=
$swTftpPrefix = "73775F746674703D" # sw_tftp=

# Build suboption 1 content
$subOptionContent = $idHex + $callSrvPrefix + $callServersHex + "3B" + $swTftpPrefix + $swTftpHex
if ($vlan) {
    $subOptionContent += "3B766C616E3D" + $vlanHex # vlan=<vlan> (no trailing semicolon)
} else {
    $subOptionContent = $subOptionContent # No trailing semicolon
}

# Calculate lengths (in bytes)
$subOptionLength = ([string]$subOptionContent).Length / 2 # Length in bytes (2 hex chars = 1 byte)
$optionDataLength = $subOptionLength + 4 # Includes suboption code (01) and length field (2 bytes) + enterprise code (1 byte)

# Convert lengths to hex (minimum 2 digits, uppercase)
$optionDataLengthHex = "{0:X2}" -f $optionDataLength | ForEach-Object { $_.ToUpper() }
$subOptionLengthHex = "{0:X2}" -f $subOptionLength | ForEach-Object { $_.ToUpper() }

# Build final Option 125 hex string
$option125 = $mitelCode + # Enterprise code
             $optionDataLengthHex + # Total length of option data
             "01" + # Suboption 1
             $subOptionLengthHex + # Length of suboption data
             $subOptionContent

# Output the result
Write-Output $option125