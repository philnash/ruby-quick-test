{BufferedProcess} = require 'atom'
testRunnerNamespace = require '../lib/test_runner'
{TestRunner, ProcessRunner} = testRunnerNamespace

describe "TestRunner", ->

  beforeEach ->
    @callback = jasmine.createSpy 'callback'
    @runner   = new TestRunner '/path/to/file', @callback

  describe '::args', ->
    it "defaults to ['-I', 'test']", ->
      expect(@runner.args).toEqual ['-I', 'test']

  describe '::command', ->
    it "defaults to 'ruby'", ->
      expect(@runner.command).toEqual 'ruby'

  describe '::processParams', ->
    it 'contains a parameters object', ->
      object =
        command: @runner.fullCommand()
        cwd: atom.project.getPath()
        stdout: @runner.collectResults
        stderr: @runner.collectResults
        exit: @runner.exit
      expect(@runner.processParams()).toEqual object

  describe '::collectResults', ->

    it "appends the given arguments to ::testResult", ->
      result = "A test result"
      @runner.collectResults result
      expect(@runner.testResult).toEqual result

    it "invokes ::returnCallback", ->
      spyOn @runner, 'returnCallback'
      @runner.collectResults ''
      expect(@runner.returnCallback).toHaveBeenCalled()

  describe '::runTests', ->
    it "runs a ProcessRunner", ->
      spyOn(ProcessRunner, 'run').andCallThrough()
      @runner.runTests()
      expect(ProcessRunner.run).toHaveBeenCalledWith(@runner.processParams())

    it "resets the ::testResult string", ->
      @runner.testResult = "Previous test results"
      @runner.runTests()
      expect(@runner.testResult).toEqual ''

    it "invokes ::returnCallback", ->
      spyOn @runner, 'returnCallback'
      @runner.runTests()
      expect(@runner.returnCallback).toHaveBeenCalled()

  describe '::exit', ->
    it "invokes ::returnCallback", ->
      spyOn @runner, 'returnCallback'
      @runner.exit()
      expect(@runner.returnCallback).toHaveBeenCalled()

  describe '::returnCallback', ->
    it "invokes ::callback with ::testFile and ::testResult", ->
      @runner.returnCallback()
      expect(@callback).toHaveBeenCalledWith @runner.testFile,
        @runner.testResult
