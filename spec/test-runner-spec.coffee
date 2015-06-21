{BufferedProcess} = require 'atom'
{TestRunner}      = require '../lib/test_runner'

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
        command: @runner.command
        args: @runner.args.concat(@runner.testFile)
        options:
          cwd: atom.project.getPaths()[0]
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

    it "creates a BufferedProcess", ->
      spyOn @runner, 'process'
      @runner.runTests()
      expect(@runner.process).toHaveBeenCalledWith @runner.processParams()

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
