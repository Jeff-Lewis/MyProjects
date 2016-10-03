=begin
  *Name             : AMCStage
  *Description      : contains all objects and methods in AMC Stage
  *Author           : Gomathi
  *Creation Date    : 22/08/2014
  *Modification Date:
=end

module EHR
  class AMCStage

    include PageObject
    include PageUtils
    include Pagination
    include AllEPReport

    form(:form_AMC_page,                            :id    => "measurecalculationForm")
    select_list(:select_EP,                         :id    => "NPI_id")
    text_field(:textfield_from_date,                :id    => "felix-widget-calendar-FromDate-input")
    text_field(:textfield_to_date,                  :id    => "felix-widget-calendar-ToDate-input")
    checkbox(:check_include_cqm_report,             :id    => "chbkCQMReport")
    div(:div_ep_stage_message,                      :id    => "divStageReporting")
    button(:button_generate_report,                 :id    => "lnkMeasureCalc-button")
    div(:div_measure_calculation,                   :id    => "measurecalculation")
    table(:table_core_set_measure,                  :id    => "tblCoreSetmeasure")
    table(:table_menu_set_measure,                  :id    => "tblMenuSetMeasure")
    table(:table_core_set_health_companion_measure, :id    => "tblHcMeasure")
    table(:table_CQM_measure,                       :id    => "tblCQMMeasure")
    button(:button_print,                           :xpath => "//input[contains(@class,'yui-button yui-radio-button-checked')]")

    # Reminder mail objects
    div(:div_reminder_confirm_dialog,               :id    => "conformdialog")
    button(:button_reminder_confirm_dialog_ok,      :xpath => "//button[text()='OK']")
    button(:button_Send_Reminder,                   :xpath =>  "//input[@value='Send']")

    # description  : Function will get invoked when object for page class is created
    # Author       : Gomathi
    #
    def initialize_page
      wait_for_loading
      hash_creation
    end

    # Description       : creates hash for indexing table data
    # Author            : Gomathi
    #
    def hash_creation
      @hash_AMC_table_header = {
          :PRINT_ITEM_SELECTION_CHECKBOX => 1,
          :EXEMPT => 2,
          :OBJECTIVE => 3,
          :NUMERATOR => 4,
          :DENOMINATOR => 5,
          :PERCENTAGE => 6,
          :REQUIREMENT => 7
      }

      @hash_CQM_report_table_header = {
          :PRINT_ITEM_SELECTION_CHECKBOX => 1,
          :OBJECTIVE => 2,
          :NUMERATOR => 3,
          :DENOMINATOR => 4,
          :PERFORMANCE_RATE => 5,
          :EXCLUSION => 6
      }

      @hash_AMC_table_objectives = {
          :CPOE_FOR_MEDICATION_ORDER => "CPOE for Medication Order",
          :CPOE_FOR_MEDICATION_ORDERS_ALTERNATE => "CPOE for Medication Orders - Alternate",
          :PROBLEM_LIST => "Problem List",
          :GENERATE_AND_TRANSMIT_ERX => "Generate and Transmit eRx",
          :MEDICATION_LIST => "Medication List",
          :MEDICATION_ALLERGY_LIST => "Medication Allergy List",
          :DEMOGRAPHICS => "Demographics",
          :VITAL_SIGNS => "Vital Signs",
          :VITAL_SIGNS_ALTERNATE => "Vital Signs- Alternate",
          :VITAL_SIGNS_HEIGHT_AND_WEIGHT => "Vital Signs - Height and Weight",
          :VITAL_SIGNS_BLOOD_PRESSURE => "Vital Signs - Blood Pressure",
          :SMOKING_STATUS => "Smoking Status",
          :CLINICAL_DECISION_SUPPORT => "Clinical Decision Support",
          :ELECTRONIC_COPY_OF_HEALTH_RECORD => "Electronic Copy of Health Record",
          :PROVIDE_CLINICAL_SUMMARY => "Provide Clinical Summary",
          :CONDUCT_ANNUAL_SECURITY_RISK_ANALYSIS => "Conduct Annual Security Risk Analysis",
          :CPOE_FOR_RADIOLOGY_ORDERS => "CPOE for Radiology Orders",
          :CPOE_FOR_LABORATORY_ORDERS => "CPOE for Laboratory Orders",
          :PATIENT_SPECIFIC_EDUCATION_RESOURCES => "Patient Specific Education Resources",
          :DRUG_DRUG_AND_DRUG_ALLERGY_INTERACTION_CHECKS_ENABLED => "Drug-Drug and Drug-Allergy Interaction Checks Enabled",
          :SUMMARY_OF_CARE_PROVIDED_FOR_TRANSITIONS => "Summary of Care Provided for Transitions",
          :SUMMARY_OF_CARE_PROVIDED_ELECTRONICALLY => "Summary of Care Provided Electronically",
          :MEDICATION_RECONCILIATION => "Medication Reconciliation",
          :GENERATE_PATIENT_LIST => "Generate Patient List",
          :PATIENT_ELECTRONIC_ACCESS => "Patient Electronic Access",
          :PREVENTIVE_CARE => "Preventive Care",
          :INCORPORATE_CLINICAL_LAB_RESULTS => "Incorporate Clinical Lab Results",
          :PERFORM_ONE_TEST_TO_SUBMIT_IMMUNIZATION_INFORMATION => "Perform One Test to Submit Immunization Information",
          :PERFORM_ONE_TEST_TO_EXCHANGE_SUMMARY_OF_CARE_DOCUMENT => "Perform One Test to Exchange Summary of Care Document",
          :DRUG_FORMULARY_CHECKS_ENABLED => "Drug Formulary Checks Enabled",
          :SEND_REMINDERS => "Send Reminders",
          :TRANSITION_SUMMARY_OF_CARE => "Transition Summary of Care",
          :PERFORM_ONE_TEST_TO_PROVIDE_SYNDROMIC_DATA => "Perform One Test to Provide Syndromic Data",
          :IMAGING_RESULTS => "Imaging Results",
          :FAMILY_HEALTH_HISTORY => "Family Health History",
          :RECORD_ELECTRONIC_NOTES => "Record Electronic Notes",
          :SECURE_MESSAGING => "Secure Messaging",
          :PATIENT_ELECTRONIC_ACCESS_VIEW_DOWNLOAD_TRANSMIT => "Patient Electronic Access-View Download,Transmit",
          :CONTROLLING_HIGH_BLOOD_PRESSURE_NQF0018 => "Controlling High Blood Pressure (NQF0018)",
          :WEIGHT_ASSESSMENT_AND_COUNCELLING_FOR_NUTRITION_AND_PHYSICAL_ACTIVITY_FOR_CHILDREN_AND_ADOLESCENTS_BMI_RECORDED_3_17_NQF0024 => "Weight Assessment and Counseling for Nutrition and Physical Activity for Children and Adolescents - BMI Recorded 3-17 (NQF0024)",
          :WEIGHT_ASSESSMENT_AND_COUNCELLING_FOR_NUTRITION_AND_PHYSICAL_ACTIVITY_FOR_CHILDREN_AND_ADOLESCENTS_NUTRITION_COUNCELLING_3_17_NQF0024 => "Weight Assessment and Counseling for Nutrition and Physical Activity for Children and Adolescents - Nutrition Counseling 3-17 (NQF0024)",
          :WEIGHT_ASSESSMENT_AND_COUNCELLING_FOR_NUTRITION_AND_PHYSICAL_ACTIVITY_FOR_CHILDREN_AND_ADOLESCENTS_PHYSICAL_ACTIVITY_COUNCELLING_3_17_NQF0024 => "Weight Assessment and Counseling for Nutrition and Physical Activity for Children and Adolescents - Physical Activity Counseling 3-17 (NQF0024)",
          :PREVENTATIVE_CARE_AND_SCREENING_TOBACCO_USE_SCREENING_AND_CESSATION_INTERVENTION_NQF0028 => "Preventative Care and Screening: Tobacco Use: Screening and Cessation Intervention (NQF0028)",
          :BREAST_CANCER_SCREENING_NQF0031 => "Breast Cancer Screening (NQF0031)",
          :COLORECTAL_CANCER_SCREENING_NQF0034 => "Colorectal Cancer Screening (NQF0034)",
          :CHILDHOOD_IMMUNIZATIONSTATUS_NQF0038 => "Childhood Immunization Status (NQF0038)",
          :PNEUMONIA_VACCINATION_STATUS_FOR_OLDER_ADULTS_NQF0043 => "Pneumonia Vaccination Status for Older Adults (NQF0043)",
          :DOCUMENTATION_OF_CURRENT_MEDICATIONS_IN_THE_MEDICAL_RECORD_NQF0419 => "Documentation of Current Medications in the Medical Record (NQF0419)",
          :PREVENTATIVE_CARE_AND_SCREENING_BMI_SCREENING_AND_FOLLOW_UP_65_PLUS_NQF0421 => "Preventative Care and Screening: Body Mass Index (BMI) Screening and Follow-Up - 65+ (NQF0421)",
          :PREVENTATIVE_CARE_AND_SCREENING_BMI_SCREENING_AND_FOLLOW_UP_18_64_NQF0421 => "Preventative Care and Screening: Body Mass Index (BMI) Screening and Follow-Up - 18-64 (NQF0421)"
      }

      @hash_AMC_popup_table_header = {
          :PATIENT_INFORMATION => 1,
          :NUMERATOR_INFORMATION => 2,
          :REASON => 3
      }
    end

    # description       : function for generating report of a EP with given From date and To date
    # Author            : Gomathi
    # Arguments         :
    #   str_EP_name     : EP name for creating report
    #   str_from_date   : From date for creating report; should be in format '31122014' for '31-12-2014'
    #   str_to_date     : To date for creating report; should be in format '31122014' for '31-12-2014'
    #
    def AMC_generate_report(str_EP_name, str_from_date = nil, str_to_date = nil, str_cqm_option = "")
      begin
        select_EP_element.when_visible.select(str_EP_name)
        wait_for_loading
        if !str_from_date.nil?
          textfield_from_date_element.focus
          self.textfield_from_date = str_from_date
        end
        if !str_to_date.nil?
          textfield_to_date_element.focus
          self.textfield_to_date = str_to_date
        end
        verify_time
        if str_cqm_option.downcase == "with cqm report"
          check_check_include_cqm_report unless check_include_cqm_report_element.checked?
        elsif str_cqm_option.downcase == "without cqm report"
          uncheck_check_include_cqm_report if check_include_cqm_report_element.checked?
        end
        click_on(button_generate_report_element)

        if is_text_present(self, "Reporting period cannot span across different years.", 5)
          refresh_page(self)
          select_EP_element.when_visible.select(str_EP_name)
          wait_for_loading
          if !str_from_date.nil?
            textfield_from_date_element.focus
            self.textfield_from_date = str_from_date
          end
          if !str_to_date.nil?
            textfield_to_date_element.focus
            self.textfield_to_date = str_to_date
          end
          verify_time
          click_on(button_generate_report_element)
          raise "Reporting period cannot span across different years (From date => #{textfield_from_date} & To date => #{textfield_to_date})" if is_text_present(self, "Reporting period cannot span across different years.", 5)
        end
        if str_EP_name.downcase == "select all eligible providers"
          switch_to_next_window    # switches to the window
          wait_until(400, "All EP report is loading after 400s") { !img_progress_bar_element.visible? }
        else
          wait_for_object(div_measure_calculation_element, "Failure in finding AMC report page tables for #{str_EP_name}")
        end
        $log.success("Report for #{str_EP_name} generated successfully") #if div_measure_calculation_element.visible?
      rescue Exception => ex
        if ex.message.include? "xpath expression './/child::option'"
          refresh_page(self)
          AMC_generate_report(str_EP_name, str_from_date, str_to_date)   # reinvoke method
        elsif ex.message == "undefined method `click' for nil:NilClass" && $bool_ep_inactivated
          $log.success("The Inactivated EP(#{$str_ep_name}) is not listed in Eligible Professional list")
        else
          $log.error("Error while generating AMC Report for #{str_EP_name} : #{ex}")
          exit
        end
      end
    end

    # description          : function for getting parent table object
    # Author               : Gomathi
    # Arguments:
    #   str_table_name     : table name from which details taken
    # Return argument      : table object
    #
    def get_parent_table_element(str_table_name)
      begin
        case str_table_name.downcase
          when "core set"
            return table_core_set_measure_element
          when "menu set"
            return table_menu_set_measure_element
          when "health companian"
            return table_core_set_health_companion_measure_element
          when "cqm report"
            return table_CQM_measure_element
          else
            raise "Invalid table name #{str_table_name}"
        end
      rescue Exception => ex
        $log.error("Error while sending parent table object : #{ex}")
        return nil
      end
    end

    # description          : function for getting details of an Objective from amc table
    # Author               : Gomathi
    # Arguments            :
    #   str_AMC_table      : string that denotes whether the table is core set table or menu set table or core set health companian table
    #   str_AMC_objective  : it denotes the row objective in table, Ex: Demographics
    # Return arguments     :
    #   @numerator         : returns the value of numerator
    #   @denominator       : returns the value of denominator
    #   @percentage        : returns the value of percentage
    #   @requirement       : returns the value of expected percentage
    #
    def get_objective_details(str_AMC_table, str_AMC_objective)
      begin
        @table_name_object = get_parent_table_element(str_AMC_table)
        wait_for_object(@table_name_object, "Failure in finding #{str_AMC_table} table under AMC page")

        @str_objective = get_objective_value(str_AMC_objective)

        @table_name_object.scroll_into_view rescue Exception

        # get all tr tags (rows) of the table using xpath
        @table_name_object.table_elements(:xpath => "./tbody/tr").each do |row_in_AMC_table|
          row_in_AMC_table.scroll_into_view rescue Exception
          if row_in_AMC_table.cell_element(:xpath => "./td[#{@hash_AMC_table_header[:OBJECTIVE]}]").text.strip == @str_objective.strip
            @numerator = row_in_AMC_table.cell_element(:xpath => "./td[#{@hash_AMC_table_header[:NUMERATOR]}]").text.strip
            @denominator = row_in_AMC_table.cell_element(:xpath => "./td[#{@hash_AMC_table_header[:DENOMINATOR]}]").text.strip
            @percentage = row_in_AMC_table.cell_element(:xpath => "./td[#{@hash_AMC_table_header[:PERCENTAGE]}]").text.strip.gsub("%", "")
            @requirement = row_in_AMC_table.cell_element(:xpath => "./td[#{@hash_AMC_table_header[:REQUIREMENT]}]").text.strip.gsub("%", "")

            $log.success("Details of #{str_AMC_objective} objective taken successfully")
            return @numerator, @denominator, @percentage, @requirement
          end
        end
        raise "Could not find #{str_AMC_objective} objective under #{str_AMC_table}"
      rescue Exception => ex
        $log.error("Error while getting details of objectives from table : #{ex}")
        exit
      end
    end

    # description           : function to click and view Numerator link popup in AMC table
    # Author                : Gomathi
    # Arguments             :
    #   str_AMC_table       : string that denotes whether the table is core set table or menu set table or core set health companian table
    #   str_AMC_objective   : it denotes the row objective in table, Ex: Demographics
    # Return argument       : str_numerator_value
    #
    def click_numerator(str_AMC_table, str_AMC_objective)
      begin
        @table_name_object = get_parent_table_element(str_AMC_table)
        wait_for_object(@table_name_object, "Failure in finding #{str_AMC_table} table under AMC page")

        @str_objective = get_objective_value(str_AMC_objective)

        @table_name_object.scroll_into_view rescue Exception

        # get all tr tags (rows) of the table using xpath
        @table_name_object.table_elements(:xpath => "./tbody/tr").each do |row_in_AMC_table|
          wait_for_object(row_in_AMC_table, "Failure in finding #{str_AMC_table} table row")
          row_in_AMC_table.scroll_into_view rescue Exception

          if row_in_AMC_table.cell_element(:xpath => "./td[#{@hash_AMC_table_header[:OBJECTIVE]}]").text.strip.downcase == @str_objective.strip.downcase
            obj_link = row_in_AMC_table.link_element(:xpath => "./td[#{@hash_AMC_table_header[:NUMERATOR]}]/div/a")
            str_numerator_value = obj_link.text.strip
            3.times { obj_link.send_keys(:arrow_down) } rescue Exception
            obj_link.click
            wait_for_object(div_numerator_popup_element, "Failure in finding Numerator popup page")
            raise "Invalid numerator link popup" if !is_text_present(self, "#{@str_objective} - Numerator Recordings", 20 )
            $log.success("Numerator clicked and details taken successfully")
            return str_numerator_value
          end
        end
        raise "Could not find #{str_AMC_objective} objective under #{str_AMC_table}"
      rescue Exception => ex
        $log.error("Error while clicking numerator link: #{ex}")
        exit
      end
    end

    # description          : function to get the content of tooltip from AMC table
    # Author               : Gomathi
    # Arguments            :
    #   str_AMC_table      : string that denotes whether the table is core set table or menu set table or core set health companian table
    #   str_AMC_objective  : it denotes the row objective in table, Ex: Demographics
    # Return argument      : @str_tooltip
    #
    def get_tooltip_content(str_AMC_table, str_AMC_objective)
      begin
        table_menu_set_measure_element.when_visible.scroll_into_view rescue Exception if $str_ep.downcase == "stage1 ep"
        div_copy_right_element.when_visible.scroll_into_view rescue Exception if str_AMC_table.downcase == "menu set"
        #div_copy_right_element.when_visible.scroll_into_view rescue Exception if str_AMC_objective.downcase == "incorporate clinical lab results"
        #table_core_set_health_companion_measure_element.when_visible.scroll_into_view rescue Exception if str_AMC_objective.downcase == "incorporate clinical lab results"

        @table_name_object = get_parent_table_element(str_AMC_table)
        wait_for_object(@table_name_object, "Failure in finding #{str_AMC_table} table under AMC page")

        @str_objective = get_objective_value(str_AMC_objective)

        @table_name_object.scroll_into_view rescue Exception

        # get all tr tags (rows) of the table using xpath
        @table_name_object.table_elements(:xpath => "./tbody/tr").each do |row_in_AMC_table|
          wait_for_object(row_in_AMC_table, "Failure in finding table row")
          row_in_AMC_table.when_visible.scroll_into_view rescue Exception
          table_core_set_health_companion_measure_element.when_visible.scroll_into_view rescue Exception if str_AMC_objective.downcase == "incorporate clinical lab results"

          if row_in_AMC_table.cell_element(:xpath => "./td[#{@hash_AMC_table_header[:OBJECTIVE]}]").text.strip == @str_objective.strip
            4.times { row_in_AMC_table.send_keys(:arrow_down) } rescue Exception
            obj_tooltip_image = row_in_AMC_table.cell_element(:xpath => "./td[#{@hash_AMC_table_header[:OBJECTIVE]}]").image_element(:xpath => "./div/img")
            obj_tooltip_image.focus
            obj_tooltip_image.click rescue Exception
            obj_tooltip_image.fire_event("onmouseover")
            div_tooltip_element.when_visible.focus
            @str_tooltip = div_tooltip_element.when_visible.text
            break
          end
        end
        if !@str_tooltip.nil?
          $log.success("Tooltip content taken successfully")
          return @str_tooltip
        else
          raise "Failure in finding tooltip content for #{str_AMC_objective} under #{str_AMC_table}"
        end
      rescue Exception => ex
        $log.error("Error while selecting tooltip content : #{ex}")
        exit
      end
    end

    # description          : function for verifying the numerator link Report
    # Author               : Gomathi
    # Arguments            :
    #   str_patient_id     : string that contains the Patient id to verify the report
    #   arr_param          : array that contains the parameter to verify the report
    #   num_column         : it specifies the column number in the report table
    #   str_table          : string that denotes whether the table is core set table or menu set table or core set health companian table
    #   str_objective      : it denotes the row objective in table, Ex: Demographics
    # Return argument      : a boolean value
    #
    def is_report_exists(str_patient_id, arr_visit_id, str_reason)
      begin
        #sleep 1 until !is_text_present(self, "Loading...", 1) if @str_objective.downcase == "medication reconciliation"
        #sleep 1 until !is_text_present(self, "Loading...", 1) if @str_objective.downcase == "demographics"
        sleep 1 until !is_text_present(self, "Loading...", 1)
        3.times { link_numerator_popup_close_element.when_visible.send_keys(:arrow_down) } rescue Exception

        # switching to the numerator report iframe
        numerator_ifram = @browser.window_handles.last
        @browser.switch_to.window(numerator_ifram)

        # since new record are added at the end of report
        click_last(div_numerator_popup_details_element)     # moves to the last page in the list

        num_row = 0

        # to handle exception if the report page shows no records found
        bool_iterate = true
        while(bool_iterate)
          if is_text_present(self, "No records found", 3)
            bool_iterate = click_prev(div_numerator_popup_details_element)
          else
            bool_iterate = false
          end
        end

        num_row = get_table_row_count_per_page(div_numerator_popup_details_element)
        return false if num_row == 0

        bool_iterate = true
        while(bool_iterate)
          table_numerator_popup_details_element.table_elements(:xpath => $xpath_tbody_data_row).each do |row|
            wait_for_object(row)
            str_patient_information = row.cell_element(:xpath => "./td[#{@hash_AMC_popup_table_header[:PATIENT_INFORMATION]}]").when_visible.text.strip
            if str_patient_information.strip.downcase.include?(str_patient_id.downcase)
              if !(@str_objective.downcase == "incorporate clinical lab results")
                td_visit_data = row.cell_element(:xpath => "./td[#{@hash_AMC_popup_table_header[:NUMERATOR_INFORMATION]}]")
                arr_visit_data = td_visit_data.text.split(",")
                td_reason_data = row.cell_element(:xpath => "./td[#{@hash_AMC_popup_table_header[:REASON]}]")
                str_reason_data = td_reason_data.text

                num_count = 0
                if !arr_visit_id.nil?
                  arr_visit_id.each do |str_visit_data|
                    arr_visit_data.each do |str_visit_data|
                      num_count += 1 if str_visit_data.strip.downcase == str_visit_data.downcase
                    end
                  end
                end

                return true if num_count == arr_visit_data.size && str_reason_data.strip.downcase == str_reason.downcase
              else
                td_reason_data = row.cell_element(:xpath => "./td[#{@hash_AMC_popup_table_header[:NUMERATOR_INFORMATION]}]")
                str_reason_data = td_reason_data.text
                return true if str_reason_data.strip.downcase == str_reason.downcase
              end
            end
          end
          if $scenario_tags.include?("@hl7")
            bool_iterate = click_prev(div_numerator_popup_details_element)  # moves to the previous page
          else
            return false
          end
        end
       return false
      rescue Exception => ex
        $log.error("Error while checking report for a patient (#{str_patient_id})  : #{ex}")
        click_on(link_numerator_popup_close_element)
        exit
      end
    end

    # description      : function to verify the from and to date in the AMC page
    # Author           : Gomathi
    #
    def verify_time
      begin
        object_date_time = pacific_time_calculation
        current_date = object_date_time.strftime(DATE_FORMAT_WITH_SLASH)
        start_date =  object_date_time.strftime("01/01/%Y")

        if self.textfield_from_date == start_date &&  self.textfield_to_date == current_date
          $log.success("From date matches the start date of the year (#{start_date}) and To date matches the current date of the server (#{current_date})")
        else
          $log.error("Mismatch occur in start date and current date of the year")
        end
      rescue Exception => ex
        $log.error("Error while verifying the start date & current date of the year : #{ex}")
      end
    end

    # description           : function for checking first column checkbox status in AMC report page
    # Author                : Gomathi
    # Arguments             :
    #	  str_AMC_table       : AMC report table name
    #	  str_AMC_objective   : Objective name
    # Return argument       : @bool_checkbox_status
    #
    def get_print_item_checkbox_status(str_AMC_table, str_AMC_objective)
      begin
        @table_name_object = get_parent_table_element(str_AMC_table)
        wait_for_object(@table_name_object, "Failure in finding #{str_AMC_table} table under AMC page")

        @str_objective = get_objective_value(str_AMC_objective)

        @table_name_object.scroll_into_view rescue Exception

        # get all tr tags (rows) of table using xpath
        @table_name_object.table_elements(:xpath => "./tbody/tr").each do |row_in_AMC_table|
          row_in_AMC_table.scroll_into_view rescue Exception
          if row_in_AMC_table.cell_element(:xpath => "./td[#{@hash_AMC_table_header[:OBJECTIVE]}]").text.strip == @str_objective.strip
            @bool_checkbox_status = row_in_AMC_table.checkbox_element(:xpath => "./td[#{@hash_AMC_table_header[:PRINT_ITEM_SELECTION_CHECKBOX]}]/input[@class='yui-dt-checkbox']").checked?

            $log.success("Selection checkbox status for objective #{str_AMC_objective} taken successfully")
            return @bool_checkbox_status
          end
        end
        raise "Could not find #{str_AMC_objective} objective under #{str_AMC_table}"
      rescue Exception => ex
        $log.error("Error while getting Selection checkbox status from table : #{ex}")
        exit
      end
    end

    # description            : function for sending reminder
    # Author                 : Chandra sekaran
    # Arguments              :
    #	  str_AMC_table        : AMC report table name
    #	  str_AMC_objective    : Objective name
    #
    def send_reminder(str_AMC_table, str_AMC_objective)
      begin
        raise "No 'Send' button exists for objective '#{str_AMC_objective}'" if !is_send_button_exists(str_AMC_table, str_AMC_objective)
        # get all tr tags (rows) of table using xpath
        @table_name_object.table_elements(:xpath => "./tbody/tr").each do |row_in_AMC_table|
          row_in_AMC_table.scroll_into_view rescue Exception
          3.times { row_in_AMC_table.send_keys(:arrow_down) } rescue Exception if BROWSER.downcase == "chrome"
          if row_in_AMC_table.cell_element(:xpath => "./td[#{@hash_AMC_table_header[:OBJECTIVE]}]").text.strip == @str_objective.strip
            click_on(button_Send_Reminder_element)    # clicks the Send button
            button_reminder_confirm_dialog_ok_element.when_visible.click   # click OK button on confirm dialog box
            wait_for_loading
            # clicks Send button until it is visible
            #3.times do
            #  if button_Send_Reminder_element.exists?
            #    break if !click_on(button_Send_Reminder_element)    # clicks the Send button
            #    button_reminder_confirm_dialog_ok_element.when_visible.click   # click OK button on confirm dialog box
            #    wait_for_loading
            #  else
            #    break
            #  end
            #end
            break
          end
        end
      rescue Exception => ex
        $log.error("Error while sending reminder in AMC report page : #{ex}")
        exit
      end
    end

    # description          	 : function for verifying send button existence
    # Author                 : Chandra sekaran
    # Arguments              :
    #	  str_AMC_table      : AMC report table name
    #	  str_AMC_objective  : Objective name
    # Return argument      	 : a boolean value
    #
    def is_send_button_exists(str_AMC_table, str_AMC_objective)
      begin
        @table_name_object = get_parent_table_element(str_AMC_table)
        wait_for_object(@table_name_object, "Failure in finding #{str_AMC_table} table under AMC page")
        @str_objective = get_objective_value(str_AMC_objective)
        @table_name_object.scroll_into_view rescue Exception

        # get all tr tags (rows) of table using xpath
        @table_name_object.table_elements(:xpath => "./tbody/tr").each do |row_in_AMC_table|
          row_in_AMC_table.scroll_into_view rescue Exception      # 3.times { row_in_AMC_table.send_keys(:arrow_down) } rescue Exception
          if row_in_AMC_table.cell_element(:xpath => "./td[#{@hash_AMC_table_header[:OBJECTIVE]}]").text.strip == @str_objective.strip
            if row_in_AMC_table.button_element(:xpath => "./td[#{@hash_AMC_table_header[:PERCENTAGE]}]/div/input").exists?
              return true
            else
              return false
            end
          end
        end
        raise "Could not find #{str_AMC_objective} objective under #{str_AMC_table}"
      rescue Exception => ex
        $log.error("Error while checking Send button existence in AMC report page : #{ex}")
        exit
      end
    end

    # description            : function for verifying the table attribute count change in AMC report page
    # Author                 : Gomathi
    # Arguments              :
    #	  num_old_value        : old value of table attribute
    #	  num_new_value        : new value of table attribute
    #   num_count            : count difference between new value and old value
    #   str_action           : action performed between old and new values
    #   str_table_attribute  : name of table attribute
    #
    def count_verification(num_old_value, num_new_value, num_count, str_action, str_table_attribute)
      if str_action.downcase == "increased"
        raise "#{str_table_attribute} is not correct : #{num_old_value} + #{num_count} != #{num_new_value}" if !((num_old_value + num_count) == num_new_value)
      elsif str_action.downcase == "decreased"
        raise "#{str_table_attribute} is not correct : #{num_old_value} - #{num_count} != #{num_new_value}" if !((num_old_value - num_count) == num_new_value)
      else
        raise "Invalid action for #{str_table_attribute} : #{str_action}"
      end
      $log.success("#{str_table_attribute} is #{str_action} by #{num_count} (#{num_old_value} => #{num_new_value})")
    end

    # description            : function for verifying the table attribute value in AMC report page
    # Author                 : Gomathi
    # Arguments              :
    #	  actual_value         : actual value of table attribute
    #	  expected_value       : expected value of table attribute
    #   str_table_attribute  : name of table attribute
    #
    def value_verification(actual_value, expected_value, str_table_attribute)
      if actual_value.to_i == expected_value.to_i
        $log.success("The actual #{str_table_attribute} value (#{actual_value}) is equal to expected #{str_table_attribute} value (#{expected_value})")
      else
        raise("The actual #{str_table_attribute} value (#{actual_value}) is not equal to expected #{str_table_attribute} value (#{expected_value})")
      end
    end

    # description            : function for verifying whether a given Objective is present in AMC report table
    # Author                 : Gomathi
    # Arguments              :
    #	  str_AMC_objective  : objective name
    #	  str_AMC_table      : table name under which the objective is present
    #
    def is_objective_exists(str_AMC_objective, str_AMC_table)
      begin
        @table_name_object = get_parent_table_element(str_AMC_table)
        wait_for_object(@table_name_object, "Failure in finding #{str_AMC_table} table under AMC page")
        @str_objective = get_objective_value(str_AMC_objective)
        @table_name_object.scroll_into_view rescue Exception

        # get all tr tags (rows) of table using xpath
        if str_AMC_table.downcase == "cqm report"
          index_element = @hash_CQM_report_table_header[:OBJECTIVE]
        else
          index_element = @hash_AMC_table_header[:OBJECTIVE]
        end
        @table_name_object.table_elements(:xpath => "./tbody/tr").each do |row_in_AMC_table|
          row_in_AMC_table.scroll_into_view rescue Exception
          if row_in_AMC_table.cell_element(:xpath => "./td[#{index_element}]").text.strip == @str_objective.strip
            $log.success("The #{str_AMC_objective} objective is present under #{str_AMC_table} table")
            break
          end
        end
      rescue Exception => ex
        $log.error("Error while checking for #{str_AMC_objective} objective existence in AMC report page : #{ex}")
        exit
      end
    end

    # description            : function to get the exact objective from the objective hash
    # Author                 : Chandra sekaran
    # Arguments              :
    #	  str_AMC_objective    : objective name
    #	Return Argument        : a hash key holding value for the given objective
    #
    def get_objective_value(str_AMC_objective)
      @hash_AMC_table_objectives.each do |key, value|
        return @hash_AMC_table_objectives[key] if value.casecmp(str_AMC_objective) == 0
      end
      raise "Invalid objective name #{str_AMC_objective}"
    end

    def is_table_exists(str_report_option, str_report)
      begin
        case str_report.downcase
          when "stage1 amc"
            wait_for_object(table_core_set_measure_element, "Failure in finding Core Set table for Stage 1", 5)
            wait_for_object(table_menu_set_measure_element, "Failure in finding Menu Set table for Stage 1", 5)
          when "stage2 amc"
            wait_for_object(table_core_set_measure_element, "Failure in finding Core Set table for Stage 2", 5)
            wait_for_object(table_core_set_health_companion_measure_element, "Failure in finding Core Set Health Companion table for Stage 2", 5)
            wait_for_object(table_menu_set_measure_element, "Failure in finding Menu Set table for Stage 2", 5)
          when "cqm"
            wait_for_object(table_CQM_measure_element, "Failure in finding CQM Report table", 5)
          else
            raise "Invalid input for str_report : #{str_report}"
        end
        $log.success("#{str_report} report exists in AMC page")
      rescue Exception => ex
        if ex.message.downcase == "failure in finding cqm report table" && str_report_option.downcase == "no"
          $log.success("CQM report is not exist in AMC page")
        else
          $log.error("Failure in finding #{str_report} table existence : #{ex}")
          exit
        end
      end
    end

    # private variables of AMC Stage class
    private
    attr_reader :numerator, :denominator

  end
end