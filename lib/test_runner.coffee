{BufferedProcess} = require 'atom'

class TestRunner
  args: ['-I', 'test']
  command: 'ruby'
  process: BufferedProcess

  constructor: (testFile, callback)->
    @testResult = ''
    @callback = callback
    @testFile = testFile

  collectResults: (output) =>
    @testResult += output.toString()
    @returnCallback()

  exit: (code) =>
    @returnCallback()

  processParams: ->
    command: @command
    args: @args.concat(@testFile)
    options:
      cwd: atom.project.getPaths()[0]
    stdout: @collectResults
    stderr: @collectResults
    exit: @exit

  returnCallback: =>
    @callback(@testFile, @testResult)

  runTests: ->
    @testResult = ''
    new @process @processParams()
    @returnCallback()

class RspecTestRunner extends TestRunner
  command: 'rspec'
  args: []

class CucumberTestRunner extends TestRunner
  command: 'cucumber'
  args: []

module.exports =
  TestRunner: TestRunner
  RspecTestRunner: RspecTestRunner
  CucumberTestRunner: CucumberTestRunner
