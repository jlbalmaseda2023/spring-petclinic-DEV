# Script para consultar documentacion del proyecto con Ollama (local, sin nube)
# Uso: .\ask-project.ps1 "pregunta" [archivo1] [archivo2] ...

param(
    [Parameter(Mandatory=$true)]
    [string]$Question,
    
    [string[]]$Files = @("README.md", "pom.xml", "src/main/resources/application.properties")
)

Write-Host "Consultando Ollama con los archivos: $($Files -join ', ')" -ForegroundColor Cyan

# Concatenar contenido de archivos
$content = ""
foreach ($file in $Files) {
    if (Test-Path $file) {
        $content += "`n--- $file ---`n"
        $content += Get-Content $file -Raw
    } else {
        Write-Warning "Archivo no encontrado: $file"
    }
}

# Llamar a Ollama
$content | ollama run llama3.2 $Question
