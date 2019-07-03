# Source URL https://deangrant.wordpress.com/2014/07/08/powercli-retrieving-drs-rules/
Import-Module VMware.VimAutomation.Core

$Servers = Get-Content .\servers.txt
$GetDate = Get-Date -UFormat %Y%m%d
$OutputFile = $GetDate + "_DRSRules.csv"


ForEach ($vi in $servers)
    {
    connect-viserver $vi

$DRSRules = Get-Cluster | Get-DrsRule
$Results = ForEach ($DRSRule in $DRSRules)
    {

    "" | Select-Object -Property @{N="Cluster";E={(Get-View -Id $DRSRule.Cluster.Id).Name}},  
    @{N="Name";E={$DRSRule.Name}},
    @{N="Enabled";E={$DRSRule.Enabled}},

    @{N="DRS Type";E={$DRSRule.Type}}, 
    @{N="VMs";E={$VMIds=$DRSRule.VMIds -split "," 
      $VMs = ForEach ($VMId in $VMIds) 
        { 
        (Get-View -Id $VMId).Name
        } 
      $VMs -join ","}}
    }

$Results | Export-Csv -NoTypeInformation $OutputFile -Append -Force

Disconnect-VIServer $vi -Force -Confirm:$false
    }
