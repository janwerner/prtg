Param(
 [string]$API_URL,
 [string]$ROUTING_KEY,
 [string]$SensorId,
 [string]$MessageType,
 [string]$SiteName,
 [string]$Device,
 [string]$DeviceId,
 [string]$Name,
 [string]$Status,
 [string]$Down,
 [string]$DateTime,
 [string]$LinkDevice,
 [string]$Message
)

function setEventAction ([string] $inputString)
{
 If ($inputString -like "Fehler beendet*")
 {
 return 'resolve'
 }
 elseif ($inputString -like "Warnung beendet*")
 {
 return 'resolve'
 }
 elseif ($inputString -like "OK*")
 {
 return 'resolve'
 }  
 elseif ($inputString -like "Schwellenwert nicht*")
 {
 return 'resolve'
 }  
 elseif ($inputString -like "Fehler*")
 {
 return 'trigger'
 } 
 elseif ($inputString -like "Warnung*")
 {
 return 'trigger'
 }
 elseif ($inputString -like "Schwellenwert erreicht*")
 {
 return 'trigger'
 }
 else
 {
 return 'trigger'
 }
}

function setMessageSeverity ([string] $inputString)
{
 If ($inputString -like "Fehler*")
 {
 return 'critical'
 }
 elseif ($inputString -like "Warnung*")
 {
 return 'warning'
 }
 elseif ($inputString -like "OK*")
 {
 return 'critical'
 }  
 elseif ($inputString -like "Schwellenwert*")
 {
 return 'critical'
 }
 else
 {
 return 'info'
 }
}

$pagerDutyPayload = @{
summary = "$($Device) $($Status) $($Down) on $($DateTime)";
source = $Device;
severity = setMessageSeverity($Status);
custom_details = @{
timestamp = $DateTime;
entity_id = $DeviceId;
entity_display_name = $Device;
monitoring_tool = "PRTG”;
site_name = $SiteName;
status = "$($Status) $($Down) on $($DateTime)";
state_message = $Message;
    }
}

$postPagerDuty = ConvertTo-Json(@{
routing_key = $ROUTING_KEY;
event_action = setEventAction($Status);
dedup_key = $SensorId;
payload = $pagerDutyPayload;
images = @(@{src = 'https://hlassets.paessler.com/common/files/graphics/prtg/prtg-kv_1.png'; href = "$($LinkDevice)"; alt = 'PRTG'});
links = @(@{href = "$($LinkDevice)"; text = "$($LinkDevice)"});
})
$API_URL = "https://events.pagerduty.com/v2/enqueue"

# Enable TLS 1.2
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

Invoke-WebRequest -Uri $API_URL -Method POST -Body $postPagerDuty -ContentType "application/json"
