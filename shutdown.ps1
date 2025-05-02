# Set window width and height
$windowSize = New-Object Management.Automation.Host.Size
$windowSize.Width = 50
$windowSize.Height = 10
$Host.UI.RawUI.WindowSize = $windowSize

$bufferSize = $Host.UI.RawUI.BufferSize
$bufferSize.Width = 60
$bufferSize.Height = 20
$Host.UI.RawUI.BufferSize = $bufferSize

# Timer logic
$time = Read-Host 'How long till shutdown (in minutes)'
$seconds = [int]$time * 60
$millisecondsPerStep = ($seconds * 1000) / 100

for ($i = 0; $i -le 100; $i++) {
    $elapsedSeconds = [math]::Round(($seconds * $i) / 100)
    Write-Progress -Activity "Shutdown Timer" -Status "$elapsedSeconds seconds elapsed" -PercentComplete $i
    Start-Sleep -Milliseconds $millisecondsPerStep
}

shutdown /s