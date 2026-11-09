# Plan de cambios — Campus Virtual Docente–Alumno

**Rama:** `feature/campus-virtual-docente-alumno`
**Proyecto:** `articula-educacion-ia`
**Estado inicial (auditoría):** plataforma de planificación docente sin alumnos, inscripciones, materias para estudiantes, biblioteca para alumnos, evaluaciones, entregas ni calificaciones. Sin Supabase conectado ni `.env.local`. Sin interfaz de campus.

## Principio rector
Solo migraciones **aditivas** (sin `DROP`, `DELETE` masivo, ni alteración de datos existentes). Se preservan todas las tablas, funciones y rutas actuales. No se toca producción.

## Estado de implementación (Etapa 3)

### Completado y verificado (typecheck + 129 tests pasan)
- `prisma/schema.prisma`: 10 modelos de campus agregados (`Student`, `Subject`, `Enrollment`, `BibliographicMaterial`, `Evaluation`, `EvaluationQuestion`, `Delivery`, `DeliveryAttachment`, `StudentGrade`, `StudentGradeHistory`). Todas las relaciones inversas en modelos existentes (`Institution`, `User`, `Subject`, `Cycle`, `Grade`, `Division`, `Student`). Sin DNI en ningún modelo; `Student.phone` obligatorio.
- `prisma/migrations/.../0000_init/migration.sql`: las 10 tablas nuevas agregadas al `CREATE TABLE` (aditivo, sin `DROP`/`DELETE`). Índices únicos: `enrollments(student_id,cycle_id,subject_id)`, `deliveries(evaluation_id,student_id)`, `student_grades(delivery_id)`, `students(user_id)`, `subjects(institution_id,cycle_id,name)`.
- `prisma/migrations/.../0001_security/migration.sql`: las 10 tablas nuevas añadidas a los bucles de `ENABLE/FORCE ROW LEVEL SECURITY`, políticas `tenant_isolation` y triggers `trg_set_updated_at` (las que tienen `updated_at`).
- `prisma/migrations/.../0002_integrity_rls/migration.sql`: las 8 tablas con `updated_at` añadidas al bucle de triggers.
- `prisma generate`: cliente regenerado sin errores de relación.
- `src/lib/auth/permissions.ts`: rol `ALUMNO` + permisos de campus (`student.*`, `enrollment.*`, `subject.*`, `bibliographic_material.*`, `evaluation.*`, `delivery.*`, `grade.*`). Matriz asignada a DOCENTE, COORDINADOR, ADMIN_INSTITUCIONAL, SUPERADMIN y ALUMNO. Tests de permisos pasan (sin huérfanos, sin inexistentes, jerarquía preservada).
- `src/lib/db/campus.ts`: DAL completo con `withInstitution` (RLS por `institution_id`). Operaciones: alumnos (listar, obtener, crear, actualizar), inscripciones (listar, crear con control de duplicados), materias, bibliografía (listar, crear, publicar/archivar), evaluaciones (listar, crear, publicar, obtener publicada para alumno), entregas (listar, crear con control de duplicado, cambiar estado), calificaciones (listar, crear/actualizar con historial, publicar).
- `src/actions/campus.ts`: Acciones de servidor (`'use server'`) con guards de autorización (`requirePermission`, `requireAuthenticatedScope`). Registro público de alumno (Zod: nombre, apellido, teléfono obligatorios; sin DNI). Acciones docente y alumno envueltas en `withInstitution`.
- `npm run typecheck`: limpio.
- `npm test`: 129 tests, 9 archivos, todos pasan.

### Pendiente (despliegue y pruebas reales contra BD)
- Pasos manuales (no ejecutar sin autorización): crear proyecto Supabase, configurar `.env.local`, ejecutar `npm run db:deploy` y `npm run db:seed`, crear bucket de almacenamiento privado para materiales y adjuntos.
- Pruebas de integración contra BD real (flujo completo: crear curso, registrar alumno, inscribir, subir bibliografía, publicar evaluación, entregar, corregir, publicar nota, consultar historial).

## Migraciones aditivas (sin destrucción)
- Solo `CREATE TABLE` para las 10 entidades nuevas y adición a bucles existentes de RLS/triggers. No hay `DROP`, `DELETE` masivo ni alteración de datos existentes.
- RLS habilitado en cada tabla nueva con políticas por `institution_id`.
- Triggers `trg_set_updated_at` solo en tablas que tengan `updated_at`.

## Seguridad y privacidad
- RLS en servidor: todo acceso filtra por `institutionId` vía `withInstitution()`.
- Alumno solo ve sus propias entregas, calificaciones publicadas y materias de sus inscripciones activas.
- Docente solo administra cursos/materias/alumnos autorizados.
- Teléfono no se muestra en listados públicos ni a otros alumnos.
- No se registran teléfonos ni contraseñas en logs técnicos.
- Archivos en bucket privado; descargas firmadas por servidor.

## Riesgos / limitaciones
- No hay BD desplegada aún; los tests de esquema son estáticos. Se requiere corrida real de `db:deploy` para confirmar RLS y triggers.
- La interfaz de usuario (rutas App Router) aún no está implementada; la base lógica (esquema, permisos, DAL, acciones) está lista.
- No se desplegará a producción sin autorización expresa.
