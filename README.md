# BTT Speed API
Unofficial PowerShell API Wrapper for the BTT (BitTorrent Token) Speed WebUI for uTorrent and BitTorrent Clients.
Ported from the [Python source](https://github.com/BTTBoost/BTTSpeed-API), and futher extended.

# Download

Download the latest .ps1 files.
* [BTTspeedAPI-PowerShell.ps1](https://raw.githubusercontent.com/ArchiRocksTech/BTTSpeed-API-PowerShell/main/BTTspeedAPI-PowerShell.ps1)
* [BTTAutoWithdraw.ps1](https://raw.githubusercontent.com/ArchiRocksTech/BTTSpeed-API-PowerShell/main/examples/BTTAutoWithdraw.ps1) (requires BTTspeedAPI-PowerShell.ps1)

# Usage example

**Windows**

Move the downloaded .ps1 file to a desired folder, and SHIFT + Right-Click in the folder, and click **Open a PowerShell window here**.
Note: If you have the **Open Command window here** option, select that, then type **PowerShell** and press Enter to start the PowerShell console. Then proceed with using the commands.

PowerShell Console

```
.\BTTspeedAPI-PowerShell.ps1 Get-WalletTransactions
```

Output (object):
```
id      : 1699243394212
amount  : 10005000000
created : 1621312093
type    : Withdrawal
status  : Complete
message : SUCCESS
```

See [Examples](https://github.com/ArchiRocksTech/BTTSpeed-API-PowerShell/tree/main/examples) for more use case demonstrations.

# Available API Endpoints

```
-=[ Earnings API ]=-
Get-Updates               [Get updated status]
Get-HourlyUpdate          [Hourly earnings update (not accurate)]
Get-TotalUpdate           [Get total earnings (not accurate)]

-=[ Wallet API ]=-
Get-PublicAddress         [Get your wallet address]
Get-PublicKey             [Get your wallet public key]
Get-WalletTransactions    [Get detailed info on your wallet transactions]
Refresh-Balance           [Refresh your wallet balance. May be useful for BTT stuck in transfer 'limbo']
Get-SpendStatus           [Get your BTT Spending status for Speed]
Disable-Spend             [Disable your BTT Spending for Speed]
Enable-Spend              [Enable your BTT Spending for Speed]

-=[ BTT Token Exchange API ]=-
Check-BTTExchange         [Check if BTT Exchange has enough tokens for withdraw]
Withdraw-BTT              [Attempt to auto-withdraw from in-app BTT to on-chain BTT via the BTT Exchange]

-=[ Misc ]=-
Get-Env                   [Get your current environment]
```

# Excluded API Endpoints
There are some endpoints purposefully left out for numerous reasons: 
1) The API endpoint is not publicly live (like the Binance Exchange Wallet Integration endpoints)
2) It's dangerous for those who don't know what they're doing (privatekey, seed phrase, etc)

Complete list of endpoints actually published by BitTorrent team can be seen in ``misc/extracted.txt``

# Donations
*Never expected, always welcome and appreciated.*
* BTC `bc1q6g7rg5xryumgygmysq5zwe0svc0jmzpazz75p8`
* ETH / ERC20 `0x2406ba931307e56f4DB506099Eb09224223CF4E8`
* TRX / BTT / USDT-TRC10 `TNRtWbQQ9aCTtQYLEePFGSBwEBvhHsa1Ye`
* DOT `14T62EomidLtwXDZsKSJ4usfm8q4UJoq1y926XG3zzbJGCMB`
* XTZ `tz1WwTjCvjxc1yeze2xMBWdyApwfHacBhh5v`
* ADA `addr1q8c9gur0mam0h69h7pttgd2vfdugl6vack42l38r7hfj2r0s23cxlhmkl05t0uzkks65cjmc3l5em3d24lzw8awny5xst84y5r`
* BNB `bnb1tw8pd7tx8m8tfcjcqkl5fp98xzvxh9u2j29kh0`
* XLM `GBOX5QQ72BPSA5ZYPN5Q5WLBRY3TTQXFU4SBLGKMAR7BS7UAR45GLXVQ`
* ONT `AG78qWzQcdwdGH7hPzxTFH7mLf8qtwz6UV`
* ATOM `cosmos1ppd4hkaznks8qhwj0v4yacmznh995s9wp2cfa2`
* DAI `0x2406ba931307e56f4DB506099Eb09224223CF4E8`
* ALGO `GLNUFUVHS4VOCLPG73S63XN3YKIC2K3XVSNA64N75YATXKITWPWBESNTK4`
* XRP `rDWb7F719h4E78GaiKpQodhk2GPJaic8Pt`
* DOGE `DRVQaveJRTeuka2sdzxRFGnw6FYzt6waTB`
* LTC `LSnLZS6L8xSJxCTpiUicVmDmfT8cV3dpsj`
* SuperDoge `SMMJQJRDymSqcZZkPihpsDrEc3dZaMvmY4`

# TO-DO

* Continue enhancements of the exposed API and utility scripts.
* Port additional endpoints as they're exposed in the [Python version](https://github.com/BTTBoost/BTTSpeed-API).

# Shout-out

* BTT Boost – [Homepage](https://bttboost.com) – bttboost@pm.me
* BTT Speed Subreddit - [Link](https://reddit.com/r/BTT_Speed)

# Troubleshooting

**ERROR**: [`ScriptName`] cannot be loaded because running scripts is disabled on this system.

**SOLUTION**: Enable running PowerShell scripts by adjusting the Execution Policy on your system.

Use the execution policy that allows the script to work.

The Set-ExecutionPolicy cmdlet enables you to determine which Windows PowerShell scripts (if any) will be allowed to run on your computer. 

Windows PowerShell has four different execution policies:

* Restricted - No scripts can be run. Windows PowerShell can be used only in interactive mode.
* AllSigned - Only scripts signed by a trusted publisher can be run.
* RemoteSigned - Downloaded scripts must be signed by a trusted publisher before they can be run.
* Unrestricted - No restrictions; all Windows PowerShell scripts can be run.

To assign a particular policy simply call Set-ExecutionPolicy followed by the appropriate policy name. For example, this command run in a PowerShell console sets the execution policy to RemoteSigned:

`Set-ExecutionPolicy RemoteSigned`

To run this in a Command Prompt console, use the following command:

`PowerShell Set-ExecutionPolicy RemoteSigned`

Source: [Microsoft Docs](https://docs.microsoft.com/en-us/previous-versions/windows/it-pro/windows-powershell-1.0/ee176961(v=technet.10)?redirectedfrom=MSDN)

# More BTT Utilities to maximize your income!!!
Check them out [here on GitHub](https://github.com/ArchiRocksTech/BTTspeedUtilities).

**[Join us](https://t.me/bttexchangewalletbalance)**

***

Distributed under the WTFPL license. See ``LICENSE`` for more information.
