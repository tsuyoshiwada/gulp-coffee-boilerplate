webpack = require("webpack")
BowerWebpackPlugin = require("bower-webpack-plugin")
path = require("path")

{isProduction} = global

devtool = if isProduction then null else "#source-map"


module.exports = 

  entry:
    app: "./src/coffee/app.coffee"

  output:
    path: path.join(__dirname, "dist/js")
    filename: "[name].bundle.js"

  devtool: devtool

  resolve:
    root: [
      path.join(__dirname, "bower_components")
      path.join(__dirname, "node_modules")
    ]
    moduleDirectories: [
      "bower_components"
      "node_modules"
    ]
    extensions: ["", ".js", ".coffee", ".webpack.js", ".web.js"]

  module:
    loaders: [
      {test: /\.coffee$/, loader: "coffee-loader"}
    ]

  plugins: [
    new BowerWebpackPlugin()
  ]
