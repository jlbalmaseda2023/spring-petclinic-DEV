# Historias de Usuario - Spring Petclinic

> Generado a partir del analisis de la arquitectura real del proyecto.

## Contexto del Negocio
La clinica veterinaria Petclinic gestiona **propietarios**, **mascotas**, **veterinarios** y **visitas**. Los usuarios principales son: recepcionistas, veterinarios y el propio sistema de gestion.

---

## HU-01: Registrar nuevo propietario
**Como** recepcionista  
**Quiero** registrar un nuevo propietario con sus datos personales  
**Para** poder asociarle mascotas y visitas futuras.

### Criterios de aceptacion
- Nombre, apellido, direccion, ciudad y telefono son obligatorios.
- El telefono debe ser unico.
- Se muestra una confirmacion tras el registro.

### Archivos a tocar
- `OwnerController.java` (POST `/owners/new`)
- `OwnerRepository.java` (metodo `save()`)
- `Owner.java` (entidad JPA)
- `owner/form.html` (Thymeleaf)

---

## HU-02: Buscar propietario por apellido
**Como** recepcionista  
**Quiero** buscar un propietario por su apellido  
**Para** localizar rapidamente su ficha.

### Criterios de aceptacion
- Busqueda parcial (contiene apellido).
- Si hay varios resultados, muestra lista.
- Si no hay resultados, muestra mensaje informativo.

### Archivos a tocar
- `OwnerController.java` (GET `/owners/find`)
- `OwnerRepository.java` (metodo `findByLastName()`)
- `owner/findOwners.html`

---

## HU-03: Registrar mascota de un propietario
**Como** recepcionista  
**Quiero** registrar una mascota asociada a un propietario existente  
**Para** llevar el historial de cada mascota.

### Criterios de aceptacion
- Nombre, fecha de nacimiento y tipo (perro, gato, pajaro, etc.) son obligatorios.
- No se permite registrar mascotas con nombre vacio.
- Se valida que el tipo exista en el catalogo.

### Archivos a tocar
- `PetController.java` (POST `/owners/{ownerId}/pets/new`)
- `Pet.java` (entidad JPA)
- `PetType.java` (catalogo)
- `pet/createOrUpdatePetForm.html`

---

## HU-04: Listar veterinarios disponibles
**Como** recepcionista  
**Quiero** ver la lista de veterinarios y sus especialidades  
**Para** asignar la visita al veterinario correcto.

### Criterios de aceptacion
- Muestra nombre y apellido del veterinario.
- Muestra especialidades (radiologia, cirugia, odontologia, etc.).
- Ordenado por apellido.

### Archivos a tocar
- `VetController.java` (GET `/vets`)
- `Vet.java` (entidad JPA)
- `Specialty.java` (especialidades)
- `vets/vetList.html`

---

## HU-05: Programar visita para una mascota
**Como** recepcionista  
**Quiero** registrar una visita de una mascota a la clinica  
**Para** llevar el historial medico.

### Criterios de aceptacion
- Fecha de la visita obligatoria.
- Descripcion de la visita (motivo, sintomas) obligatoria.
- Se asocia a una mascota existente.
- Se puede editar la visita antes de la fecha.

### Archivos a tocar
- `VisitController.java` (POST `/owners/{ownerId}/pets/{petId}/visits/new`)
- `Visit.java` (entidad JPA)
- `visit/createOrUpdateVisitForm.html`

---

## HU-06: Ver historial de visitas de una mascota
**Como** veterinario  
**Quiero** ver todas las visitas previas de una mascota  
**Para** conocer su historial medico antes de atenderla.

### Criterios de aceptacion
- Muestra fecha y descripcion de cada visita.
- Ordenado cronologicamente (mas reciente primero).
- Accesible desde la ficha del propietario.

### Archivos a tocar
- `OwnerController.java` (detalle de propietario con mascotas y visitas)
- `owner/ownerDetails.html` (Thymeleaf)
- Relacion `Pet` -> `Visit` (coleccion `visits` en `Pet.java`)

---

## HU-07: Cache de veterinarios (rendimiento)
**Como** administrador del sistema  
**Quiero** que la lista de veterinarios se cachee  
**Para** reducir consultas a base de datos.

### Criterios de aceptacion
- Cache activado por defecto.
- Se invalida cuando se actualizan veterinarios.
- Tiempo de vida configurable.

### Archivos a tocar
- `CacheConfiguration.java` (configuracion de Spring Cache)
- `VetController.java` (anotacion `@Cacheable`)

---

## HU-08: Endpoint de salud (monitorizacion)
**Como** equipo de DevOps  
**Quiero** un endpoint que indique si la aplicacion esta viva  
**Para** integrar con sistemas de monitorizacion.

### Criterios de aceptacion
- GET `/actuator/health` devuelve estado UP/DOWN.
- Incluye estado de base de datos.
- Respuesta rapida (< 100ms).

### Archivos a tocar
- `application.properties` (`management.endpoints.web.exposure.include`)
- Configuracion por defecto de Spring Boot Actuator.

---

## Mapa de arquitectura rapida

```
[Usuario] -> [Thymeleaf HTML] -> [Controller] -> [Repository] -> [H2/MySQL/PostgreSQL]
                                        |
                                        v
                                [Entidad JPA]
```

| Capa | Clave | Ejemplo |
|------|-------|---------|
| **Vista** | Thymeleaf templates | `owner/*.html`, `pet/*.html` |
| **Controlador** | `@Controller` Spring MVC | `OwnerController`, `PetController` |
| **Repositorio** | Spring Data JPA | `OwnerRepository`, `PetRepository` |
| **Entidad** | `@Entity` JPA | `Owner`, `Pet`, `Vet`, `Visit` |
| **Configuracion** | Properties, Cache | `application.properties`, `CacheConfiguration` |
