{BufferedProcess} = require 'atom'

class TestRunner
  args: ['-I', 'test']
  command: 'ruby'

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
    command: @fullCommand(),
    cwd:     atom.project.getPath(),
    stdout:  @collectResults,
    stderr:  @collectResults,
    exit:    @exit

  returnCallback: =>
    @callback(@testFile, @testResult)

  runTests: ->
    @testResult = ''
    ProcessRunner.run(@processParams())
    @returnCallback()

  fullCommand: ->
    args = @args.concat(@testFile)
    "#{@command} #{args}"

class ProcessRunner
  @run: (opts) ->
    p = new ProcessRunner(opts)
    p.run()

  constructor: (opts) ->
    @cwd = opts.cwd
    @command = opts.command
    @stdout = opts.stdout
    @stderr = opts.stderr
    @exit = opts.exit

  run: ->
    p = new BufferedProcess(@processParams())
    stdin = p.process.stdin
    stdin.write "#{@command} && exit\n"

  processParams: ->
    command: "bash"
    args: ["-l"]
    options:
      cwd: @cwd
    stdout: @stdout
    stderr: @stderr
    exit: @exit

class RspecTestRunner extends TestRunner
  command: 'rspec'
  args: []

class CucumberTestRunner extends TestRunner
  command: 'cucumber'
  args: []

module.exports =
  TestRunner: TestRunner
  ProcessRunner: ProcessRunner
  RspecTestRunner: RspecTestRunner
  CucumberTestRunner: CucumberTestRunner
