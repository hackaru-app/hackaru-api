const path = require('path');
const glob = require('glob');
const MiniCssExtractPlugin = require('mini-css-extract-plugin');
const { WebpackManifestPlugin } = require('webpack-manifest-plugin');
const CopyPlugin = require('copy-webpack-plugin');

const assetsDir = './app/assets';

function omitExt(assetPath) {
  const extname = path.extname(assetPath);
  return assetPath.replace(extname, '');
}

function toAssetHash(assetPath) {
  return [omitExt(assetPath), `${assetsDir}/${assetPath}`];
}

function buildEntries(pattern) {
  const entries = glob.sync(pattern, { cwd: assetsDir }).map(toAssetHash);
  return Object.fromEntries(entries);
}

module.exports = {
  entry: {
    ...buildEntries('javascripts/views/**/*.js'),
    ...buildEntries('stylesheets/views/**/*.scss'),
  },
  plugins: [
    new MiniCssExtractPlugin(),
    new CopyPlugin({
      patterns: [
        {
          from: `${assetsDir}/images/**/*.png`,
          to: 'images/[name]-[contenthash][ext]',
        },
      ],
    }),
    new WebpackManifestPlugin({
      fileName: 'manifest.json',
      publicPath: '/packs/',
    }),
  ],
  module: {
    rules: [
      {
        test: /\.scss$/,
        use: [
          MiniCssExtractPlugin.loader,
          'css-loader',
          'sass-loader',
          {
            loader: 'style-resources-loader',
            options: {
              patterns: ['./app/assets/stylesheets/modules/*.scss'],
            },
          },
        ],
      },
    ],
  },
  output: {
    filename: '[name]-[contenthash].js',
    path: path.resolve(__dirname, 'public/packs'),
    clean: true,
  },
};
