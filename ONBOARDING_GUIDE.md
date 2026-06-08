# Guia de Onboarding - Spring Petclinic

> Resumen de la sesion de configuracion del proyecto

## Repositorio GitHub
- URL: https://github.com/jlbalmaseda2023/spring-petclinics
- Ramas: `main`, `feature-1`, `feature-2`

## Ejecucion Local (8GB RAM)
```powershell
.\mvnw.cmd clean package -DskipTests
.\mvnw.cmd spring-boot:run -DskipTests
```

## Configuracion de Logs
- Archivo: `src/main/resources/logback-spring.xml`
- Salida: `logs/petclinic.log` (rotacion diaria)

## Plugins IntelliJ Instalados
1. Lombok
2. Maven Helper
3. Rainbow Brackets
4. Key Promoter X
5. SonarLint
6. EnvFile
7. Cody (Sourcegraph) - requiere enterprise

## Proximos Pasos Pendientes
- [ ] Crear workflow CI/CD en `.github/workflows/ci.yml`
- [ ] Conectar con Jira (GitHub for Jira app)
- [ ] Configurar n8n para notificaciones
- [ ] Practicar merge entre feature-1 y feature-2

## Documentacion del Proyecto
- `README.md` - Descripcion en espanol
- `pom.xml` - Dependencias Maven
- `application.properties` - Configuracion app

## Herramientas Externas Configuradas
- **Windsurf**: IA sobre codigo (offline)
- **Ollama (Llama 3.2)**: IA local (requiere cerrar IntelliJ por RAM)

## Scripts Utiles
- `ask-project.ps1` - Consultar documentacion con Ollama
