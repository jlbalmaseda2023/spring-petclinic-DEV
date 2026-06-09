# Progreso del Onboarding - Spring Petclinic

> Archivo de sesion. Actualizar despues de cada sesion de trabajo.

## Sesion 1 (8-9 Jun 2026)

### Completado
- [x] Repo GitHub creado: `jlbalmaseda2023/spring-petclinics` (3 ramas: main, feature-1, feature-2)
- [x] README.md en espanol
- [x] ONBOARDING_GUIDE.md con resumen de configuracion
- [x] USER_STORIES.md con 8 historias de usuario mapeadas a archivos
- [x] Logs configurados: `logback-spring.xml` (rotacion diaria, colores consola)
- [x] Jira + GitHub conectados via "GitHub for Atlassian" (ticket KAN-3 verificado)
- [x] Pipeline CI/CD creado: `.github/workflows/ci.yml` (build, test, artifact, n8n webhook)
- [x] Plugins IntelliJ instalados: Lombok, Maven Helper, Rainbow Brackets, Key Promoter X, SonarLint, EnvFile
- [x] Compilacion y ejecucion local exitosa
- [x] CodeGraph instalado e indexado (72 archivos)

### Herramientas probadas pero no viables (8GB RAM)
- Ollama (llama3.2): funciona solo con IntelliJ cerrado
- AnythingLLM: satura RAM, errores de red
- NotebookLM: innecesario para proyecto pequeno

## Sesion 2 (9 Jun 2026)

### Completado
- [x] CodeGraph: indice actualizado (864 nodos, 1.608 aristas, 72 → 47 archivos Java + otros)
- [x] CodeGraph: guia de uso creada (`CODEGRAPH_GUIDE.md`)
- [x] CodeGraph: ejemplo practico paso a paso — verificacion de unicidad del telefono en HU-01
  - Resultado: **NO esta implementada** (`Owner.java:61` solo tiene `@Pattern`, no `@Column(unique=true)` ni metodo en `OwnerRepository`)
- [x] CodeGraph: descubierto que `@Cacheable` esta en `VetRepository.java:18`, no en `VetController` (USER_STORIES.md incorrecto para HU-07)
- [x] CodeGraph: validaciones de `PetValidator.java` mapeadas (nombre, tipo, birthDate). FALTA: validacion de tipo contra catalogo (`PetType`)
- [x] Ollama: descargado y probado `llama3.2:1b` (~1.2 GB) — **funciona con 8GB RAM + IntelliJ abierto**
- [x] Ollama + CodeGraph: flujo de "extraer codigo con CodeGraph y preguntar a Ollama" probado
  - Conclusion: modelo 1B **alucina con codigo** (inventa clases, omite validaciones existentes). Util para chat general, NO para analisis de codigo
- [x] Ollama: probado `qwen2.5-coder:1.5b` (~1.0 GB, especializado en codigo)
  - Resultado: **NO carga** con 8GB RAM + IntelliJ abierto (91% RAM ocupada, se queda bloqueado). Modelos coder no viables en este hardware.
- [x] AnythingLLM: diagnosticado — errores de red, satura RAM, se queda colgado. **No viable con 8GB RAM**
- [x] Jira: creados 8 tickets (KAN-4 a KAN-11) basados en `USER_STORIES.md`
  - Import: script `create_jira_tickets.ps1` leyendo `JIRA_TICKETS.csv` → API REST de Jira Cloud
  - Archivos preparados para futuro: `JIRA_TICKETS.md` (plantillas) y `JIRA_TICKETS.csv` (datos)

### Hallazgos / Aclaraciones
- Archivo `.github/workflows/ci.yml` referenciado en Sesion 1 **no existe** en working directory actual (posiblemente en otra rama o se perdio)
- Archivo `src/main/resources/logback-spring.xml` tampoco existe en working directory actual
- `USER_STORIES.md` tiene imprecisiones mapeadas a archivos (HU-07 menciona `VetController` para caché, realmente es `VetRepository`)
- MCP (Model Context Protocol) de CodeGraph conecta con Claude/Cursor, no con Cascade

### Herramientas: estado final tras pruebas

| Herramienta | Estado | Uso recomendado |
|-------------|--------|-----------------|
| **CodeGraph** | ✅ Productivo | Navegar codigo, localizar archivos, verificar implementaciones antes de tocar |
| **Ollama `llama3.2:1b`** | ✅ Funcional | Chat general, n8n, tareas no tecnicas. NO para analisis de codigo |
| **AnythingLLM** | ❌ No viable | Saturacion de RAM + errores de red. No usar hasta tener mas recursos |
| **Cascade (IDE)** | ✅ Productivo | Asistente de programacion integrado |

### Pendientes para proxima sesion
- [ ] Verificar ejecucion del pipeline CI/CD en GitHub Actions (recuperar/crear `.github/workflows/ci.yml`)
- [ ] Practicar merge feature-1 -> main via Pull Request
- [ ] Configurar n8n para notificaciones del pipeline (conectar con Ollama si aplica)
- [ ] Corregir imprecisiones de USER_STORIES.md segun hallazgos de CodeGraph

## Datos de acceso rapido

| Recurso | URL / Path |
|---------|-----------|
| GitHub | https://github.com/jlbalmaseda2023/spring-petclinics |
| Jira | https://joseluisbalmaseda.atlassian.net |
| Local | `C:\Users\Jose Luis\CascadeProjects\spring-petclinic` |

## Comandos utiles

```powershell
# Compilar (sin tests por RAM)
.\mvnw.cmd clean package -DskipTests

# Ejecutar
.\mvnw.cmd spring-boot:run -DskipTests

# Ver ramas
git branch -a

# Status del grafo CodeGraph
codegraph status
```
