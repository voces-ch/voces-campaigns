import tailwindcss from "@tailwindcss/vite";

// https://nuxt.com/docs/api/configuration/nuxt-config
export default defineNuxtConfig({
  compatibilityDate: "2025-07-15",
  devtools: { enabled: true },
  css: ["@/assets/css/main.css"],
  vite: {
    plugins: [tailwindcss()],
  },
  runtimeConfig: {
    public: {
      apiBase: process.env.API_BASE || "https://voces.lndo.site/api/v1",
      widgetUrl:
        process.env.WIDGET_URL ||
        "https://voces.lndo.site/widget/latest/voces-widget.js",
    },
  },
});
