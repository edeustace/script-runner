require 'logging'
require 'script-runner/main'

module ScriptRunner

  # Run a set of scripts
  #
  # Note: non executable files are skipped and a warning is sent to the console
  #
  # @paths - an array of paths with scripts to invoke
  # @env_vars - an array of paths that contains .properties files
  # @options -
  # -- :error_handler - a lambda that gets passed the script file path that exited with a non zero value
  # -- :log_level - one of :debug, :info, :warn, :errror
  # @block - a block to handle the output of the script if non is given it is sent to the console
  def self.run( paths, env_vars, options = {}, &block)

    Logging.appenders.stdout(
      :layout => Logging.layouts.pattern(:pattern => '[%c][%-5l] %m\n'),
      :color_scheme => 'bright')

    logger = Logging.logger['script-runner']
    logger.add_appenders(Logging.appenders.stdout)
    logger.level = options[:log_level] || :warn

    runner = ScriptRunner::Main.new(logger)
    error_handler = options[:error_handler]
    runner.run(paths, env_vars, error_handler, &block)
  end

end
