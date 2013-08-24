# script-runner

A very simple library for running scripts on a file system.

## Usage

    require 'script-runner'
    error_handler = lamba{ |script_path| raise "an error occured with: #{script_path}" }
    ScriptRunner.run( ["path-one", "path-two"], ["env-one"], error_handler ){ |script_output| puts script_output}
    

### installation

    cd script-runner
    gem install bundler
    bundle install
    rake # run tests
    rake build # make .gem file
    gem install pkg/script-runner-0.0.1.gem
