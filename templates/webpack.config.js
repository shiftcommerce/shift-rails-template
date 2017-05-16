const webpack = require('webpack')
const path = require('path')

const config  = {
  context: path.resolve(__dirname, './app/assets/javascripts'),
  entry: ['./index.js'],
  output: {
    path: path.join(__dirname, 'public'),
    filename: 'bundle.js'
  },
  module: {
    rules: [
      {
        test: /\.(png|jpe?g|gif|svg)$/,
        use: ['file-loader?name=[name]-[hash].[ext]&publicPath=/images/&outputPath=images/']
      },
      {
        test: /\.(scss|css)$/,
        use: ['style-loader', 'css-loader']
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
  ]
}

if(process.env.NODE_ENV === 'development'){

  config.devServer = {
    port: process.env.PORT || 3000,
    compress: true,
    contentBase: path.join(__dirname, 'public'),
    historyApiFallback: {
      index: 'public/index.html'
    },
    headers:{
      'Content-Type': 'text/html'
    },
    disableHostCheck: true
  }

}


module.exports = config
