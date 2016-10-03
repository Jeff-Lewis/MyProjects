=begin
*Name           : Read_From_YML
*Description    : class definition for reading data value from yml file
*Author         : Chandra sekaran
*Creation Date  : 23/08/2014
*Updation Date  :
=end

module EHR
  class Read_From_YML
    include FileLibrary     # module that define methods for all file manipulations

    # Description       : opens the yml file
    # Author            : Chandra sekaran
    # Arguments         :
    #   str_file_path   : relative path of the yml file
    #
    def initialize(str_file_path = '')
      begin
        raise "Exception : ReadFromYML instance cannot be created with filename" if str_file_path.nil?
        raise "Exception : file does not exists #{str_file_path}" if !is_file_exists(str_file_path)
        @yml = open_yml_file(str_file_path)
        @yml_file_path = str_file_path
      rescue Exception => ex
        $log.error("Error in opening file '#{str_file_path}' : #{ex}")
        exit
      end
    end

    # Description      : returns the value for the given input ypath
    # Author           : Chandra sekaran
    # Arguments        :
    #   str_ypath      : ypath of the key element
    # Return value     :
    #   req_val        : value of the key element
    #
    def get_value(str_ypath = '')
      begin
        raise "Exception : ReadFromYML - ypath cannot be empty" if str_ypath.nil?
        req_val = traverse_yml(str_ypath)
        return req_val
      rescue Exception => ex
        $log.error("Error in getting value for ypath '#{str_ypath}' : #{ex}")
        exit
      end
    end

    # Description      : returns the hash value for the given unique key
    # Author           : Chandra sekaran
    # Arguments        :
    #   str_key        : name of the unique key
    # Return value     :
    #   @req_hash      : hash value of the unique key element
    #
    def get_values(str_key)
      begin
        raise "Exception : ReadFromYML - key cannot be empty" if str_key.nil?
        @yml.each do |key, value|
          @req_hash = ''
          if key == str_key
            @req_hash = value
            break
          else
            if value.size >= 1 and value.class.to_s == "Hash"
              @req_hash = traverse_hash(value, str_key)
              return @req_hash if @req_hash.class.to_s == "Hash"
            end
          end
        end
      rescue Exception => ex
        $log.error("Error in getting value for '#{str_key}' : #{ex}")
        exit
      end
    end

    # Description      : returns the hash from the given input hash that matches the given key
    # Author           : Chandra sekaran
    # Arguments        :
    #   hash_val       : hash element
    #   req_key        : key to be found inside the hash element
    # Return value     :
    #    @hash_value   : value of the key element
    #
    def traverse_hash(hash_val, req_key)
      begin
        hash_val.each do |key, value|
          traverse_hash(value, req_key) if !value.nil? and value.size >= 1 and value.class.to_s == "Hash"
          if key == req_key
            @hash_value = value
            break
          end
        end
        return @hash_value
      rescue Exception => ex
        $log.error("Error in traversing hash '#{hash_val}' for '#{req_key}' : #{ex}")
        exit
      end
    end

    # Description      : traverses the yml file and gets the value for the given input ypath
    # Author           : Chandra sekaran
    # Arguments        :
    #   str_ypath      : ypath of the key element
    # Return value     :
    #    str_value     : value of the key element
    #
    def traverse_yml(str_ypath)
      begin
        str_value = ''
        arr_key = str_ypath.split('/')
        num_level = arr_key.size

        case num_level
          when 1
            str_value = @yml[arr_key[0]]
          when 2
            str_value = @yml[arr_key[0]][arr_key[1]]
          when 3
            str_value = @yml[arr_key[0]][arr_key[1]][arr_key[2]]
          when 4
            str_value = @yml[arr_key[0]][arr_key[1]][arr_key[2]][arr_key[3]]
          when 5
            str_value = @yml[arr_key[0]][arr_key[1]][arr_key[2]][arr_key[3]][arr_key[4]]
          when 6
            str_value = @yml[arr_key[0]][arr_key[1]][arr_key[2]][arr_key[3]][arr_key[4]][arr_key[5]]
          when 7
            str_value = @yml[arr_key[0]][arr_key[1]][arr_key[2]][arr_key[3]][arr_key[4]][arr_key[5]][arr_key[6]]
          else
            raise "Given YML path cannot be traversed"
        end
        return str_value
      rescue Exception => ex
        $log.error("Error in traverse_yml '#{str_ypath}' : #{ex}")
        exit
      end
    end

    # Description      : returns the profile name that is currently available
    # Author           : Chandra sekaran
    # Arguments        :
    #   str_box        : profile name whether development/test
    # Return value     :
    #    str_key       : key name of the profile
    #
    def get_specific_profile(str_box)
      begin
        str_key = ""
        # iterates through the @yml content to find the BOX key and reads the value of :in_use key and returns the key
        # if its value is "no"
        @yml.each do |key, value|
          value.each do |k, v|
          if k.downcase == BOX.downcase
          v.each do |k1, v1|
            if k1.downcase.include? str_box.downcase
              v1.each do |k2, v2|
                if k2.downcase.include? "in_use"
                  if v2.downcase == "no"
                    str_key = k1
                    set_value("application/#{BOX}/#{str_key}/in_use", "yes")    # updates the key values to "yes"
                    change_execution_count("environment/parallel_execution_count", get_value("application/#{BOX}/#{str_key}/in_use"))
                    break
                  end
                end
              end
              break if str_key != ""
            end
            break if str_key != ""
          end
          break if str_key != ""
          end
          break if str_key != ""
          end
          break if str_key != ""
        end
        raise "All the profiles (for Login credentials) are in use and hence stopping the execution for #{BOX}/#{str_box}" if str_key == ""
        $log.info("Currently using #{str_key} under #{str_box} profile under #{BOX} box")
        str_key
      rescue Exception => ex
        $log.error("Error in getting free BOX config values : #{ex}")
        exit
      end
    end

    # Description      : returns the box and profile names that is currently available
    # Author           : Chandra sekaran
    # Arguments        :
    #   str_box        : profile name whether development/test
    # Return value     :
    #    str_box       : key name of the box
    #    str_key       : key name of the profile
    #
    def get_any_profile(str_box)
      begin
        str_key = ""
        str_box_avail = ""
        # iterates through the @yml content to find the BOX key and reads the value of :in_use key and returns the key
        # if its value is "no"
        @yml.each do |key, value|
          value.each do |k, v|
            str_box_avail = k
              v.each do |k1, v1|
                if k1.downcase.include? str_box.downcase
                  v1.each do |k2, v2|
                    if k2.downcase.include? "in_use"
                      if v2.downcase == "no"
                        str_key = k1
                        set_value("application/#{str_box_avail}/#{str_key}/in_use", "yes")    # updates the key values to "yes"
                        change_execution_count("environment/parallel_execution_count", get_value("application/#{str_box_avail}/#{str_key}/in_use"))
                        break
                      end
                    end
                    break if str_key != ""
                  end
                  #break if str_key != ""
                end
                break if str_key != ""
              end
              break if str_key != ""
          end
          break if str_key != ""
        end
        raise "All the profiles (for Login credentials) are in use and hence stopping the execution for #{str_box}" if str_key == ""
        $log.info("Currently using #{str_key} under #{str_box} profile under #{str_box_avail} box")
        return str_box_avail, str_key
      rescue Exception => ex
        $log.error("Error in getting free PROFILE config values : #{ex}")
        exit
      end
    end

    # Description      : updates the parallel execution counter in config.yml file
    # Author           : Gomathi
    # Arguments        :
    #   str_ypath      : ypath of yml content
    #   str_value      : boolean value to update the counter
    #
    def change_execution_count(str_ypath, str_value)
      #if str_value == "yes"
      #  $parallel_execution_count += 1
      #else
      #  $parallel_execution_count -= 1
      #end
      #set_value(str_ypath, $parallel_execution_count)

      # changes made to overcome issue in creating custom_report during parrel execution
      if str_value == "yes"
        set_value(str_ypath, get_value(str_ypath) + 1)
      else
        set_value(str_ypath, get_value(str_ypath) - 1)
      end
    end

    # Description      : sets the value for the given ypath
    # Author           : Chandra sekaran
    # Arguments        :
    #   str_ypath      : ypath of yml content
    # Return value     :
    #    str_value     : value to be set for ypath
    #
    def set_value(str_ypath, str_value = "")
      begin
        raise "Exception : ReadFromYML - ypath cannot be empty" if str_ypath.nil?

        @yml = open_yml_file(@yml_file_path)

        arr_key = str_ypath.split('/')
        num_level = arr_key.size

        case num_level
          when 1
            @yml[arr_key[0]] = str_value
          when 2
            @yml[arr_key[0]][arr_key[1]] = str_value
          when 3
            @yml[arr_key[0]][arr_key[1]][arr_key[2]] = str_value
          when 4
            @yml[arr_key[0]][arr_key[1]][arr_key[2]][arr_key[3]] = str_value
          when 5
            @yml[arr_key[0]][arr_key[1]][arr_key[2]][arr_key[3]][arr_key[4]] = str_value
          when 6
            @yml[arr_key[0]][arr_key[1]][arr_key[2]][arr_key[3]][arr_key[4]][arr_key[5]] = str_value
          when 7
            @yml[arr_key[0]][arr_key[1]][arr_key[2]][arr_key[3]][arr_key[4]][arr_key[5]][arr_key[6]] = str_value
          else
            raise "Given YML path cannot be traversed"
        end
        File.open(@yml_file_path, 'w') { |h| h.write @yml.to_yaml }   # updates the yml file content with the updated hash
        @yml = open_yml_file(@yml_file_path)
      rescue Exception => ex
        $log.error("Error in setting value for ypath '#{str_ypath}' : #{ex}")
        exit
      end
    end

    # Description      : resets all the unused profiles
    # Author           : Chandra sekaran
    #
    def release_all_profiles
      begin
        @yml.each do |key, value|
          if key.downcase == "application"
            value.each do |k, v|
              v.each do |k1, v1|
                v1.each do |k2, v2|
                  if k2.downcase.include? "in_use"
                    set_value("#{key}/#{k}/#{k1}/#{k2}", "no") if v2.downcase == "yes"  # set "no" to in_use key for all profiles
                  end
                end
              end
            end
          end
        end
      rescue Exception => ex
        $log.error("Error in releasing all profiles : #{ex}")
        exit
      end
    end

  end
end