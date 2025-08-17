module.exports = {
  rules: {
    "no-restricted-imports": [
      "error",
      {
        patterns: [
          {
            group: ["**/components/ui/*", "**/components/shared/*"],
            message: "Use @app-oint/design-system components",
          },
        ],
      },
    ],
  },
};

