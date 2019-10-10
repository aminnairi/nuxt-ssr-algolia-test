"use strict";

module.exports = {
  server: {
    port: 1234,
    host: "0.0.0.0"
  },

  build: {
    transpile: [
      "vue-instantsearch",
      "instantsearch.js/es"
    ]
  }
};
