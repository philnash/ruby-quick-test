{$, View} = require 'atom'
{TestRunner, RspecTestRunner, CucumberTestRunner} = require './test_runner'

module.exports =
class RubyQuickTestView extends View
  @content: ->
    @div class: "inset-panel panel-bottom ruby-quick-test", =>
      @div class: "panel-heading", =>
        @span 'Running tests: '
        @span outlet: 'header'
      @div class: "panel-body padded results", =>
        @pre '', outlet: 'results'

  initialize: (serializeState) ->
    atom.workspaceView.command "ruby-quick-test:run-tests", @runTests
    atom.workspaceView.command "ruby-quick-test:re-run-last-test", @reRunTests
    atom.workspaceView.command "ruby-quick-test:toggle", @togglePanel
    @subscribe atom.workspaceView, "core:cancel", @hidePanel

  # Returns an object that can be retrieved when package is activated
  serialize: ->

  # Tear down any state and detach
  destroy: ->
    delete @testRunner
    @detach()

  render: (header, results)=>
    @header.text(header)
    @results.text(results)

  hidePanel: =>
    @detach() if @hasParent()

  showPanel: =>
    atom.workspaceView.prependToBottom(this) unless @hasParent()

  togglePanel: =>
    if @hasParent() then @hidePanel() else @showPanel()

  newTestRunner: (klass)->
    delete @testRunner if @testRunner?
    @testRunner = new klass(@activeFile(), @render)
    @testRunner.runTests()
    @showPanel()

  runTests: (e)=>
    switch @testFileType()
      when 'test' then @newTestRunner(TestRunner)
      when 'spec' then @newTestRunner(RspecTestRunner)
      when 'feature' then @newTestRunner(CucumberTestRunner)
      else e.abortKeyBinding()

  reRunTests: (e)=>
    if @testRunner?
      @testRunner.runTests()
      @showPanel()
    else
      e.abortKeyBinding()

  activeFile: ->
    atom.project.relativize(atom.workspace.getActiveEditor().buffer.file.path)

  testFileType: ->
    if matches = @activeFile().match(/_(test|spec)\.rb$/)
      matches[1]
    else if matches = @activeFile().match(/.(feature)$/)
      matches[1]
