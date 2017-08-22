const webpack = require('webpack')
const path = require('path')

let host = ''
if(process.env.NODE_ENV === 'development') {
  host = 'http://localhost:4000'
}

const config  = {
  entry: [
    'url-search-params-polyfill',
    path.resolve(__dirname, './app/assets/javascripts/index.js')
  ],
  output: {
    path: path.join(__dirname, 'public'),
    filename: 'bundle.js'
  },
  module: {
    rules: [
      {
        test: /\.(png|jpe?g|gif|svg)$/,
        use: [`file-loader?name=[name]-[hash].[ext]&publicPath=${host}/images/&outputPath=images/`]
      },
      {
        test: /\.(scss)$/,
        use: ['style-loader', 'css-loader']
      },
      {
        test: /\.(scss)$/,
        loader: 'sass-loader',
        options: {
          includePaths:[
            'shift-admin-ui-kit/src/stylesheets'
          ]
        }
      },
      {
        test: /\.js$/,
        exclude: /node_modules/,
        use: ['babel-loader']
      }
    ]
  },
  plugins: [
    new webpack.DefinePlugin({
      DEVELOPMENT: process.env.NODE_ENV === 'development',
      API_HOST: JSON.stringify(process.env.API_HOST)
    })
  ],
  resolve: {
    extensions: ['.react.js', '.js', '.jsx', '.scss', '.svg'],
    modules: [
      "node_modules"
    ]
  }
}

if(process.env.NODE_ENV === 'development'){

  config.devServer = {
    port: process.env.PORT || 3000,
    compress: true
  }

}

module.exports = config
