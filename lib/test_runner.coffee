{BufferedProcess} = require 'atom'

module.exports =
class TestRunner
  constructor: (testFile, callback)->
    @testResult = ''
    @callback = callback
    @testFile = testFile

  runTests: ->
    @testResult = ''
    new BufferedProcess
      command: 'ruby'
      args: ['-I', 'test', @testFile]
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
