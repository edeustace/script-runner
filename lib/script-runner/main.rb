require 'logging'

module ScriptRunner

  class Main

    def initialize(logger)
      @logger = logger
    end


    # Run a set of scripts
    #
    # Note: non executable files are skipped and a warning is sent to the console
    #
    # @paths - an array of paths with scripts to invoke
    # @env_vars - an array of paths that contains .properties files
    # @error_handler - a callback if a non-zero exit code occured
    # @block - a block to handle the output of the script if non is given it is sent to the console
    def run( paths, env_vars, error_handler = nil, &block)

      all_paths = all_files(paths).select{ |p| File.file? p }

      @logger.debug all_paths

      runnable = all_paths.select{ |p| File.executable? p }

      set_env(env_vars) if runnable.length > 0

      non_runnable = all_paths - runnable

      @logger.debug "runnable: #{runnable}"

      non_runnable.each{ |nr|
        @logger.warn "#{nr} is not runnable - skipping"
      }

      runnable.each{ |p|
        exec(p, error_handler, &block)
      }
    end

    private

    def exec(script_path, error_handler = nil, &block)
      IO.popen(script_path) do |io|
        while line = io.gets
          if block_given?
            block.call(line.chomp)
          else
            @logger.info line.chomp
          end
        end
        io.close
        error_handler.call(script_path) if $?.to_i != 0 and !error_handler.nil?
      end
    end

    def all_files(array)
      array.inject([]){ |acc,y|
        acc.concat(Dir["#{y}/**/*"].entries)
      }
    end

    def set_env(env_paths)
      env_files = all_files(env_paths)

      env_files.each{ |p|
        File.readlines(p).each do |line|
          if line.include? "="
            key, value = line.split("=")
            @logger.debug "set: #{key} -> #{value}"
            ENV[key.strip] = value.strip
          end
        end
      }
    end

  end

end
