## vCenter Storage vMotion Script

This script automates the process of performing a storage vMotion on a virtual machine (VM) in a vCenter environment. It connects to a vCenter server using the vCenter server URL, username, and a password that is stored in a Hashicorp Vault.

### Prerequisites

- VMware PowerCLI must be installed on the machine running this script.
- The machine running this script must have access to the vCenter server and the Hashicorp Vault server.
- The Hashicorp Vault secret containing the vCenter password must be correctly configured and accessible using the specified path.

### Variables

The following variables must be configured before running the script:

- `$vCenterServer`: The URL of the vCenter server.
- `$vCenterUser`: The vCenter username, in the format `username@domain`.
- `$vmName`: The name of the VM to perform the storage vMotion on.
- `$vmFolder`: The name of the folder containing the VM.
- `$vaultUrl`: The URL of the Hashicorp Vault server.
- `$secretPath`: The path to the Hashicorp Vault secret containing the vCenter password.
- `$datastoreClusterName` : the name of datastore cluster where we will move the VM

### Execution

- If the variable `$vaultToken` is not set, the script prompts the user for the Vault token.
- The script then sets the HTTP headers for the request, including the Vault token, and makes a GET request to retrieve the secret.
- The response from the request is in JSON format, and the script uses the `ConvertFrom-Json` cmdlet to convert the content to a PowerShell object, from which the vCenter password is extracted.
- Once the password is obtained, the script uses the `Connect-VIServer` cmdlet to connect to the vCenter server using the specified server URL, username, and password.
- After that, using `Get-VM` cmdlet it retrieves the virtual machine (VM) specified by the `$vmName` variable and the `$vmFolder` variable.
- Then the script retrieves the destination datastore storage cluster using `Get-Datastore` and `$datastoreClusterName` variable.
- At last using `Move-VMStorage` cmdlet it performs the Storage vMotion, converting the disk type to Thick (Lazy Zeroed) format which is specified by `-DiskStorageFormat 'ThickLazyZeroed'` option.

