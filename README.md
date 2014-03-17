# Ruby Quick Test

Run your `TestUnit`, `RSpec` and `Cucumber` ruby test files from within [Atom](http://atom.io). Inspired by [Sublime Test Ruby-Test](https://github.com/maltize/sublime-text-2-ruby-tests).

![Ruby Quick Test screenshot](https://raw.github.com/philnash/ruby-quick-test/master/screenshots/ruby-quick-test-demo.png)

## Installing

Use the Atom package manager, which can be found in the Settings view or run `apm install ruby-quick-test` from the command line.

## Usage

Ruby Quick Test can be used to quickly run a test file with a file name that matches the pattern `/_(test|spec)\.rb$/` or `/.(feature)$/`. Test files ending in `_test.rb` will be run using the `ruby` command, files ending `_spec.rb` will be run with the `rspec` command and files ending `.feature` will be run with the `cucumber` command.

When the active editor is using such a file, you can run the tests with the key combination `cmd-ctrl-t` or by using the command palette (`cmd-shift-p`).

This currently doesn't cover `MiniTest::Spec` style files, but support is planned for those soon.

### Commands

* `cmd-ctrl-t` - Run the current test file
* `cmd-ctrl-e` - Re-run the previous test file
* `cmd-ctrl-x` - Show/hide the test panel

## Todo

* Tests!
* `MiniTest::Spec` support
* Support for running individual tests
* Run the entire test suite using `rake test`, `rake spec` or `rake cucumber`
* [Issues/pull requests](https://github.com/philnash/ruby-quick-test/issues) welcome
