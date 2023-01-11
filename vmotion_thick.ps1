# vCenter Variables
$vCenterServer = 'vmvcenteruat.example.com'
$vCenterUser = 'vmuseruat'
# VM to perform the storage vMotion 
$vmName = 'linuxtestvm'
$vmFolder = 'dc.UAE.UAT.SRV'

# Set the URL of the Vault server and the path to the secret
$vaultUrl = 'https://vmvaultuat.example.com:8200'
$secretPath = 'vcenter/vcenter_pass'

# If you dont want any interaction the uncomment the below, add the correct token then comment line 9 - Set the Vault token to use for authentication
#$vaultToken = 'abcd-efgh-ijkl-mnop'

# Prompt the user for the Vault token
$vaultToken = Read-Host -Prompt 'Enter the Hashicorp Vault token:'

# Set the HTTP headers for the request
$headers = @{
    'X-Vault-Token' = $vaultToken
}

# Make the request to retrieve the secret
$response = Invoke-WebRequest -Uri "$vaultUrl/v1/$secretPath" -Headers $headers -Method GET

# Extract the vCenter password from the response
$vCenterPassword = ($response.Content | ConvertFrom-Json).data.password

# Connect to vCenter
Connect-VIServer -Server $vCenterServer -User $vCenterUser -Password $vCenterPassword

# Retrieve the VM to perform a Storage vMotion on
$vm = Get-VM -Name $vmName -Location $vmFolder

# Retrieve the destination datastore storage cluster
$datastoreClusterName = 'DatastoreCluster-01'
$datastoreCluster = Get-Datastore -Name $datastoreClusterName

# Perform the Storage vMotion, converting the disk type to Thick (Lazy Zeroed)
Move-VMStorage -VM $vm -Destination $datastoreCluster -DiskStorageFormat 'ThickLazyZeroed'
