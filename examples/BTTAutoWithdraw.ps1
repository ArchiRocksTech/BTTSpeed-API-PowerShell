# Auto-Withdraw and Balance Logger Script
# Source https://github.com/ArchiRocksTech/BTTSpeed-API-PowerShell
# Ported / Adapted from https://github.com/badenbaden/BTTdevAMOUNT/blob/main/withdraw.js
# Ported and Expanded by Archimedez
# @ frt.rocks
# License: WTFPL
# =======================================================

# CONFIGURATION

# BTT API PowerShell file path (Default: "$env:USERPROFILE\Downloads\BTTspeedAPI-PowerShell.ps1")
$BTTapi = "$env:USERPROFILE\Downloads\BTTspeedAPI-PowerShell.ps1"

# Withdraw Log file (Default: "$env:USERPROFILE\Documents\BTTautoWithdraw.log")
$withdrawLog = "$env:USERPROFILE\Documents\BTTautoWithdraw.log"

# Balance Log file (Default: "$env:USERPROFILE\Documents\BTTbalance.log")
$balanceLog = "$env:USERPROFILE\Documents\BTTbalance.log"

# Actually withdraw or just log / monitor? ($true or $false. Default: $false)
$doWithdraw = $false

# Check In-App BTT Balance every X seconds. (Number. Default: 30)
$min = 30

# Withdraw if in-app balance is above X in BTT. 1000 is minimum allowed by exchange. (Number. Default 1000)
$withdrawAbove = 1000

# Amount to withdraw (0 is all) in BTT. (Number. Default 0)
$withdrawAmount = 0

# Attempt withdraw of remaining exchange balance if full withdraw not possible? ($true or $false. Default $true)
$withdrawMinimum = $true

# Disable spending BTT for Speed? ($true or $false. Default $true)
$disableSpending = $true

#======== CHANGE NOTHING BELOW ===============================
$host.UI.RawUI.WindowTitle = "BTTSpeed-Auto-Withdraw-And-Balance-Logger"
# Die if we don't have the BTTSpeedAPI-PowerShell
If (!(Test-Path -Path $BTTapi -ErrorAction SilentlyContinue)) {
    Write-Host "Unable to locate BTTspeedAPI-PowerShell.ps1. Verify `$BTTapi Path" -ForegroundColor Red
    pause; Break
}
# Warn if we don't have the uTorrent Helper process running
If (!(Get-Process helper | Where-Object {$_.Description -like "*Torrent Helper"})){
    Write-Host "BTTSpeed Helper Process was not detected. Make sure you click 'Speed' inside your torrent client before running this script." -ForegroundColor Yellow    
    pause; Break
}

$stopIt = $false
$lastBalance = 0

Do {    
    $sleepTime = ($min * 1000) + (Get-Random -Minimum 1 -Maximum 500)
    & $BTTapi Refresh-Balance | Out-Null
    $myInfo = & $BTTapi Get-Updates
    [decimal]$myBalance = $myInfo.balance / 1000000
    $bttPeers = $myInfo.peers
    If ($lastBalance -ne $myBalance) {
        Add-Content -Path $balanceLog -Value "$(Get-Date), $myBalance"
        $lastBalance = $myBalance
    }
    $exBalance = & $BTTapi Check-BTTExchange
    Write-Host "[$(Get-Date)][BTT Peers: $bttPeers] [BTT Balance: $([math]::Round($myBalance,4))] [Exchange Balance: $([math]::Round($exBalance,2))]" -ForegroundColor Cyan
    If ($myBalance -ge $withdrawAbove -and $doWithdraw -eq $true){
        # My balance is X or more, so I want to exchange        
        $amount = If ($withdrawAmount -eq 0){$myBalance}Else{$withdrawAmount}
        If ($exBalance -ge $amount) {
            # Exchange balance is X or more, so exchange might work
            Write-Host "Exchange has sufficent funds [$exBalance], attempting withdraw" -ForegroundColor Green
            Add-Content -Path $withdrawLog -Value "$(Get-Date) Exchange Balance [$exBalance]"            
            $txResponse = & $BTTapi Withdraw-BTT -withdraw $amount
            If ($txResponse -like "ERROR:*") {
                Write-Host "[$txResponse]" -ForegroundColor Red
            } Else {               
                Write-Host "[Status]  $($txResponse.status)`r`n[Message] $($txResponse.message)" -ForegroundColor Yellow            
                Add-Content -Path $withdrawLog -Value "$(Get-Date)`r`n$txResponse"
            }
        } ElseIf ($exBalance -ge 1000 -and $withdrawMinimum -eq $true) {
            # Exchange balance is X or more, so exchange might work
            Write-Host "Exchange has sufficent minimum funds [$exBalance], attempting withdraw" -ForegroundColor Green
            Add-Content -Path $withdrawLog -Value "$(Get-Date) Exchange Balance [$exBalance]"
            $txResponse = & $BTTapi Withdraw-BTT -withdraw $exBalance
            If ($txResponse -like "ERROR:*") {
                Write-Host "[$txResponse]" -ForegroundColor Red
            } Else {                
                Write-Host "[Status]  $($txResponse.status)`r`n[Message] $($txResponse.message)" -ForegroundColor Yellow            
                Add-Content -Path $withdrawLog -Value "$(Get-Date)`r`n$txResponse"
            }
        } Else {
            Write-Host "Exchange has insufficent funds [$exBalance]" -ForegroundColor Red
        }

    }

    # Report on Speed Spending, disable Speed spending if configured to do so in settings
    $spendingStatus = & $BTTapi Get-SpendStatus
    If ($spendingStatus -like "ERROR:*") {
        Write-Host "[$spendingStatus]" -ForegroundColor Red
    } Else {               
        If ($spendingStatus -eq $true) {
            Write-Host "BTT Spending is Enabled" -ForegroundColor Yellow
            If ($disableSpending -eq $true) {
                & $BTTapi Disable-Spend | Out-Null
                Start-Sleep -Seconds 1
                If ( (& $BTTapi Get-SpendStatus) -eq $false) {
                    Write-Host "BTT Spending is now Disabled" -ForegroundColor Green
                }
            }
        } ElseIf ($spendingStatus -eq $false) {
            Write-Host "BTT Spending is Disabled" -ForegroundColor Cyan
        }
    }

    Write-Host "Sleeping for $($sleepTime / 1000) seconds" -ForegroundColor Cyan
    $host.UI.RawUI.WindowTitle = "BTTSpeed-Auto-Withdraw-And-Balance-Logger"
    Start-Sleep -Milliseconds $sleepTime

} Until ($stopIt -eq $true)