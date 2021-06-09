# BTT Speed API
Unofficial PowerShell API Wrapper for the BTT (BitTorrent Token) Speed WebUI for uTorrent and BitTorrent Clients.
Ported from the [Python source](https://github.com/BTTBoost/BTTSpeed-API). As this is a port, I will update it as the Python source is updated.

## Available API Endpoints

```
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
```

## Download

Download the latest .ps1 file in [Releases](https://github.com/ArchiRocksTech/BTTSpeed-API-PowerShell/releases).

## Usage example

Move the downloaded .ps1 file to a desired folder, and SHIFT + Right-Click in the folder, and click Open a PowerShell window.
Note: If you have the Open Command window option, open that, then type PowerShell and press Enter to start the PowerShell console.

PowerShell Console

```
.\BTTboostAPI-PowerShell-v0-1.ps1 Get-WalletTransactions
```

Output:
```
[{'amount': 1195000000,
  'created': 1622713771,
  'id': 1622578556996,
  'message': 'calling interface [BroadcastTransaction] fail, reasons: '
             '[ResultCode[CONTRACT_VALIDATE_ERROR], Message[contract validate '
             'error : assetBalance is not sufficient.]]',
  'status': 'Complete',
  'type': 'Withdrawal'},
 {'amount': 2350000000,
  'created': 1622483796,
  'id': 1622483746585,
  'message': 'SUCCESS',
  'status': 'Complete',
  'type': 'Withdrawal'}]
```

## Excluded API Endpoints
There are some endpoints purposefully left out for numerous reasons: 
1) The API endpoint is not publicly live (like the Binance Exchange Wallet Integration endpoints)
2) It's dangerous for those who don't know what they're doing (privatekey, seed phrase, etc)

Complete list of endpoints actually published by BitTorrent team can be seen in ``misc/extracted.txt``


## TO-DO

* Port additional endpoints as they're exposed in the [Python version](https://github.com/BTTBoost/BTTSpeed-API).

## Meta

* BTT Boost – [Homepage](https://bttboost.com) – bttboost@pm.me
* BTT Speed Subreddit - [Link](https://reddit.com/r/BTT_Speed)

Distributed under the WTFPL license. See ``LICENSE`` for more information.

## Contributing

If you'd like to assist with the Python Version:
1. Fork it (<https://github.com/BTTBoost/BTTSpeed-API/fork>)
2. Create your feature branch (`git checkout -b feature/fooBar`)
3. Commit your changes (`git commit -am 'Add some fooBar'`)
4. Push to the branch (`git push origin feature/fooBar`)
5. Create a new Pull Request
