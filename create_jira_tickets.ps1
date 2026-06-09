# Script para crear tickets Jira desde CSV
# Uso: rellena EMAIL y API_TOKEN, luego ejecuta en PowerShell

# ============================================
# CONFIGURACION - RELLENA ESTOS DOS VALORES
# ============================================
$EMAIL = "joseluisbalmaseda@gmail.com"        # Tu email de Atlassian
$API_TOKEN = "TU_API_TOKEN_AQUI"               # Pega aqui el token de https://id.atlassian.com/manage-profile/security/api-tokens
# ============================================

$JIRA_URL = "https://joseluisbalmaseda.atlassian.net"
$PROJECT_KEY = "KAN"
$CSV_PATH = "JIRA_TICKETS.csv"

# Verificar que el token no este sin rellenar
if ($API_TOKEN -eq "TU_API_TOKEN_AQUI") {
    Write-Host "ERROR: Debes rellenar la variable API_TOKEN en este script antes de ejecutar." -ForegroundColor Red
    Write-Host "Ve a: https://id.atlassian.com/manage-profile/security/api-tokens"
    exit 1
}

# Credenciales en Base64 para autenticacion basica
$pair = "$EMAIL`:$API_TOKEN"
$bytes = [System.Text.Encoding]::ASCII.GetBytes($pair)
$base64 = [System.Convert]::ToBase64String($bytes)
$headers = @{
    "Authorization" = "Basic $base64"
    "Content-Type" = "application/json"
}

# Leer CSV
if (-not (Test-Path $CSV_PATH)) {
    Write-Host "ERROR: No se encuentra $CSV_PATH" -ForegroundColor Red
    exit 1
}

$csv = Import-Csv $CSV_PATH
Write-Host "Tickets a crear: $($csv.Count)" -ForegroundColor Cyan

$created = 0
$errors = 0

foreach ($row in $csv) {
    $summary = $row.Summary
    $description = $row.Description

    $body = @{
        fields = @{
            project = @{
                key = $PROJECT_KEY
            }
            summary = $summary
            description = $description
            issuetype = @{
                name = "Story"
            }
        }
    } | ConvertTo-Json -Depth 10

    try {
        $response = Invoke-RestMethod -Uri "$JIRA_URL/rest/api/2/issue" -Method Post -Headers $headers -Body $body
        $key = $response.key
        Write-Host "✅ Creado: $key - $summary" -ForegroundColor Green
        $created++
    } catch {
        Write-Host "❌ Error creando '$summary'" -ForegroundColor Red
        Write-Host $_.Exception.Message -ForegroundColor DarkRed
        $errors++
    }

    # Pequena pausa para no saturar la API
    Start-Sleep -Milliseconds 500
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "Resultado: $created creados, $errors errores" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
