param(
[VMware.VimAutomation.ViCore.Types.V1.Inventory.Datacenter]
$context,
[int]
$daysOld,
[string]
$emailTo='bwuchner@example.com')

# Note: This script expects a Datacenter object and will find/email a listing of all snapshots over 3 days old found in that datacenter.

$results = $context | Get-VM |Get-Snapshot |?{$_.Created.AddDays($daysOld) -lt (Get-Date)} | Select VM, Name, @{N='SizeGB';E={[math]::round($_.SizeGB,1)}}, Created

$style = "<style>BODY{font-family: Arial; font-size: 10pt;}"
$style = $style + "TABLE{border: 1px solid black; border-collapse: collapse;}"
$style = $style + "TH{border: 1px solid black; background: #dddddd; padding: 5px; }"
$style = $style + "TD{border: 1px solid black; padding: 5px; }"
$style = $style + "</style>"
$body = $style + ( $results | ConvertTo-HTML )

Send-MailMessage -From poweraction@example.com -SmtpServer mail.example.com -Subject 'Datacenter_Get-VM_WithSnapshot Script Complete' -BodyAsHtml $body -To $emailTo
$results
