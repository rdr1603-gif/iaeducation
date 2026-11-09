# Articula Educación IA

Plataforma profesional para **planificar y articular** la Educación Primaria: los
docentes cargan sus planificaciones, el sistema las analiza, las articula entre
grados y entre áreas, y deja registro de cada acuerdo en el trabajo colectivo
docente.

> **Estado actual:** la base técnica (esquema, seguridad, análisis de texto,
> extracción pedagógica y suite de tests) está completa y verificada. **No hay
> conexión a Supabase todavía**: falta crear el proyecto y configurar `.env.local`.
> Ver [Puesta en marcha](#puesta-en-marcha).

---

## Principio de diseño

**El sistema no inventa contenido pedagógico.** Si una planificación no dice qué
instrumentos de evaluación usa, la plataforma dice que no está declarado. Un
sistema que completa huecos con texto plausible es peor que uno que no dice
nada: el docente no puede distinguir lo que leyó de lo que inventó la máquina.

Todo lo que la plataforma afirma sobre un documento es texto literal del
documento, y hay un test que lo verifica en cada corrida.

---

## Stack

| Capa | Tecnología |
| --- | --- |
| Framework | Next.js 16 (App Router, Turbopack) |
| Lenguaje | TypeScript (modo estricto) |
| Base de datos | PostgreSQL vía Supabase, Prisma 7 |
| Autenticación | Supabase Auth |
| Almacenamiento | Supabase Storage (bucket privado) |
| Estilos | Tailwind CSS |
| Tests | Vitest |

---

## Arquitectura

### Multi-institución con aislamiento en base de datos

Cada escuela es una institution. **El aislamiento no se aplica en el código de
aplicación**: se aplica en PostgreSQL, con *Row Level Security*. Esto no es
redundancia defensiva, es la diferencia entre un forgot de filtro y una fuga de
datos entre escuelas.

El mecanismo tiene dos capas:

1. `src/lib/db/scope.ts` abre una transacción y ejecuta
   `set_config('app.institution_id', ..., true)`, fijando la institución activa
   para esa transacción.
2. Las políticas RLS de la migración `0001_security` comparan
   `institution_id` contra esa variable en cada fila.

Consecuencia práctica: aunque un endpoint futuro olvide filtrar por institución,
la base de datos sigue rechazando la lectura. Por eso el rol de aplicación no
puede tener `BYPASSRLS`, y por eso las tablas usan `FORCE ROW LEVEL SECURITY`
(para que el dueño de la tabla tampoco la esquive).

`src/lib/auth/permissions.ts` define la matriz de roles y permisos, y sus tests
verifican que no haya permisos huérfanos ni roles con permisos inexistentes.

### Análisis de texto (`src/lib/text/analyze.ts`)

Normalización y métricas para comparar y agrupar textos educators:

- **Normalización**: minúsculas, sin diacríticos, ordinales y puntuación
  unificados. `4.º grado`, `4° grado` y `4 grado` deben ser la misma unidad, o
  la articulación vertical entre grados se rompe justo donde más importa.
- **TF-IDF** en vector disperso, con colisiones de hash sumadas en vez de
  pisadas.
- **Detección de verbos de acción** con conjugación: `analizar`, `analiza`,
  `analizan`, `analizando` y `analizarán` son el mismo verbo. Sin esto, la mitad
  de los objetivos de una planificación real quedaría sin verbo reconocido.

### Extracción pedagógica (`src/lib/documents/pedagogy.ts`)

Segmenta un documento en las 19 categorías de una planificación escolar
(fundamentación, objetivos, contenidos conceptuales/procedimentales/actitudinales,
metodología, evaluación, cronograma, etc.) y extrae los ítems de cada una.

Cuando una sección no está en el documento, el ítem se devuelve con
`identified: false` y el texto constante `NOT_IDENTIFIED_TEXT`. Nunca con una
estimación.

---

## Puesta en marcha

### 1. Requisitos

- Node.js 20 o superior
- Un proyecto Supabase (aún no creado para este repositorio)

### 2. Variables de entorno

```bash
cp .env.example .env.local
```

Completar `DATABASE_URL`, `DIRECT_DATABASE_URL`,
`NEXT_PUBLIC_SUPABASE_URL`, `NEXT_PUBLIC_SUPABASE_ANON_KEY` y
`SUPABASE_SERVICE_ROLE_KEY`. Generar `ENCRYPTION_KEY` con:

```bash
node -e "console.log(require('crypto').randomBytes(32).toString('hex'))"
```

La aplicación **falla al arrancar**, no en producción, si falta o es inválida
alguna variable, y el mensaje indica el nombre exacto de la variable a corregir.

### 3. Base de datos

```bash
npm run db:deploy    # aplica las migraciones (producción / CI)
npm run db:seed      # carga roles y permisos
```

Migraciones en orden de aplicación:

| Migración | Contenido |
| --- | --- |
| `0000_init` | 47 tablas, índices, extensiones |
| `0001_security` | RLS, políticas, integridad de pertenencia institucional, triggers |
| `0002_integrity_rls` | Correcciones de RLS y `updated_at`, con verificación que falla en voz alta |

### 4. Desarrollo

```bash
npm run dev
```

---

## Comandos

| Comando | Qué hace |
| --- | --- |
| `npm run dev` | Servidor de desarrollo |
| `npm run build` | Build de producción |
| `npm run check` | typecheck + lint + tests (lo que debe pasar siempre) |
| `npm run test` | Suite de tests |
| `npm run test:watch` | Tests en modo interactivo |
| `npm run db:deploy` | Aplica migraciones |
| `npm run db:seed` | Carga roles y permisos |

---

## Tests

```bash
npm run test
```

**98 tests.** La cobertura no es decorativa: cada archivo protege una propiedad
que, si se rompe, produce un fallo silencioso en producción.

| Archivo | Qué protege |
| --- | --- |
| `src/lib/auth/permissions.test.ts` | Matriz de roles y permisos: sin permisos huérfanos ni roles con permisos inexistentes |
| `src/lib/text/analyze.test.ts` | Normalización (ordinales, acentos), TF-IDF, conjugación verbal |
| `src/lib/documents/pedagogy.test.ts` | Que lo extraído sea texto literal; que lo ausente se marque como ausente |
| `tests/schema-consistency.test.ts` | Correspondencia entre esquema Prisma y SQL: orden de migraciones, RLS, triggers |
| `tests/env.test.ts` | Validación de configuración y reglas de campos cruzados |
| `tests/errors.test.ts` | Que ningún detalle técnico llegue al usuario |

### `tests/schema-consistency.test.ts` merece una nota

Prisma no valida el SQL escrito a mano. Una tabla puede quedar sin RLS, un
trigger puede quedar sobre una columna que no existe, y `prisma migrate dev`
acepta todo sin comentarios. Ese archivo reconstruye el estado final de RLS y de
triggers aplicando las migraciones en orden y verifica:

- que la primera migración sea la que crea el esquema;
- que toda tabla con `institution_id` tenga RLS habilitado;
- que el trigger `trg_set_updated_at` esté **exactamente** en las tablas que
  tienen esa columna;
- que toda tabla creada esté declarada como modelo en Prisma, y viceversa.

Se validó que estos tests **fallan** cuando se reintroduce cada defecto: no son
tests que pasan por construcción.

---

## Defectos corregidos en la base

Estos problemas existían en el repositorio y se corrigieron. Se documentan
porque un test sin historia no explica por qué existe.

**RLS inactivo en `assistant_messages`.** La política `thread_isolation` estaba
creada, pero la tabla quedó fuera del bucle que hace `ENABLE/FORCE ROW LEVEL
SECURITY`. Una política sin RLS habilitado es **inerte**: el contenido de las
conversaciones del asistente —que incluye fragmentos de planificaciones de la
institución— era legible por cualquier conexión.

**Triggers sobre tablas sin `updated_at`.** `trg_set_updated_at` estaba creado
sobre `pedagogical_items` y `articulation_relations`, que no tienen esa columna.
PL/pgSQL valida el cuerpo del trigger **en tiempo de ejecución**, así que la
migración pasaba sin error y todo `UPDATE` sobre esas tablas fallaba después con
`record "new" has no field "updated_at"`.

**Triggers ausentes donde sí había columna.** `meeting_minute_sections` y
`assistant_threads` nunca actualizaban su `updated_at` ante un cambio que viniera
de SQL crudo, de un job o de mantenimiento.

**Orden de aplicación de migraciones.** `20260101000000_init` ordenaba **después**
de `20260101000000_0001_security`, porque Prisma ordena por nombre de carpeta. Las
políticas RLS se habrían aplicado antes de que existieran las tablas y
`migrate deploy` habría fallado. Las carpetas siguen ahora la convención
`<timestamp>_<secuencia>_<nombre>`, y hay un test que lo verifica.

---

## Seguridad

- Los documentos institucionales se guardan en un bucket **privado**. Nunca
  público.
- `SUPABASE_SERVICE_ROLE_KEY` ignora RLS: sólo se usa en servidor. Si se filtra,
  rotarla en el panel de Supabase.
- `ENCRYPTION_KEY` cifra los secretos por institución (API keys de IA,
  configuraciones OAuth) con AES-256-GCM.
- Los errores de dominio llevan un `code` estable y un mensaje en español
  accionable. El detalle técnico se conserva para el log del servidor y nunca
  se envía al cliente (`src/lib/errors.ts`).
- `src/proxy.ts` controla la UX de sesión, **no** es la frontera de seguridad. La
  autorización real vive en los guards de servidor y en las políticas RLS.

---

## Limitaciones conocidas

- **Sin conexión a Supabase.** El esquema y las migraciones están verificados
  estáticamente y por tests, pero no se ejecutaron contra PostgreSQL. Las
  políticas RLS, los triggers y las restricciones `CHECK` necesitan una corrida
  real de `db:deploy` para confirmarse.
- **Sin interfaz de aplicación.** No hay login, panel ni flujo de carga de
  documentos todavía.
- `src/proxy.ts` referencia rutas (`/login`, `/panel`, …) que aún no existen.
