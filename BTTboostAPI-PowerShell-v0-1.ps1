# BTTboost API - PowerShell Port
# Ported by Archimedez
# @ frt.rocks
# Python Source: https://github.com/BTTBoost/BTTSpeed-API
# License: WTFPL
# Version: 0.1 - Modified - 2021-06-09 - Initial Build
# =======================================================

param (
    [string]$command = "Show-Commands"
)

Function Show-Commands {

    $commands = @"

BTTboost API - PowerShell Wrapper
Ported from Python

Example Usage:  .\BTTboostAPI-PowerShell-v0-1.ps1 Check-BTTExchange

-=[ Earnings API ]=-
Get-Updates               [Get current status]
Get-HourlyUpdate          [Hourly earnings update (not accurate)]
Get-TotalUpdate           [Get total earnings (not accurate)]

-=[ Wallet API ]=-
Get-PublicAddress         [Get your wallet address]
Get-PublicKey             [Get your wallet public key]
Get-WalletTransactions    [Get detailed info on your wallet transactions]
Refresh-Balance           [Refresh your wallet balance. May be useful if your BTT is stuck in transfer 'limbo']

-=[ BTT Token Exchange API ]=-
Check-BTTExchange         [Check if BTT Exchange has enough tokens for withdraw]

-=[ Misc ]=-
Get-Env                   [Get your current environment]

"@

    Return $commands

}

#region BTTAPIdefaults
$base = 'http://127.0.0.1'
$exchangeWalletBTT = 'TA1EHWb1PymZ1qpBNfNj9uTaxd18ubrC7a' 

Function Get-Port {
    $portFile = "$env:LOCALAPPDATA\BitTorrentHelper\port"
    $port = Get-Content $portFile -TotalCount 1
    Return $port
}

Function Get-Token {
    $port = Get-Port
    $url = "$base`:$port/api/token"
    $token = Invoke-RestMethod -Uri $url
    Return $token
}

# BTT API Defaults
$port = Get-Port
$token = Get-Token

Function Get-Env($base, $token, $port){
    $url = "$base`:$port/api/env?t=$token"
    $data = Invoke-RestMethod -Uri $url | ConvertTo-Json
    Return $data
}
#endregion BTTAPIdefaults

# EARNINGS API
#region EarningsAPI
Function Get-Updates($base, $token, $port){
    $url = "$base`:$port/api/status?t=$token"
    $data = Invoke-RestMethod -Uri $url | ConvertTo-Json
    Return $data
}

Function Get-HourlyUpdate($base, $token, $port){
    $url = "$base`:$port/api/revenue/hourly?t=$token&revenue_type=earning"
    $data = Invoke-RestMethod -Uri $url | ConvertTo-Json
    Return $data
}

Function Get-TotalUpdate($base, $token, $port){
    $url = "$base`:$port/api/revenue/total?t=$token"
    $data = Invoke-RestMethod -Uri $url | ConvertTo-Json
    Return $data
}
#endregion EarningsAPI

#WALLET API
#region WalletAPI
Function Get-PublicAddress($base, $token, $port){
    $url = "$base`:$port/api/public_address?t=$token"
    $data = Invoke-RestMethod -Uri $url -ContentType 'charset=utf-8'
    Return $data
}

Function Get-PublicKey($base, $token, $port){
    $url = "$base`:$port/api/public_key?t=$token"
    $data = Invoke-RestMethod -Uri $url -ContentType 'charset=utf-8'
    Return $data
}

Function Get-WalletTransactions($base, $token, $port){
    $url = "$base`:$port/api/exchange/transactions?t=$token&count=100"
    $data = Invoke-RestMethod -Uri $url | ConvertTo-Json
    Return $data
}

Function Refresh-Balance($base, $token, $port){
    $url = "$base`:$port/api/refresh_balance?t=$token"
    $status = $null
    $status = Invoke-WebRequest -Uri $url -ErrorVariable webReq
    If ($status.StatusCode -eq 200 -or $status.StatusCode -eq 202) {
        Write-Host $($status.StatusCode)
        # 200 is OK
        # 202 is accepting and processing
        Return
    } ElseIf ($status.StatusCode) {
        Write-Host "HTTP Error: $($status.StatusCode)"
        Return $false
    }
    If ($webReq) {
        Write-Host "Request Error: $($webReq.message)"
        Return $false
    }
    
}
#endregion WalletAPI

# BTT TOKEN EXCHANGE API
#region BTTtokenExchangeAPI
Function Check-BTTExchange {
    $exchangeWallet = "https://apilist.tronscan.org/api/account?address=$exchangeWalletBTT"
    $data = Invoke-RestMethod -Uri $exchangeWallet | ConvertTo-Json | ConvertFrom-Json
    $bttBalance = ($data.tokenBalances | Where-Object {$_.tokenAbbr -eq 'BTT'}).balance
    If ($bttBalance) {
        $walletBalance = $bttBalance / 1000000
        Return $walletBalance
    } Else {
        Write-Host "Error: Btt index incorrect"
        Return $false
    }
}
#endregion BTTtokenExchangeAPI

If ($command -eq 'Show-Commands') {
    Write-Host "$(Show-Commands)" -ForegroundColor Yellow
} Else {    
    & $command $base $token $port
}


