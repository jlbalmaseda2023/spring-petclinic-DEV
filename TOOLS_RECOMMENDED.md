# Herramientas Recomendadas - Entorno 8GB RAM / Windows

> Lista curada para tu setup actual. Priorizadas por compatibilidad con 8GB RAM + IntelliJ abierto.

---

## 1. Navegacion y comprension de codigo

| Herramienta | Estado | Por que usarla | RAM |
|-------------|--------|----------------|-----|
| **CodeGraph** | ✅ Ya instalado | Grafo semantico del proyecto. Busca clases, metodos, campos con precision. Sin alucinaciones. | ~0 MB (CLI) |
| **IntelliJ Structure tool window** | ✅ Ya disponible | `Alt+7` muestra la estructura del archivo actual. Navegacion rapida sin salir del IDE. | 0 (nativo) |
| **IntelliJ Find Usages** | ✅ Ya disponible | `Alt+F7` sobre cualquier simbolo. Encuentra donde se usa algo en todo el proyecto. | 0 (nativo) |
| **IntelliJ Call Hierarchy** | ✅ Ya disponible | `Ctrl+Alt+H`. Ver quien llama a un metodo y a quien llama el. | 0 (nativo) |

**Recomendacion:** Antes de buscar herramientas externas, domina las que ya tienes en IntelliJ. Son gratuitas, exactas y no consumen RAM extra.

---

## 2. Asistencia de IA para codigo (alternativas a Cascade)

| Herramienta | Compatibilidad RAM | Notas |
|-------------|-------------------|-------|
| **Cascade (actual)** | ✅ Funciona | Integrado en el IDE. Bueno para tareas dirigidas. |
| **GitHub Copilot** | ⚠️ Medio | Requiere internet. Funciona bien pero la version gratuita es limitada. Consume ~500MB extra. |
| **Ollama + Continue.dev (plugin IntelliJ)** | ✅ Posible | Plugin que conecta Ollama con IntelliJ. Usa tu `llama3.2:1b` local. Gratuito, offline. **Requiere prueba con tu RAM.** |
| **Tabnine** | ⚠️ Medio | Autocompletado con IA. Tiene modo local gratuito. Consume RAM variable. |
| **Codeium** | ⚠️ Medio | Autocompletado gratuito. Requiere internet. |

**Mi recomendacion para ti:** Prueba **Continue.dev** con Ollama. Es un plugin de IntelliJ que conecta con modelos locales. Con `llama3.2:1b` es usable para autocompletado basico y chat dentro del IDE. Gratuito y sin enviar codigo a la nube.

---

## 3. Testing y calidad de codigo

| Herramienta | Estado | Uso | RAM |
|-------------|--------|-----|-----|
| **SonarLint** | ✅ Ya instalado | Detecta bugs, code smells, vulnerabilidades en tiempo real. Integrado en IntelliJ. | 0 (nativo) |
| **JUnit 5** | ✅ Ya en proyecto | Tests unitarios y de integracion. Spring Boot los incluye por defecto. | 0 (solo al ejecutar) |
| **Mockito** | ✅ Ya en proyecto | Mock de dependencias para tests. Incluido en Spring Boot. | 0 |
| **AssertJ** | ✅ Ya en proyecto | Assertions mas legibles que JUnit puro. Incluido. | 0 |

**Recomendacion:** Usa SonarLint antes de cada commit. Es gratis y te evita errores tontos.

---

## 4. Automatizacion y CI/CD

| Herramienta | Estado | Uso |
|-------------|--------|-----|
| **GitHub Actions** | ✅ Cuenta creada | CI/CD en la nube. No consume RAM local. Build, test, deploy automatico. |
| **n8n** | ⚠️ Pendiente | Automatizacion de flujos (webhooks, notificaciones). Puede conectar con Ollama. Requiere Docker o Node.js. |
| **Maven (ya incluido)** | ✅ Funcionando | Build, dependencias, tests. Usalo con `-DskipTests` si la RAM aprieta al compilar. |

---

## 5. Documentacion y gestion

