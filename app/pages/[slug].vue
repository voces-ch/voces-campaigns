<template>
  <div>
    <div v-if="pending" class="p-8 text-center text-gray-500">
      Loading campaign...
    </div>
    <div v-else-if="error" class="p-8 text-center text-red-500">
      Campaign not found.
    </div>

    <NuxtLayout v-else :name="pageData?.theme || 'default'">
      <article
        class="prose prose-lg max-w-none mb-12"
        v-html="parsedContent"
      ></article>

      <div class="border-t border-gray-200/50 pt-10 mt-10">
        <div id="voces-widget-container"></div>
      </div>
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

// 1. Fetch data from your Laravel API
// UPDATE THIS URL TO MATCH YOUR LOCAL BACKEND!
const {
  data: response,
  pending,
  error,
} = await useFetch(
  `${config.public.apiBase}/campaign-pages/${route.params.slug}`,
);

const pageData = computed(() => response.value?.data || null);

// 2. Parse Editor.js JSON to HTML
const edjsParser = parser();
const parsedContent = computed(() => {
  // 1. Bail early if data isn't ready
  if (!pageData.value || !pageData.value.content) return "";

  // 2. Safely grab the content
  let contentObj = pageData.value.content;

  // 3. Just in case Laravel sent it as a string, parse it back to an object
  if (typeof contentObj === "string") {
    try {
      contentObj = JSON.parse(contentObj);
    } catch (e) {
      console.error("Could not parse Editor.js string:", e);
      return "";
    }
  }

  // 4. Ensure the blocks array actually exists before parsing
  if (!contentObj.blocks || !Array.isArray(contentObj.blocks)) {
    return "";
  }

  // 5. Parse and join safely!
  try {
    return edjsParser.parse(contentObj);
  } catch (e) {
    console.error("EditorJS parsing error:", e);
    return "<p>Error loading page content.</p>";
  }
});

// 3. Set SEO Meta Tags dynamically!
useHead({
  title: computed(() =>
    pageData.value?.title ? `${pageData.value.title} - voces.ch` : "Campaign",
  ),
  // Inject your widget script globally
  script: [
    {
      // UPDATE THIS TO YOUR LOCAL WIDGET SCRIPT URL!
      src: config.public.widgetUrl,
      defer: true,
    },
  ],
});

// 4. Fire the widget once the DOM is ready
onMounted(() => {
  // Give the script a tiny fraction of a second to parse just in case
  setTimeout(() => {
    if (window.voces && window.voces.widget && pageData.value) {
      window.voces.widget({
        target: "#voces-widget-container",
        campaignUuid: pageData.value.campaign_uuid,
        theme: pageData.value.theme || "minimal",
        locale: pageData.value.locale || "de",
      });
    } else {
      console.error("voces widget script not loaded or page data missing");
    }
  }, 100);
});
</script>

<style>
/* Optional: A little bit of styling for the parsed Editor.js HTML so it isn't completely raw */
.prose h2 {
  font-size: 1.8rem;
  font-weight: 700;
  margin-top: 2rem;
  margin-bottom: 1rem;
}
.prose h3 {
  font-size: 1.4rem;
  font-weight: 600;
  margin-top: 1.5rem;
  margin-bottom: 0.5rem;
}
.prose p {
  margin-bottom: 1rem;
  line-height: 1.6;
}
</style>
