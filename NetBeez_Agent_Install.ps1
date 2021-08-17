[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$Logfile = "c:\\nb.log"
Add-content $Logfile -value "Start script..."

$secret = "67822654c54f6a45d1b439041dda90b4de3dde36"

Add-content $Logfile -value "Get json from github..."
$json_url = Invoke-WebRequest 'https://api.github.com/repos/netbeez/windows/releases/latest' -UseBasicParsing | ConvertFrom-Json
Write-Output $json_url.assets[0].browser_download_url
$url = $json_url.assets[0].browser_download_url


$output = "$env:TMP\NetBeez_Agent_Installer.msi"
$start_time = Get-Date

Add-content $Logfile -value  "Download from $url to $output"

Invoke-WebRequest -Uri $url -OutFile $output
Write-Output "Time taken: $((Get-Date).Subtract($start_time).Seconds) second(s)"



$args = "/qn INSTALLGROUP=""1"" SECRETKEY=""$secret"" AUTOSETUP=""1"""
Write-Output $args
Add-content $Logfile -value "ArgumentList: $args"

Add-content $Logfile -value  "Install new NetBeez Agent..."
Start-Process "$output" -ArgumentList $args -Wait
Add-content $Logfile -value  "Complete"
