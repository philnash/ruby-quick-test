{BufferedProcess} = require 'atom'

class TestRunner
  args: ['-I', 'test']
  command: 'ruby'
  processClass: BufferedProcess

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
    command: "bash"
    args: ["-l"]
    options:
      cwd: atom.project.getPath()
    stdout: @collectResults
    stderr: @collectResults
    exit: @exit

  returnCallback: =>
    @callback(@testFile, @testResult)

  runTests: ->
    @testResult = ''
    @executeProcess()
    @returnCallback()

  executeProcess: ->
    process = new @processClass @processParams()
    stdin = process.process.stdin
    stdin.write "#{@fullCommand()} && exit\n"

  fullCommand: ->
    args = @args.concat(@testFile)
    "#{@command} #{args}"

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
