import type { NextConfig } from "next";

const nextConfig: NextConfig = {
  output: 'export',  // Habilita la exportación estática
  images: {
    unoptimized: true,  // Las imágenes en S3 no pueden usar el optimizador de Next.js
  },
  trailingSlash: true,  // Añade / al final de las URLs (mejor para S3)
};

export default nextConfig;
