# script-runner

A very simple library for running scripts on a file system.

## Usage

    require 'script-runner'
    ScriptRunner.run( array_of_paths, array_of_env_paths, error_handler, &handle_script_output )

## Example

If we have the following file structure


    path-one/
      script.sh
    path-two/
      path-two-one/
        script.sh
      script.sh
    env-one/
      one.properties

The following:

    require 'script-runner'
    error_handler = lamba{ |script_path| raise "an error occured with: #{script_path}" }
    ScriptRunner.run( ["path-one", "path-two"], ["env-one"], error_handler ){ |script_output| puts script_output}

Will:
* set env vars as defined in `env-one/one.properties`
* run `path-one/script.sh`, `path-two/path-two-one/script.sh`, `path-two/script.sh` - with the env vars defined
* the output will be sent to the console using `puts`
* any errors will call `error_handler`

Note: for each root_path, all files under are invoked in alphabetical order

### installation

    cd script-runner
    gem install bundler
    bundle install
    rake # run tests
    rake build # make .gem file
    gem install pkg/script-runner-0.0.1.gem


### Changelog
0.0.7 - min ruby version now 1.9.3
0.0.6 - add your own logger if you want
0.0.5 - only set env if there are scripts to run
0.0.4 - fixed dependency on logging
0.0.3 - Added logging
0.0.2 - Added mit license
0.0.1 - First version
