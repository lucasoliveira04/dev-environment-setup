$awsPath = "C:\Program Files\Amazon\AWSCLIV2\aws.exe"

$bucketName = "ambient-pc-bucket"
$s3FileName = "vscode-info.txt"

$localBackup = "$env:USERPROFILE\Desktop\$s3FileName"

$settingsPath = "$env:APPDATA\Code\User\settings.json"

try {
    Write-Host "Baixando backup do S3..."
    & "$awsPath" s3 cp "s3://$bucketName/$s3FileName" "$localBackup"
    Write-Host "Backup baixado: $localBackup" -ForegroundColor Green
} catch {
    Write-Host "Erro ao baixar backup: $_" -ForegroundColor Red
    exit
}

$lines = Get-Content $localBackup

$startExt = $lines.IndexOf("=== EXTENSÕES INSTALADAS ===") + 1
$endExt = $lines.IndexOf("=== CONFIGURAÇÕES DO VS CODE (settings.json) ===") - 1
$extensions = $lines[$startExt..$endExt] | Where-Object { $_ -ne "" }

$startSettings = $lines.IndexOf("=== CONFIGURAÇÕES DO VS CODE (settings.json) ===") + 1
$settingsContent = $lines[$startSettings..($lines.Count-1)]

foreach ($ext in $extensions) {
    Write-Host "Instalando extensão: $ext..."
    code --install-extension $ext --force
}

try {
    $settingsContent | Set-Content $settingsPath -Force
    Write-Host "Configurações aplicadas em: $settingsPath" -ForegroundColor Green
} catch {
    Write-Host "Erro ao aplicar configurações: $_" -ForegroundColor Red
}

Write-Host "Restauração do VS Code concluída!" -ForegroundColor Cyan
