'use strict'
/**
 * all native modules must be explicitly exposed to sugly code.
 */

function copy (source, exporting) {
  // In real world, native members can be filtered before exporting.
  Object.assign(exporting, source)
  return true
}

module.exports = function (uri) {
  switch (uri) {
    case 'fs':
      return copy.bind(null, require('fs'))
    case 'path':
      return copy.bind(null, require('path'))
    case 'shelljs':
      return copy.bind(null, require('shelljs'))
    default:
      console.warn('Sugly code is requesting for an unknown module:', uri)
      return null
  }
}
