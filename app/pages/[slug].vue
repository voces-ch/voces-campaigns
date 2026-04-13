<template>
  <div>
    <div v-if="pending" class="p-8 text-center text-gray-500">
      Loading campaign...
    </div>
    <div v-else-if="error" class="p-8 text-center text-red-500">
      Campaign not found.
    </div>

    <NuxtLayout
      v-else
      :name="pageData?.theme || 'minimal'"
      :pageData="pageData"
      :apiBaseUrl="apiBaseUrl"
    >
      <article v-html="parsedContent"></article>
    </NuxtLayout>
  </div>
</template>

<script setup>
import { computed, onMounted } from "vue";
import { useRoute } from "vue-router";
import parser from "editorjs-html";

definePageMeta({
  layout: false,
});
const route = useRoute();
const config = useRuntimeConfig();

const apiBaseUrl = computed(() => config.public.apiBase);
const campaignUuid = computed(() => pageData.value?.campaign_uuid || null);
const theme = computed(() => pageData.value?.theme || "minimal");
const locale = computed(() => pageData.value?.locale || "de");

const {
  data: response,
  pending,
  error,
} = await useFetch(
  `${config.public.apiBase}/campaign-pages/${route.params.slug}`,
);

const pageData = computed(() => response.value?.data || null);

const edjsParser = parser();
const parsedContent = computed(() => {
  if (!pageData.value || !pageData.value.content) return "";

  let contentObj = pageData.value.content;

  if (typeof contentObj === "string") {
    try {
      contentObj = JSON.parse(contentObj);
    } catch (e) {
      console.error("Could not parse Editor.js string:", e);
      return "";
    }
  }

  if (!contentObj.blocks || !Array.isArray(contentObj.blocks)) {
    return "";
  }

  try {
    return edjsParser.parse(contentObj);
  } catch (e) {
    console.error("EditorJS parsing error:", e);
    return "<p>Error loading page content.</p>";
  }
});

useHead({
  title: computed(() =>
    pageData.value?.title ? `${pageData.value.title} - voces.ch` : "Campaign",
  ),
  script: [
    {
      src: config.public.widgetUrl,
      defer: true,
    },
  ],
});
</script>
