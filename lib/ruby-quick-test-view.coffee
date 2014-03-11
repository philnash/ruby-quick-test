{$, View} = require 'atom'
TestRunner = require './test_runner'

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
    @testRunner = new TestRunner(this)
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

  runTests: (e)=>
    if @isRubyTestFile()
      @testRunner.runTests(@activeFile(), @render)
      @showPanel()
    else
      e.abortKeyBinding()

  reRunTests: (e)=>
    if @testRunner.hasTestFile()
      @testRunner.reRunTests()
      @showPanel()
    else
      e.abortKeyBinding()

  activeFile: ->
    atom.project.relativize(atom.workspace.getActiveEditor().buffer.file.path)

  isRubyTestFile: ->
    !!@activeFile().match(/_test\.rb$/)
