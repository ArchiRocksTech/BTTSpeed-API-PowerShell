# BTTspeedAPI-PowerShell
# Source https://github.com/ArchiRocksTech/BTTSpeed-API-PowerShell
# Ported by Archimedez
# @ frt.rocks
# Original Python Source: https://github.com/BTTBoost/BTTSpeed-API
# License: WTFPL
# =======================================================

param (
    [ValidateSet('Get-SpendStatus','Disable-Spend','Enable-Spend','Get-Updates','Get-HourlyUpdate','Get-TotalUpdate','Get-PublicAddress','Get-PublicKey','Get-WalletTransactions','Refresh-Balance','Check-BTTExchange','Withdraw-BTT','Get-Env')]
    [string]$command = "Show-Commands",
    [decimal]$withdraw = 0
)

$host.UI.RawUI.WindowTitle = "BTTspeedAPI-PowerShell"

Function Show-Commands {
    $commands = @"

BTTspeed API - PowerShell Wrapper

These must be run in a PowerShell Window (In a folder, Shift + Right-Click, open PowerShell Window here)

Example Usage:  .\BTTspeedAPI-PowerShell.ps1 Check-BTTExchange

Example Usage:  .\BTTspeedAPI-PowerShell.ps1 -command Withdraw-BTT -withdraw 1000

-=[ Earnings API ]=-
Get-Updates               [Get updated status]
Get-HourlyUpdate          [Hourly earnings update (not accurate)]
Get-TotalUpdate           [Get total earnings (not accurate)]

-=[ Wallet API ]=-
Get-PublicAddress         [Get your wallet address]
Get-PublicKey             [Get your wallet public key]
Get-WalletTransactions    [Get detailed info on your wallet transactions]
Refresh-Balance           [Refresh your wallet balance. May be useful if your BTT is stuck in transfer 'limbo']
Get-SpendStatus           [Get your BTT Spending status for Speed]
Disable-Spend             [Disable your BTT Spending for Speed]
Enable-Spend              [Enable your BTT Spending for Speed]

-=[ BTT Token Exchange API ]=-
Check-BTTExchange         [Check if BTT Exchange has enough tokens for withdraw]
Withdraw-BTT              [Attempt to auto-withdraw in-app BTT from BTT Exchange]

-=[ Misc ]=-
Get-Env                   [Get your current environment]


Note: This script may also be called by other scripts to utilize the functions and perform actions
based on the returned data. See the example scripts for more information.

"@

    Return $commands

}

#region BTTAPIdefaults
$base = 'http://127.0.0.1'
#$exchangeWalletBTT = 'TA1EHWb1PymZ1qpBNfNj9uTaxd18ubrC7a' 

Function Get-Port {
    $portFile = "$env:LOCALAPPDATA\BitTorrentHelper\port"
    $port = Get-Content $portFile -TotalCount 1
    Return $port
}

Function Get-Token {
    $port = Get-Port
    $url = "$base`:$port/api/token"
    Try {
        $token = Invoke-RestMethod -Uri $url -Headers $headers -Method Get -ErrorVariable webError -UseBasicParsing
        Return $token
    } Catch {
        Return "ERROR: $($webError.message)"
    }
}

# BTT API Defaults
$port = Get-Port
$token = Get-Token

$headers = @{
    "Accept" = "*/*"        
    "Accept-Language" = "en-US,en;q=0.9"    
    "Content-Length" = 0
    "Content-Type" = "text/plain"
    "Host" = "127.0.0.1:$port"
    "Origin" = "https://speed.btt.network"
    "Referer" ="https://speed.btt.network/"
    "sec-ch-ua" = '" Not;A Brand";v="99", "Google Chrome";v="91", "Chromium";v="91"'
    "sec-ch-ua-mobile" = "?0"
    "Sec-Fetch-Dest" = "empty"
    "Sec-Fetch-Mode" = "cors"
    "Sec-Fetch-Site" = "cross-site"
    "User-Agent" = "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/91.0.4472.101 Safari/537.36"
}

Function Get-Env($base, $token, $port){
    $url = "$base`:$port/api/env?t=$token"
    Try {
        $data = Invoke-RestMethod -Uri $url -Headers $headers -Method Get -ErrorVariable webError -UseBasicParsing
        Return $data
    } Catch {
        Return "ERROR: $($webError.message)"
    }
}
#endregion BTTAPIdefaults

# AIRDROP API - Incomplete
#region AirdropAPI
Function Check-Airdrops($base, $token, $port){
    $url = "$base`:$port/api/airdrops?t=$token"
    Try {
        $data = Invoke-RestMethod -Uri $url -Headers $headers -ErrorVariable webError -UseBasicParsing
        Return $data
    } Catch {
        Return "ERROR: $($webError.message)"
    }
}
#endregion AirdropAPI

