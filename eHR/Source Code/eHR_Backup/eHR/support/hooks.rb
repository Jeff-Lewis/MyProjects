=begin
*Name           : hooks.rb
*Description    : hooks definition to perform task pre/post a scenario and/or step execution
*Author         : Chandra sekaran
*Creation Date  : 23/08/2014
*Updation Date  :
=end

$log = EHR::CreateLog.new("app_env") # base log to hold the environment details

$obj_yml = EHR::Read_From_YML.new("config/config.yml") # read the config file content

# for resetting config values
if !RESET_CONFIG_VALUES.nil?
  $obj_yml.set_value("environment/parallel_execution_count", 0)  # reset parallel execution count
  $obj_yml.release_all_profiles     # release all unused profiles
end

$parallel_execution_count = $obj_yml.get_value("environment/parallel_execution_count")

# set dynamic profile for a specific box or any free box
if ENV["PROFILE"].downcase == "development"
  if BOX.nil?
    BOX, PROFILE = $obj_yml.get_any_profile("development")
  else
    PROFILE = $obj_yml.get_specific_profile("development")
  end
elsif ENV["PROFILE"].downcase == "test"
  if BOX.nil?
    BOX, PROFILE = $obj_yml.get_any_profile("test")
  else
    PROFILE = $obj_yml.get_specific_profile("test")
  end
else
  raise "Invalid profile name : #{ENV["PROFILE"]}"
end

DESKTOP_APP_URL = $obj_yml.get_value("application/#{BOX}/#{PROFILE}/url/ehrbox") # get the desktop app url to be launched
MOBILE_APP_URL = $obj_yml.get_value("application/#{BOX}/#{PROFILE}/url/ehrmob") # get the mobile app url to be launched

# stage1 EP details
$stage1_ep_name_ypath = "application/#{BOX}/#{PROFILE}/login_credentials/stage1_ep/ep_name"
$stage1_ep_first_name_ypath = "application/#{BOX}/#{PROFILE}/login_credentials/stage1_ep/first_name"
$stage1_ep_last_name_ypath = "application/#{BOX}/#{PROFILE}/login_credentials/stage1_ep/last_name"
$stage1_ep_npi_ypath = "application/#{BOX}/#{PROFILE}/login_credentials/stage1_ep/npi"
STAGE1_EP_NAME = $obj_yml.get_value($stage1_ep_name_ypath)
STAGE1_EP_FIRST_NAME = $obj_yml.get_value($stage1_ep_first_name_ypath)
STAGE1_EP_LAST_NAME = $obj_yml.get_value($stage1_ep_last_name_ypath)
STAGE1_EP_NPI = $obj_yml.get_value($stage1_ep_npi_ypath)

# stage2 EP details
$stage2_ep_name_ypath = "application/#{BOX}/#{PROFILE}/login_credentials/stage2_ep/ep_name"
$stage2_ep_first_name_ypath = "application/#{BOX}/#{PROFILE}/login_credentials/stage2_ep/first_name"
$stage2_ep_last_name_ypath = "application/#{BOX}/#{PROFILE}/login_credentials/stage2_ep/last_name"
$stage2_ep_npi_ypath = "application/#{BOX}/#{PROFILE}/login_credentials/stage2_ep/npi"
STAGE2_EP_NAME = $obj_yml.get_value($stage2_ep_name_ypath)
STAGE2_EP_FIRST_NAME = $obj_yml.get_value($stage2_ep_first_name_ypath)
STAGE2_EP_LAST_NAME = $obj_yml.get_value($stage2_ep_last_name_ypath)
STAGE2_EP_NPI = $obj_yml.get_value($stage2_ep_npi_ypath)

# Application framework setting details
LOGGER_LEVEL = $obj_yml.get_value("environment/logger_level") # get the Logger Level
DATETIME_FORMAT = $obj_yml.get_value("environment/datetime_pattern")   # get the datetime format
DATE_FORMAT = $obj_yml.get_value("environment/date_pattern")   # get the date format
DATE_FORMAT_WITH_SLASH = $obj_yml.get_value("environment/date_pattern_with_slash")   # get the date format with slash in between
DATE_FORMAT_IN_YYYYMMDD = $obj_yml.get_value("environment/date_pattern_in_yyyymmdd")  # get the date in 'YYYYMMDD' format
IST_PACIFIC_TIME_DIFFERENCE = $obj_yml.get_value("environment/ist_pacific_time_difference")   # get Time difference between IST and PST

