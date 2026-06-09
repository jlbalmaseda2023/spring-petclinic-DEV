# Tickets Jira - Listos para crear

> Proyecto: https://joseluisbalmaseda.atlassian.net
> Prefijo: KAN
> Tickets a crear: KAN-4 a KAN-11 (8 tickets)

---

## KAN-4: HU-01 - Registrar nuevo propietario

**Tipo:** Story
**Resumen:** Registrar nuevo propietario con datos personales

**Descripcion:**
Como recepcionista quiero registrar un nuevo propietario con sus datos personales para poder asociarle mascotas y visitas futuras.

**Criterios de aceptacion:**
- Nombre, apellido, direccion, ciudad y telefono son obligatorios.
- El telefono debe ser unico.
- Se muestra una confirmacion tras el registro.

**Archivos a tocar:**
- `OwnerController.java` (POST `/owners/new`)
- `OwnerRepository.java` (metodo `save()`)
- `Owner.java` (entidad JPA)
- `owner/form.html` (Thymeleaf)

**Notas tecnicas (CodeGraph):**
- Telefono tiene `@Pattern(regexp = "\\d{10}")` pero **NO tiene validacion de unicidad** (`@Column(unique=true)` ni metodo en repository).
- Bug detectado: criterio "telefono unico" no esta implementado.

**Etiquetas:** frontend, backend, validation

---

## KAN-5: HU-02 - Buscar propietario por apellido

**Tipo:** Story
**Resumen:** Buscar propietario por apellido

**Descripcion:**
Como recepcionista quiero buscar un propietario por su apellido para localizar rapidamente su ficha.

**Criterios de aceptacion:**
- Busqueda parcial (contiene apellido).
- Si hay varios resultados, muestra lista.
- Si no hay resultados, muestra mensaje informativo.

**Archivos a tocar:**
- `OwnerController.java` (GET `/owners/find`)
- `OwnerRepository.java` (metodo `findByLastName()`)
- `owner/findOwners.html`

**Notas tecnicas (CodeGraph):**
- `OwnerRepository` ya tiene `findByLastNameStartingWith` (linea 45).
- Funcionalidad probablemente ya implementada. Verificar.

**Etiquetas:** backend, frontend, search

---

## KAN-6: HU-03 - Registrar mascota de un propietario

**Tipo:** Story
**Resumen:** Registrar mascota asociada a un propietario existente

**Descripcion:**
Como recepcionista quiero registrar una mascota asociada a un propietario existente para llevar el historial de cada mascota.

**Criterios de aceptacion:**
- Nombre, fecha de nacimiento y tipo (perro, gato, pajaro, etc.) son obligatorios.
- No se permite registrar mascotas con nombre vacio.
- Se valida que el tipo exista en el catalogo.

**Archivos a tocar:**
- `PetController.java` (POST `/owners/{ownerId}/pets/new`)
- `Pet.java` (entidad JPA)
- `PetType.java` (catalogo)
- `pet/createOrUpdatePetForm.html`

**Notas tecnicas (CodeGraph):**
- `PetValidator.java` valida nombre, tipo (null) y birthDate.
- **FALTA:** validacion de que el tipo exista en el catalogo (`PetType`). Solo comprueba `type != null`.

**Etiquetas:** frontend, backend, validation

---

## KAN-7: HU-04 - Listar veterinarios disponibles

**Tipo:** Story
**Resumen:** Listar veterinarios y sus especialidades

**Descripcion:**
Como recepcionista quiero ver la lista de veterinarios y sus especialidades para asignar la visita al veterinario correcto.

**Criterios de aceptacion:**
- Muestra nombre y apellido del veterinario.
- Muestra especialidades (radiologia, cirugia, odontologia, etc.).
- Ordenado por apellido.

**Archivos a tocar:**
- `VetController.java` (GET `/vets`)
- `Vet.java` (entidad JPA)
- `Specialty.java` (especialidades)
- `vets/vetList.html`