# BINANCE API - Incomplete
#region BinanceAPI

Function Get-BinanceInfo($base, $token, $port){
    $url = "$base`:$port/api/binance/binance_info?t=$token"
    Try {
        $data = Invoke-RestMethod -Uri $url -Headers $headers -Method Get -ErrorVariable webError -UseBasicParsing
        Return $data
    } Catch {
        Return "ERROR: $($webError.message)"
    }
}

Function Get-BinanceQuote($base, $token, $port){
    $url = "$base`:$port/api/binance/quote_info?t=$token"
    Try {
        $data = Invoke-RestMethod -Uri $url -Headers $headers -Method Get -ErrorVariable webError -UseBasicParsing
        Return $data
    } Catch {
        Return "ERROR: $($webError.message)"
    }
}

Function Create-BinanceTransaction($base, $token, $port){
    $url = "$base`:$port/api/binance/create_transaction?t=$token&order_id=$orderID&quote_id=$quoteID"
    Try {
        $data = Invoke-RestMethod -Uri $url -Headers $headers -Method Post -ErrorVariable webError -UseBasicParsing
        Return $data
    } Catch {
        Return "ERROR: $($webError.message)"
    }
}

Function Get-RecentBinanceTX($base, $token, $port){
    $url = "$base`:$port/api/binance/recent_transactions?t=$token"
    Try {
        $data = Invoke-RestMethod -Uri $url -Headers $headers -Method Get -ErrorVariable webError -UseBasicParsing
        Return $data
    } Catch {
        Return "ERROR: $($webError.message)"
    }
}

#endregion BinanceAPI

# EARNINGS API
#region EarningsAPI
Function Get-Updates($base, $token, $port){
    $url = "$base`:$port/api/status?t=$token"
    Try {
        $data = Invoke-RestMethod -Uri $url -Headers $headers -Method Get -ErrorVariable webError -UseBasicParsing
        Return $data
    } Catch {
        Return "ERROR: $($webError.message)"
    }
}

Function Get-TronGridUpdates($base, $token, $port){
    $url = "$base`:$port/api/trongrid/status?t=$token"
    Try {
        $data = Invoke-RestMethod -Uri $url -Headers $headers -Method Get -ErrorVariable webError -UseBasicParsing
        Return $data
    } Catch {
        Return "ERROR: $($webError.message)"
    }
}

Function Get-HourlyUpdate($base, $token, $port){
    $url = "$base`:$port/api/revenue/hourly?t=$token&revenue_type=earning"
    Try {
        $data = Invoke-RestMethod -Uri $url -Headers $headers -Method Get -ErrorVariable webError -UseBasicParsing
        Return $data
    } Catch {
        Return "ERROR: $($webError.message)"
    }
}

Function Get-TotalUpdate($base, $token, $port){
    $url = "$base`:$port/api/revenue/total?t=$token"
    Try {
        $data = Invoke-RestMethod -Uri $url -Headers $headers -Method Get -ErrorVariable webError -UseBasicParsing
        Return $data
    } Catch {
        Return "ERROR: $($webError.message)"
    }
}

# Incomplete
Function Get-HourByHourUpdate($base, $token, $port){
    $url = "$base`:$port/api/revenue/hour_by_hour?t=$token&revenue_type=earning&start_date=$startDate&end_date=$endDate"
    Try {
        $data = Invoke-RestMethod -Uri $url -Headers $headers -Method Get -ErrorVariable webError -UseBasicParsing
        Return $data
    } Catch {
        Return "ERROR: $($webError.message)"
    }
}

# Incomplete
Function Get-DailyUpdate($base, $token, $port){
    $url = "$base`:$port/api/revenue/daily?t=$token&revenue_type=earning&start_date=$startDate&end_date=$endDate"
    Try {
        $data = Invoke-RestMethod -Uri $url -Headers $headers -Method Get -ErrorVariable webError -UseBasicParsing
        Return $data
    } Catch {
        Return "ERROR: $($webError.message)"
    }
}
#endregion EarningsAPI

#WALLET API
#region WalletAPI
Function Get-PublicAddress($base, $token, $port){
    $url = "$base`:$port/api/public_address?t=$token"
    Try {
        $data = Invoke-RestMethod -Uri $url -Headers $headers -Method Get -ErrorVariable webError -UseBasicParsing
        Return $data
    } Catch {
        Return "ERROR: $($webError.message)"
    }
}

Function Get-PublicKey($base, $token, $port){
    $url = "$base`:$port/api/public_key?t=$token"
    Try {
        $data = Invoke-RestMethod -Uri $url -Headers $headers -Method Get -ErrorVariable webError -UseBasicParsing
        Return $data
    } Catch {
        Return "ERROR: $($webError.message)"
    }
}

