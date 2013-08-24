require 'script-runner/main'

module ScriptRunner

  # Run a set of scripts
  #
  # Note: non executable files are skipped and a warning is sent to the console
  #
  # @paths - an array of paths with scripts to invoke
  # @env_vars - an array of paths that contains .properties files
  # @error_handler - a callback if a non-zero exit code occured
  # @block - a block to handle the output of the script if non is given it is sent to the console
  def self.run( paths, env_vars, error_handler = nil, &block)
    runner = ScriptRunner::Main.new
    runner.run(paths, env_vars, error_handler, &block)
  end

end
