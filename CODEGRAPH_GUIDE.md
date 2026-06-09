# Guía de CodeGraph - Spring Petclinic

> Referencia rápida para navegar el proyecto con CodeGraph.

## ¿Qué es CodeGraph?

Un **mapa inteligente del código** que permite hacer consultas semánticas en lenguaje natural sobre el proyecto.

## Estado actual del índice

```powershell
codegraph status "C:\Users\Jose Luis\CascadeProjects\spring-petclinic"
```

- **Nodos:** 864
- **Aristas:** 1.608
- **DB Size:** 2,36 MB
- **Archivos:** 47 Java, 14 properties, 8 yaml, 3 xml
- **Backend:** node:sqlite (WAL activado)
- **Índice:** al día

## Comandos esenciales

```powershell
# Estado del índice
codegraph status "C:\Users\Jose Luis\CascadeProjects\spring-petclinic"

# Re-indexar tras cambios
codegraph index "C:\Users\Jose Luis\CascadeProjects\spring-petclinic"

# Sincronizar cambios incrementales
codegraph sync "C:\Users\Jose Luis\CascadeProjects\spring-petclinic"

# Listar archivos indexados
codegraph files "C:\Users\Jose Luis\CascadeProjects\spring-petclinic"
```

## Consultar el grafo (`codegraph query`)

```powershell
# Buscar clases
codegraph query -p "C:\Users\Jose Luis\CascadeProjects\spring-petclinic" -k class "Owner"

# Buscar métodos
codegraph query -p "C:\Users\Jose Luis\CascadeProjects\spring-petclinic" -k method "findByLastName"

# Buscar rutas HTTP
codegraph query -p "C:\Users\Jose Luis\CascadeProjects\spring-petclinic" -k route "/owners"

# Buscar imports de una anotación
codegraph query -p "C:\Users\Jose Luis\CascadeProjects\spring-petclinic" "@Cacheable"

# Limitar resultados
codegraph query -p "C:\Users\Jose Luis\CascadeProjects\spring-petclinic" -l 3 -k class "Pet"

# Salida JSON (para scripts)
codegraph query -p "C:\Users\Jose Luis\CascadeProjects\spring-petclinic" -j -k method "save"
```

## Tipos de nodos disponibles (`-k`)

| Tipo | Descripción | Ejemplo |
|------|-------------|---------|
| `class` | Clases Java | `Owner`, `PetController` |
| `method` | Métodos | `findByLastNameStartingWith` |
| `route` | Rutas HTTP | `GET /owners`, `POST /vets` |
| `field` | Campos de clase | `telephone`, `firstName` |
| `import` | Importaciones | `org.springframework...` |
| `file` | Archivos | `OwnerController.java` |
| `interface` | Interfaces | `OwnerRepository` |
| `constant` | Constantes | enumeraciones |

## Descubrimientos del proyecto

### La caché de veterinarios NO está donde indica USER_STORIES.md
- **HU-07** dice tocar `VetController.java` (`@Cacheable`)
- **Realidad:** `@Cacheable` está en `VetRepository.java:18`, no en el controlador

### Rutas de propietarios (Owner)
- `GET /owners/find` → `OwnerController.java`
- `POST /owners/new` → `OwnerController.java`
- Rutas de mascotas bajo `/owners/{ownerId}/pets/*` → `PetController.java`

### Validaciones relevantes descubiertas con CodeGraph + lectura de código

**HU-01: Teléfono único**
- `Owner.java:61` → `@Pattern(regexp = "\\d{10}")` valida **formato** (10 dígitos)
- **NO existe** `@Column(unique=true)` ni validación de unicidad en la entidad
- CodeGraph no encontró métodos tipo `existsByTelephone` en `OwnerRepository`
- **Conclusión:** la unicidad del teléfono (criterio HU-01) probablemente **no está implementada**

**HU-03: Validación de mascota (PetValidator.java:37-53)**
- Nombre obligatorio: `!StringUtils.hasText(name)` → error `"required"`
- Tipo obligatorio (solo si es nueva): `pet.getType() == null` → error `"required"`
- Fecha de nacimiento obligatoria: `pet.getBirthDate() == null` → error `"required"`
- **NO valida** que el tipo exista en el catálogo (`PetType`) — solo comprueba que no sea `null`
- Tests en `PetValidatorTests.java:80-103` cubren estos 3 casos

**HU-07: Caché de veterinarios**
- `@Cacheable` está en `VetRepository.java:18`, **no** en `VetController` como indica `USER_STORIES.md`
- `VetController` solo expone el endpoint, la caché actúa a nivel de repositorio

## Flujo de trabajo recomendado con historias de usuario

1. **Antes de implementar:** consultar el grafo para localizar archivos relevantes
2. **Durante la implementación:** usar `codegraph sync` tras guardar cambios para mantener el índice fresco
3. **Al revisar código:** consultar relaciones entre clases (`query` por imports o métodos)

## Errores conocidos en el índice

Archivos referenciados pero no encontrados (probablemente en otra rama git):
- `.github/workflows/ci.yml`
- `src/main/resources/logback-spring.xml`

## Nota sobre MCP

CodeGraph tiene un modo servidor MCP para integrarse con agentes de IA como Claude Code o Cursor. Si en el futuro usas alguno de esos agentes, puedes activarlo con `codegraph serve --mcp`. De momento, los comandos `query` y `status` de la línea de comandos son suficientes.