# HL7 server machine details
HL7_SERVER_IP = $obj_yml.get_value("environment/hl7_details/server_ip")
HL7_SERVER_PORT = $obj_yml.get_value("environment/hl7_details/port")

# Organization code
ORGANIZATION_CODE = $obj_yml.get_value("environment/organization_code")

# Site name
if ENV["PROFILE"].downcase == "development"
  $site_name1_ypath = "environment/dev/site1"
  $site_name2_ypath = "environment/dev/site2"
elsif ENV["PROFILE"].downcase == "test"
  $site_name1_ypath = "environment/test/site1"
  $site_name2_ypath = "environment/test/site2"
end

SITE_NAME1 = $obj_yml.get_value($site_name1_ypath)
SITE_NAME2 = $obj_yml.get_value($site_name2_ypath)

# Performance report
PERFORMANCE_REPORT = $obj_yml.get_value("environment/performance_report")
if ["yes", "true"].include?(PERFORMANCE_REPORT.to_s.downcase)
  DB_SERVER = $obj_yml.get_value("environment/db_server")
  DB_NAME = $obj_yml.get_value("environment/db_name")
  DB_USER_NAME = $obj_yml.get_value("environment/db_user_name")
  DB_PASSWORD = $obj_yml.get_value("environment/db_password")
end

# log test execution environment details
$log.info("__________________________________________________________")
$log.info("Test Machine         : #{ENV["COMPUTERNAME"]}(#{ENV['OS']})")
$log.info("Test Browser         : #{BROWSER}")
$log.info("Test URL             : #{ PLATFORM.downcase == 'desktop' ? DESKTOP_APP_URL : MOBILE_APP_URL}")
$log.info("__________________________________________________________")

$current_log_dir = $log.get_current_log_dir   # global variable to hold the base log directory name

$start_time = $log.get_current_datetime     # start time of the execution

$log_env = $log       # to hold base log file object for log entries after test execution

$current_log_file = nil       # hold the current log file name

PageObject.default_element_wait = $obj_yml.get_value("environment/default_element_wait")  # set default timeout for element wait
PageObject.default_page_wait = $obj_yml.get_value("environment/default_page_wait")  # set default timeout for page wait

$browser = EHR::BrowserSettings.browser_setup(BROWSER)     # launches the browser

$browser.navigate.to(DESKTOP_APP_URL) if PLATFORM.downcase == "desktop"

$scenario_count = 0    # holds scenario count for each feature file

$arr_holidays = EHR::Holiday.new.federal_holiday_calculation

# Description       : called before the execution of a scenario
# Author            : Chandra sekaran
# Arguments         :
#   scenario        : scenario object
#
Before do |scenario|
  @step_count = nil  # step counter used in AfterStep to get current step name

  @scenario_start_time = $log.get_current_datetime     # scenario execution start time

  @browser = $browser    # passes the browser object to the page class constructor (implicitly)
  @browser.manage.timeouts.implicit_wait = 3  # set 3s implicit wait time
  $browser_version = @browser.capabilities[:version]    # current browser version

  $world = self          # for overriding puts method to print the argument into html file and in console as well 

  $str_feature_file_path = scenario.file       # absolute path of current feature file

  @str_feature_module_name = $log.get_feature_module_name($str_feature_file_path)   # extracts module (and/or submodule) name from str_file_path
  if $current_log_file.nil? || !($current_log_file.include? @str_feature_module_name)
    $log = EHR::CreateLog.new(@str_feature_module_name)       # creates a new log file with the module ame
    $current_log_file = $log.get_current_log_file
  end

  $log.info("__________________________________________________________")

  # feature name
  case scenario
    when Cucumber::Ast::Scenario
      @feature_name = scenario.feature.name
    when Cucumber::Ast::OutlineTable::ExampleRow
      @feature_name = scenario.scenario_outline.feature.name
  end
  $log.info("Test Feature         : " + @feature_name)

  # check for a new feature and set $scenario_count accordingly
  if $feature_name_old != @feature_name
    $scenario_count = 0
    $feature_name_old = @feature_name
  end

  # scenario name
  case scenario
    when Cucumber::Ast::Scenario
      @scenario_name = scenario.name
    when Cucumber::Ast::OutlineTable::ExampleRow
      @scenario_name = scenario.scenario_outline.name
  end
  $log.info("Test Scenario        : " + @scenario_name)
  Kernel.puts("\n [#{Time.now.strftime(DATETIME_FORMAT)}] Currently running scenario : \n #{@scenario_name.to_s}")

  # tags name
  $scenario_tags = scenario.source_tag_names
  $log.info("Test tag(s)          : " + $scenario_tags.to_s)
  Kernel.puts("\n \tWith tag(s) : #{$scenario_tags.to_s}")

  # get first step name of first scenario
  @current_feature = if scenario.respond_to?('scenario_outline')
                       # execute the following code only for scenarios outline (starting from the second example)
                       scenario.scenario_outline.feature
                     else
                       # execute the following code only for a scenario and a scenario outline (the first example only)
                       scenario.feature
                     end
  $log.info("__________________________________________________________")

  @arr_steps = []
  @arr_steps = get_steps(@current_feature)  # get all steps under the current scenario
  EHR::BrowserSettings.delete_cookies if $scenario_tags.include? "@tc_1606"  # delete current browser cookies for the specific scenario (mobile TC1606)
