$awsPath = "C:\Program Files\Amazon\AWSCLIV2\aws.exe"
$bucketName = "ambient-pc-bucket"

$settingsPath = "$env:APPDATA\Code\User\settings.json"

Write-Host "Listando backups disponíveis no S3..."

$filesJson = & "$awsPath" s3api list-objects-v2 `
    --bucket $bucketName `
    --prefix "backups/" `
    --query 'Contents[].{Key: Key, LastModified: LastModified}' `
    --output json | ConvertFrom-Json

if ($filesJson.Count -eq 0) {
    Write-Host "Nenhum arquivo encontrado no bucket!" -ForegroundColor Red
    exit
}

$latestFile = $filesJson | Sort-Object {[datetime]$_.LastModified} -Descending | Select-Object -First 1
$latestKey = $latestFile.Key

$localBackup = "$env:USERPROFILE\Desktop\$([System.IO.Path]::GetFileName($latestKey))"

Write-Host "Baixando backup mais recente: $latestKey"

try {
    & "$awsPath" s3 cp "s3://$bucketName/$latestKey" "$localBackup"
    Write-Host "Backup baixado em: $localBackup" -ForegroundColor Green
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
