{BufferedProcess} = require 'atom'

class TestRunner
  command: 'ruby'
  args: ['-I', 'test']
  
  constructor: (testFile, callback)->
    @testResult = ''
    @callback = callback
    @testFile = testFile

  runTests: ->
    @testResult = ''
    new BufferedProcess
      command: @command
      args: @args.concat(@testFile)
      options:
        cwd: atom.project.getPath()
      stdout: @collectResults
      stderr: @collectResults
      exit: @exit
    @returnCallback()

  collectResults: (output)=>
    @testResult += output.toString()
    @returnCallback()

  exit: (code)=>
    @returnCallback()

  returnCallback: =>
    @callback(@testFile, @testResult)

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
