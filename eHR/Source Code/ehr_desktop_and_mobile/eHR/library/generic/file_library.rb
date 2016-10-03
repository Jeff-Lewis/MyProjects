=begin
*Name           : FileLibrary
*Description    : class that define methods for file related manipulations
*Author         : Chandra sekaran
*Creation Date  : 23/08/2014
*Updation Date  :
=end

module EHR
  module FileLibrary
    include DataMagic

    # Description       : checks for file existance and returns the boolean result
    # Author            : Chandra sekaran
    # Arguments         :
    #   str_file_path   : absolute path of file
    # Return values     :
    #   bool_file       : boolean variable that hold the result of the file existence
    #
    def is_file_exists(str_file_path)
      begin
        bool_file = File.exists?(str_file_path)#get_absolute_path(str_file_name) )
        bool_file
      rescue Exception => ex
        $log.error("Error while checking for existence of #{str_file_path} : #{ex}")
        exit
      end
    end

    # Description       : opens the yml file
    # Author            : Chandra sekaran
    # Arguments         :
    #   str_file_path   : absolute path of yml file
    # Return values     :
    #   obj_file        : hash value of the yml file content
    #
    def open_yml_file(str_file_path)
      begin
        obj_file = YAML.load_file(File.open(str_file_path)) #get_absolute_path(str_file_name))  # obj_file = YAML.load_file(format_filepath(str_file_name))
        obj_file
      rescue Exception => ex
        $log.error("Error while opening #{str_file_path} : #{ex}")
        exit
      end
    end

    # Description       : opens the excel file
    # Author            : Chandra sekaran
    # Arguments         :
    #   str_file_name   : absolute path of excel file
    # Return values     :
    #   obj_file        : file object of the workbook
    #
    def open_excel_file(str_file_name)
      begin
        Spreadsheet.client_encoding = 'UTF-8'
        obj_file = Spreadsheet.open(get_absolute_path(str_file_name))
        $log.success("File #{str_file_name} opened successfully.")
        obj_file
      rescue Exception => ex
        $log.error("Error while opening #{str_file_name} : #{ex}")
        exit
      end
    end

    # Description      : closes the given file object
    # Author           : Chandra sekaran
    # Arguments        :
    #   file_object    : object of the file to be closed
    #
    def close_file(file_object)
      begin
        file_object.close
        #$log.success("File #{file_object} closed successfully.")
      rescue Exception => ex
        #file_object = nil
        $log.error("Error while closing #{file_object} : #{ex}")
        exit
      end
    end

    # Description      : creates a new directory under the given path
    # Author           : Chandra sekaran
    # Arguments        :
    #   str_directory_path : absolute path of directory
    #
    def create_directory(str_directory_path)
      begin
        unless File.directory?(str_directory_path)
          FileUtils.mkdir_p(str_directory_path)
        end
        #$log.success("New directory created : #{str_directory_path}")
      rescue Exception => ex
        $log.error("Error in creating directory #{str_directory_path} : #{ex}")
        exit
      end
    end

    # Description     : deletes an object
    # Author          : Chandra sekaran
    # Arguments       :
    #   object        : object to be deleted
    #
    def self.delete_object(object)
      object = nil
    end

    # Description     : extracts the features module and submodule names from a given file path
    # Author          : Chandra sekaran
    # Arguments       :
    #   str_file_path : absolute path of the feature file
    # Return value    :
    #   str_feature_dir: string value of module/submodule name
    #
    def get_feature_module_name(str_file_path)
      begin
        str_file_path = format_file_path(str_file_path)
        str_file_path = str_file_path.split("features/").last   # extracts all strings after 'features\'
                                                                #puts str_file_path
        arr_file_dirs = str_file_path.split("/")    # split the strings into array based on '\'
        str_feature_dir = ""

        arr_file_dirs.pop             # removes the last element i.e., feature file
        arr_file_dirs.pop             # removes the second last element i.e., test case folder
        (0..arr_file_dirs.size - 1).each do |num_counter|
          str_feature_dir << "_" if num_counter > 0
          str_feature_dir << "#{arr_file_dirs[num_counter]}"   # form a new string from array values
        end

        return str_feature_dir
      rescue Exception => ex
        $log.error("Error in extracting features directory : #{ex}")
        exit
      end
    end

    # Description     : Renames the created html/json report file and moves it to the current log directory
    # Author          : Chandra sekaran
    #
    def create_html_report
      begin
        str_timestamp = $log_env.get_formatted_datetime($end_time)
        # rename and move html report file into current test report directory
        File.rename("#{$REPORT_FILE_NAME}.html", "report_#{str_timestamp}.html")
        FileUtils.mv("report_#{str_timestamp}.html", $current_log_dir)
        # rename and move json report file into current test report directory
        File.rename("#{$REPORT_FILE_NAME}.json", "report_#{str_timestamp}.json")
        FileUtils.mv("report_#{str_timestamp}.json", $current_log_dir)
        $log.info("Html/JSON report files created and saved in '#{$current_log_dir}'")
      rescue Exception => ex
        $log.error("Error in creating html report : #{ex}")
        exit
      end
    end

    # Description        : renames all files extension under given file path
    # Author             : Chandra sekaran
    # Arguments          :
    #   str_file_path    : absolute path of file
    #   str_file_type    : new file extension to be created
    #
    def rename_file_type(str_file_path, str_file_type)
      begin
        Dir.glob(str_file_path).each do |file|
          FileUtils.mv file, "#{File.dirname(file)}/#{File.basename(file,'.*')}.#{str_file_type}"
        end
        $log.info("File type(s) under '#{str_file_path}' renamed successfully to '#{str_file_type}'")
      rescue Exception => ex
        $log.error("Error in renaming '#{str_file_path}' to type '#{str_file_type}': #{ex}")
        exit
      end
    end

    # Description        : get files which are all created under given file path with extension and after given timestamp
    # Author             : Gomathi
    # Arguments          :
    #   str_file_path    : absolute path of file
    #   str_file_type    : file extension
    #   obj_time_stamp   : execution start time as time object
    # Return argument    :
    #   arr_files        : array of file path(s)
    #
    def get_files_absolute_path(str_file_path, str_file_type, obj_time_stamp)
      begin
        arr_abs_path = Dir["#{str_file_path}/*/*.#{str_file_type}"]
        arr_files = []
        arr_abs_path.each do |file_path|
          arr_files << file_path if File.ctime(file_path) > obj_time_stamp
        end
        arr_files
      rescue Exception => ex
        $log.error("Error in getting '#{str_file_type}' file(s) under '#{str_file_path}' for '#{obj_time_stamp}' : #{ex}")
        exit
      end
    end

    # Description        : formats the file path by replacing "\" with "/"
    # Author             : Chandra sekaran
    # Arguments          :
    #   str_fileabs_path : absolute path of file
    # Return value    :
    #   str_file_path    : formatted absolute path of file
    #
    def format_file_path(str_fileabs_path)
      begin
        str_file_path = str_fileabs_path
        str_file_path.each_char do |letter|     # replace all the escape sequences
          case letter
            when /[\a]/
              str_file_path[letter] = "/a"
            when /[\e]/
              str_file_path[letter] = "/e"
            when /[\b]/
              str_file_path[letter] = "/b"
            when /[\cx]/
              str_file_path[letter] = "/cx"
            when /[\f]/
              str_file_path[letter] = "/f"
            when /[\n]/
              str_file_path[letter] = "/n"
            when /[\nnn]/
              #str_file_path[letter] = "/nnn" # not required as \n is given
            when /[\r]/
              str_file_path[letter] = "/r"
            when /[\s]/
              str_file_path[letter] = "/t"   # it is taking "\t" as "\s"
            when /[\t]/
              str_file_path[letter] = "/t"
            when "\\"
              str_file_path[letter] = "/"
            #when /[\v]/                       #  not required due to expression error
              #str_file_path[letter] = "/v"    #  not required due to expression error
            #when /[\x]/                       #  not required due to expression error
              #str_file_path[letter] = "/x"    #  not required due to expression error
            #when /[\xnn]/                     #  not required due to expression error
              #str_file_path[letter] = "/xnn"  #  not required due to expression error
          end
        end
        return str_file_path
      rescue Exception => ex
        $log.error("Error in formatting file path (#{str_file_path}) : #{ex}")
        exit
      end
    end

    # Description         : extracts local file name and sets the directory path for DataMagic to load the data file for the current scenario/step
    # Author              : Chandra sekaran
    # Arguments           :
    #   str_datafile_name : name of data file
    # Return value        :
    #                     : hash of the loaded yml file
    #
    def set_scenario_based_datafile(str_global_file_name)
      begin
        str_local_file_name = str_global_file_name
        $scenario_tags.each do |tag|
          if tag.include? "tc"
            tag_name = tag.gsub("@", "_")
            tmp = str_global_file_name.gsub(".", "#{tag_name}.")
            str_local_file_name = tmp
            break
          end
        end
        str_file_name = set_datafile_path(str_local_file_name, str_global_file_name)
        DataMagic.load(str_file_name)   # returns yml content as a hash
      rescue Exception => ex
        $log.error("Error in setting scenario based data file for (#{str_global_file_name}) : #{ex}")
        exit
      end
    end

    # Description           : sets the directory path for DataMagic to load the data file for the current scenario/step
    # Author                : Chandra sekaran
    # Arguments             :
    #   str_local_file_name : name of local data file
    #   str_global_file_name: name of global data file
    # Return value          :
    #    actual_file        : name of the required file
    #
    def set_datafile_path(str_local_file_name, str_global_file_name)
      begin
        str_feature_file_path = format_file_path($str_feature_file_path)
        arr_temp = str_feature_file_path.split("/")
        arr_temp.pop
        arr_temp.push(str_local_file_name)
        str_datafile_dir = arr_temp * "/"
        actual_file = ""
        if File.exists?(str_datafile_dir)
          arr_temp_dir = str_datafile_dir.split('/')
          arr_temp_dir.pop
          @str_temp_dir =  arr_temp_dir * "/"
          DataMagic.yml_directory = @str_temp_dir
          actual_file = str_local_file_name
        else
          arr_temp_dir = str_datafile_dir.split('/')
          arr_temp_dir.pop
          arr_temp_dir.pop
          arr_temp_dir.push("test_data")
          @str_temp_dir =  arr_temp_dir * "/"
          DataMagic.yml_directory = @str_temp_dir
          actual_file = str_global_file_name
        end
        puts "Test data file successfully set to #{@str_temp_dir}"
        return actual_file
      rescue Exception => ex
        $log.error("Error in setting data file path (#{str_local_file_name}/#{str_global_file_name}) : #{ex}")
        exit
      end
    end

    # Description           : execute the kernel command
    # Author                : Chandra sekaran
    # Arguments             :
    #   str_command         : command string
    # Return value          : a boolean value
    #
    def execute_command(str_command)
      begin
        str_stdout, str_stderr = '', ''
        Open3.popen3(str_command) do |i,o,e|
          i.close
          while((line = o.gets))
            str_stdout << line
          end
          while((line = e.gets))
            str_stderr << line
          end
        end
        $log.success("STDOUT : #{str_stdout.strip}") if !(str_stdout.nil? || str_stdout.empty?)
        raise str_stderr.strip if !(str_stderr.nil? || str_stderr.empty?)
        return true
      rescue Exception => ex
        $log.error("Error while executing the command (#{str_command}) : #{ex}")
        exit
      end
    end

  end
end