Function Get-WalletTransactions($base, $token, $port){
    $url = "$base`:$port/api/exchange/transactions?t=$token&count=5"
    Try {
        $data = Invoke-RestMethod -Uri $url -Headers $headers -Method Get -ErrorVariable webError -UseBasicParsing
        Return $data
    } Catch {
        Return "ERROR: $($webError.message)"
    }
}

Function Refresh-Balance($base, $token, $port){
    $url = "$base`:$port/api/refresh_balance?t=$token"
    $status = $null
    Try {
        $status = Invoke-WebRequest -Uri $url -Headers $headers -Method Get -ErrorVariable webError -UseBasicParsing
        If ($status.StatusCode -eq 200 -or $status.StatusCode -eq 202) {
            # Write-Host $($status.StatusCode)
            # 200 is OK
            # 202 is accepting and processing
            Return
        } ElseIf ($status.StatusCode) {
            Return "HTTP Error: $($status.StatusCode)"
        }
    } Catch {
        Return "ERROR: $($webError.message)"
    }    
}

Function Get-SpendStatus($base, $token, $port){
    $url = "$base`:$port/api/store/spend?t=$token"
    Try {
        $data = Invoke-RestMethod -Uri $url -Headers $headers -Method Get -ErrorVariable webError -UseBasicParsing
        Return $data # True, spending enabled. False, spending not enabled.
    } Catch {
        Return "ERROR: $($webError.message)"
    }
}

Function Disable-Spend($base, $token, $port){
    $url = "$base`:$port/api/store/spend?t=$token"
    Try {
        $data = Invoke-RestMethod -Uri $url -Headers $headers -Method Post -ErrorVariable webError -UseBasicParsing -Body 'false'
        Return $data
    } Catch {
        Return "ERROR: $($webError.message)"
    }
}

Function Enable-Spend($base, $token, $port){
    $url = "$base`:$port/api/store/spend?t=$token"
    Try {
        $data = Invoke-RestMethod -Uri $url -Headers $headers -Method Post -ErrorVariable webError -UseBasicParsing
        Return $data
    } Catch {
        Return "ERROR: $($webError.message)"
    }
}

#endregion WalletAPI

# BTT TOKEN EXCHANGE API
#region BTTtokenExchangeAPI
Function Check-BTTExchange {
    Try {
        $exchangeWallet = (Invoke-WebRequest -Uri "https://api.trongrid.io/v1/accounts/410061E74968E356A61E859EB96329812FE58F5BDC" -Method Get -ContentType 'charset=utf-8' -ErrorVariable webError -UseBasicParsing).content
        $wallet = $exchangeWallet | ConvertFrom-Json
        $bttBalance = $wallet.data[0].assetV2[1].value
        # Fallback method included
        #$exchangeWallet = "https://apilist.tronscan.org/api/account?address=$exchangeWalletBTT"
        #$data = Invoke-RestMethod -Uri $exchangeWallet | ConvertTo-Json | ConvertFrom-Json
        #$bttBalance = ($data.tokenBalances | Where-Object {$_.tokenAbbr -eq 'BTT'}).balance
        If ($bttBalance) {
            $walletBalance = $bttBalance / 1000000
            Return $walletBalance # Returns normalized balance
        }
    } Catch {
        Write-Host "ERROR: $($webError.message)" -ForegroundColor Red
        Return 0
    }
    
}

Function Withdraw-BTT ($base, $token, $port, $withdraw) {  # $withdraw = 1001
    [decimal]$realAmount = If ($withdraw -eq 1000){ $withdraw * 1000000 }ElseIf ($withdraw -gt 1000) { (($withdraw * 1000000) - 0.5) } # If not the exchange minimum, leave a tiny bit so rounding doesn't cause a failure
    $url = "$base`:$port/api/exchange/withdrawal?t=$token&amount=$realAmount"    
    Try {
        $data = Invoke-RestMethod -Uri $url -Method Post -Headers $headers -Body $null -ErrorVariable webError -ContentType "text/plain" -UseBasicParsing
        If ($data) {
            # We now send the withdraw URL as GET with the transaction ID            
            $url2 = "$base`:$port/api/exchange/withdrawal?t=$token&id=$data"
            $data2 = Invoke-RestMethod -Uri $url2 -Method Get -Headers $headers -Body $null -ErrorVariable webError -UseBasicParsing
            Return $data2 # Returns {"id":1623999999999,"amount":1000000000,"created":1699999999,"type":"Withdrawal","status":"Pending","message":""}
        }
    } Catch {
         If($webError) {
            Return "ERROR: $($webError.message)" # Web Request failed, return the error message
        }
    }
}

#endregion BTTtokenExchangeAPI

switch ($command)
{
    'Show-Commands' {Write-Host "$(Show-Commands)" -ForegroundColor Yellow;pause}
    'Withdraw-BTT' {& $command $base $token $port $withdraw}
    Default {& $command $base $token $port}
}
