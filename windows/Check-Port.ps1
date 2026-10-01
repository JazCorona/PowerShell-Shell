<#
.SYNOPSIS
    Revisa si un puerto TCP está abierto o cerrado.

.DESCRIPTION
    Equivalente en PowerShell de linux/check_port.sh.
    Intenta una conexión TCP contra TargetHost:Puerto con un timeout.

.PARAMETER Port
    Puerto a revisar (1-65535). Obligatorio.

.PARAMETER TargetHost
    Host o IP a revisar. Por defecto 127.0.0.1

.PARAMETER TimeoutMs
    Tiempo de espera en milisegundos. Por defecto 2000.

.EXAMPLE
    .\Check-Port.ps1 -Port 80
    .\Check-Port.ps1 -Port 80 -TargetHost "127.0.0.1"
    .\Check-Port.ps1 -Port 443 -TargetHost "google.com"
#>
param(
    [Parameter(Mandatory = $true, HelpMessage = "Puerto a revisar (1-65535)")]
    [ValidateRange(1, 65535)]
    [int]$Port,

    [string]$TargetHost = "127.0.0.1",

    [int]$TimeoutMs = 2000
)

$tcpClient = New-Object System.Net.Sockets.TcpClient

try {
    $connectTask = $tcpClient.BeginConnect($TargetHost, $Port, $null, $null)
    $connected = $connectTask.AsyncWaitHandle.WaitOne($TimeoutMs)

    if ($connected -and $tcpClient.Connected) {
        $tcpClient.EndConnect($connectTask)
        Write-Host "Puerto $Port en $TargetHost está ABIERTO" -ForegroundColor Green
        exit 0
    }
    else {
        Write-Host "Puerto $Port en $TargetHost está CERRADO" -ForegroundColor Red
        exit 1
    }
}
catch {
    Write-Host "Puerto $Port en $TargetHost está CERRADO" -ForegroundColor Red
    exit 1
}
finally {
    $tcpClient.Close()
}
