#Requires -RunAsAdministrator
<#
.SYNOPSIS
    Script de optimizacion completo para Windows.
.DESCRIPTION
    Realiza limpieza de archivos temporales, libera memoria, optimiza disco,
    limpia cache DNS, desactiva servicios innecesarios y optimiza rendimiento.
    Requiere ejecutarse como Administrador.
.NOTES
    Version: 1.0
    Uso: Click derecho -> "Ejecutar con PowerShell" como Administrador.
#>

#--- FUNCIONES AUXILIARES ---
function Write-Header($Text) {
    Write-Host "`n========================================" -ForegroundColor Cyan
    Write-Host "  $Text" -ForegroundColor Cyan
    Write-Host "========================================" -ForegroundColor Cyan
}

function Write-Status($Text, $Level = "Info") {
    $color = switch ($Level) {
        "Success" { "Green" }
        "Warning" { "Yellow" }
        "Error"   { "Red" }
        default   { "White" }
    }
    Write-Host "  [$Level] $Text" -ForegroundColor $color
}

#--- VERIFICAR ADMIN ---
$currentPrincipal = New-Object Security.Principal.WindowsPrincipal([Security.Principal.WindowsIdentity]::GetCurrent())
if (-not $currentPrincipal.IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)) {
    Write-Status "Este script debe ejecutarse como Administrador." "Error"
    Write-Host "  Pulsa cualquier tecla para salir..."
    [void][System.Console]::ReadKey($true)
    exit 1
}

Write-Host "`n       =============================================" -ForegroundColor Magenta
Write-Host "         SCRIPT DE OPTIMIZACION DE WINDOWS" -ForegroundColor Magenta
Write-Host "       =============================================" -ForegroundColor Magenta

#--- 1. LIMPIEZA DE ARCHIVOS TEMPORALES ---
Write-Header "1. LIMPIEZA DE ARCHIVOS TEMPORALES"

$tempPaths = @(
    $env:TEMP,
    "C:\Windows\Temp",
    "$env:LOCALAPPDATA\Temp",
    "$env:LOCALAPPDATA\Microsoft\Windows\Explorer\ThumbCacheToDelete",
    "$env:LOCALAPPDATA\Microsoft\Windows\INetCache",
    "$env:LOCALAPPDATA\Google\Chrome\User Data\Default\Cache",
    "$env:LOCALAPPDATA\Mozilla\Firefox\Profiles\*\cache2"
)

$totalRemoved = 0
foreach ($path in $tempPaths) {
    if (Test-Path $path) {
        try {
            $before = (Get-ChildItem $path -Recurse -Force -ErrorAction SilentlyContinue | Measure-Object -Property Length -Sum).Sum
            if ($before -eq $null) { $before = 0 }

            Get-ChildItem $path -Recurse -Force -ErrorAction SilentlyContinue | Remove-Item -Recurse -Force -ErrorAction SilentlyContinue

            $after = (Get-ChildItem $path -Recurse -Force -ErrorAction SilentlyContinue | Measure-Object -Property Length -Sum).Sum
            if ($after -eq $null) { $after = 0 }

            $freed = [math]::Round(($before - $after) / 1MB, 2)
            if ($freed -gt 0) {
                Write-Status "Liberados ${freed} MB en: $path" "Success"
                $totalRemoved += $freed
            }
        } catch {
            Write-Status "No se pudo limpiar: $path" "Warning"
        }
    }
}
Write-Status "Total aproximado liberado: ${totalRemoved} MB" "Success"

#--- 2. LIMPIEZA DE PAPELERA ---
Write-Header "2. VACIADO DE PAPELERA"
try {
    $recycleBin = (New-Object -ComObject Shell.Application).Namespace(0xA)
    $recycleBin.Items() | ForEach-Object { $recycleBin.InvokeVerb("Delete") }
    Write-Status "Papelera vaciada correctamente." "Success"
} catch {
    Write-Status "No se pudo vaciar la papelera completamente." "Warning"
}

#--- 3. LIMPIEZA DE DISCO CON DISM Y SFC ---
Write-Header "3. LIMPIEZA Y REPARACION DEL SISTEMA"
Write-Status "Ejecutando DISM /RestoreHealth (puede tardar varios minutos)..." "Info"
DISM.exe /Online /Cleanup-image /RestoreHealth | Out-Null
Write-Status "DISM completado." "Success"

Write-Status "Ejecutando SFC /scannow..." "Info"
sfc /scannow | Out-Null
Write-Status "SFC completado." "Success"

#--- 4. LIMPIEZA DE PREFETCH Y RECENT ---
Write-Header "4. LIMPIEZA DE PREFETCH Y ARCHIVOS RECIENTES"

$prefetchPath = "C:\Windows\Prefetch"
if (Test-Path $prefetchPath) {
    try {
        Get-ChildItem $prefetchPath -Filter *.pf -ErrorAction SilentlyContinue | Remove-Item -Force -ErrorAction SilentlyContinue
        Write-Status "Archivos Prefetch limpiados." "Success"
    } catch {
        Write-Status "No se pudieron limpiar los Prefetch." "Warning"
    }
}

