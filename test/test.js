var assert = require('assert')

describe('es/cli', function () {
  var cli = require('../index.js')

  describe('cli', function () {
    it('command "init" is exported as a function', function () {
      assert(typeof cli.init === 'function')
    })
  })
})
