{CucumberTestRunner} = require '../lib/test_runner'

describe "CucumberTestRunner", ->

  beforeEach ->
    @callback = jasmine.createSpy 'callback'
    @runner   = new CucumberTestRunner '/path/to/file', @callback

  describe '::args', ->
    it "defaults to []", ->
      expect(@runner.args).toEqual []

  describe '::command', ->
    it "defaults to 'rspec'", ->
      expect(@runner.command).toEqual 'cucumber'
