RubyQuickTestView = require './ruby-quick-test-view'

module.exports =
  configDefaults:
    rspecCommand: "rspec"

  rubyQuickTestView: null

  activate: (state) ->
    atom.config.setDefaults "ruby-quick-test",
      rspecCommand: "rspec"

    @rubyQuickTestView = new RubyQuickTestView(state.rubyQuickTestViewState)

  deactivate: ->
    @rubyQuickTestView.destroy()

  serialize: ->
    rubyQuickTestViewState: @rubyQuickTestView.serialize()
