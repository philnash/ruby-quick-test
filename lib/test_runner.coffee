{BufferedProcess} = require 'atom'
ChildProcess = require 'child_process'

class TestRunner
  args: ['-I', 'test']
  command: 'ruby'
  process: BufferedProcess

  constructor: (testFile, callback, opts)->
    @testResult = ''
    @callback = callback
    @testFile = testFile
    @opts = opts || {}

  collectResults: (output) =>
    @testResult += output.toString()
    @returnCallback()

  exit: (code) =>
    @returnCallback()

  processParams: ->
    fileArg = if @opts.lineNumber
      "#{@testFile}:#{@opts.lineNumber}"
    else
      @testFile
    command: @command
    args: @args.concat(fileArg)
    options:
      cwd: atom.project.getPath()
    stdout: @collectResults
    stderr: @collectResults
    exit: @exit

  returnCallback: =>
    @callback(@testFile, @testResult)

  runTests: ->
    @testResult = ''
    @runCommand(@processParams())
    @returnCallback()

  runCommand: (params) ->
    command = "#{params.command} #{params.args}"
    spawn = ChildProcess.spawn
    terminal = spawn("bash", ["-l"])
    terminal.on 'close', params.exit
    terminal.stdout.on 'data', params.stdout
    terminal.stderr.on 'data', params.stderr
    terminal.stdin.write("cd #{params.options.cwd} && #{command}\n")
    terminal.stdin.write("exit\n")


class RspecTestRunner extends TestRunner
  command: atom.config.get("ruby-quick-test.rspecCommand") || 'rspec'
  args: []

class CucumberTestRunner extends TestRunner
  command: 'cucumber'
  args: []

module.exports =
  TestRunner: TestRunner
  RspecTestRunner: RspecTestRunner
  CucumberTestRunner: CucumberTestRunner
