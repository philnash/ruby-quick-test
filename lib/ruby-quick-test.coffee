RubyQuickTestView = require './ruby-quick-test-view'

module.exports =
  rubyQuickTestView: null

  activate: (state) ->
    @rubyQuickTestView = new RubyQuickTestView(state.rubyQuickTestViewState)

  deactivate: ->
    @rubyQuickTestView.destroy()

  serialize: ->
    rubyQuickTestViewState: @rubyQuickTestView.serialize()
