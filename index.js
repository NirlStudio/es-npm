'use strict'

var path = require('path')
var eslang = require('eslang')
var modules = require('eslang/modules')

// expose some native modules.
modules.register(require('./modules.js'))

// create the void.
var $void = eslang()

// prepare the path of app home directory.
var appHome = path.join(__dirname, 'es')

if (require.main === module) {
  // running as an app.
  var args = global.process.argv.slice(2) || []
  module.exports = $void.$run('app', args, appHome)
} else {
  // running as a module (exposing Espresso module to JS code)
  var being = $void.createBootstrapSpace(path.join(appHome, '@'))
  module.exports = being.$import('cli')
}
