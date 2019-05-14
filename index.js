'use strict'

var path = require('path')
var sugly = require('sugly')
var modules = require('sugly/modules')

// expose some native modules.
modules.register(require('./modules.js'))

// create the void.
var $void = sugly()

// prepare the path of app home directory.
var srcHome = path.join(__dirname, 'sugly')

if (require.main === module) {
  // running as an app.
  var args = global.process.argv.slice(2) || []
  module.exports = $void.$run('app', args, srcHome)
} else {
  // running as a module (exposing sugly module to JS code)
  var being = $void.createBootstrapSpace(path.join(srcHome, '@'))
  module.exports = being.$import('module')
}
