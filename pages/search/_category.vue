<template>
  <ais-instant-search-ssr>
    <ais-search-box />
    <ais-stats />
    <ais-refinement-list attribute="brand" />
    <ais-hits>
      <template
        slot="item"
        slot-scope="{ item }"
      >
        <p>
          <ais-highlight
            attribute="name"
            :hit="item"
          />
        </p>
        <p>
          <ais-highlight
            attribute="brand"
            :hit="item"
          />
        </p>
      </template>
    </ais-hits>
    <ais-pagination />
  </ais-instant-search-ssr>
</template>

<script>
"use strict";

import algoliasearch from "algoliasearch/lite";

import { AisInstantSearchSsr } from "vue-instantsearch";
import { AisSearchBox } from "vue-instantsearch";
import { AisStats } from "vue-instantsearch";
import { AisRefinementList } from "vue-instantsearch";
import { AisHits } from "vue-instantsearch";
import { AisHighlight } from "vue-instantsearch";
import { AisPagination } from "vue-instantsearch";
import { createInstantSearch } from "vue-instantsearch";
import { history as historyRouter } from "instantsearch.js/es/lib/routers";

const searchClient = algoliasearch("latency", "6be0576ff61c053d5f9a3225e2a90f76");

function getCategorySlug(name) {
  return name
    .split(" ")
    .map(encodeURIComponent)
    .join("+");
}

function getCategoryName(slug) {
  return slug
    .split("+")
    .map(decodeURIComponent)
    .join(" ");
}

const routing = {
  router: process.client && historyRouter({
    windowTitle({ category, query }) {
      const queryTitle = query ? `Results for "${query}"` : 'Search';

      if (category) {
        return `${category} – ${queryTitle}`;
      }

      return queryTitle;
    },

    createURL({ qsModule, routeState, location }) {
      const urlParts = location.href.match(/^(.*?)\/search/);
      const baseUrl = `${urlParts ? urlParts[1] : ''}/`;

      const categoryPath = routeState.category
        ? `${getCategorySlug(routeState.category)}/`
        : '';
      const queryParameters = {};

      if (routeState.query) {
        queryParameters.query = encodeURIComponent(routeState.query);
      }
      if (routeState.page !== 1) {
        queryParameters.page = routeState.page;
      }
      if (routeState.brands) {
        queryParameters.brands = routeState.brands.map(encodeURIComponent);
      }

      const queryString = qsModule.stringify(queryParameters, {
        addQueryPrefix: true,
        arrayFormat: 'repeat',
      });

      return `${baseUrl}search/${categoryPath}${queryString}`;
    },

    parseURL({ qsModule, location }) {
      const pathnameMatches = location.pathname.match(/search\/(.*?)\/?$/);
      const category = getCategoryName(
        (pathnameMatches && pathnameMatches[1]) || ''
      );
      const { query = '', page, brands = [] } = qsModule.parse(
        location.search.slice(1)
      );
      // `qs` does not return an array when there's a single value.
      const allBrands = Array.isArray(brands)
        ? brands
        : [brands].filter(Boolean);

      return {
        query: decodeURIComponent(query),
        page,
        brands: allBrands.map(decodeURIComponent),
        category,
      };
    },
  }),

  stateMapping: {
    stateToRoute(uiState) {
      return {
        query: uiState.query,
        page: uiState.page,
        brands: uiState.refinementList && uiState.refinementList.brand,
        category: uiState.menu && uiState.menu.categories,
      };
    },

    routeToState(routeState) {
      return {
        query: routeState.query,
        page: routeState.page,
        menu: {
          categories: routeState.category,
        },
        refinementList: {
          brand: routeState.brands,
        },
      };
    },
  },
};

const { instantsearch, rootMixin } = createInstantSearch({
  searchClient,
  indexName: "instant_search",
  routing
});

export default {
  layout: "app",

  asyncData() {
    return instantsearch.findResultsState({
      query: "iphone",
      hitsPerPage: 5,
      disjunctiveFacets: ["brand"],
      disjunctiveFacetsRefinements: { brand: ["Apple"] }
    }).then(function() {
      instantSearchState: instantsearch.getState()
    });
  },

  beforeMount() {
    instantsearch.hydrate(this.instantSearchState)
  },

  mixins: [rootMixin],

  components: {
    AisHighlight,
    AisHits,
    AisInstantSearchSsr,
    AisPagination,
    AisRefinementList,
    AisSearchBox,
    AisStats
  },

  data() {
    return {
      searchClient
    };
  },

  head() {
    return {
      link: [
        {
          rel: "stylesheet",
          href: "https://cdn.jsdelivr.net/npm/instantsearch.css@7.3.1/themes/algolia-min.css"
        }
      ]
    };
  }
};
</script>
