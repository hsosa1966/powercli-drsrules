# Source URL https://deangrant.wordpress.com/2014/07/08/powercli-retrieving-drs-rules/
Import-Module VMware.VimAutomation.Core
Connect-VIServer raus-dc1-vc01.ravagoamericas.com
$DRSRules = Get-Cluster | Get-DrsRule
$Results = ForEach ($DRSRule in $DRSRules)
     {    
    "" | Select-Object -Property @{N="Cluster";E={(Get-View -Id $DRSRule.Cluster.Id).Name}},  
    @{N="Name";E={$DRSRule.Name}},
    @{N="Enabled";E={$DRSRule.Enabled}},
#   @{N="DRS Type";E={$DRSRule.KeepTogether}}, 
    @{N="DRS Type";E={$DRSRule.Type}}, 
    @{N="VMs";E={$VMIds=$DRSRule.VMIds -split "," 
      $VMs = ForEach ($VMId in $VMIds) 
        { 
        (Get-View -Id $VMId).Name
        } 
      $VMs -join ","}}     
     }
$Results | Export-Csv -NoTypeInformation -Path _DRSrules.csv
Disconnect-VIServer raus-dc1-vc01.ravagoamericas.com -Confirm:$false