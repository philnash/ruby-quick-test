{BufferedProcess} = require 'atom'

module.exports =
class TestRunner
  constructor: (view)->
    @view = view
    @testResult = ''
    @testFile = ''

  hasTestFile: ()->
    @testFile.length > 0

  runTests: (testFile, callback)->
    @testResult = ''
    @callback = callback
    @testFile = testFile
    @createProcess()
    @returnCallback()

  reRunTests: ()->
    @testResult = ''
    @createProcess()
    @returnCallback()

  createProcess: ()->
    new BufferedProcess
      command: 'ruby'
      args: ['-I', 'test', @testFile]
      options:
        cwd: atom.project.getPath()
      stdout: @collectResults
      stderr: @collectResults
      exit: @exit

  collectResults: (output)=>
    @testResult += output.toString()
    @returnCallback()

  exit: (code)=>
    @returnCallback()

  returnCallback: =>
    @callback(@testFile, @testResult)
