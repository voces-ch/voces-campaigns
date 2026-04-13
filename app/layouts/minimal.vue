<template>
  <div class="min-h-screen bg-gray-50 font-sans text-gray-800">
    <header class="bg-white shadow-sm sticky top-0 z-50">
      <div
        class="max-w-370 mx-auto px-4 sm:px-6 lg:px-8 py-3 flex items-center justify-between"
      >
        <img
          :src="pageData?.organization.logo_url"
          alt="Campaign Logo"
          class="h-14 w-auto object-contain"
          v-if="pageData?.organization.logo_url"
        />
        <div v-else class="h-14 flex items-center">
          <h2 class="text-lg font-bold text-gray-900">
            {{ pageData.organization.name }}
          </h2>
        </div>
        <div class="text-xs text-indigo-600 text-end leading-3.5">
          <a
            :href="`https://docs.voces.ch` + `/${locale}`"
            target="_blank"
            class="hover:underline font-bold"
            >voces.ch</a
          ><br />
          <em>{{ t("power_to_the_people") }}</em>
        </div>
      </div>
    </header>

    <section class="relative w-full h-[40vh] min-h-112.5 bg-indigo-800">
      <img
        :src="pageData?.heroine_image_url"
        alt="Campaign Hero"
        class="absolute inset-0 w-full h-full object-cover opacity-60"
        v-if="pageData?.heroine_image_url"
      />
      <div
        class="absolute inset-0 bg-linear-to-t from-black/80 via-black/30 to-transparent"
      ></div>

      <div
        class="relative h-full max-w-370 mx-auto px-4 sm:px-6 lg:px-8 flex flex-col justify-end pb-12"
      >
        <h1
          class="text-4xl md:text-5xl font-extrabold text-white mb-4 leading-tight drop-shadow-md"
        >
          {{ pageData.campaign.title }}
        </h1>
        <div
          class="text-lg md:text-xl text-gray-200 max-w-2xl drop-shadow"
          v-html="pageData.campaign.description"
        ></div>
      </div>
    </section>

    <main class="max-w-370 mx-auto px-4 sm:px-6 lg:px-8 py-6 sm:py-8 lg:py-12">
      <div class="flex flex-col xl:flex-row gap-12">
        <article
          class="xl:w-7/12 prose prose-lg prose-indigo max-w-none bg-white p-6 lg:p-8 rounded-lg lg:rounded-xl shadow-sm border border-gray-100"
        >
          <slot />
        </article>

        <aside class="xl:w-5/12">
          <div
            class="sticky top-24 bg-white p-6 rounded-lg lg:rounded-xl shadow-xl border border-gray-100 ring-1 ring-gray-900/5"
          >
            <h3
              class="text-xl font-extrabold text-gray-900 mb-4 pb-4 border-b border-gray-100"
            >
              {{ t("sign_now") }}
            </h3>

            <div id="voces-widget-container">
              <span class="text-gray-400 text-sm animate-pulse">
                {{ t("loading_form") }}
              </span>
            </div>

            <p class="mt-4 text-xs text-gray-500 text-center">
              {{ t("data_secure") }}
              <a
                :href="`https://docs.voces.ch/${locale}/legal/privacy`"
                target="_blank"
                class="underline hover:text-gray-700"
                >{{ t("privacy_policy") }}</a
              >.
            </p>
          </div>
        </aside>
      </div>
    </main>

    <footer class="bg-gray-900 py-10 text-center text-gray-400 text-sm">
      <div class="max-w-370 mx-auto px-4">
        <p class="mb-2">
          &copy; {{ new Date().getFullYear() }}
          {{ pageData.organization.name }}. {{ t("all_rights_reserved") }}
        </p>
        <p class="text-xs text-gray-500">
          {{ t("powered_by") }}
          <a
            :href="`https://docs.voces.ch` + `/${locale}`"
            target="_blank"
            class="text-indigo-400 hover:underline"
            >voces.ch</a
          >
        </p>
      </div>
    </footer>
  </div>
</template>

<script setup>
import { onMounted } from "vue";
const { t, locale, setLocale } = useI18n();

const props = defineProps({
  pageData: {
    type: Object,
    required: true,
  },
  apiBaseUrl: {
    type: String,
    required: false,
    default: "https://app.voces.ch/api/v1",
  },
});

onMounted(() => {
  setLocale(props.pageData?.locale || "de");
  if (window.voces && window.voces.widget) {
    window.voces.widget({
      target: "#voces-widget-container",
      campaignUuid: props.pageData?.campaign.uuid,
      theme: props.pageData?.theme,
      locale: props.pageData?.locale,
      apiBaseUrl: props.apiBaseUrl,
      locale: props.pageData?.locale,
    });
  } else {
    console.error("Voces widget script not loaded or page data missing");
  }
});
</script>
