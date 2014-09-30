{assert} = require('chai')
{exec} = require('child_process')


CMD_PREFIX = ''

stderr = ''
stdout = ''
report = ''
exitStatus = null

execCommand = (cmd, callback) ->
  stderr = ''
  stdout = ''
  report = ''
  exitStatus = null

  cli = exec CMD_PREFIX + cmd, (error, out, err) ->
    stdout = out
    stderr = err
    try
      report = JSON.parse out

    if error
      exitStatus = error.code

  exitEventName = if process.version.split('.')[1] is '6' then 'exit' else 'close'

  cli.on exitEventName, (code) ->
    exitStatus = code if exitStatus == null and code != undefined
    callback()

describe "Command line interface", ->

  describe "When raml file not found", (done) ->
    before (done) ->
      cmd = "./bin/csonschema ./test/fixtures/nonexistent_path.schema"

      execCommand cmd, done

    it 'should exit with status 1', ->
      assert.equal exitStatus, 1

    it 'should print error message to stderr', ->
      assert.include stderr, 'Error: ENOENT, '

  describe "When executed with no arguments", ->
    before (done) ->
      cmd = "./bin/csonschema"

      execCommand cmd, done

    it 'should exit with status 1', ->
      assert.equal exitStatus, 1

    it 'should print error message to stderr', ->
      assert.include stderr, 'Error: Must specify path to schema file.'

  describe "Arguments with validated raml", ->

    before (done) ->
      cmd = "./bin/csonschema ./test/fixtures/sample1.schema"

      execCommand cmd, done

    it 'should exit with status 0', ->
      assert.equal exitStatus, 0

    it 'should be a valid jsonschema', ->
      assert.equal report.$schema, 'http://json-schema.org/draft-04/schema'
