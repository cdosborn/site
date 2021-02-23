module.exports = {
  // plugins: [
  //   "unused-imports"
  // ],
  "parserOptions": {
    "ecmaVersion": 2020
  },

  "env": {
    "es6": true
  },
  extends: [
    "eslint:recommended",
    "plugin:react/recommended",
    "plugin:react-hooks/recommended"
  ],
  rules: {
    "eqeqeq": ["error", "smart"],
    /* replace default no-unused-vars with a plugin, which will allow us to
     * run autofix to cleanup unused imports */
    // "@typescript-eslint/no-unused-vars": "off",
    // "unused-imports/no-unused-imports-ts": "error",
    // "unused-imports/no-unused-vars-ts": "error"
  }
};
