/** @type {import('next').NextConfig} */
const nextConfig = {
  // Configuración para que los assets estáticos y el service worker funcionen correctamente
  reactStrictMode: true,
  swr: true,
  // Asegurarnos de que el service worker sea servido desde la raíz
  images: {
    dangerouslyAllowSVG: true,
    contentSecurityPolicy: "default-src 'self'; script-src 'self'; sandbox allow-scripts;",
  },
};

module.exports = nextConfig;