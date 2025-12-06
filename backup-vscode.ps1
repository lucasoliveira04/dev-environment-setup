$codePaths = @(
    "$env:APPDATA\Code\User\settings.json",                 
    "$env:APPDATA\Code - Insiders\User\settings.json"      
)

$bucketName = "ambient-pc-bucket"

$awsPath = "C:\Program Files\Amazon\AWSCLIV2\aws.exe"

$dateStr = Get-Date -Format "yyyy-MM-dd_HH-mm-ss"

$outFile = "$env:USERPROFILE\Desktop\vscode-info-$dateStr.txt"

"=== EXTENSÕES INSTALADAS ===" | Out-File $outFile

try {
    code --list-extensions 2>$null | Out-File $outFile -Append
} catch {
    "Erro ao listar extensões do VS Code." | Out-File $outFile -Append
}

"`n=== CONFIGURAÇÕES DO VS CODE (settings.json) ===" | Out-File $outFile -Append

$foundConfig = $false
foreach ($path in $codePaths) {
    if (Test-Path $path) {
        "`nArquivo encontrado: $path" | Out-File $outFile -Append
        Get-Content $path | Out-File $outFile -Append
        $foundConfig = $true
    }
}

if (-not $foundConfig) {
    "`nNenhum settings.json encontrado." | Out-File $outFile -Append
}

Write-Host "Arquivo gerado em: $outFile" -ForegroundColor Green

$bucketPath = "backups/$dateStr/$([System.IO.Path]::GetFileName($outFile))"

try {
    & "$awsPath" s3 cp $outFile "s3://$bucketName/$bucketPath"
    Write-Host "Arquivo enviado para o bucket S3 em: s3://$bucketName/$bucketPath" -ForegroundColor Green
} catch {
    Write-Host "Erro ao enviar para o S3: $_" -ForegroundColor Red
}
