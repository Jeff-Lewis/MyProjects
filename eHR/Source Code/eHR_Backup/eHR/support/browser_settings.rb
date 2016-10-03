=begin
*Name           : BrowserSettings
*Description    : Browser settings definition for different web and mobile browsers
*Author         : Chandra sekaran
*Creation Date  : 23/08/2014
*Updation Date  :
=end

module EHR
  module BrowserSettings
    include FileLibrary     # module that defines all file related manipulations
    include DateTimeLibrary # module that defines all date time manipulations

    # Description       : launches a browser and returns the browser object
    # Author            : Chandra sekaran
    # Arguments         :
    #   str_browser_name: name of the browser
    # Return values     :
    #   @browser        : browser object
    #
    def self.browser_setup(str_browser_name)
      begin
        @browser_name = str_browser_name
        @browser = start_browser(@browser_name)
        raise "Nil class error : No valid browser object found for #{str_browser_name}" if @browser.nil?
        return @browser
      rescue Exception => ex
        $log.error("Error in launching browser #{str_browser_name} : #{ex}")
        exit
      end
    end

    # Description       : deletes all cookies from the current browser
    # Author            : Chandra sekaran
    #
    def self.delete_cookies
      begin
        @browser.manage.delete_all_cookies
        $log.success("#{@browser_name} browser cookies deleted successfully")
      rescue Exception => ex
        $log.error("Error while deleting the " + @browser_name + " browser cookies - #{ex}")
        exit
      end
    end

    # Description       : launches the given URL in the current browser
    # Author            : Chandra sekaran
    # Arguments         :
    #   str_url         : url of the web site to be launched
    #
    def self.launch_url(str_url)
      begin
        #delete_cookies
        @browser.navigate.to(str_url)
        $log.info("#{str_url} launched successfully")
      rescue Exception => ex
        $log.error("Error in launching URL - #{str_url}")
        exit
      end
    end

    # Description       : sets the timeout limit to find elements
    # Author            : Chandra sekaran
    # Arguments         :
    #   num_timeout     : numeric timeout value
    #
    def self.set_timeout(num_timeout)
      begin
        @browser.manage.timeouts.implicit_wait = num_timeout
        $log.success("Selenium timeout set to " + num_timeout.to_s)
      rescue Exception => ex
        $log.error("Error in setting the selenium timeout to: " + num_timeout.to_s)
        exit
      end
    end

    # Description       : starts the browser and returns the browser object
    # Author            : Chandra sekaran
    # Arguments         :
    #   str_browser     : browser name
    # Return values     :
    #   @browser        : browser object of the launched browser
    #
    def self.start_browser(str_browser)
      @browser = ''
      if PLATFORM == "desktop"
        @browser = setup_desktop_browser(str_browser)
        @browser.manage.window.maximize if !@browser.nil?
      else
        @browser = setup_mobile_browser
      end
      return @browser
    end

    # Description       : closes the current browser
    # Author            : Chandra sekaran
    #
    def self.close_browser
      begin
        @browser.close
        $log.success("Current browser closed successfully")
        $log_env.success("Current browser closed successfully")
      rescue Exception => ex
        $log.error("Error while closing the current browser - #{ex}")
        exit
      end
    end

    # Description       : closes the current browser
    # Author            : Chandra sekaran
    #
    def self.quit_browser
      begin
        @browser.quit
        #$log.success("Current browser closed successfully")
        $log_env.success("Current browser closed successfully")
      rescue Exception => ex
        $log.error("Error while closing the current browser - #{ex}")
        exit
      end
    end

    # Description       : restarts the current browser
    # Author            : Chandra sekaran
    # Return value      :
    #   @browser        : browser object of the new browser
    #
    def self.restart_browser
      begin
        quit_browser
        @browser_name = BROWSER
        $log.info("Restarting the browser (#{@browser_name})")
        @browser = browser_setup(@browser_name)
        @browser
      rescue Exception => ex
        $log.error("Error while restarting browser - #{ex}")
        exit
      end
    end

    # Description       : launches the desktop browser
    # Author            : Chandra sekaran
    # Arguments         :
    #   str_browser     : browser name
    # Return value      :
    #   @browser        : browser object of the new browser
    #
    def self.setup_desktop_browser(str_browser)
      begin
        #$log.info("Starting desktop browser : " + str_browser)
        @browser = nil
        case str_browser.downcase
          when "internet_explorer"
            @browser = Selenium::WebDriver.for :internet_explorer
            #caps = Selenium::WebDriver::Remote::Capabilities.internet_explorer("download" => {
            #    :prompt_for_download => false,
            #    :default_directory => File.expand_path($current_log_dir)
            #})
            #@browser = Selenium::WebDriver.for :internet_explorer, desired_capabilities: caps

          when "firefox"
            @browser = Selenium::WebDriver.for :firefox

          when "chrome"
            caps = Selenium::WebDriver::Remote::Capabilities.chrome("chromeOptions" => {"args" => ["test-type" ]})
            prefs = {
              :download => {
                :prompt_for_download => false,
                :default_directory => File.expand_path($current_log_dir)
              }
            }
            @browser = Selenium::WebDriver.for :chrome, :prefs => prefs, desired_capabilities: caps

          when "safari"
            @browser = Selenium::WebDriver.for :safari

          when "ios"
            if RUBY_PLATFORM.downcase.include?("darwin")
              @browser = Selenium::WebDriver.for :iphone
            else
              raise "You can't run IOS tests on non-mac machine"
            end
          else
            raise "Could not determine the browser"
        end
        $log.success("Successfully launched desktop #{str_browser} browser (Version : #{@browser.capabilities[:version]}, Resolution : '#{@browser.execute_script('return screen.width')}x#{@browser.execute_script('return screen.height')}')")
        return @browser
      rescue Exception => ex
        $log.error("Error in starting desktop browser : " + str_browser)
        exit
      end
    end

    # Description       : saves the screenshot of the webpage as png file
    # Author            : Chandra sekaran
    # Arguments         :
    #   str_module_name : module name under features directory
    #
    def self.capture_screenshot(str_module_name)
      begin
        str_imgdir_path = "#{$current_log_dir}/screenshot"
        unless File.directory?(str_imgdir_path)   # creates a new directory
          FileUtils.mkdir_p(str_imgdir_path)
        end
        str_image = "/#{str_module_name}_#{Time.now.strftime(DATETIME_FORMAT)}.png"
        str_imgdir_path << str_image    # adds image file name to the directory
        @browser.save_screenshot(str_imgdir_path)       # saves the screenshot image to the directory
        $log.info("Screenshot is saved in #{str_imgdir_path}")
        return "screenshot#{str_image}"
      rescue Exception => ex
        $log.error("Error in taking screenshot for #{str_imgdir_path} : #{ex}")
        exit
      end
    end

    # Description       : launches the mobile browser
    # Author            : Chandra sekaran
    # Arguments         :
    #   @browser        : browser object of the mobile browser
    #
    def self.setup_mobile_browser
      begin
        bool_device_enabled = DEVICE.nil? ? false : (DEVICE.downcase.eql?("true")? true : false)
        case(BROWSER.downcase)
          when "android", "chrome", "browser"
            @browser = setup_android(bool_device_enabled, BROWSER)
          when "safari"
            #if is_emulator_enabled
            #  caps = {
            #      :platform           => 'Mac',
            #      :device             => 'iPhone Simulator',
            #      :browser_name       => 'iOS',
            #      :version            => '7.1',
            #      :app                => 'safari',
            #      :newCommandTimeout  => 60000,
            #      :javascript_enabled => true
            #  }
            #  client = Selenium::WebDriver::Remote::Http::Default.new
            #  client.timeout = 30000 # seconds
            #  @browser = Selenium::WebDriver.for :remote, :url => app_url , :desired_capabilities => caps , :http_client => client
            #end
          else
            raise "Invalid browser name : #{BROWSER}"
        end

        #@browser.manage.window.hide_keyboard   # not working
        return @browser
      rescue Exception => ex
        $log.error("Error while setting up mobile browser : #{ex}")
        exit
      end
    end

    # Description       : launches mobile browser
    # Author            : Chandra sekaran
    # Arguments         :
    #   str_module_name : module name under features directory
    #
    def self.setup_android(bool_device_enabled, str_browser_name)
      begin
        browser = ""
        if str_browser_name.downcase == "chrome"
          browser_name = "Chrome"
        elsif str_browser_name.downcase == "browser" || str_browser_name.downcase == "android"
          browser_name = "Browser"
        else
          raise "Profile for '#{str_browser_name}' browser does not exists"
        end

        if bool_device_enabled
          caps = { :browserName => browser_name, :platformName => "Android", :newCommandTimeout => 60000, :deviceName => "4D00C0124B174161" }
          client = Selenium::WebDriver::Remote::Http::Default.new
          client.timeout = 5000
          browser = Selenium::WebDriver.for(:remote, :url => "http://localhost:4723/wd/hub/", :http_client => client, :desired_capabilities => caps)
        else
          #caps = { :browserName => browser_name, :platform => "Android", :Version => "4.0.4", :device => "EMULATOR-5554" }
          #client = Selenium::WebDriver::Remote::Http::Default.new
          #client.timeout = 500
          #browser = Selenium::WebDriver.for(:remote, :url => "http://localhost:4723/wd/hub/", :http_client => client, :desired_capabilities => caps)
          caps = { :browserName => browser_name, :platformName => "Android", :Version => "4.4.2", :deviceName => "EMULATOR-5554" }
          client = Selenium::WebDriver::Remote::Http::Default.new
          client.timeout = 5000
          browser = Selenium::WebDriver.for(:remote, :url => "http://localhost:4723/wd/hub/", :http_client => client, :desired_capabilities => caps)
        end
        $log.success("Launched #{str_browser_name} in Android #{bool_device_enabled ? 'device' : 'emulator'} successfully")
        browser
      rescue Exception => ex
        $log.error("Error while setting Android browser profile for '#{str_browser_name}' : #{ex}")
        exit
      end
    end

  end
end