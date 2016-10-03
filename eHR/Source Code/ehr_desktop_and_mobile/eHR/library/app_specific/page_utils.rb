=begin
*Name           : PageUtils
*Description    : module that define methods for commonly used page-object related manipulations
*Author         : Chandra sekaran
*Creation Date  : 28/08/2014
*Updation Date  :
=end

module EHR
  module PageUtils
    include PageObject
    include FileLibrary

    image(:image_loading,                  :src   => "../../Content/themes/base/images/busy-icon.gif")   # image shown while page loading
    #div(:div_progress_image,              :id    => "progressimagediv")
    div(:div_progress_image,               :id    => "progressimageTable")

    # iframe window for AMC report numerator
    div(:div_numerator_popup,              :id    => "PopUpDivMaster_c")
    link(:link_numerator_popup_close,      :class => "container-close")
    h3(:h3_numerator_popup_heading,        :xpath => "//div[@class='content']/h3")
    table(:table_numerator_popup_details,  :xpath => "//div[@id='AMCRowMeasureDetails_Div']/table")
    div(:div_numerator_popup_details,      :id    => "AMCRowMeasureDetails_Div")

    # iframe window for Health Status
    #link(:link_close_health_status_iframe, :xpath  => "//div[@id='popUpNonCompHealthStatus']/a")
    link(:link_close_health_status_iframe, :class  => "container-close")

    # tooltip object for AMC report page objective help text
    div(:div_tooltip,                      :xpath => "//div[@id='myTooltip']/div[1]") #:id => "myTooltip")

    # Objects of items visible at bottom of page
    div(:div_copy_right,                   :id    => "footer")
    div(:div_toolbar,                      :id    => "toolbar")

    # xpath of table tr tags
    $xpath_table_message_row = "./table/tbody[@class='yui-dt-message']/tr"
    $xpath_table_data_row = "./table/tbody[@class='yui-dt-data']/tr"
    $xpath_tbody_message_row = "./tbody[@class='yui-dt-message']/tr"
    $xpath_tbody_data_row = "./tbody[@class='yui-dt-data']/tr"
    $xpath_tbody_data_first_row = "./tbody[@class='yui-dt-data']/tr[1]"
    $xpath_table_data_first_row = "./table/tbody[@class='yui-dt-data']/tr[1]"

    #xpath for generic popup
    link(:link_generic_popup_close,         :xpath => "/descendant::a[contains(@class,'close')][1]")

    # Description         : waits until the web element is visible
    # Author              : Chandra sekaran
    # Arguments           :
    #   element           : page object element
    #   str_error_message : error message to be displayed if web element is not visible within the timeout
    #   num_wait_time     : number of seconds to wait
    #
    def wait_for_object(element, str_error_message = "Failure in finding the element", num_wait_time = PageObject.default_element_wait)
      wait_until(num_wait_time, str_error_message) { element.visible? }
    end

    # Description         : waits until the web page title is visible
    # Author              : Chandra sekaran
    # Arguments           :
    #   str_error_message : error message to be displayed if web page title is not within the timeout
    #   num_wait_time     : number of seconds to wait
    #
    def wait_for_page_load(str_error_message = "Failure in page load", num_wait_time = PageObject.default_page_wait)
      wait_until(num_wait_time, str_error_message) { title != '' }
    end

    # Description       : compares two strings and throws error if the strings are unequal
    # Author            : Chandra sekaran
    # Arguments         :
    #   str_actual      : actual string value
    #   str_expected    : expected string value
    #
    def compare_string(str_actual, str_expected)
      raise "The expected string is '#{str_expected}' but the actual string value is '#{str_actual}'" if str_actual != str_expected
    end

    # Description         : waits until the web page is loading and ajax requests are completed
    # Author              : Gomathi
    #
    def wait_for_loading
      begin
        #wait_until(3) { image_loading_element.visible? } rescue Exception
        #wait_until(PageObject.default_element_wait, "Timed out after waiting for #{PageObject.default_page_wait}s") { !image_loading_element.visible? }   # rescue Exception
        wait_until(3) { div_progress_image_element.visible? } rescue Exception
        wait_until(PageObject.default_element_wait, "Timed out after waiting for #{PageObject.default_page_wait}s") { !div_progress_image_element.visible? }   # rescue Exception
        wait_for_ajax(PageObject.default_element_wait) rescue Exception  # waits until ajax request is complete
      rescue Exception => ex
        raise "Timed out after waiting for #{PageObject.default_page_wait}s" if !ex.message.downcase.include? "undefined method `wait_until' for nil:nilclass"
      end
    end

    # Description        : clicks on the given web element
    # Author             : Chandra sekaran
    # Arguments          :
    #   clickable_element: element object
    # Return argument    : a boolean value
    #
    def click_on(clickable_element)
      begin
        wait_for_loading
        wait_until(PageObject.default_element_wait) { element.visible? } rescue Exception
        clickable_element.scroll_into_view rescue Exception
        #if clickable_element.enabled?
        clickable_element.focus rescue Exception
        clickable_element.click
        wait_for_loading
        #end
        return true
      rescue Exception => ex
        clickable_element.fire_event("click") rescue Exception
        $log.error("Error in clicking web element : #{ex}")
        return false
      end
    end

    # Description        : checks if the given text is present in the current page or iframe
    # Author             : Chandra sekaran
    # Arguments          :
    #   page_object      : page object
    #   str_text         : string text
    #   num_wait         : time out value
    # Return argument    : a boolean value
    #
    def is_text_present(page_object, str_text, num_wait = PageObject.default_element_wait)
      begin
        wait_for_loading
        page_object.wait_until(num_wait, "Failure in finding text '#{str_text}' in the page #{page_object}") do
          page_object.text.include? str_text
        end
        return true
      rescue Exception => ex
        return false
      end
    end

    # Description        : refresh the current web page
    # Author             : Chandra sekaran
    # Arguments          :
    #   page_object      : page object
    #
    def refresh_page(page_object)
      page_object.refresh
      wait_for_page_load
    end

    # Description         : Function for Calculating pacific date and time
    # Author              : Gomathi
    # Return argument     : object_date_time
    #
    def pacific_time_calculation
      begin
        if Time.now.zone == "Pacific Standard Time" || Time.now.zone == "Pacific Daylight Time"
          current_time = Time.now
        elsif Time.now.zone == "India Standard Time"
          current_time = Time.now - IST_PACIFIC_TIME_DIFFERENCE.hours
        end
        object_date_time = Time.parse("#{current_time}")
      rescue Exception => ex
        $log.error("Error while calculating Pacific date time : #{ex}")
        exit
      end
    end

    # Description          : Function for Calculating Exam date and time
    # Author               : Gomathi
    # Arguments            :
    #   str_date_attribute : describes exam creation date and time
    #   str_report_range   : describes whether exam creation date is before or after reporting period
    # Return argument      : str_exam_time
    #
    def exam_date_time_calculation(str_date_attribute, str_report_range, str_exam_creation_time = "")
      begin
        if str_date_attribute.include?(" ")
          arr_date_attribute = str_date_attribute.split(" ")
          float_time_period = arr_date_attribute[0].to_f
          str_time_period = arr_date_attribute[1]
        else
          float_time_period = str_date_attribute
        end
        if str_report_range.downcase != "on"
          case str_time_period.downcase
            when /month/
              if str_report_range.downcase == "after"
                str_exam_time = $report_generation_time + float_time_period.to_i.months
              elsif str_report_range.downcase == "before"
                str_exam_time = $report_generation_time - float_time_period.to_i.months
              end
            when /day/
              if str_report_range.downcase == "after"
                str_exam_time = $report_generation_time + float_time_period.days
              elsif str_report_range.downcase == "before"
                str_exam_time = $report_generation_time - float_time_period.days
              end
            when /hour/
              if str_report_range.downcase == "after"
                str_exam_time = $report_generation_time + float_time_period.hours
              elsif str_report_range.downcase == "before"
                str_exam_time = $report_generation_time - float_time_period.hours
              end
            when /minute/
              if str_report_range.downcase == "after"
                str_exam_time = $report_generation_time + float_time_period.minutes
              elsif str_report_range.downcase == "before"
                str_exam_time = $report_generation_time - float_time_period.minutes
              end
            when /year/
              if str_report_range.downcase == "after"
                str_exam_time = $report_generation_time + float_time_period.to_i.years
              elsif str_report_range.downcase == "before"
                str_exam_time = $report_generation_time - float_time_period.to_i.years
              end
            else
              raise "Invalid time period : #{str_time_period}"
          end
          if str_exam_creation_time != ""
            return Time.parse("#{str_exam_time.strftime(DATE_FORMAT_IN_YYYYMMDD)} #{str_exam_creation_time.downcase.gsub("at ", "").gsub(".", ":")}")
          else
            return str_exam_time
          end
        else
          if str_date_attribute.include?(" ")
            if float_time_period > 96
              exam_date = $report_generation_time - 4.days
              float_time_period = float_time_period - 96
            elsif float_time_period > 72
              exam_date = $report_generation_time - 3.days
              float_time_period = float_time_period - 72
            elsif float_time_period > 48
              exam_date = $report_generation_time - 2.days
              float_time_period = float_time_period - 48
            elsif float_time_period > 24
              exam_date = $report_generation_time - 1.days
              float_time_period = float_time_period - 24
            else
              exam_date = $report_generation_time
            end
            exam_time = float_time_period.to_i
          else
            exam_date = $report_generation_time
            exam_time = float_time_period
          end
          str_exam_time = Time.parse("#{exam_date.strftime(DATE_FORMAT_IN_YYYYMMDD)} #{exam_time}")
        end
      rescue Exception => ex
        $log.error("Error while calculating Exam date and time : #{ex}")
        exit
      end
    end

    # Description          : Function for Calculating if week end falls in Exam creation time span or not
    # Author               : Gomathi
    # Arguments            :
    #   str_date_attribute : describes exam creation date and time
    #   str_report_range   : describes whether exam creation date is before or after reporting period
    # Return argument      : Boolean value
    #
    def weekend_calculation(str_date_attribute, str_report_range)
      begin
        arr_week_ends = ["saturday", "sunday"]
        temp_date = $report_generation_time

        if str_report_range.downcase != "on"
          arr_date_attribute = str_date_attribute.split(" ")
          float_time_period = arr_date_attribute[0].to_f
          temp_time_period = float_time_period
          iterate = true

          if float_time_period > 24
            while temp_time_period >= 0 && iterate
              return true if arr_week_ends.include?temp_date.strftime("%A").downcase
              iterate = false if temp_time_period == 0
              if temp_time_period >= 24
                temp_date = temp_date - 24.hours if str_report_range.downcase == "before"
                temp_date = temp_date + 24.hours if str_report_range.downcase == "after"
                temp_time_period = temp_time_period - 24
              else
                temp_date = temp_date - temp_time_period.hours if str_report_range.downcase == "before"
                temp_date = temp_date + temp_time_period.hours if str_report_range.downcase == "after"
                temp_time_period = 0
              end
            end
          else
            while temp_time_period >= 0
              return true if arr_week_ends.include?temp_date.strftime("%A").downcase
              temp_date = temp_date - float_time_period.hours if str_report_range.downcase == "before"
              temp_date = temp_date + float_time_period.hours if str_report_range.downcase == "after"
              temp_time_period = temp_time_period - float_time_period
            end
          end
        else
          return true if arr_week_ends.include?temp_date.strftime("%A").downcase
        end
        return false
      rescue Exception => ex
        $log.error("Error while Calculating if week end falls in Exam creation time span or not : #{ex}")
        exit
      end
    end

    # Description          : Function for Calculating if holiday falls in Exam creation time span or not
    # Author               : Gomathi
    # Arguments            :
    #   str_date_attribute : describes exam creation date and time
    #   str_report_range   : describes whether exam creation date is before or after reporting period
    # Return argument      : Boolean value
    #
    def holiday_calculation(str_date_attribute, str_report_range)
      begin
        temp_date = $report_generation_time

        if str_report_range.downcase != "on"
          arr_date_attribute = str_date_attribute.split(" ")
          float_time_period = arr_date_attribute[0].to_f
          temp_time_period = float_time_period
          iterate = true

          if float_time_period > 24
            while temp_time_period >= 0 && iterate
              return true if $arr_holidays.include?(temp_date.strftime("%m/%d/%Y"))
              iterate = false if temp_time_period == 0
              if temp_time_period >= 24
                temp_date = temp_date - 24.hours if str_report_range.downcase == "before"
                temp_date = temp_date + 24.hours if str_report_range.downcase == "after"
                temp_time_period = temp_time_period - 24
              else
                temp_date = temp_date - temp_time_period.hours if str_report_range.downcase == "before"
                temp_date = temp_date + temp_time_period.hours if str_report_range.downcase == "after"
                temp_time_period = 0
              end
            end
          else
            while temp_time_period >= 0
              return true if $arr_holidays.include?(temp_date.strftime("%m/%d/%Y"))
              temp_date = temp_date - float_time_period.hours if str_report_range.downcase == "before"
              temp_date = temp_date + float_time_period.hours if str_report_range.downcase == "after"
              temp_time_period = temp_time_period - float_time_period
            end
          end
        else
          return true if $arr_holidays.include?(temp_date.strftime("%m/%d/%Y"))
        end
        return false
      rescue Exception => ex
        $log.error("Error while Calculating if holiday falls in Exam creation time span or not : #{ex}")
        exit
      end
    end

    # description          : closes the iframes/ browser windows which are currently open
    # Author               : Chandra sekaran
    #
    def close_application_windows
      begin
        wait_for_loading rescue Exception
        # close AMC report page numerator iframe
        if div_numerator_popup_details_element.exists? && div_numerator_popup_details_element.visible?
          link_numerator_popup_close_element.click
        end

        # close Health Status iframe
        if link_close_health_status_iframe_element.exists? && link_close_health_status_iframe_element.visible?
          link_close_health_status_iframe_element.click
          wait_for_loading
        end

        # below step to handle multiple popup close if it is present
        #iterate=true
        #while(iterate)
        #  if link_generic_popup_close_element.exists? && link_generic_popup_close_element.visible?
        #    link_generic_popup_close_element.click
        #    wait_for_loading rescue Exception
        #  else
        #    iterate=false
        #  end
        #end

        switch_to_application_window
      rescue Exception => ex
        $log.error("Error while closing opened iframe(s) : #{ex}")
        exit
      end
    end

    # description     : function for moving to newly opened browser window
    # Author          : Chandra sekaran
    #
    def switch_to_next_window
      #raise "Number of windows should be two" if @browser.window_handles.size != 2
      window_to_switch = @browser.window_handles.find { |window| window != @browser.window_handle }
      @browser.switch_to.window window_to_switch
    end

    # description     : function for moving to application window
    # Author          : Chandra sekaran
    #
    def switch_to_application_window
      # closes other browser windows and switches to application main window
      if @browser.window_handles.size > 1
        window_to_close = @browser.window_handle
        parent_window = @browser.window_handles.find_all { |window| window != @browser.window_handle }
        @browser.switch_to.window window_to_close
        puts("Closing window " + @browser.title)
        @browser.close
        parent_window.each do |window|
          @browser.switch_to.window window
        end
      end
    end

    # description     : function for getting all steps under the current running scenario
    # Author          : Chandra sekaran
    # Argument        :
    #   feature       : feature object of current running feature file
    # Return argument :
    #   arr_steps     : array of steps
    #
    def get_steps(feature)
      arr_steps = []
      feature.feature_elements[$scenario_count].steps.each do |step|
        arr_steps << step.name
      end
      arr_steps
    end

    def set_ep(str_ep_stage)
      if str_ep_stage.downcase == "stage1 ep"
        return STAGE1_EP_NAME
      elsif str_ep_stage.downcase == "stage2 ep"
        return STAGE2_EP_NAME
      else
        raise "Invalid stage doctor : #{str_ep_stage}"
      end
    end

    def set_report_range(str_report_range)
      object_date_time = pacific_time_calculation
      str_from_date = object_date_time.strftime("0101%Y")

      if str_report_range.downcase == "within report range"
        object_to_date = object_date_time
      elsif str_report_range.downcase == "outside report range"
        object_to_date = object_date_time - 1.days
      elsif str_report_range.downcase == "2 days before within report range"
        object_to_date = object_date_time - 2.days
      elsif str_report_range.downcase == "3 days before within report range"
        object_to_date = object_date_time - 3.days
      else
        raise "Invalid report range : #{str_report_range}"
      end
      return str_from_date, object_to_date
    end

  end
end