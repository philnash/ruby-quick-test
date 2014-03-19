{RspecTestRunner} = require '../lib/test_runner'

describe "RspecTestRunner", ->

  beforeEach ->
    @callback = jasmine.createSpy 'callback'
    @runner   = new RspecTestRunner '/path/to/file', @callback

  describe '::args', ->
    it "defaults to []", ->
      expect(@runner.args).toEqual []

  describe '::command', ->
    it "defaults to 'rspec'", ->
      expect(@runner.command).toEqual 'rspec'
