# Spring PetClinic - Proyecto de Practica DevOps

> **Proposito**: Proyecto Spring Boot monolito para practicar CI/CD con GitHub Actions, automatizacion con n8n y gestion de ramas.

## Estado del Pipeline

- **Rama principal**: `main`
- **Ramas de trabajo**: `feature-1`, `feature-2`
- **CI/CD**: GitHub Actions (en configuracion)

## Requisitos

| Herramienta | Version | Verificacion |
|------------|---------|--------------|
| Java JDK | 17+ | `java -version` |
| Maven | 3.9+ (incluido via wrapper) | `.\mvnw.cmd -version` |
| Git | Cualquier version | `git --version` |

## Ejecutar localmente

### Desde terminal (PowerShell)

```powershell
# Compilar (sin tests para evitar problemas de memoria en laptops con 8GB)
.\mvnw.cmd clean package -DskipTests

# Ejecutar la aplicacion
.\mvnw.cmd spring-boot:run -DskipTests
```

### Desde IntelliJ IDEA

1. `File -> Open` y selecciona la carpeta del proyecto
2. Espera a que Maven descargue dependencias (primera vez)
3. Panel Maven (derecha) -> Lifecycle -> `package` (doble clic)

La aplicacion estara disponible en: **http://localhost:8080**

## Endpoints principales

| URL | Descripcion |
|-----|-------------|
| `http://localhost:8080` | Aplicacion Petclinic |
| `http://localhost:8080/actuator` | Endpoints de monitoring |
| `http://localhost:8080/actuator/health` | Estado de salud |
| `http://localhost:8080/h2-console` | Consola H2 (BBDD en memoria) |

## Configuracion de logs

Los logs se escriben automaticamente en:
```
logs/petclinic.log
logs/petclinic-YYYY-MM-DD.log  (rotacion diaria)
```

Configurados via `logback-spring.xml` con:
- Colores en consola para desarrollo
- Archivo rotatorio diario (30 dias de historial)
- Async appender para alto rendimiento

## Estructura del proyecto

```
spring-petclinic/
├── src/
│   ├── main/
│   │   ├── java/              # Codigo fuente Java
│   │   │   └── org/springframework/samples/petclinic/
│   │   │       ├── owner/      # CRUD de propietarios
│   │   │       ├── pet/        # CRUD de mascotas
│   │   │       ├── vet/        # CRUD de veterinarios
│   │   │       ├── visit/      # Visitas
│   │   │       └── system/     # Configuracion del sistema
│   │   └── resources/
│   │       ├── application.properties  # Configuracion
│   │       ├── logback-spring.xml    # Configuracion de logs
│   │       └── db/             # Scripts SQL (H2, MySQL, PostgreSQL)
│   └── test/                   # Tests unitarios y de integracion
├── .github/
│   └── workflows/              # Pipelines CI/CD (GitHub Actions)
├── logs/                       # Logs generados por la aplicacion
├── pom.xml                     # Dependencias Maven
└── README.md                   # Este archivo
```

## Ramas Git

| Rama | Proposito |
|------|-----------|
| `main` | Rama estable. Codigo probado y funcionando. |
| `feature-1` | Desarrollo de nuevas funcionalidades. |
| `feature-2` | Desarrollo paralelo. |

## Comandos Git utiles

```powershell
# Ver ramas locales y remotas
git branch -a

# Cambiar a feature-1
git checkout feature-1

# Crear un commit
git add .
git commit -m "Descripcion del cambio"

# Subir cambios a GitHub
git push origin feature-1
```

## Compilar imagen Docker

```powershell
.\mvnw.cmd spring-boot:build-image
docker run -p 8080:8080 docker.io/library/spring-petclinic:latest
```

## Bases de datos soportadas

Por defecto usa **H2** (en memoria). Para usar MySQL o PostgreSQL:

```powershell
# MySQL
.\mvnw.cmd spring-boot:run -Dspring-boot.run.profiles=mysql

# PostgreSQL
.\mvnw.cmd spring-boot:run -Dspring-boot.run.profiles=postgres
```

Levantar la base de datos con Docker Compose:
```powershell
docker compose up mysql     # o postgres
```

## Licencia

Proyecto basado en [Spring PetClinic](https://github.com/spring-projects/spring-petclinic) bajo licencia Apache 2.0.
