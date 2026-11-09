import { defineConfig, env } from "prisma/config";
import dotenv from "dotenv";

dotenv.config({ path: ".env" });

/**
 * Configuración de Prisma 7 — Articula Educación IA.
 *
 * Prisma 7 movió la URL de conexión fuera del `schema.prisma`. Acá se declara
 * dónde viven las migraciones y con qué base de datos trabaja la CLI (migraciones,
 * `db push`, Studio). El cliente de la aplicación usa un driver adapter; ver
 * `src/lib/db/client.ts`.
 *
 * `DIRECT_DATABASE_URL` es la conexión directa (puerto 5432) y es la que se debe
 * usar para migraciones: el pooler de transacciones de Supabase (6543) no admite
 * DDL ni migraciones.
 */
export default defineConfig({
  schema: "prisma/schema.prisma",
  migrations: {
    path: "prisma/migrations",
    seed: "tsx prisma/seed.ts",
  },
  datasource: {
    url: env("DIRECT_DATABASE_URL"),
  },
});
