param(
    [string]$Username,
    [string]$Token
)

Write-Host "Lendo arquivo .env..." -ForegroundColor Cyan

$envFile = ".env"

if (Test-Path $envFile) {
    Get-Content $envFile | ForEach-Object {
        if ($_ -match "^\s*([^#][^=]+)\s*=\s*(.*)$") {
            $name  = $matches[1].Trim()
            $value = $matches[2].Trim()
            Set-Item -Path "env:$name" -Value $value
        }
    }
} else {
    Write-Host "Arquivo .env não encontrado no diretório atual." -ForegroundColor Red
    exit
}

if (-not $Username) { $Username = $env:USERNAME }
if (-not $Token)    { $Token    = $env:GITHUB_TOKEN }

if (-not $Token) {
    Write-Host "Nenhum token encontrado. Defina GITHUB_TOKEN no arquivo .env." -ForegroundColor Red
    exit
}

$clonePath = $env:URL_LOCAL

if (-not $clonePath) {
    Write-Host "URL_LOCAL não está definida no arquivo .env." -ForegroundColor Red
    exit
}

Write-Host "Diretório de destino: $clonePath" -ForegroundColor Magenta

if (-not (Test-Path $clonePath)) {
    Write-Host "Criando diretório de destino..." -ForegroundColor Cyan
    New-Item -ItemType Directory -Path $clonePath | Out-Null
}

$apiUrl = "https://api.github.com/user/repos?per_page=200"

$headers = @{
    "User-Agent"    = "PowerShell Script"
    "Authorization" = "Bearer $Token"
}

try {
    Write-Host "Buscando repositórios do usuário $Username..." -ForegroundColor Cyan
    $repos = Invoke-RestMethod -Uri $apiUrl -Headers $headers

    foreach ($repo in $repos) {
        $name = $repo.name
        $cloneUrl = $repo.clone_url

        Write-Host ""
        Write-Host "Clonando repositório: $name" -ForegroundColor Green

        $cloneUrlAuth = $cloneUrl -replace "https://", "https://$Token:x-oauth-basic@"
        $destFolder = Join-Path $clonePath $name

        if (Test-Path $destFolder) {
            Write-Host "O repositório '$name' já existe. Pulando..." -ForegroundColor Yellow
            continue
        }

        Write-Host "Executando git clone..." -ForegroundColor Magenta
        git clone $cloneUrlAuth $destFolder
    }

    Write-Host ""
    Write-Host "Processo concluído. Todos os repositórios foram verificados ou clonados." -ForegroundColor Cyan
}
catch {
    Write-Host "Erro ao executar operação: $_" -ForegroundColor Red
}
