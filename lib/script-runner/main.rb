module ScriptRunner

  class Main

    # Run a set of scripts
    #
    # Note: non executable files are skipped and a warning is sent to the console
    #
    # @paths - an array of paths with scripts to invoke
    # @env_vars - an array of paths that contains .properties files
    # @error_handler - a callback if a non-zero exit code occured
    # @block - a block to handle the output of the script if non is given it is sent to the console
    def run( paths, env_vars, error_handler = nil, &block)
      set_env(env_vars)
      all_paths = all_files(paths).select{ |p| File.file? p }
      runnable = all_paths.select{ |p| File.executable? p }
      non_runnable = all_paths - runnable

      non_runnable.each{ |nr|
        puts "warning: #{nr} is not runnable - skipping"
      }

      all_paths.each{ |p|
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
            puts line.chomp
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
        puts "setting env from #{p}"
        File.readlines(p).each do |line|
          if line.include? "="
            values = line.split("=")
            ENV[values[0].chomp] = values[1].chomp
          end
        end
      }
    end

  end

end