end

# Description       : called after the execution of a step
# Author            : Chandra sekaran
# Arguments         :
#   scenario        : scenario object
#
AfterStep do |scenario|
  sleep 1
  @step_count = 0 if @step_count.nil?   # @step_count ||= 0

  begin
    $log.info("Test Step (#{scenario.failed? ? 'failed' : 'success'})  : " + @arr_steps[@step_count])
  rescue Exception => e
    $log.error("Error in AfterStep hook for step_count (#{@step_count}): #{e}")
    $log.info("Test Step (#{scenario.failed? ? 'failed' : 'success'})  : " + @arr_steps[@step_count-1]) rescue Exception
  end
  Kernel.puts("\n \t\t[#{Time.now.strftime(DATETIME_FORMAT)}] #{@arr_steps[@step_count].to_s}") rescue Exception

  @step_count += 1       # increase step counter
  if $embed_hl7
    $embed_hl7 = false
    embed("screenshot/#{$str_hl7_file_name}", "text/plain", "Click to view HL7 message") rescue Exception
  end
end

# Description       : called after support has been loaded but before features are loaded
# Author            : Chandra sekaran
# Arguments         :
#   config          : config object
#
AfterConfiguration do |config|

end

# Description       : called after the execution of a scenario
# Author            : Chandra sekaran
# Arguments         :
#   scenario        : scenario object
#
After do |scenario|
  @step_count = 0 if @step_count.nil?
  @scenario_end_time = $log.get_current_datetime    # scenario execution finish time

  if scenario.failed?
    begin
      $log.info("Test Step (failed)   : " + @arr_steps[@step_count])
    rescue Exception => e
      $log.error("Error in After hook for step_count (#{@step_count}): #{e}")
      $log.info("Test Step (failed)   : " + @arr_steps[@step_count-1]) rescue Exception
    end
    str_img_path = EHR::BrowserSettings.capture_screenshot(@str_feature_module_name)   # takes the screenshot of webpage

    # attaches a link to html page, on click of which shows the image in the web page
    # only for internet explorer, on click of the link opens the location window of the image
    embed(str_img_path, "image/png", "Click to view screenshot") rescue Exception

    # close the open iframes
    on(EHR::MasterPage).close_application_windows if PLATFORM.downcase == "desktop"
  end

  $scenario_count += 1    # increment scenario count by 1

  $log.info("__________________________________________________________")
  $log.info("Scenario start time  : " + $log.get_formatted_datetime(@scenario_start_time))
  $log.info("Scenario end time    : " + $log.get_formatted_datetime(@scenario_end_time))
  $log.info("Total elapsed time   : " + $log.get_datetime_diff(@scenario_start_time, @scenario_end_time))
  $log.info("__________________________________________________________")

  if PLATFORM.downcase == "desktop"
    if scenario.failed?
      if (@browser.current_url.downcase.include? "errorpage") || (@browser.title.downcase.include? "file or directory not found") || (@browser.title.downcase.include? "not available")
        $log.info("Due to exception the current browser session is being restarted")
          # for restarting the browser
          #$browser = @browser = nil
          #@browser = EHR::BrowserSettings.restart_browser
          #$browser = @browser
          #@browser.navigate.to(DESKTOP_APP_URL)
          #$world = self
          #on(EHR::LoginPage).login
          #@@browser = @browser
        EHR::BrowserSettings.launch_url(DESKTOP_APP_URL)    # relaunches the URL
        on(EHR::LoginPage).login     # resumes the current user session
      end
    end
    on(EHR::MasterPage).select_menu_item(HOME)    # navigate to dashboard
  else
    on(EHR::DashboardPage).goto_home
  end
  #if $scenario_tags.include? "@tc_3573"
  #  $log.info "-------------inside hooks---------"
  #  step %{a "non EP" user is logged in "desktop" web application}
  #  step %{the "Auto Fact to Face Visit" is "checked" in Organization tab}
  #end
