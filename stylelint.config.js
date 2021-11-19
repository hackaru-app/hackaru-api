module.exports = {
  plugins: ['stylelint-order'],
  extends: ['stylelint-config-standard-scss', 'stylelint-config-prettier'],
  overrides: [
    {
      files: ['**/*.scss'],
      customSyntax: 'postcss-scss',
    },
  ],
};
