# Looping BTTexchange balance check every minute and do something when above 1000 balance
$stopIt = $false
Do {

    $balance = Check-BTTExchange $base $token $port
    If ($balance -gt 1000) {
        Write-Host "[$(Get-Date)] OMG BTT Balance above 1K !! [$balance]" -ForegroundColor Green

        # Do other stuff

    }
    Write-Host "[$(Get-Date)] Sleeping... [$balance]" -ForegroundColor Cyan
    Start-Sleep -Seconds 60

} Until ($stopIt -eq $true)
