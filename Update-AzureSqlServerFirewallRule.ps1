<#
.SYNOPSIS
    Returns current IP address
.DESCRIPTION
    Sends a request to 'http://checkip.dyndns.org' and returns current IP address
.EXAMPLE
    CurrentIpAddress
.OUTPUTS
    System.String
.NOTES
    Version 1
    Developed By: Lyubomir Lirkov
    Last Updated: 2022/08/09
#>
function Get-CurrentIpAddress{
    $web_client = New-Object System.Net.WebClient
    [xml]$response = $web_client.DownloadString('http://checkip.dyndns.org')
    $current_ip = ($response.html.body -split ':')[1].Trim()
    Write-Output $current_ip
}


<#
.SYNOPSIS
    Updates Azure SQL server firewall rule
.DESCRIPTION
    Checks Azure SQL server firewall rule and updates it if it does not match with the users' current IP address
.EXAMPLE
    Update-AzureSqlServerFirewallRule
.OUTPUTS
    System.String
.NOTES
    Version 1
    Developed By: Lyubomir Lirkov
    Last Updated: 2022/08/09
#>
function Update-AzureSqlServerFirewallRule{
    [CmdletBinding()]
    param
    (
        [Parameter (Mandatory = $true, 
            Position = 1, 
            HelpMessage = 'The name of the Azure resource group where the server deployed')] 
        [string]$resource_group,

        [Parameter (Mandatory = $true, 
            Position = 2, 
            HelpMessage = 'The name of the server')] 
        [string]$server_name,

        [Parameter (Mandatory = $true, 
            Position = 3, 
            HelpMessage = 'The name of the server firewall rule')] 
        [string]$rule_name,

        [Parameter (Mandatory = $true, 
            Position = 4, 
            HelpMessage = 'Current IP address')] 
        [string]$current_ip
    )

    $current_firewall_rule = Get-AzSqlServerFirewallRule `
        -ServerName $server_name `
        -ResourceGroupName $resource_group |` 
        Where-Object {$_.FirewallRuleName -eq $rule_name}

    if ($current_firewall_rule.StartIpAddress -ne $current_ip){
        Set-AzSqlServerFirewallRule `
            -ResourceGroupName $resource_group `
            -ServerName $server_name `
            -FirewallRuleName $rule_name `
            -StartIpAddress $current_ip `
            -EndIpAddress $current_ip
        Write-Host 'Server firewall rule has been updated!'
    }else {
        Write-Host 'Server firewall rule is up to date!'
    }
}



# Connect to Azure account 
Connect-AzAccount 

# Select specific subscription, before sending any other commands
Select-AzSubscription -Subscription "Visual Studio Enterprise Subscription – MPN"

# Define variables
$resource_group = "dev-primary-we"
$server_name = "server-dev-prim-01"
$rule_name = "LTL-HOME"
$current_ip = Get-CurrentIpAddress

# Execute Update-AzureSqlServerFirewallRule
Update-AzureSqlServerFirewallRule `
    -resource_group 'PRIM' `
    -server_name 'srv-prim-we-001' `
    -rule_name 'LTL-HOME' `
    -current_ip $current_ip