end

# Description       : called after the execution of all features
# Author            : Chandra sekaran
#
at_exit do
    $log_env.info("Before value setting it to 'no' - 'application/#{BOX}/#{PROFILE}/in_use' = #{$obj_yml.get_value("application/#{BOX}/#{PROFILE}/in_use")}")
  $obj_yml.set_value("application/#{BOX}/#{PROFILE}/in_use", "no")   # releases the current profile
    $log_env.info("After value setting it to 'no' - 'application/#{BOX}/#{PROFILE}/in_use' = #{$obj_yml.get_value("application/#{BOX}/#{PROFILE}/in_use")}")

    #$log_env.info("------------ Before changing $parallel_execution_count = #{$parallel_execution_count} ----------------------")
    $log_env.info("------------ Before changing environment/parallel_execution_count = #{$obj_yml.get_value("environment/parallel_execution_count")} ----------------------")
  $obj_yml.change_execution_count("environment/parallel_execution_count", $obj_yml.get_value("application/#{BOX}/#{PROFILE}/in_use"))
    #$log_env.info("------------ After changing $parallel_execution_count = #{$parallel_execution_count} ----------------------")
    $log_env.info("------------ After changing environment/parallel_execution_count = #{$obj_yml.get_value("environment/parallel_execution_count")} ----------------------")

  $end_time = $log_env.get_current_datetime

  # logs into the base log file created with the name 'app_env.log'
  $log_env.info("__________________________________________________________")
  $log_env.info("Execution start time : " + $log_env.get_formatted_datetime($start_time))
  $log_env.info("Execution end time   : " + $log_env.get_formatted_datetime($end_time))
  $log_env.info("Total elapsed time   : " + $log_env.get_datetime_diff($start_time, $end_time).to_s)
  $log_env.info("__________________________________________________________")

  # rename the html report file and move it to respective log report directory
  $log_env.create_html_report

  $log_env.info("-------------------- inside at_exit hook ----------------------")
  #$log_env.info("-------------------- $parallel_execution_count = #{$parallel_execution_count} ----------------------")
  $log_env.info("------------ environment/parallel_execution_count = #{$obj_yml.get_value("environment/parallel_execution_count")} ----------------------")

    # creates a new custom HTML report based on cucumber report(s) generated only after complete (single or parallel) execution
  #if $parallel_execution_count == 0
  if $obj_yml.get_value("environment/parallel_execution_count") == 0
    #$log_env.info("-------------------- inside if $parallel_execution_count == 0 ----------------------")
    $log_env.info("-------------------- $start_time = #{$start_time}, $start_time - 11.minutes = #{$start_time - 11.minutes} ----------------------")
    # get the html report files of current execution
    arr_report_file = $log_env.get_files_absolute_path("test_result", "html", $start_time - 11.minutes)
    $log.info("Report directory names (html): #{arr_report_file.to_s}")

    obj = EHR::CustomHtmlReport.new(arr_report_file)
    obj.create_custom_report

    if ["yes", "true"].include?(PERFORMANCE_REPORT.to_s.downcase)
      # get the json report files of current execution
      arr_report_file = $log_env.get_files_absolute_path("test_result", "json", $start_time - 11.minutes)
      $log.info("Report directory names (json): #{arr_report_file.to_s}")

      obj = EHR::PerformanceReport.new(arr_report_file)
      obj.create_performance_report
    end
  end

  begin
    if PLATFORM.downcase == "desktop"
      $world.on(EHR::MasterPage).logout if !$world.nil?     # logout desktop web application
    else
      $world.on(EHR::DashboardPage).logout if !$world.nil?     # logout mobile web application
    end
  rescue Exception => ex
    puts "Error while logging out : #{ex}"
  ensure
    EHR::BrowserSettings.quit_browser       # closes the current browser
  end
end