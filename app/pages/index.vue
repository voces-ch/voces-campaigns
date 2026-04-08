<template>
  <div
    class="min-h-screen bg-gray-50 flex flex-col justify-center items-center py-12 px-4 sm:px-6 lg:px-8"
  >
    <div class="max-w-md w-full space-y-8 text-center">
      <div>
        <h2 class="mt-6 text-3xl font-extrabold text-gray-900 tracking-tight">
          voces.ch Aktionsnetzwerk
        </h2>
        <p class="mt-2 text-sm text-gray-500">
          Die Plattform für unabhängige Kampagnen.
        </p>
      </div>

      <div class="mt-8 bg-white py-8 px-6 shadow-sm sm:rounded-xl">
        <div class="flex justify-center mb-4">
          <svg
            class="h-12 w-12 text-indigo-500"
            fill="none"
            viewBox="0 0 24 24"
            stroke="currentColor"
          >
            <path
              stroke-linecap="round"
              stroke-linejoin="round"
              stroke-width="1.5"
              d="M11 5.882V19.24a1.76 1.76 0 01-3.417.592l-2.147-6.15M18 13a3 3 0 100-6M5.436 13.683A4.001 4.001 0 017 6h1.832c4.1 0 7.625-1.234 9.168-3v14c-1.543-1.766-5.067-3-9.168-3H7a3.988 3.988 0 01-1.564-.317z"
            />
          </svg>
        </div>

        <p class="text-gray-700 mb-6 leading-relaxed">
          Wenn du eine bestimmte Kampagne unterstützen möchtest, überprüfe bitte
          den genauen Link, den du erhalten hast<br />
          <span class="text-sm text-gray-400 mt-2 block"
            >(z.B. <code>act.voces.ch/name-der-kampagne</code>)</span
          >.
        </p>

        <a
          href="https://docs.voces.ch"
          class="w-full flex justify-center py-3 px-4 border border-transparent rounded-lg shadow-sm text-sm font-medium text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500 transition-colors"
        >
          Eigene Kampagne starten
        </a>
      </div>
    </div>
  </div>
</template>

<script setup>
import { useHead } from "#imports";

// Tell search engines NOT to index this generic fallback page
useHead({
  title: "Aktionsnetzwerk - voces.ch",
  meta: [{ name: "robots", content: "noindex, nofollow" }],
});
</script>