**Etiquetas:** frontend, backend

---

## KAN-8: HU-05 - Programar visita para una mascota

**Tipo:** Story
**Resumen:** Registrar visita de una mascota a la clinica

**Descripcion:**
Como recepcionista quiero registrar una visita de una mascota a la clinica para llevar el historial medico.

**Criterios de aceptacion:**
- Fecha de la visita obligatoria.
- Descripcion de la visita (motivo, sintomas) obligatoria.
- Se asocia a una mascota existente.
- Se puede editar la visita antes de la fecha.

**Archivos a tocar:**
- `VisitController.java` (POST `/owners/{ownerId}/pets/{petId}/visits/new`)
- `Visit.java` (entidad JPA)
- `visit/createOrUpdateVisitForm.html`

**Etiquetas:** frontend, backend

---

## KAN-9: HU-06 - Ver historial de visitas de una mascota

**Tipo:** Story
**Resumen:** Ver historial de visitas previas de una mascota

**Descripcion:**
Como veterinario quiero ver todas las visitas previas de una mascota para conocer su historial medico antes de atenderla.

**Criterios de aceptacion:**
- Muestra fecha y descripcion de cada visita.
- Ordenado cronologicamente (mas reciente primero).
- Accesible desde la ficha del propietario.

**Archivos a tocar:**
- `OwnerController.java` (detalle de propietario con mascotas y visitas)
- `owner/ownerDetails.html` (Thymeleaf)
- Relacion `Pet` -> `Visit` (coleccion `visits` en `Pet.java`)

**Etiquetas:** frontend, backend

---

## KAN-10: HU-07 - Cache de veterinarios (rendimiento)

**Tipo:** Story
**Resumen:** Cachear lista de veterinarios para reducir consultas a BD

**Descripcion:**
Como administrador del sistema quiero que la lista de veterinarios se cachee para reducir consultas a base de datos.

**Criterios de aceptacion:**
- Cache activado por defecto.
- Se invalida cuando se actualizan veterinarios.
- Tiempo de vida configurable.

**Archivos a tocar:**
- `CacheConfiguration.java` (configuracion de Spring Cache)
- `VetRepository.java` (anotacion `@Cacheable` - ya existe en linea 18)

**Notas tecnicas (CodeGraph):**
- `@Cacheable` ya esta en `VetRepository.java:18`, NO en `VetController`.
- `USER_STORIES.md` tiene imprecision: menciona `VetController` para caché.
- Verificar si falta invalidacion de cache y tiempo de vida configurable.

**Etiquetas:** backend, performance

---

## KAN-11: HU-08 - Endpoint de salud (monitorizacion)

**Tipo:** Story
**Resumen:** Endpoint de salud para monitorizacion

**Descripcion:**
Como equipo de DevOps quiero un endpoint que indique si la aplicacion esta viva para integrar con sistemas de monitorizacion.

**Criterios de aceptacion:**
- GET `/actuator/health` devuelve estado UP/DOWN.
- Incluye estado de base de datos.
- Respuesta rapida (< 100ms).

**Archivos a tocar:**
- `application.properties` (`management.endpoints.web.exposure.include`)
- Configuracion por defecto de Spring Boot Actuator.

**Etiquetas:** backend, devops, monitoring

---

## Instrucciones para crear en Jira

1. Abrir https://joseluisbalmaseda.atlassian.net
2. Ir al proyecto (prefijo KAN)
3. Crear ticket → Tipo: Story
4. Copiar y pegar Resumen y Descripcion de cada ticket
5. Guardar. Jira asignara automaticamente KAN-4, KAN-5, etc.
6. (Opcional) Añadir etiquetas y enlazar a USER_STORIES.md en GitHub

## Relacion con GitHub

Si GitHub for Atlassian esta conectado, al crear branches tipo `feature/KAN-4-hu01-registrar-propietario` los tickets se vincularan automaticamente.