$recentPath = "$env:APPDATA\Microsoft\Windows\Recent"
if (Test-Path $recentPath) {
    try {
        Get-ChildItem $recentPath -ErrorAction SilentlyContinue | Remove-Item -Force -Recurse -ErrorAction SilentlyContinue
        Write-Status "Archivos recientes limpiados." "Success"
    } catch {
        Write-Status "No se pudieron limpiar los recientes." "Warning"
    }
}

#--- 5. LIBERACION DE MEMORIA RAM ---
Write-Header "5. LIBERACION DE MEMORIA RAM"
try {
    $ramBefore = [math]::Round((Get-CimInstance Win32_OperatingSystem).FreePhysicalMemory / 1MB, 2)

    # Fuerza la liberacion de memoria trabajando el Garbage Collector
    [System.GC]::Collect()
    [System.GC]::WaitForPendingFinalizers()
    [System.GC]::Collect()

    # Detener servicios de Windows Search temporalmente para liberar RAM
    $searchService = Get-Service -Name "WSearch" -ErrorAction SilentlyContinue
    if ($searchService -and $searchService.Status -eq 'Running') {
        Stop-Service "WSearch" -Force -ErrorAction SilentlyContinue
        Start-Sleep -Seconds 2
        Start-Service "WSearch" -ErrorAction SilentlyContinue
        Write-Status "Servicio de busqueda de Windows reiniciado para liberar RAM." "Success"
    }

    $ramAfter = [math]::Round((Get-CimInstance Win32_OperatingSystem).FreePhysicalMemory / 1MB, 2)
    Write-Status "RAM libre antes: ${ramBefore} MB | despues: ${ramAfter} MB" "Success"
} catch {
    Write-Status "No se pudo liberar memoria completamente." "Warning"
}

#--- 6. OPTIMIZACION DE DISCOS (TRIM/Desfragmentacion) ---
Write-Header "6. OPTIMIZACION DE DISCOS"
$volumes = Get-Volume | Where-Object { $_.DriveLetter -and $_.DriveType -eq 'Fixed' }
foreach ($vol in $volumes) {
    $drive = "$($vol.DriveLetter):"
    try {
        $defragType = if ((Get-PhysicalDisk | Where-Object { $_.DeviceId -eq (Get-Partition -DriveLetter $vol.DriveLetter | Get-Disk).Number }).MediaType -eq 'SSD') { "TRIM" } else { "Desfragmentacion" }
        Write-Status "Ejecutando $defragType en $drive..." "Info"
        Optimize-Volume -DriveLetter $vol.DriveLetter -ReTrim -Analyze -Defrag -ErrorAction SilentlyContinue | Out-Null
        Write-Status "$drive optimizado." "Success"
    } catch {
        Write-Status "No se pudo optimizar $drive" "Warning"
    }
}

#--- 7. LIMPIEZA DE CACHE DNS Y RESET DE RED ---
Write-Header "7. LIMPIEZA DE CACHE DNS Y RED"
try {
    ipconfig /flushdns | Out-Null
    Write-Status "Cache DNS limpiada." "Success"

    # Reset de Winsock
    netsh winsock reset | Out-Null
    Write-Status "Winsock reseteado (requiere reinicio para aplicar)." "Success"
} catch {
    Write-Status "Error al limpiar red." "Warning"
}

#--- 8. DETENER PROCESOS DE SEGUNDO PLANO INNECESARIOS ---
Write-Header "8. DETENCION DE PROCESOS INNECESARIOS"
$processesToStop = @(
    "OneDrive",        # Sync se reanuda al abrir el explorador
    "Teams",           # Teams personal
    "Spotify",         # Si esta abierto en segundo plano
    "Dropbox",
    "CCleaner",
    "Skype"
)

foreach ($procName in $processesToStop) {
    $proc = Get-Process -Name $procName -ErrorAction SilentlyContinue
    if ($proc) {
        try {
            Stop-Process -Name $procName -Force -ErrorAction SilentlyContinue
            Write-Status "$procName detenido." "Success"
        } catch {
            Write-Status "No se pudo detener $procName" "Warning"
        }
    }
}

#--- 9. DESACTIVAR EFECTOS VISUALES (Opcional - guarda en registro) ---
Write-Header "9. AJUSTE DE EFECTOS VISUALES"
try {
    $visualEffectsPath = "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\VisualEffects"
    if (-not (Test-Path $visualEffectsPath)) { New-Item -Path $visualEffectsPath -Force | Out-Null }
    Set-ItemProperty -Path $visualEffectsPath -Name "VisualFXSetting" -Value 2 -ErrorAction SilentlyContinue  # 2 = Mejor rendimiento
    Write-Status "Efectos visuales ajustados a 'Mejor rendimiento'." "Success"
} catch {
    Write-Status "No se pudieron ajustar efectos visuales." "Warning"
}

#--- 10. INFORMACION FINAL ---
Write-Header "OPTIMIZACION COMPLETADA"
Write-Status "El sistema ha sido optimizado." "Success"
Write-Status "Se recomienda REINICIAR el equipo para aplicar todos los cambios." "Warning"
Write-Host "`n  Pulsa cualquier tecla para salir..."
[void][System.Console]::ReadKey($true)
