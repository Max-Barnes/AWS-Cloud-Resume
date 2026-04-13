const { defineConfig } = require("cypress");

module.exports = defineConfig({
  allowCypressEnv: false,
  chromeWebSecurity: false,
  e2e: {
    setupNodeEvents(on, config) {
      // implement node event listeners here
    },
    baseUrl: "http://localhost:5500",
  },
});
