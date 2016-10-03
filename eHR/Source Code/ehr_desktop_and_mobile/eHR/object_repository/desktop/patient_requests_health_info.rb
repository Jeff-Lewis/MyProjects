=begin
  *Name             : PatientRequestsHealthInformation
  *Description      : Class that contains all objects and methods in Patient Requests Health Information page
  *Author           : Mani.Sundaram
  *Creation Date    : 18/03/2015
  *Modification Date:
=end

module EHR
  class PatientRequestsHealthInformation
    include PageObject
    include PageUtils
    include Pagination
    include TransitionOfCare

    paragraph(:paragraph_popup_error_msg,             :xpath => "//div[@id='popup_small']//p")
    form(:form_create_health_record,                  :id    => "createHealthRecord")
    button(:button_create_report_yes,                 :xpath => "//div[@class='btn_yes']/input")
    button(:button_create_report_no,                  :xpath => "//div[@class='btn_no']/input")
    text_field(:textfield_report_request_on_date,     :name  => "ReportRequestedOn")
    text_field(:textfield_report_delivered_on_date,   :name  => "ReportDeliveredOn")
    button(:button_generate_health_record,            :id    => "lnkGenerateHealthRecord-button")
    button(:button_generate_health_record_for_visit,  :id    => "ActionButton1-button")
    div(:div_patient_request_details,                 :id    => "divPatientRequestDetails")
    div(:div_report_request_on_date_error,            :id    => "divReportRequestedOnError" )
    div(:div_report_delivered_on_date_error,          :id    => "divReportDeliveredOnError" )
    div(:div_health_record_request_list,              :id    => "health_record_div")
    table(:table_health_record_request_list,          :xpath => "//div[@id='health_record_div']/table")

    # description      : invoked automatically when page class object is created
    # Author           : Mani.Sundaram
    #
    def initialize_page
      wait_for_page_load
      wait_for_object(form_create_health_record_element,"Failure in finding patient create health form")
      raise paragraph_popup_error_msg_element.text.strip if paragraph_popup_error_msg_element.visible?
      hash_creation
    end

    # description          : creates hash for indexing table data
    # Author               : Mani.Sundaram
    #
    def hash_creation
      @hash_patient_health_record_list_table = {
          :REPORT_REQUEST_ON_DATE => 1,
          :REPORT_DELIVERED_ON_DATE => 2
      }
    end

    # Description      : function for report request and delivered date selection
    # Author           : Mani.Sundaram
    # Arguments:
    #   request_date   : specifies the request date of health report generation
    #   delivered_date : specifies the delivered date of health report generation
    #
    def date_selection(request_date, delivered_date)
      begin
        self.textfield_report_request_on_date = request_date
        self.textfield_report_delivered_on_date = delivered_date
      rescue Exception => ex
        $log.error("Error while setting date for health reporting period : #{ex}")
        exit
      end
    end

    # description          : Validating the generate health record date selection
    # Author               : Mani.Sundaram
    # Arguments            :
    #  str_enter_date      : which date field to verify as string
    #
    def validate_generate_health_record_date(str_enter_date)
      begin
        object_date_time = pacific_time_calculation
        case str_enter_date.downcase
          when "request date"
            self.textfield_report_delivered_on_date =(object_date_time + 1.days).strftime(DATE_FORMAT)
            button_generate_health_record_element.click
            raise "Invalid error msg getting displayed while entering the report request date" unless div_report_request_on_date_error_element.when_visible.text.strip.include? "Report Requested Date should be less than or equal to current date"
          when "delivered date"
            self.execute_script('arguments[0].removeAttribute("disabled");', textfield_report_delivered_on_date_element)
            self.textfield_report_delivered_on_date =(object_date_time - 1.days).strftime(DATE_FORMAT)
            button_generate_health_record_element.click
            raise "Invalid error msg getting displayed while entering the report delivered date" unless div_report_delivered_on_date_error_element.when_visible.text.strip.include? "Report Being Delivered Date should be greater than or equal to current date"
          else
            button_generate_health_record_element.click
            div_report_request_on_date_error_element.not_visible
            div_report_delivered_on_date_error_element.not_visible
        end
      rescue Exception => ex
        $log.error("Error while generating health report for '#{str_enter_date}' : #{ex}")
        exit
      end
    end

    # Description      : function for generate health status
    # Author           : Mani.Sundaram
    # Arguments:
    #   str_request    : specifies the patient's request
    #   str_report_for : specifies to generate the health report for patient/visit
    #   str_date       : specifies the date field
    #   str_date_value : specifies value for date field
    #
    def generate_health_report(str_request,str_report_for, str_date, str_date_value)
      begin
        @@old_row_count = get_table_row_count(div_health_record_request_list_element)
        object_date_time = pacific_time_calculation
        bool_question = is_text_present(self, "Are you creating this report at the patient request?", 5)
        bool_button_yes = button_create_report_yes_element.visible?
        bool_button_no = button_create_report_no_element.visible?
        if bool_question && bool_button_yes && bool_button_no
          $log.success("a question 'Are you creating this report at the patient request ?' with 2 buttons- Yes and No are visible")
        end

        case str_request.downcase
          when "with patient request"
            button_create_report_yes_element.click
            raise "Patient request details are not getting displayed" unless div_patient_request_details_element.visible?
            $log.success("Patient request details are getting displayed")

            if str_date.downcase == "request date" && str_date_value.downcase == "future date"
              self.textfield_report_request_on_date = (object_date_time + 1.days).strftime(DATE_FORMAT)
            else
              self.textfield_report_request_on_date = (object_date_time - 1.days).strftime(DATE_FORMAT)
            end

            if textfield_report_delivered_on_date_element.attribute("disabled") && textfield_report_delivered_on_date == object_date_time.strftime(DATE_FORMAT_WITH_SLASH)
              $log.success("Date of report being delivered to patient is current date and is in disabled mode")
            else
              raise "Date of report being delivered to patient is not current date and is not in disabled mode"
            end
          when "without patient request"
            button_create_report_no_element.click
            raise "Patient request details are getting displayed, Even we clicked the 'No' button" if div_patient_request_details_element.visible?
            $log.success("Patient request details are not getting displayed")
        end

        if str_report_for.downcase == "patient"
          button_generate_health_record_element.click
        elsif str_report_for.downcase == "visit"
          button_generate_health_record_for_visit_element.click
        else
          raise "Invalid input for Health report generation : #{str_report_for}"
        end
        if str_date.downcase == "request date" && str_date_value.downcase == "future date" && div_report_request_on_date_error_element.visible?
          $log.success("Proper validation message is getting displayed while selecting future date for Request date 'Report Requested Date should be less than or equal to current date'")
        elsif div_report_request_on_date_error_element.visible?
          raise "Report Requested Date should be less than or equal to current date"
        else
          $log.success("Health Record generated successfully")
        end
      rescue Exception => ex
        $log.error("Error while generating Health Record for #{str_report_for} #{str_request} : #{ex}")
        exit
      end
    end

    # description       : Verify entry has been added into health record list table
    # Author            : Mani.Sundaram
    # Arguments:
    #   str_request     : specifies the patient's request
    #
    def verify_generated_health_report_entry(str_request)
      begin
        div_copy_right_element.when_visible.scroll_into_view rescue Exception
        wait_for_object(table_health_record_request_list_element, "Failure in finding patient health record entry list table")
        @new_row_count = get_table_row_count(div_health_record_request_list_element)

        if str_request.downcase == "a record" && (@new_row_count == @@old_row_count + 1)
          $log.success("Entry is added into health record request list table")
        elsif str_request.downcase == "a record" && !(@new_row_count == @@old_row_count + 1)
          raise "Entry is not added into health record request list table"
        elsif (@new_row_count == @old_row_count + 1)
          raise "Entry is added into health record request list table"
        else
          $log.success("Entry is not added into health record request list table as expected")
        end
      rescue Exception => ex
        $log.error("Error while verifying health record request list table : #{ex}")
        exit
      end
    end

    # description       : Verify the data in health record
    # Author            : Gomathi
    # Arguments:
    #   str_option     : specifies the option in health record
    #
    def verify_health_record_details(str_option)
      begin
        case str_option.downcase
          when "race"
            str_patient_race = table_patient_details_element.cell_element(:xpath => ".//tr[3]/td[2]").text.downcase
          when "sex"
            str_patient_sex = table_patient_details_element.cell_element(:xpath => ".//tr[2]/td[4]").text.downcase
          else
            raise "Invalid input for str_option : #{str_option}"
        end
      rescue Exception => ex
        $log.error("Error while verifying health record details of #{str_option}: #{ex}")
        exit
      end
    end

  end
end
