=begin
*Name           : CreateLog
*Description    : class that defines custom logger methods
*Author         : Chandra sekaran
*Creation Date  : 23/08/2014
*Updation Date  :
=end

module EHR
  class CreateLog
    include FileLibrary      # module that define methods all file related manipulations
    include DateTimeLibrary  # module that define methods for all datetime related manipulations

    # Description       : initializes the Logger class and creates a new log file
    # Author            : Chandra sekaran
    # Arguments         :
    #   str_logfile_name: name of the log file to be created
    #
    def initialize(str_logfile_name = "log_")
      begin
        date_time_format = DATETIME_FORMAT || "%d_%m_%Y-%H_%M_%S"
      rescue Exception => ex
        date_time_format = "%d_%m_%Y-%H_%M_%S"   # when DATETIME_FORMAT is not defined
      end

      begin
        level = LOGGER_LEVEL || "DEBUG"
      rescue Exception => ex
        level = "DEBUG"    # when LOGGER_LEVEL is not defined
      end

      begin
        @str_logdir_name = $current_log_dir || "./test_result/test_report_#{Time.now.strftime(date_time_format)}"       # this line is enough, ex handlng not need
      rescue Exception => ex
        @str_logdir_name = "./test_result/test_report_#{Time.now.strftime(date_time_format)}"
      end

      create_directory(@str_logdir_name)       # creates a new directory
      @log_file = "#{@str_logdir_name}/#{str_logfile_name}.log"
      @log = Logger.new(@log_file)              # creates a new log file
      set_level(level)                          # sets the Logger::Level
      @log.datetime_format = date_time_format   # sets the datetime format
      @log.formatter = lambda do |severity, datetime, progname, message|
        "[#{Time.now.strftime(date_time_format)}] #{severity}: #{message}\n"   # customize the log content
      end
    end

    # Description   : logs a DEBUG message
    # Author        : Chandra sekaran
    # Arguments     :
    #   message     : string message to be logged
    #
    def debug(message)
      @log.debug(message)
    end

    # Description   : logs an INFO message
    # Author        : Chandra sekaran
    # Arguments     :
    #   message     : string message to be logged
    #
    def info(message)
      @log.info(message)
    end

    # Description   : logs a WARN message
    # Author        : Chandra sekaran
    # Arguments     :
    #   message     : string message to be logged
    #
    def warn(message)
      @log.warn(message)
    end

    # Description   : logs an ERROR message
    # Author        : Chandra sekaran
    # Arguments     :
    #   message     : string message to be logged
    #
    def error(message)
      @log.error(message)
      #$world.puts(message)  if !$world.nil?
      #exit #raise #"EXCEPTION RAISED"#Cucumber.wants_to_quit = true     # exit(1)
    end

    # Description   : logs a success message
    # Author        : Chandra sekaran
    # Arguments     :
    #   message     : string message to be logged
    #
    def success(message)
      info(message)
      $world.puts(message)  if !$world.nil?
    end

    # Description   : logs a FATAL message
    # Author        : Chandra sekaran
    # Arguments     :
    #   message     : string message to be logged
    #
    def fatal(message)
      @log.fatal(message)
    end

    # Description   : sets the logger level
    # Author        : Chandra sekaran
    # Arguments     :
    #   level       : logger level string
    #
    def set_level(level)
      case level.upcase
        when "DEBUG"
          @log.level = Logger::DEBUG
        when "INFO"
          @log.level = Logger::INFO
        when "WARN"
          @log.level = Logger::WARN
        when "ERROR"
          @log.level = Logger::ERROR
        when "FATAL"
          @log.level = Logger::FATAL
      end
    end

    # Description         : creates a new directory under the given path (newly added to override the method in file_library.rb)
    # Author              : Chandra sekaran
    # Arguments           :
    #  str_directory_path : relative path of the directory to be created
    #
    def create_directory(str_directory_path)
      unless File.directory?(str_directory_path)
        FileUtils.mkdir_p(str_directory_path)
        puts "New directory created under : #{str_directory_path}"
      end
    end

    # Description   : returns the relative path of currently created directory
    # Author        : Chandra sekaran
    #
    def get_current_log_dir
      @str_logdir_name
    end

    # Description   : returns the relative path of currently created file (logfile)
    # Author        : Chandra sekaran
    #
    def get_current_log_file
      @log_file
    end

    private
    attr_reader :log
  end
end