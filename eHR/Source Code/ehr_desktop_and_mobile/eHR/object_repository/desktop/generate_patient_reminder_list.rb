=begin
  *Name             : GeneratePatientReminderList
  *Description      : Class that contains all objects and methods in Generate Patient Reminder List page
  *Author           : Mani.Sundaram
  *Creation Date    : 26/03/2015
  *Modification Date:
=end

module EHR
  class GeneratePatientReminderList
    include PageObject
    include PageUtils
    include Pagination
    include Demographics

    # Page objects under Demographics
    text_field(:textfield_DOB,                      :id     => "felix-widget-calendar-DOB-input")
    text_field(:textfield_age_from,                 :id     => "AgeFrom")
    text_field(:textfield_age_to,                   :id     => "AgeTo")
    select_list(:select_ethnicity,                  :id     => "Ethnicity")
    select_list(:select_preferred_communication,    :id     => "PreferredContactType")

    # Page objects under Problem list
    checkbox(:check_archived_list_problem,          :id     => "IsArchivedList")
    text_field(:textfield_problem_name,             :id     => "ProblemCode_TextBox")
    div(:div_problem_ajax,                          :xpath  => "//div[@id='ProblemCode_container']/div")
    select_list(:select_problem_status,             :id     => "ProblemStatus")
    text_field(:textfield_problem_from_date,        :id     => "felix-widget-calendar-FromDOE-input")
    text_field(:textfield_problem_to_date,          :id     => "felix-widget-calendar-ToDOE-input")

    # Page objects under Medication list
    div(:div_medication_content,                    :xpath  => "//div[@id='validationdiv']/div[2]/div[6]")
    checkbox(:check_archived_list_medication,       :id     => "IsArchivedMedication")
    text_field(:textfield_medication_name,          :id     => "Medication_TextBox")
    div(:div_medication_ajax,                       :xpath  => "//div[@id='Medication_container']/div")
    select_list(:select_medication_format,          :id     => "MedicationFormat")
    select_list(:select_medication_dose_unit,       :id     => "DoseUnit")
    select_list(:select_medication_status,          :id     => "MedicationStatus")
    text_field(:textfield_medication_from_date,     :id     => "felix-widget-calendar-MedicationFrom-input")
    text_field(:textfield_medication_to_date,       :id     => "felix-widget-calendar-MadicationTo-input")

    # Page objects under Medication Allergy
    div(:div_allergy_content,                       :xpath  => "//div[@id='validationdiv']/div[2]/div[7]")
    select_list(:select_allergy,                    :id     => "AllergyCodeValue")
    text_field(:textfield_medication_allergy,       :id     => "AllergenMedicationCode_TextBox")
    div(:div_medication_allergy_ajax,               :css    => "#AllergenMedicationCode_container > .yui-ac-content")
    select_list(:select_allergy_status,             :id     => "AllergyStatus")
    select_list(:select_adverse_reaction,           :id     => "AdverseReaction")
    text_field(:textfield_allergy_from_date,        :id     => "felix-widget-calendar-AllergenFrom-input")
    text_field(:textfield_allergy_to_date,          :id     => "felix-widget-calendar-AllergenTo-input")

    # Page objects under Lab Results
    div(:div_lab_result_content,                    :xpath  => "//div[@id='validationdiv']/div[2]/div[8]")
    text_field(:textfield_lab_test_name,            :id     => "LabId_TextBox")
    div(:div_lab_test_ajax,                         :xpath  => "//div[@id='LabId_container']/div")
    select_list(:select_results,                    :id     => "operators")
    text_field(:textfield_value,                    :id     => "result")
    text_field(:textfield_lab_result_from_date,     :id     => "felix-widget-calendar-LabFrom-input")
    text_field(:textfield_lab_result_to_date,       :id     => "felix-widget-calendar-LabTo-input")

    button(:button_search,                          :id     => "btnGeneratePatientReminder-button")
    button(:button_clear,                           :id     => "button2-button")
    div(:div_patient_list, 					                :id     => "generate_Reminder_div")
    table(:table_patient_list,                      :xpath  => "//div[@id='generate_Reminder_div']/table")
    text_area(:textarea_comments,                   :css    => ".input_container>textarea")

    # description      : invoked automatically when page class object is created
    # Author           : Mani.Sundaram
    #
    def initialize_page
      wait_for_page_load
      wait_for_loading
      wait_for_object(textfield_DOB_element, "Failure in finding DOB textbox for Demographics")
      hash_creation
    end

    # description          : creates hash for indexing table data
    # Author               : Mani.Sundaram
    #
    def hash_creation
      @hash_patient_reminder_list_table = {
          :PATIENT_ID => 1,
          :PATIENT_NAME => 2,
          :CONFIDENTIAL_COMMUNICATION_METHOD => 3
      }
    end

    # description          : Generates a patient list based on search item
    # Author               : Gomathi
    # Arguments            :
    #  str_search_item     : type of search item
    #  str_search_value    : value for search item
    #
    def generate_patient_list(str_search_item1, str_search_value1, str_search_item2, str_search_value2, str_search_item3, str_search_value3, str_search_item4, str_search_value4)
      begin
        arr_search_items = [str_search_item1, str_search_item2, str_search_item3, str_search_item4]
        arr_search_values = [str_search_value1, str_search_value2, str_search_value3, str_search_value4]
        object_date_time = pacific_time_calculation

        arr_search_items.each do |str_search_item|
          case str_search_item.downcase
            when  "sex"
              select_sex_element.select(arr_search_values[arr_search_items.index(str_search_item)].capitalize)

            when "race"
              if BROWSER.downcase == "chrome"
                div_medication_content_element.scroll_into_view rescue Exception
              else
                paragraph_race_element.scroll_into_view rescue Exception
              end
              select_race(arr_search_values[arr_search_items.index(str_search_item)])

            when "problem"
              if BROWSER.downcase == "chrome"
                div_medication_content_element.scroll_into_view rescue Exception
              else
                div_problem_content_element.scroll_into_view rescue Exception
              end
              self.textfield_problem_name = arr_search_values[arr_search_items.index(str_search_item)]
              wait_for_object(div_problem_ajax_element, "Failure in finding ajax for problem name list")
              div_problem_ajax_element.list_item_elements(:xpath => ".//ul/li").each do |list_item|
                list_item.scroll_into_view rescue Exception
                if list_item.text.downcase.strip == arr_search_values[arr_search_items.index(str_search_item)].downcase
                  list_item.click
                  break
                end
              end

            when "problem status"
              select_problem_status_element.select(arr_search_values[arr_search_items.index(str_search_item)])

            when "problem from date"
              if arr_search_values[arr_search_items.index(str_search_item)].downcase == "start date of year"
                str_from_date = object_date_time.strftime("0101%Y")
              end
              self.textfield_problem_from_date = str_from_date

            when "problem to date"
              if arr_search_values[arr_search_items.index(str_search_item)].downcase == "yesterday"
                str_to_date = object_date_time - 1.days
              elsif arr_search_values[arr_search_items.index(str_search_item)].downcase == "today"
                str_to_date = object_date_time
              end
              self.textfield_problem_to_date = str_to_date.strftime(DATE_FORMAT)

            else
              "Invalid search item #{str_search_item}"
          end
        end

        div_copy_right_element.when_visible.scroll_into_view rescue Exception
        click_on(button_search_element)
        div_copy_right_element.when_visible.scroll_into_view rescue Exception
        wait_for_object(table_patient_list_element, "Failure in finding patient list table")
        $log.success("Patient list generated using '#{arr_search_items.join(" ").strip}' '#{arr_search_values.join(" ").strip}'")
      rescue Exception => ex
        $log.error("Error while generating patient list using '#{arr_search_items.join(" ")}' '#{arr_search_values.join(" ")}' :#{ex} ")
        exit
      end

      # description          : verify the patient list
      # Author               : Gomathi
      #
      def verify_patient_list
        begin
          table_patient_list_element.when_visible.scroll_into_view rescue Exception
          wait_for_object(table_patient_list_element, "Failure in finding patient list table")

          @str_row = ""
          if div_patient_list_element.table_element(:xpath => $xpath_table_message_row).exists?
            obj_tr = div_patient_list_element.table_element(:xpath => $xpath_table_message_row)
            if obj_tr.visible?
              @str_row = obj_tr.text.strip
            end
          end

          if @str_row.downcase.include?("no records found")
            $log.success("No patient records found in Generate Reminder List page")
          else
            sleep 1 until !div_patient_list_element.table_element(:xpath => $xpath_table_message_row).visible?
            $log.success("The Generated Patient Reminder List consists patient records")
          end

          button_clear_element.scroll_into_view rescue Exception
          button_clear_element.click
        rescue Exception => ex
          $log.error("Error while verifying Patient List in Patient Reminder List page : #{ex}")
          exit
        end
      end

    end
  end
end