# Mitel Option 125 Hex String Generator

This PowerShell script generates a hexadecimal string for DHCP Option 125, used in Mitel phone configurations. The script takes user inputs for call server IP addresses, TFTP server IP address, and an optional VLAN number, converting them to ASCII hex format. The output is formatted with uppercase hex letters, excludes the "7D" prefix, places the total length after the enterprise code, and ensures no trailing semicolon.

## Prerequisites

- **PowerShell**: The script requires PowerShell (version 5.1 or later recommended) installed on your system. It works on Windows, macOS, or Linux with PowerShell Core.
- **Basic Knowledge**: Familiarity with running PowerShell scripts and providing input via the console.

## Usage

1. **Save the Script**:
   - Save the script as `GenerateOption125.ps1` (or another name with a `.ps1` extension).

2. **Run the Script**:
   - Open a PowerShell terminal.
   - Navigate to the directory containing the script using `cd <directory-path>`.
   - Run the script with:
     ```powershell
     .\GenerateOption125.ps1
     ```

3. **Provide Inputs**:
   - **Call Servers**: Enter comma-separated IP addresses for the Mitel call servers (e.g., `192.168.1.1,192.168.1.2`).
   - **TFTP Server**: Enter the IP address for the TFTP server (e.g., `192.168.1.3`).
   - **Voice VLAN**: Answer `yes` or `no` to indicate if a Voice VLAN is configured on the connected switch. If `yes`, enter the VLAN number (e.g., `1234`).

4. **Output**:
   - The script outputs a single hexadecimal string representing the Option 125 value, with all letters in uppercase (e.g., `A-F`).
   - The string includes:
     - Fixed enterprise code (`00000403`).
     - Total length of option data (2-digit hex).
     - Suboption 1 with its length and content, including `id:ipphone.mitel.com;`, `call_srv=<IPs>;`, `sw_tftp=<IP>;`, and optionally `vlan=<VLAN>`.

## Example

```powershell
PS> .\GenerateOption125.ps1
Enter IP addresses for call servers (comma-separated, e.g., 192.168.1.1,192.168.1.2): 192.168.1.1,192.168.1.2
Enter IP address for TFTP server (e.g., 192.168.1.3): 192.168.1.3
Is Voice VLAN configured on the connected switch? (yes/no): yes
Enter VLAN number: 1234
000004036901696470686F6E652E6D6974656C2E636F6D3B63616C6C5F7372763D3139322E3136382E312E312C3139322E3136382E312E323B73775F746674703D3139322E3136382E312E333B766C616E3D31323334
```

### Explanation of Output
- **Enterprise Code**: `00000403` (fixed Mitel code).
- **Total Length**: `69` (length of suboption data plus 4 bytes, in hex).
- **Suboption 1**: `01` (suboption code).
- **Suboption Length**: `65` (length of suboption content, in hex).
- **Content**:
  - `id:ipphone.mitel.com;` as ASCII hex (`696470686F6E652E6D6974656C2E636F6D3B`).
  - `call_srv=192.168.1.1,192.168.1.2;` as ASCII hex.
  - `sw_tftp=192.168.1.3;` as ASCII hex.
  - `vlan=1234` as ASCII hex (if provided, no trailing semicolon).

## Notes
- **Input Validation**: Ensure IP addresses are entered in the correct format (e.g., `x.x.x.x`). The script does not validate input formats.
- **ASCII Conversion**: IP addresses and VLAN numbers are converted to hex as ASCII strings (e.g., `192.168.1.1` becomes `3139322E3136382E312E31`).
- **Uppercase Hex**: All hex letters are capitalized (e.g., `A-F`).
- **No Trailing Semicolon**: The final string does not end with `3B`.

## Troubleshooting
- **Script Not Running**: If you get a "scripts disabled" error, set the execution policy:
  ```powershell
  Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy RemoteSigned
  ```
- **Incorrect Output**: Verify that inputs are correctly formatted and that the VLAN is only provided if `yes` is selected.

For further assistance, contact your network administrator or refer to Mitel documentation for DHCP Option 125 configuration.