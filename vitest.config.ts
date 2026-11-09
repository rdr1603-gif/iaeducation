import { fileURLToPath } from "node:url";

import { defineConfig } from "vitest/config";

/**
 * Configuración de tests unitarios.
 *
 * Entorno `node` porque lo que se testea hoy es lógica de dominio y de servidor
 * (matriz de permisos, análisis textual, extracción pedagógica, validación de
 * entorno, alcance institucional y consistencia del esquema). Cuando haya que
 * testear componentes con estado o DOM, ese archivo se aísla con el docblock
 * `// @vitest-environment jsdom` y no hace falta tocar esta configuración.
 *
 * `server-only` existe para que el bundler de Next falle si un módulo de
 * servidor llega al cliente. En un test no hay bundler que lo compruebe, así que
 * se resuelve a un módulo vacío: la garantía real la da Next, no Vitest.
 */
const SIN_OPERATION = fileURLToPath(new URL("./tests/stubs/sin-operacion.ts", import.meta.url));

export default defineConfig({
  test: {
    environment: "node",
    include: ["src/**/*.test.ts", "tests/**/*.test.ts"],
    exclude: ["**/node_modules/**", "**/.next/**"],
    reporters: ["default"],
    // Varios módulos de servidor validan la configuración al importarse. Esta
    // base les da valores ficticios y válidos para que el fallo, cuando lo haya,
    // sea del código bajo prueba y no de la máquina que corre los tests.
    setupFiles: ["./tests/setup.ts"],
  },
  resolve: {
    alias: {
      "@": fileURLToPath(new URL("./src", import.meta.url)),
      "server-only": SIN_OPERATION,
      "client-only": SIN_OPERATION,
    },
  },
});
