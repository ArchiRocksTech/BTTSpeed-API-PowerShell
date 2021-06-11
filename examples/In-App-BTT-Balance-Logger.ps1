# In-App BTT Balance Logger, using BTTspeed-API-PowerShell
# Source https://github.com/ArchiRocksTech/BTTSpeed-API-PowerShell

# BTT API PowerShell file path
$BTTapi = "D:\BTT\BTTBoostAPI-PowerShell.ps1"

# Balance Log file
$balanceLog = "D:\BTT\BTTbalance.log"

# Check In-App BTT Balance every X minutes
$min = 5

#======== CHANGE NOTHING BELOW ===============================
If (!(Test-Path -Path $BTTapi -ErrorAction SilentlyContinue)) {
    Write-Host "Unable to locate BTTBoostAPI-PowerShell.ps1. Verify `$BTTapi Path" -ForegroundColor Red
    Pause
    Break
}
$sleepTime = 60 * $min
$stopIt = $false
$lastBalance = 0
Do {    
    $balance = [math]::Round( (& $BTTapi Get-Updates | ConvertFrom-Json).balance / 1000000 ,2)
    If ($balance){
        If ($balance -ne $lastBalance){
            Add-Content -Path $balanceLog -Value "$(Get-Date), $balance"
            Write-Host "[$(Get-Date)][Balance Change][Balance = $balance]" -ForegroundColor Green
            $lastBalance = $balance
        }
    }

    Write-Host "Sleeping for $min minutes" -ForegroundColor Cyan
    Start-Sleep -Seconds $sleepTime

} Until ($stopIt -eq $true)


<# BTTbalance.log Content Example

06/11/2021 11:12:34, 12385.21
06/11/2021 11:17:35, 12390.13

#>