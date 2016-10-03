=begin
  *Name             : DesktopHealthStatus
  *Description      : class that holds the desktop web HealthStatus page objects and method definitions
  *Author           : Chandra sekaran
  *Creation Date    : 02/03/2015
  *Modification Date:
=end

module EHR
  class DesktopHealthStatus < HealthStatus

    # Vitals History
    div(:div_vitals_history,               :id     =>  "editVitalsDiv")
    div(:div_vitals_list_details,          :id     =>  "Vitals_list_details_Container")
    table(:table_vitals_list_details,      :xpath  =>  "//div[@id='Vitals_list_details_Container']/table")
    link(:link_close_vitals_history,       :xpath  =>  "//div[@id='PopUpDivMaster']/a")

    # Description          : function that is automatically invoked when an object is created
    # Author               : Chandra sekaran
    def initialize_page
      create_hashes
    end

    # Description          : function for createing hashes for indexing table columns
    # Author               : Chandra sekaran
    def create_hashes
      @hash_problem_list_table_header = {
          :TASK => 1,
          :PROBLEM => 2,
          :DATE_ENTERED => 3,
          :STATUS => 4,
          :CODE_TYPE => 5
      }
      @hash_allergy_table_header = {
          :TASK => 1,
          :ALLERGEN => 2,
          :REACTION => 3,
          :SEVERITY => 4,
          :DATE_ENTERED => 5,
          :STATUS => 6
      }
      @hash_family_info_table_header = {
          :TASK => 1,
          :PROBLEM => 2,
          :REALTION => 3,
          :STATUS => 4,
          :DIAGNOSED_DATE => 5,
          :AGE_AT_DIAGNOSIS => 6
      }
      @hash_medication_list_table_header = {
          :TASK => 1,
          :MEDICATION => 2,
          :DOSE_UNIT => 3,
          :DRUG_FORMAT => 4,
          :ROUTE => 5,
          :NUMBER => 6,
          :FREQUENCY => 7,
          :STATUS => 8,
          :DATE_PRESCRIBED => 9
      }
      @hash_vitals_list_table_header = {
          :TASK => 1,
          :HEIGHT => 2,
          :WEIGHT  => 3,
          :BP => 4,
          :PULSE => 5,
          :RESPIRATION => 6,
          :BMI => 7,
          :CREATED_ON => 8
      }
    end

    # Description          : function for checking if the Health status data have been added
    # Author               : Chandra sekaran
    # Argument             :
    #   str_sub_section    : clinical data section name
    # Return argument      : a boolean value
    #
    def is_health_status_data_added(str_sub_section)
      begin
        element_location = table_data_element = num_problem_index = arr_health_status_data = element_view_all = ""
        case str_sub_section.downcase
          when /race/
            str_race = paragraph_race_element.text.strip
            bool_return = true
            if str_sub_section.downcase == "no race"
              bool_return = str_race.include?("Select 1 or more")
            end
            return bool_return
          when /problem/
            element_location = div_problem_list_details_element
            table_data_element = table_problem_list_element
            num_problem_index = @hash_problem_list_table_header[:PROBLEM]
            num_status_index = @hash_problem_list_table_header[:STATUS]
            arr_health_status_data = [$str_problem]
            element_view_all = span_view_all_problem_element
          when /medication/
            element_location = div_medication_div_element
            table_data_element = table_medication_details_element
            num_problem_index = @hash_medication_list_table_header[:MEDICATION]
            num_status_index = @hash_medication_list_table_header[:STATUS]
            arr_health_status_data = [$str_medication]
            element_view_all = span_view_all_medication_element
          when /med allergy/
            element_location = div_medication_allergy_element
            table_data_element = table_allergy_details_element
            num_problem_index = @hash_allergy_table_header[:ALLERGEN]
            num_status_index = @hash_allergy_table_header[:STATUS]
            arr_health_status_data = [$str_med_allergies]
            element_view_all = span_view_all_allergies_element
          when /family history/
            element_location = div_family_history_element
            table_data_element = table_family_info_element
            num_problem_index = @hash_family_info_table_header[:PROBLEM]
            num_status_index = @hash_family_info_table_header[:STATUS]
            arr_health_status_data = $arr_family_history
            element_view_all = div_view_all_family_element
          when /vital/
            return is_vital_data_added
          else
            raise "Invalid section name in desktop Health Status : #{str_sub_section}"
        end
        str_status = ["activated", "added"].include?($str_action.downcase) ? "Active" : "Inactive"

        element_location.when_visible.scroll_into_view rescue Exception
        element_view_all.when_visible.scroll_into_view rescue Exception
        element_view_all.click rescue Exception
        wait_for_loading rescue Exception

        2.times { element_location.when_visible.scroll_into_view rescue Exception }

        @str_row = nil
        if table_data_element.table_element(:xpath => $xpath_tbody_message_row).exists?
          obj_tr = table_data_element.table_element(:xpath => $xpath_tbody_message_row)
          if obj_tr.visible?
            @str_row = obj_tr.text.strip
          end
        end
        raise "No records found in Med Allergy for patient with ID #{$str_patient_id}" if !@str_row.nil? && @str_row.downcase.include?("no records found")

        bool_pager = true
        begin
          bool_pager = div_family_history_element.link_element(:xpath => "./div[3]/a[@class='yui-pg-next']").exists?
        rescue Exception => ex
          bool_pager = false
        end

        num_count = 0
        arr_health_status_data.each do |str_health_status_data|
          click_first(element_location) if bool_pager # goto first page
          bool_iterate = true
          while(bool_iterate)
            table_data_element.table_elements(:xpath => $xpath_tbody_data_row).each do |row|
              if row.cell_element(:xpath => "./td[#{num_problem_index}]").text.strip.include? str_health_status_data
                if row.cell_element(:xpath => "./td[#{num_status_index}]").text.strip.downcase == str_status.downcase
                  $log.success("'#{str_health_status_data}' found with status '#{str_status}' in desktop Health Status page")
                else
                  $log.error("'#{str_health_status_data}' found but not with status '#{str_status}' in desktop Health Status page")
                end
                num_count += 1
              end
            end
            bool_iterate = bool_pager ? click_next(element_location) : false
          end
        end
        num_count >= arr_health_status_data.size
      rescue Exception => ex
        $log.error("Error while checking for #{str_sub_section.capitalize} (#{arr_health_status_data}) in Health Status tab : #{ex}")
        exit
      end
    end

    # Description          : function for checking if the Vitals data have been added
    # Author               : Chandra sekaran
    # Argument             :
    #   str_vitals_node    : test data node
    # Return argument      :
    #   bool_return        : a boolean value
    #
    def is_vital_data_added(str_vitals_node = "vitals_data1")
      begin
        hash_vitals = set_scenario_based_datafile(VITAL_SIGNS)
        bool_return = true
        2.times { div_vital_container_element.scroll_into_view rescue Exception }
        str_height_feet = self.textfield_height_feet
        str_height_inch = self.textfield_height_inch
        str_weight_pound = self.textfield_weight
        str_actual_bmi = self.textfield_bmi
        str_bp_systolic = self.textfield_bp_systolic
        str_bp_diastolic = self.textfield_bp_diastolic

        # check for vitals in health status tab
        num_height_in_inch = (str_height_feet.to_i*12)+str_height_inch.to_i
        num_expected_bmi = str_weight_pound.to_f/(num_height_in_inch*num_height_in_inch)*703
        if num_expected_bmi.round(2) == str_actual_bmi.to_f
          $log.success("The BMI (#{str_actual_bmi.to_f}) has been calculated correctly")
        elsif num_expected_bmi.round(0) == str_actual_bmi.to_f.round(0)
          $log.error("The decimal of actual BMI(#{str_actual_bmi.to_f}) differs from expected BMI(#{num_expected_bmi.round(2)})")
        else
          raise "The decimal of actual BMI(#{str_actual_bmi.to_f}) is not equal to expected BMI(#{num_expected_bmi.round(2)})"
        end

        bool_return &&= str_height_feet.to_i == hash_vitals[str_vitals_node]["textfield_height_in_feet"]
        bool_return &&= str_height_inch.to_i == hash_vitals[str_vitals_node]["textfield_height_in_inch"]
        bool_return &&= str_weight_pound.to_f == hash_vitals[str_vitals_node]["textfield_weight"]
        bool_return &&= str_bp_systolic.to_i == hash_vitals[str_vitals_node]["textfield_systolic_bp"]
        bool_return &&= str_bp_diastolic.to_i == hash_vitals[str_vitals_node]["textfield_diastolic_bp"]
        if bool_return
          $log.success("The vitals data are present in Health Status tab")
        else
          raise "The vitals data are not present in Health Status tab"
        end

        # check for vitals in vitals history table in iframe
        click_on(span_history_vital_element)
        wait_for_object(div_vitals_history_element, "Failure in finding Vitals History div element")
        arr_cells = table_vitals_list_details_element.cell_elements(:xpath => "#{$xpath_tbody_data_first_row}/td")
        bool_return &&= arr_cells[@hash_vitals_list_table_header[:HEIGHT]-1].text.strip.include? str_height_feet
        bool_return &&= arr_cells[@hash_vitals_list_table_header[:HEIGHT]-1].text.strip.include? str_height_inch
        bool_return &&= arr_cells[@hash_vitals_list_table_header[:WEIGHT]-1].text.strip.include? str_weight_pound
        bool_return &&= arr_cells[@hash_vitals_list_table_header[:BP]-1].text.strip.include? str_bp_systolic
        bool_return &&= arr_cells[@hash_vitals_list_table_header[:BP]-1].text.strip.include? str_bp_diastolic
        bool_return &&= arr_cells[@hash_vitals_list_table_header[:BMI]-1].text.strip.include? str_actual_bmi
        click_on(link_close_vitals_history_element)  # close the vitals history iframe
        if bool_return
          $log.success("The vitals data are present in Vitals History table iframe")
        else
          raise "The vitals data are not present in Vitals History table iframe"
        end

        # check for Vital chart
        click_on(span_vital_chart_element)
        switch_to_next_window
        wait_for_loading
        bool_return &&= image_elements(:xpath => '//img').size > 3
        if bool_return
          $log.success("Successfully opened Vital chart and verified screen contents")
        else
          raise "failure in opening/verifying Vital chart"
        end
        switch_to_application_window
        bool_return
      rescue Exception => ex
        $log.error("Error while checking for Vitals in Health Status tab : #{ex}")
        link_close_vitals_history_element.click if link_close_vitals_history_element.exists?
        switch_to_application_window   # closes the vital window if opened
        exit
      end
    end
  end
end