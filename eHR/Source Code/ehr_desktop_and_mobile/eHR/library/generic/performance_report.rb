=begin
*Name           : CustomHtmlReport
*Description    : class that holds performance report data generator methods
*Author         : Chandra sekaran
*Creation Date  : 05/03/2015
*Updation Date  :
=end

module EHR
  class PerformanceReport

    # Description       : invoked automatically when an object of the class type is created
    # Author            : Chandra sekaran
    # Arguments         :
    #   arr_file_paths  : array of html report file paths
    #
    def initialize(arr_file_path)
      @arr_file_name = arr_file_path
      @num_build_duration = 0
      @bool_build_passed = true
      @num_feature_count = 0
      @num_feature_pass_count = 0
      @num_feature_fail_count = 0
      @num_feature_skip_count = 0
    end

    # Description       : parses the json object saves the required execution data into Sybase DB
    # Author            : Chandra sekaran
    #
    def parse_json
      begin
        @json.each_with_index do |json, index|         # iterate each feature
          str_feature_id, num_feature_result_id = set_feature(json["name"].to_s)      # add feature name
          @num_feature_count += 1
          scenario_count = 0
          feature_duration = 0
          bool_feature_passed = true
          num_scenario_pass_count = 0
          num_scenario_fail_count = 0
          num_scenario_skip_count = 0

          json["elements"].each do |element|
            # for including the first background steps duration to the first scenario background steps as Cucumber json
            # report considers background for the first scenario and hence will have 0 duration for the background steps
            # under first scenario and the actual duration for the background will be set for the subsequent scenarios
            if index == 0
              if element["keyword"] == "Background"
                element["steps"].each do |step|
                  @arr_background_step_duration << step["result"]["duration"].to_i
                  @bool = true
                end
              end
            end
            num_step_pass_count = 0
            num_step_fail_count = 0
            num_step_skip_count = 0

            if element["keyword"] == "Scenario"       # take scenario for scenario level details
              str_scenario_id, scenario_result_id = set_scenario(element["name"], element["tags"][0]["name"], str_feature_id)     # add scenario name

              scenario_count += 1  # as it counts only 'Scenarios' and not 'Backgrounds'
              step_count = 0
              scenario_duration = 0
              bool_scenario_passed = true

              element["steps"].each_with_index do |step, indx|    # iterate each steps of the current scenario
                #num_step_id, num_step_result_id = set_step(step['keyword']+step['name'], str_scenario_id, scenario_result_id)    # add step name
                num_step_id = set_step(step['keyword']+step['name'], str_scenario_id, scenario_result_id)    # add step name

                step_count += 1
                step_duration = 0
                bool_step_passed = true
                if (index == 0) && (indx < @arr_background_step_duration.size) && @bool
                  step_duration = @arr_background_step_duration[indx]    # take duration from Background for the first scenario
                else
                  step_duration = step['result']['duration'].to_i     # take usual duration
                  @bool = false
                end
                scenario_duration += step_duration
                if step['result']['status'] == "passed"
                  num_step_pass_count += 1
                elsif step['result']['status'] == "failed"
                  num_step_fail_count += 1
                elsif step['result']['status'] == "skipped"
                  num_step_skip_count += 1
                end
                bool_step_passed = ["passed", "pending"].include?(step['result']['status']) ? true : false
                bool_scenario_passed &&= bool_step_passed
                                                                                                                                 #puts "\t\t Step : #{step['keyword']+step['name']} - #{step_duration} - #{bool_step_passed}"
                #reset_step_result(bool_step_passed, step_duration, num_step_result_id)
                set_step_result_new(num_step_id, str_scenario_id, scenario_result_id, bool_step_passed, step_duration)
              end
                                                                                                                                  #puts "Scenario : #{element["tags"][0]["name"]} - #{element['name']} - #{scenario_duration} - #{bool_scenario_passed} - #{step_count}"
              reset_scenario_result(scenario_result_id, scenario_duration, num_step_pass_count, num_step_fail_count, num_step_skip_count, bool_scenario_passed)
              feature_duration += scenario_duration
              bool_feature_passed &&= bool_scenario_passed

              if bool_scenario_passed
                num_scenario_pass_count += 1    # scenario pass count
              else
                if num_step_pass_count == 0 && num_step_fail_count == 0 && num_step_skip_count > 0
                  num_scenario_skip_count += 1   # scenario skip count
                else
                  num_scenario_fail_count += 1   # scenario fail count
                end
              end

            end
          end
                                                                                      #puts "Feature : #{json['name']} - #{feature_duration} - #{bool_feature_passed} - #{scenario_count}"
          reset_feature_result(feature_duration, num_scenario_pass_count, num_scenario_fail_count, num_scenario_skip_count, bool_feature_passed, num_feature_result_id)
          @num_build_duration += feature_duration
          @bool_build_passed &&= bool_feature_passed

          if bool_feature_passed
            @num_feature_pass_count += 1
          else
            @num_feature_fail_count += 1    # to do feature skip count
          end
        end
      rescue Exception => ex
        $log.error("Error while parsing JSON : #{ex}")
        exit
      end
    end

    # Description       : sets the build data with default details into Sybase
    # Author            : Chandra sekaran
    #
    def set_build
      begin
        num_host_id = get_host_data
        build_name = Time.now.strftime("%d_%m_%Y-%H_%M_%S")
        DBI.connect("DBI:SQLAnywhere:SERVER=#{DB_SERVER};DBN=#{DB_NAME}", DB_USER_NAME, DB_PASSWORD) do |dbh|
          str_query = "insert into BuildData(BuildName,HostDataID) values (?,?)"
          sth = dbh.prepare(str_query)
          sth.execute(build_name, num_host_id)
          sth.finish
          dbh.commit
          #puts "Added a record to BuildData table successfully"

          str_query = "select BuildID from BuildData where BuildName='#{build_name}' and HostDataID=#{num_host_id}"
          sth = dbh.prepare(str_query)
          sth.execute()
          @build_id  = sth.fetch[0]
          dbh.disconnect()
        end
      rescue Exception => ex
        $log.error("Error in setting build data to BuildData table: #{ex}")
        exit
      end
    end

    # Description       : gets the host data from Sybase based on current execution host
    # Author            : Chandra sekaran
    # Return Arguments  :
    #     num_host_id   : primary key the host
    #
    def get_host_data
      begin
        DBI.connect("DBI:SQLAnywhere:SERVER=#{DB_SERVER};DBN=#{DB_NAME}", DB_USER_NAME, DB_PASSWORD) do |dbh|
          str_query = "select HostDataID from HostData where HostName like '#{ENV['COMPUTERNAME'].downcase}' and OS like '#{ENV['OS'].downcase}' and Browser like '#{BROWSER.downcase}'"
          sth = dbh.prepare(str_query)
          sth.execute()
          num_host_id  = sth.fetch[0]
          dbh.disconnect()
          $log.info("------------host id : #{num_host_id.nil?}")
          num_host_id.nil? ? 5 : num_host_id
        end
      rescue Exception => ex
        $log.error("Error in getting host data from HostData table: #{ex}")
        exit
      end
    end

    # Description       : resets the build data with execution details into Sybase
    # Author            : Chandra sekaran
    # Arguments         :
    #    num_run_length : total execution time in nanoseconds
    #    num_pass_count : number of features passed
    #    num_fail_count : number of features failed
    #    num_skip_count : number of features skipped
    #    bool_result    : boolean value resembling the state of build result
    #
    def reset_build(num_run_length, num_pass_count, num_fail_count, num_skip_count, bool_result)
      begin
        num_result =  bool_result ? 1 : 0
        DBI.connect("DBI:SQLAnywhere:SERVER=#{DB_SERVER};DBN=#{DB_NAME}", DB_USER_NAME, DB_PASSWORD) do |dbh|
          sth = dbh.prepare("update BuildData set RunLength=?, Passes=?, Failures=?, Skips=?, Result=? where BuildID=?")
          sth.execute(convert_duration(num_run_length), num_pass_count, num_fail_count, num_skip_count, num_result, @build_id)
          sth.finish
          dbh.commit
          #puts "Updated a record (#{@build_id}) in BuildData table successfully"
          dbh.disconnect()
        end
      rescue Exception => ex
        $log.error("Error in resetting build data to BuildData table: #{ex}")
        exit
      end
    end

    # Description       : sets the feature data with default details into Sybase
    # Author            : Chandra sekaran
    # Arguments         :
    #  str_feature_name : feature name
    # Return Arguments  :
    #  num_feature_id   : primary key the feature
    #  num_feature_result_id  : primary key of the feature result
    #
    def set_feature(str_feature_name)
      begin
        DBI.connect("DBI:SQLAnywhere:SERVER=#{DB_SERVER};DBN=#{DB_NAME}", DB_USER_NAME, DB_PASSWORD) do |dbh|
          str_query = "select TestFeatureID from TestFeature where FeatureName=?"
          sth = dbh.prepare(str_query)
          sth.execute(str_feature_name)

          if sth.fetch.nil?   # insert only if the data is not present in the table
            sth = dbh.prepare("insert into TestFeature(FeatureName) values (?)")
            sth.execute(str_feature_name)
            dbh.commit
            #puts "Added a record to TestFeature table successfully"
          end
          str_query = "select TestFeatureID from TestFeature where FeatureName='#{str_feature_name}'"
          sth = dbh.prepare(str_query)
          sth.execute()
          num_feature_id = sth.fetch[0]
          #puts "********** Record found with Primary key '#{num_feature_id}' in TestFeature *************"
          dbh.disconnect()
          num_feature_result_id = set_feature_result(num_feature_id)
          return num_feature_id, num_feature_result_id   # return the feature id and feature result id of the feature
        end
      rescue Exception => ex
        $log.error("Error in setting feature data to TestFeature table : #{ex}")
        exit
      end
    end

    # Description       : sets the feature result data with default details into Sybase
    # Author            : Chandra sekaran
    # Arguments         :
    #  str_feature_name : feature_id of the feature
    # Return Arguments  :
    #  num_feature_result_id  : primary key of the feature result
    #
    def set_feature_result(num_feature_id)
      begin
        DBI.connect("DBI:SQLAnywhere:SERVER=#{DB_SERVER};DBN=#{DB_NAME}", DB_USER_NAME, DB_PASSWORD) do |dbh|
          str_query = "select TestFeatureResultID from TestFeatureResult where TestFeatureID=? and BuildID=?"
          sth = dbh.prepare(str_query)
          sth.execute(num_feature_id, @build_id)

          if sth.fetch.nil?   # insert only if the data is not present in the table
            sth = dbh.prepare("insert into TestFeatureResult(TestFeatureID,BuildID) values (?,?)")
            sth.execute(num_feature_id, @build_id)
            dbh.commit
            #puts "Added a record to TestFeatureResult table successfully"
          end

          str_query = "select TestFeatureResultID from TestFeatureResult where TestFeatureID=#{num_feature_id} and BuildID=#{@build_id}"
          sth = dbh.prepare(str_query)
          sth.execute()
          num_feature_result_id = sth.fetch[0]
          #puts "********** Record found with Primary key '#{num_feature_result_id}' in TestFeatureResult *************"
          dbh.disconnect()
          return num_feature_result_id   # return the feature result id of the feature
        end
      rescue Exception => ex
        $log.error("Error in setting feature result data to TestFeatureResult table : #{ex}")
        exit
      end
    end

    # Description       : resets the feature result data with execution details into Sybase
    # Author            : Chandra sekaran
    # Arguments         :
    #    num_run_length : feature execution time in nanoseconds
    #    num_pass_count : number of scenarios passed
    #    num_fail_count : number of scenarios failed
    #    num_skip_count : number of scenarios skipped
    #    bool_result    : boolean value resembling the state of build result
    #    num_feature_result_id : primary key of the TestFeatureResult table
    #
    def reset_feature_result(num_run_length, num_pass_count, num_fail_count, num_skip_count, bool_result, num_feature_result_id)
      begin
        num_result =  bool_result ? 1 : 0
        DBI.connect("DBI:SQLAnywhere:SERVER=#{DB_SERVER};DBN=#{DB_NAME}", DB_USER_NAME, DB_PASSWORD) do |dbh|
          sth = dbh.prepare("update TestFeatureResult set RunLength=?, Passes=?, Failures=?, Skips=?, Result=? where TestFeatureResultID=?")
          sth.execute(convert_duration(num_run_length), num_pass_count, num_fail_count, num_skip_count, num_result, num_feature_result_id)
          sth.finish
          dbh.commit
          #puts "Updated a record (#{num_feature_result_id}) in TestFeatureResult table successfully"
          dbh.disconnect()
        end
      rescue Exception => ex
        $log.error("Error in resetting feature result data to TestFeatureResult table : #{ex}")
        exit
      end
    end

    # Description           : sets the scenario data with default details into Sybase
    # Author                : Chandra sekaran
    # Arguments             :
    #    str_scenario_name  : scenario name
    #    str_qa_complete_id : QA Complete ID (Scenario ID) of the scenario
    #    str_feature_id     : primary key of the feature
    # Return Arguments      :
    #    num_scenario_id    : primary key of the scenario
    #    scenario_result_id : primary key of the scenario result
    #
    def set_scenario(str_scenario_name, str_qa_complete_id, str_feature_id)
      begin
        DBI.connect("DBI:SQLAnywhere:SERVER=#{DB_SERVER};DBN=#{DB_NAME}", DB_USER_NAME, DB_PASSWORD) do |dbh|
          str_query = "select TestScenarioID from TestScenario where ScenarioName=? and TestFeatureID=?"
          sth = dbh.prepare(str_query)
          sth.execute(str_scenario_name, str_feature_id.to_i)

          if sth.fetch.nil?  # insert only if the data is not present in the table
            sth = dbh.prepare("insert into TestScenario(ScenarioName,QACompleteID,TestFeatureID) values (?,?,?)")
            sth.execute(str_scenario_name, str_qa_complete_id, str_feature_id.to_i)
            sth.finish
            dbh.commit
            #puts "Added a record to TestScenario table successfully"
          end

          str_query = "select TestScenarioID from TestScenario where ScenarioName='#{str_scenario_name}' and TestFeatureID=#{str_feature_id}"
          sth = dbh.prepare(str_query)
          sth.execute()
          num_scenario_id = sth.fetch[0]
          #puts "********** Record found with Primary key '#{num_scenario_id}' in TestScenario *************"
          scenario_result_id = set_scenario_result(num_scenario_id, str_feature_id)
          dbh.disconnect()
          return num_scenario_id, scenario_result_id    # return the scenario id and scenario result id of the scenario
        end
      rescue Exception => ex
        $log.error("Error in setting scenario data to TestScenario table : #{ex}")
        exit
      end
    end

    # Description           : sets the scenario result data with default details into Sybase
    # Author                : Chandra sekaran
    # Arguments             :
    #    num_scenario_id    : primary key of the scenario
    #    num_feature_id     : primary key of the feature
    # Return Arguments      :
    #    num_scenario_result_id : primary key of the scenario result
    #
    def set_scenario_result(num_scenario_id, num_feature_id)
      begin
        DBI.connect("DBI:SQLAnywhere:SERVER=#{DB_SERVER};DBN=#{DB_NAME}", DB_USER_NAME, DB_PASSWORD) do |dbh|
          sth = dbh.prepare("insert into TestScenarioResult(TestFeatureID,TestScenarioID,BuildID) values (?,?,?)")
          sth.execute(num_feature_id, num_scenario_id, @build_id)
          sth.finish
          dbh.commit
          #puts "Added a record to TestScenarioResult table successfully"

          str_query = "select TestScenarioResultID from TestScenarioResult where TestFeatureID=#{num_feature_id} and TestScenarioID=#{num_scenario_id} and BuildID=#{@build_id}"
          sth = dbh.prepare(str_query)
          sth.execute()
          num_scenario_result_id = sth.fetch[0]
          #puts "********** Record found with Primary key '#{num_scenario_result_id}' in TestScenarioResult *************"
          dbh.disconnect()
          return num_scenario_result_id    # return the scenario id of the scenario
        end
      rescue Exception => ex
        $log.error("Error in setting scenario data to TestScenarioResult table : #{ex}")
        exit
      end
    end

    # Description              : resets the scenario result data with execution details into Sybase
    # Author                   : Chandra sekaran
    # Arguments                :
    #   num_scenario_result_id : primary key of the scenario result
    #   num_run_length         : steps execution time in nanoseconds
    #   num_pass_count         : number of steps passed
    #   num_fail_count         : number of steps failed
    #   num_skip_count         : number of steps skipped
    #   bool_result            : boolean value resembling the state of steps result
    #
    def reset_scenario_result(num_scenario_result_id, num_run_length, num_pass_count, num_fail_count, num_skip_count, bool_result)
      begin
        num_result =  bool_result ? 1 : 0
        DBI.connect("DBI:SQLAnywhere:SERVER=#{DB_SERVER};DBN=#{DB_NAME}", DB_USER_NAME, DB_PASSWORD) do |dbh|
          sth = dbh.prepare("update TestScenarioResult set RunLength=?, Passes=?, Failures=?, Skips=?, Result=? where TestScenarioResultID=?")
          sth.execute(convert_duration(num_run_length), num_pass_count, num_fail_count, num_skip_count, num_result, num_scenario_result_id)
          sth.finish
          dbh.commit
          #puts "Updated a record (#{num_scenario_result_id}) in TestScenarioResult table successfully"
          dbh.disconnect()
        end
      rescue Exception => ex
        $log.error("Error in resetting scenario data to TestScenarioResult table : #{ex}")
        exit
      end
    end

    # Description               : sets the step data with default details into Sybase
    # Author                    : Chandra sekaran
    # Arguments                 :
    #   str_step_name           : step name
    #   str_scenario_id         : primary key of scenario
    #   num_scenario_result_id  : primary key of scenario result
    # Return Arguments          :
    #   num_step_id             : primary key of step
    #   num_step_result_id      : primary key of step result
    #
    def set_step(str_step_name, str_scenario_id, num_scenario_result_id)
      begin
        DBI.connect("DBI:SQLAnywhere:SERVER=#{DB_SERVER};DBN=#{DB_NAME}", DB_USER_NAME, DB_PASSWORD) do |dbh|
          str_query = "select TestStepID from TestStep where StepName=? and TestScenarioID=?"
          sth = dbh.prepare(str_query)
          sth.execute(str_step_name, str_scenario_id)

          if sth.fetch.nil?   # insert only if the data is not present in the table
            sth = dbh.prepare("insert into TestStep(StepName,TestScenarioID) values (?,?)")
            sth.execute(str_step_name, str_scenario_id)
            dbh.commit
            #puts "Added a record to TestStep table successfully"
          end

          str_query = "select TestStepID from TestStep where StepName='#{str_step_name}' and TestScenarioID=#{str_scenario_id}"
          sth = dbh.prepare(str_query)
          sth.execute()
          num_step_id = sth.fetch[0]
          #puts "********** Record found with Primary key '#{num_step_id}' in TestStep *************"
          dbh.disconnect()
          #num_step_result_id = set_step_result(num_step_id, str_scenario_id, num_scenario_result_id)
          #return num_step_id, num_step_result_id     # return the step id and step result id of the step
          return num_step_id
        end
      rescue Exception => ex
        $log.error("Error in setting step data to TestStep table : #{ex}")
        exit
      end
    end

    # Description               : sets the step result data with execution details into Sybase
    # Author                    : Chandra sekaran
    # Arguments                 :
    #   num_step_id             : primary key of step
    #   num_scenario_id         : primary key of scenario
    #   num_scenario_result_id  : primary key of scenario result
    #   bool_result             : boolean value resembling the state of step result
    #   num_run_length          : steps execution time in nanoseconds
    #
    def set_step_result_new(num_step_id, num_scenario_id, num_scenario_result_id, bool_result, num_run_length)
      begin
        num_result = bool_result ? 1 : 0
        DBI.connect("DBI:SQLAnywhere:SERVER=#{DB_SERVER};DBN=#{DB_NAME}", DB_USER_NAME, DB_PASSWORD) do |dbh|
          sth = dbh.prepare("insert into TestStepResult(TestScenarioResultID,Result,RunLength,TestStepID,BuildID,TestScenarioID) values (?,?,?,?,?,?)")
          sth.execute(num_scenario_result_id, num_result, convert_duration(num_run_length), num_step_id, @build_id, num_scenario_id)
          dbh.commit
          dbh.disconnect()
          #puts "Added a record to TestStepResult table successfully"
        end
      rescue Exception => ex
        $log.error("(set_step_result_new)Error in setting step data to TestStepResult table : #{ex}")
        exit
      end
    end

    # Description               : sets the step result data with default details into Sybase
    # Author                    : Chandra sekaran
    # Arguments                 :
    #   num_step_id             : primary key of step
    #   str_scenario_id         : primary key of scenario
    #   num_scenario_result_id  : primary key of scenario result
    # Return Arguments          :
    #   num_step_result_id      : primary key of step result
    #
    def set_step_result(num_step_id, num_scenario_id, num_scenario_result_id)
      begin
        DBI.connect("DBI:SQLAnywhere:SERVER=#{DB_SERVER};DBN=#{DB_NAME}", DB_USER_NAME, DB_PASSWORD) do |dbh|
          sth = dbh.prepare("insert into TestStepResult(TestScenarioResultID,TestStepID,BuildID,TestScenarioID) values (?,?,?,?)")
          sth.execute(num_scenario_result_id, num_step_id, @build_id, num_scenario_id)
          dbh.commit
          #puts "Added a record to TestStepResult table successfully"

          str_query = "select TestStepResultID from TestStepResult where TestScenarioResultID=#{num_scenario_result_id} and TestStepID=#{num_step_id} and BuildID=#{@build_id} and TestScenarioID=#{num_scenario_id}"
          sth = dbh.prepare(str_query)
          sth.execute()
          num_step_result_id = sth.fetch[0]
          #puts "********** Record found with Primary key '#{num_step_result_id}' in TestStepResult *************"
          dbh.disconnect()
          return num_step_result_id     # return the step result id of the step
        end
      rescue Exception => ex
        $log.error("Error in setting step data to TestStep table : #{ex}")
        exit
      end
    end

    # Description           : resets the step result data with execution details into Sybase
    # Author                : Chandra sekaran
    # Arguments             :
    #   bool_result         : boolean value resembling the state of step result
    #   num_run_length      : step execution time in nanoseconds
    #   num_step_result_id  : primary key of step result
    #
    def reset_step_result(bool_result, num_run_length, num_step_result_id)
      begin
        num_result = bool_result ? 1 : 0
        DBI.connect("DBI:SQLAnywhere:SERVER=#{DB_SERVER};DBN=#{DB_NAME}", DB_USER_NAME, DB_PASSWORD) do |dbh|
          sth = dbh.prepare("update TestStepResult set Result=?, RunLength=? where TestStepResultID=?")
          sth.execute(num_result, convert_duration(num_run_length), num_step_result_id)
          sth.finish
          dbh.commit
          #puts "Updated a record (#{num_step_result_id}) in TestStepResult table successfully"
          dbh.disconnect()
        end
      rescue Exception => ex
        $log.error("Error in resetting step results data in TestStepResult table : #{ex}")
        exit
      end
    end

    # Description           : converts nanoseconds to seconds
    # Author                : Chandra sekaran
    # Arguments             :
    #   num_duration        : time in nanoseconds
    # Return Argument       : time in seconds
    #
    def convert_duration(num_duration)
      num_duration/(1000*1000*1000) #.to_f    # convert nanosecond to second
    end

    # Description           : function that creates performance report data and stores it in Sybase
    # Author                : Chandra sekaran
    #
    def create_performance_report
      begin
        set_build       # set Build data only once for each execution (Single or Parallel)
        @arr_file_name.each do |path|
          @arr_background_step_duration = []
          file = File.read(path)
          @json = JSON.parse(file)
          parse_json    # parse each json file and extract report data
        end
        #puts "Build duration : #{@num_build_duration} - #{@bool_build_passed} - #{@num_feature_count}"
        reset_build(@num_build_duration, @num_feature_pass_count, @num_feature_fail_count, @num_feature_skip_count, @bool_build_passed)  # Update the Build data with execution summary
      rescue Exception => ex
        $log.error("Error while creating report : #{ex}")
        exit
      end
    end

  end
end