| Herramienta | Estado | Uso |
|-------------|--------|-----|
| **Jira (gratuita)** | ✅ Ya configurada | Tickets, sprint planning, seguimiento de HU. 10 usuarios max en gratis. |
| **Markdown en repo** | ✅ En uso | `PROGRESS.md`, `USER_STORIES.md`, `CODEGRAPH_GUIDE.md`. Versionado con git. |
| **GitHub Projects** | ⚠️ Opcional | Tablero Kanban gratis en GitHub. Alternativa ligera a Jira para proyectos pequenos. |
| **PlantUML / Mermaid** | ⚠️ Opcional | Diagramas de secuencia, clases, flujo. Se escriben en texto y se renderizan. Util para documentar arquitectura. |

---

## 6. Bases de datos y utilidades

| Herramienta | Estado | Uso | RAM |
|-------------|--------|-----|-----|
| **H2 Console (incluida en Spring Boot)** | ✅ Ya disponible | Consola web para ver la BD en desarrollo. `http://localhost:8080/h2-console` | 0 |
| **IntelliJ Database tool** | ✅ Ya disponible | `View -> Tool Windows -> Database`. Explora tablas, ejecuta queries SQL. | 0 |
| **DBeaver** | ✅ Opcional | Cliente SQL universal. Gratuito. Util si la tool de IntelliJ no te convence. | ~200 MB |
| **Postman / Bruno** | ⚠️ Opcional | Test de APIs REST. Bruno es ligero y gratuito (alternativa a Postman). | ~100 MB |

---

## 7. Modelos de IA locales (para Ollama)

| Modelo | Tamaño | Uso recomendado | Funciona con 8GB? |
|--------|--------|-----------------|-------------------|
| `llama3.2:1b` | ~1.2 GB | Chat general, tareas simples, n8n | ✅ Si |
| `llama3.2:3b` | ~2.0 GB | Chat general, mejora notable vs 1B | ✅ Solo con IntelliJ cerrado |
| `qwen2.5-coder:1.5b` | ~1.0 GB | **Especializado en codigo** | ✅ Si |
| `deepseek-coder:1.3b` | ~1.0 GB | **Especializado en codigo** | ✅ Si |
| `codellama:7b` | ~4.0 GB | Coding avanzado | ❌ No |

**Recomendacion para ti:** Prueba `qwen2.5-coder:1.5b` o `deepseek-coder:1.3b`. Estan optimizados para codigo y con 8GB deberian funcionar mejor que llama3.2:1b para tecnicas.

```powershell
# Probar un modelo especializado en codigo
ollama pull qwen2.5-coder:1.5b
ollama run qwen2.5-coder:1.5b
```

---

## 8. Herramientas descartadas (por RAM)

| Herramienta | Motivo |
|-------------|--------|
| **AnythingLLM** | Satura RAM, se queda colgado |
| **Docker Desktop** | Requiere 4GB+ solo para el daemon. Imposible con 8GB total |
| **VS Code + extensiones pesadas** | VS Code es mas ligero que IntelliJ, pero con extensiones de IA consume similar |
| **Claude Desktop / Cursor** | Requieren cuentas de pago y RAM extra |
| **Modelos 7B+ (llama3, mistral, etc.)** | Necesitan 6GB+ de VRAM/RAM. Imposibles |

---

## Plan de adopcion recomendado

### Fase 1 (ya tienes)
- [x] IntelliJ + SonarLint
- [x] CodeGraph
- [x] Git + GitHub
- [x] Jira
- [x] Maven

### Fase 2 (proxima)
- [ ] Probar **Continue.dev** en IntelliJ con Ollama
- [ ] Probar **qwen2.5-coder:1.5b** para ver si mejora el analisis de codigo
- [ ] Configurar **GitHub Actions** pipeline CI/CD real
- [ ] Activar **n8n** para notificaciones

### Fase 3 (cuando tengas mas RAM)
- [ ] AnythingLLM (necesita 12GB+ para ser usable)
- [ ] Modelos 7B+ para analisis de codigo serio
- [ ] Docker para entornos aislados

---

## Comandos utiles rapidos

```powershell
# Ver RAM disponible
(Get-CimInstance -ClassName Win32_OperatingSystem).FreePhysicalMemory / 1MB

# Ver que procesos consumen mas RAM
Get-Process | Sort-Object WorkingSet -Descending | Select-Object -First 10 Name, WorkingSet

# Status de Ollama
ollama list

# Status de CodeGraph
codegraph status
```
