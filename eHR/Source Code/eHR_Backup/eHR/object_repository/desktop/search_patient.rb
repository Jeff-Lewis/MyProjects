=begin
  *Name             : SearchPatient
  *Description      : contains all objects and methods in Search Patient page
  *Author           : Gomathi
  *Creation Date    : 25/08/2014
  *Modification Date:
=end

module EHR
  class SearchPatient

    include PageObject
    include PageUtils
    include Pagination

    div(:div_search_patient_page,               :class => "content_container")
    span(:span_create_patient,                  :id    => "lnkCreatePatient")
    span(:span_create_exam_visit,               :id    => "lnkCreateVisit")

    # Objects visible under search patient div
    text_field(:textfield_last_name_search,     :id    => "LastNameSearch")
    text_field(:textfield_first_name_search,    :id    => "FirstNameSearch")
    text_field(:textfield_patient_id_search,    :id    => "PatientIdSearch")
    text_field(:textfield_date_of_birth_search, :id    => "felix-widget-calendar-DateOfBirthSearch-input")
    text_field(:textfield_phone_number_search,  :id    => "PhonePreferredSearch")
    select_list(:select_gender_search,          :id    => "GenderSearch")
    select_list(:select_status_search,          :id    => "StatusSearch")
    button(:button_search,                      :id    => "lnkSearch-button")
    button(:button_clear,                       :text  => "Clear")

    # Objects visible under patient details div
    div(:div_patient_details,                   :id    => "patient_details_div")
    table(:table_patient_details,               :xpath => "//div[@id='patient_details_div']/table")
    label(:label_edit,                          :text  => "Edit")
    label(:label_delete,                        :text  => "Delete")
    label(:label_inactivate,                    :text  => "Inactivate")
    label(:label_assign_new_PIN,                :text  => "Assign New PIN")
    label(:label_send_reminder,                 :text  => "Send Reminder")

    # Objects visible under patient demographics div
    div(:div_demographics,                      :id    => "accordion")
    link(:link_demographics_up_down,            :id    => "lnkAccordion")     #this link specifies whether content of Demographics visible or not
    div(:div_demographics_content,              :class => "demographics")
    paragraph(:p_ethnicity,                     :xpath => "//div[@class='demographics']/div[1]/p[1]")
    paragraph(:p_race,                          :xpath => "//div[@class='demographics']/div[1]/p[2]")
    paragraph(:p_preferred_language,            :xpath => "//div[@class='demographics']/div[1]/p[3]")
    paragraph(:p_sex,                           :xpath => "//div[@class='demographics']/div[1]/p[4]")
    paragraph(:p_email,                         :xpath => "//div[@class='demographics']/div[2]/p[1]")
    paragraph(:p_secondary_ID,                  :xpath => "//div[@class='demographics']/div[2]/p[2]")
    paragraph(:p_address,                       :xpath => "//div[@class='demographics']/div[3]/p[1]")

    # Objects visible under exam/visit history div
    div(:div_exam_visit_history,                :id    => "patient_visit_history_list")
    div(:div_patient_visit_list,                :id    => "patient_visit_list")
    table(:table_exam_visit_history,            :xpath => "//div[@id='patient_visit_list']/table")
    label(:label_edit_exam_visit,               :text  => "Edit Exam/Visit")
    label(:label_delete_exam_visit,             :text  => "Delete Exam/Visit")
    label(:label_resend_patient_email,          :text  => "Resend Patient Email")

    # description  : Function will get invoked when object for page class is created
    # Author       : Gomathi
    #
    def initialize_page
      wait_for_page_load
      wait_for_loading
      wait_for_object(div_search_patient_page_element, "Failure in finding search patient page")
      create_hash
    end

    # description  : hash for grouping index of table headers in the name of constant keys
    # Author       : Chandra sekaran
    #
    def create_hash
      @hash_patient_table = {
          :TASK => 1,
          :LAST_NAME => 2,
          :FIRST_NAME => 3,
          :PATIENT_ID => 4,
          :DOB => 5,
          :PREFERRED_PHONE_NO => 6,
          :SEX => 7,
          :STATUS => 8
      }

      @hash_exam_table = {
          :TASK => 1,
          :ACTIVE => 2,
          :EXAM_DATE => 3,
          :EXAM_ID => 4,
          :EXAM_DESCRIPTION => 5,
          :MODALITY => 6,
          :SITE => 7
      }
    end

    # description          : function to search a patient using a filter item
    # Author               : Gomathi
    # Arguments:
    #   str_filter_type    : string that defines the filter type for search a patient
    #   str_filter_value   : Value given for the filter object to search a patient
    # Return argument      : boolean value - true if record exists else false
    #
    def search_patient(str_filter_type, str_filter_value)
      begin
        case str_filter_type.downcase
          when "last name"
            wait_for_object(textfield_last_name_search_element, "Failure in finding last name text field")
            self.textfield_last_name_search = str_filter_value
          when "first name"
            wait_for_object(textfield_first_name_search_element, "Failure in finding first name text field")
            self.textfield_first_name_search = str_filter_value
          when "patient id"
            wait_for_object(textfield_patient_id_search_element, "Failure in finding patient id text field")
            self.textfield_patient_id_search = str_filter_value
          when "date of birth"
            wait_for_object(textfield_date_of_birth_search_element, "Failure in finding date of birth text field")
            self.textfield_date_of_birth_search = str_filter_value
          when "phone number"
            wait_for_object(textfield_phone_number_search_element, "Failure in finding phone number text field")
            self.textfield_phone_number_search = str_filter_value
          when "sex"
            wait_for_object(select_gender_search_element_element, "Failure in finding select list for sex")
            select_gender_search_element.select(str_filter_value)
          when "status"
            wait_for_object(select_status_search_element_element, "Failure in finding select list for status")
            select_status_search_element.select(str_filter_value)
          else
            raise "invalid filter type : #{str_filter_type}"
        end
        click_on(button_search_element)

        wait_for_object(div_patient_details_element, "Failure in finding patient details table")

        if div_patient_details_element.table_element(:xpath => $xpath_table_message_row).visible?
          str_row = div_patient_details_element.table_element(:xpath => $xpath_table_message_row).text.strip
          if str_row.include?("No records found") && div_patient_details_element.table_elements(:xpath => $xpath_table_data_row).size == 0
            return false
          else
            return true
          end
        else
          sleep 1 until !div_patient_details_element.table_element(:xpath => $xpath_table_message_row).visible?
          return true
        end
      rescue Exception => ex
        $log.error("Error while searching a patient using #{str_filter_type} with #{str_filter_value} : #{ex}")
        exit
      end
    end

    # description          : function to select a patient from list of search result patients
    # Author               : Gomathi
    #
    def select_patient
      begin
        wait_for_object(table_patient_details_element, "Failure in finding patient details table")
        table_patient_details_element.table_element(:xpath => $xpath_tbody_data_first_row).when_visible.click
        ##wait_for_object(div_demographics_element, "Failure in finding demographics of a patient")
        wait_for_object(div_exam_visit_history_element, "Failure in finding exam visit or history of a patient")
        $log.success("Patient selected successfully")
      rescue Exception => ex
        $log.error("Error while selecting a patient : #{ex}")
        exit
      end
    end

    # description          : function to verify whether Patient exists or not
    # Author               : Chandra sekaran
    # Arguments:
    #   str_patient_id     : string that denotes the patient id
    #
    def is_patient_exists(str_patient_id)
      begin
        wait_for_loading
        wait_for_object(table_patient_details_element, "Failure in finding patient details table")
        click_on(table_patient_details_element.table_element(:xpath => $xpath_tbody_data_first_row))

        is_record_exists(div_patient_details_element, @hash_patient_table[:PATIENT_ID], str_patient_id)
      rescue Exception => ex
        $log.error("Error while checking for existence of a patient with ID (#{str_patient_id}) : #{ex}")
        return false
      end
    end

    # description          : function to verify whether exam exists or not
    # Author               : Chandra sekaran
    # Arguments:
    #   arr_visit_id       : array that contains the visit id to verify the existence
    #
    def is_exam_exists(arr_visit_id)
      begin
        wait_for_loading
        arr_status = []
        wait_for_object(table_patient_details_element, "Failure in finding patient details table")
        click_on(table_patient_details_element.table_element(:xpath => $xpath_tbody_data_first_row))
        arr_visit_id.each do |str_visit_id|
          arr_status << is_record_exists(div_patient_visit_list_element, @hash_exam_table[:EXAM_ID], str_visit_id)
        end
        arr_status.uniq.length == 1 ? true : false    # returns true if all visits exist else return false
      rescue Exception => ex
        $log.error("Error while checking for exam/visit with ID (#{arr_visit_id}) of a patient : #{ex}")
        return false
      end
    end

	  # description          : function for updating a visit to required status
    # Author               : Gomathi
    # Arguments            :
    #   arr_visit_id       : array that contains the visit id
    #   str_required_status: string that denotes required exam status
    #
    def update_exam_status(arr_visit_id, str_required_status)
      begin
        if !is_exam_exists(arr_visit_id)
          if ["delete", "deleted", "present"].include? str_required_status.downcase
            $log.success("Exam (#{arr_visit_id}) is already Deleted")
            return false
          else
            raise "Exam not exists with exam id : #{arr_visit_id}"
          end
        end
        bool_found = false
        iterate = true
        while(iterate)
          arr_visit_id.each do |str_visit_id|
            iterate = true
            table_exam_visit_history_element.table_elements(:xpath => $xpath_tbody_data_row).each do |row|
              str_tmp_visit_id = row.cell_element(:xpath => "./td[#{@hash_exam_table[:EXAM_ID]}]").text.strip.downcase
              if str_tmp_visit_id == str_visit_id.downcase
                obj_active_checkbox = row.checkbox_element(:xpath => "./td[#{@hash_exam_table[:ACTIVE]}]/div/input[@class='yui-dt-checkbox']")
                wait_for_object(obj_active_checkbox)
                3.times { obj_active_checkbox.send_keys(:arrow_down) } rescue Exception
                if ["inactive", "inactivated"].include? str_required_status.downcase
                  if !obj_active_checkbox.checked?
                    $log.success("Exam (#{str_visit_id}) is already in Inactivated status")
                    bool_found = true
                    break
                  end
                  click_on(obj_active_checkbox)
                  raise "Visit/Exam is still active, id is #{str_visit_id}" if obj_active_checkbox.checked?
                elsif ["active", "activated"].include? str_required_status.downcase
                  if obj_active_checkbox.checked?
                    $log.success("Exam (#{str_visit_id}) is already in activated status")
                    bool_found = true
                    break
                  end
                  click_on(obj_active_checkbox)
                  raise "Visit/Exam is still Inactive, id is #{str_visit_id}" if !obj_active_checkbox.checked?
                else
                  raise "Invalid input for str_required_status : #{str_required_status}"
                end
                iterate = false
                break
              end
            end
            iterate = click_next(div_patient_visit_list_element) if iterate != false
          end
        end
        return bool_found
      rescue Exception => ex
        $log.error("Error while updating the the exam(#{arr_visit_id}) to #{str_required_status} status : #{ex}")
        exit
      end
    end

    # description          : clicks the edit button of a given visit id
    # Author               : Gomathi
    # Arguments            :
    #   str_visit_id       : string that denotes the visit id
    #
    def edit_exam_visit(str_visit_id)
      begin
        raise "Exam not exists with exam id : #{str_visit_id}" if !is_exam_exists([str_visit_id])

        iterate = true
        while(iterate)
          table_exam_visit_history_element.table_elements(:xpath => $xpath_tbody_data_row).each do |row|
            if row.cell_element(:xpath => "./td[#{@hash_exam_table[:EXAM_ID]}]").text.strip.downcase == str_visit_id.downcase
              row.cell_element(:xpath => "./td[#{@hash_exam_table[:TASK]}]").image_element(:xpath => "./div/img").fire_event("onmouseover")
              label_edit_exam_visit_element.click
              wait_for_loading
              raise "Failure in opening Edit Exam/Visit iframe" if !is_text_present(self, "Visit Information", 10)
              iterate = false
              break
            end
          end
          iterate = click_next(div_patient_visit_list_element) if iterate != false
        end
      rescue Exception => ex
        $log.error("Error while clicking Edit Exam/Visit label of an exam(#{str_visit_id}) : #{ex}")
        exit
      end
    end

  end
end