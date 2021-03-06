<# 

 This Nutanix REST API PowerShell script shows how to connect and authenticate to a cluster, get unprotected VMs, create a protection domain, 
 and add unprotected VMs to a protection domain.

 Note: 	You cannot add Controller VMs or Metro Available VMs.
 		Be sure that you are running the latest version of the Nutanix cmdlets. 
		Be sure that variables have appropriate quotation marks.
***

 Set variables and authenticate to the Nutanix cluster.
 Replace "cluster_ip_address" with the cluster IP address.
 Replace "cluster_username" with the cluster username.
 Replace "cluster_password" with the cluster password.
 
#>

$ipAddress = "cluster_ip_address"    
$clusterUserName = "cluster_username" 
$clusterPassword = "cluster_password"

<#
 Connect to the Nutanix cluster. Select 'Y' for Yes when authenticating to the cluster.
#>
Connect-NutanixCluster -Server $ipAddress -UserName $clusterUserName -Password $clusterPassword -AcceptInvalidSSLCerts

<#
 Get Nutanix cluster information.
#>
Get-NTNXClusterInfo

<#
 Get specific elements from the Nutanix cluster information.
#>
Get-NTNXClusterInfo | Select ID, Name, ClusterExternalIPAddress, NumNodes, Version, HypervisorTypes

<#
 Add a protection domain to the cluster.
 Replace "pd_name" with the name of the protection domain.
#>
Add-NTNXProtectionDomain -Input "pd_name"

<#
 Find the unprotected VMs in a cluster.
#>
Get-NTNXUnprotectedVM

<#
Note:
Be sure that you are adding only unprotected VMs to a protection domain. 
Adding protected VMs to a protection domain may cause an error.
#>

<# 
Get the list of user unprotected VMs and add the list to a protection domain.
Replace "pd_name" with the name of the protection domain.
#>
Get-NTNXUnprotectedVM | where {-not $_.iscontrollerVM} | foreach-object{Add-NTNXProtectionDomainVM -Name "pd_name" -Names $_.vmName}

<#
 Add a specific VM to a protection domain.
 Replace "pd_name" with the name of the protection domain.
 Replace "vm_name" with the name of the VM.
#>
Add-NTNXProtectionDomainVM -Name "pd_name" -Names "vm_name"

<#
 Get the list of VMs that have been added to a protection domain.
 Replace "pd_name" with the name of your protection domain.
#>
Get-NTNXvm | where{$_.protectiondomainname -eq "pd_name"}
