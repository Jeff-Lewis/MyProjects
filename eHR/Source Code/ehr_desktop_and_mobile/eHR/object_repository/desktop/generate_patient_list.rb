=begin
  *Name             : GeneratePatientList
  *Description      : Class that contains all objects and methods in Generate Patient List page
  *Author           : Gomathi
  *Creation Date    : 27/10/2014
  *Modification Date:
=end

module EHR
  class GeneratePatientList
    include PageObject
    include PageUtils
    include Pagination
    include Demographics

    # Page objects under Eligible Professional
    select_list(:select_EP,                       :id     => "PhysicianId")
    checkbox(:check_visit_associated_to_EP,       :id     => "SearchPatientAssociatedtoEP")
    text_field(:textfield_from_date,              :id     => "felix-widget-calendar-VisitFromDate-input")
    select_list(:select_visit_from_hour,          :id     => "vdfromhour")
    select_list(:select_visit_from_minute,        :id     => "vdfromminute")
    select_list(:select_visit_from_meridien,      :id     => "vdfrommeridiem")
    text_field(:textfield_to_date,                :id     => "felix-widget-calendar-VisitToDate-input")
    select_list(:select_visit_to_hour,            :id     => "vdtohour")
    select_list(:select_visit_to_minute,          :id     => "vdtominute")
    select_list(:select_visit_to_meridien,        :id     => "vdtomeridiem")

    # Page objects under Demographics
    text_field(:textfield_DOB,                    :id     => "felix-widget-calendar-DOB-input")
    text_field(:textfield_age_from,               :id     => "AgeFrom")
    text_field(:textfield_age_to,                 :id     => "AgeTo")
    select_list(:select_ethnicity,                :id     => "Ethnicity")
    select_list(:select_preferred_communication,  :id     => "PreferredContactType")

    # Page objects under Problem list
    div(:div_problem_content,                     :xpath  => "//div[@id='validationdiv']/div[2]/div[5]")
    checkbox(:check_archived_list_problem,        :id     => "IsArchivedList")
    text_field(:textfield_problem_name,           :id     => "ProblemCode_TextBox")
    div(:div_problem_ajax,                        :xpath  => "//div[@id='ProblemCode_container']/div")
    select_list(:select_problem_status,           :id     => "ProblemStatus")
    text_field(:textfield_problem_from_date,      :id     => "felix-widget-calendar-FromDOE-input")
    text_field(:textfield_problem_to_date,        :id     => "felix-widget-calendar-ToDOE-input")

    # Page objects under Medication list
    div(:div_medication_content,                  :xpath  => "//div[@id='validationdiv']/div[2]/div[6]")
    checkbox(:check_archived_list_medication,     :id     => "IsArchivedMedication")
    text_field(:textfield_medication_name,        :id     => "Medication_TextBox")
    div(:div_medication_ajax,                     :xpath  => "//div[@id='Medication_container']/div")
    select_list(:select_medication_format,        :id     => "MedicationFormat")
    select_list(:select_medication_dose_unit,     :id     => "DoseUnit")
    select_list(:select_medication_status,        :id     => "MedicationStatus")
    text_field(:textfield_medication_from_date,   :id     => "felix-widget-calendar-MedicationFrom-input")
    text_field(:textfield_medication_to_date,     :id     => "felix-widget-calendar-MadicationTo-input")

    # Page objects under Medication Allergy
    div(:div_allergy_content,                     :xpath  => "//div[@id='validationdiv']/div[2]/div[7]")
    select_list(:select_allergy,                  :id     => "AllergyCodeValue")
    text_field(:textfield_medication_allergy,     :id     => "AllergenMedicationCode_TextBox")
    div(:div_medication_allergy_ajax,             :css    => "#AllergenMedicationCode_container > .yui-ac-content")
    select_list(:select_allergy_status,           :id     => "AllergyStatus")
    select_list(:select_adverse_reaction,         :id     => "AdverseReaction")
    text_field(:textfield_allergy_from_date,      :id     => "felix-widget-calendar-AllergenFrom-input")
    text_field(:textfield_allergy_to_date,        :id     => "felix-widget-calendar-AllergenTo-input")

    # Page objects under Lab Results
    div(:div_lab_result_content,                  :xpath  => "//div[@id='validationdiv']/div[2]/div[8]")
    text_field(:textfield_lab_test_name,          :id     => "LabId_TextBox")
    div(:div_lab_test_ajax,                       :xpath  => "//div[@id='LabId_container']/div")
    select_list(:select_results,                  :id     => "operators")
    text_field(:textfield_value,                  :id     => "result")
    text_field(:textfield_lab_result_from_date,   :id     => "felix-widget-calendar-LabFrom-input")
    text_field(:textfield_lab_result_to_date,     :id     => "felix-widget-calendar-LabTo-input")

    button(:button_search,                        :id     => "btnGeneratePatientList-button")
    button(:button_clear,                         :id     => "btnClearGeneratePatient-button")
    div(:div_patient_list, 					              :id     => "generate_patient_div")
    table(:table_patient_list,                    :xpath  => "//div[@id='generate_patient_div']/table")

    # description      : invoked automatically when page class object is created
    # Author           : Gomathi
    #
    def initialize_page
      wait_for_page_load
      wait_for_loading
      wait_for_object(check_visit_associated_to_EP_element, "Failure in finding checkbox for visit associated to EP")
      hash_creation
    end

    # description          : creates hash for indexing table data
    # Author               : Gomathi
    #
    def hash_creation
      @hash_patient_list_table = {
          :VISIT_DATE_TIME => 1,
          :PATIENT_ID => 2,
          :PATIENT_DOB => 3,
          :PATIENT_NAME => 4,
          :PREFERRED_METHOD_OF_COMMUNICATION => 5,
          :SEX => 6,
          :RACE => 7,
          :ETHNICITY => 8,
          :PREFERRED_LANGUAGE => 9,
          :PROBLEM => 10,
          :MEDICATION => 11,
          :ALLERGY => 12,
          :LAB_TEST => 13,
          :LAB_RESULT => 14
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
        select_EP_element.when_visible.select($str_ep_name)
        check_check_visit_associated_to_EP unless check_visit_associated_to_EP_checked?

        arr_search_items.each do |str_search_item|
          case str_search_item.downcase
            when "exam date from"
              if arr_search_values[arr_search_items.index(str_search_item)].downcase == "yesterday"
                str_from_date = object_date_time - 1.days
              end
              self.textfield_from_date = str_from_date.strftime(DATE_FORMAT)

            when "exam date to"
              if arr_search_values[arr_search_items.index(str_search_item)].downcase == "today"
                str_to_date = object_date_time
              elsif arr_search_values[arr_search_items.index(str_search_item)].downcase == "yesterday"
                str_to_date = object_date_time - 1.days
              end
              self.textfield_to_date = str_to_date.strftime(DATE_FORMAT)

            when "exam time from"
              arr_exam_from_time = arr_search_values[arr_search_items.index(str_search_item)].split(" ")
              str_exam_from_meridien = arr_exam_from_time.pop
              arr_exam_from_hour_minute = arr_exam_from_time.join.split(":")
              select_visit_from_hour_element.select(arr_exam_from_hour_minute[0])
              select_visit_from_minute_element.select(arr_exam_from_hour_minute[1]) if arr_exam_from_hour_minute[1].to_i != 0
              select_visit_from_meridien_element.select(str_exam_from_meridien)

            when "exam time to"
              arr_exam_to_time = arr_search_values[arr_search_items.index(str_search_item)].split(" ")
              str_exam_to_meridien = arr_exam_to_time.pop
              arr_exam_to_hour_minute = arr_exam_to_time.join.split(":")
              select_visit_to_hour_element.select(arr_exam_to_hour_minute[0])
              select_visit_to_minute_element.select(arr_exam_to_hour_minute[1]) if arr_exam_to_hour_minute[1].to_i != 0
              select_visit_to_meridien_element.select(str_exam_to_meridien)

            when  "sex"
              select_sex_element.select(arr_search_values[arr_search_items.index(str_search_item)].capitalize)

            when "race"
              if BROWSER.downcase == "chrome"
                div_medication_content_element.scroll_into_view rescue Exception
              else
                paragraph_race_element.scroll_into_view rescue Exception
              end
              select_race(arr_search_values[arr_search_items.index(str_search_item)])

            when "age from"
              self.textfield_age_from = arr_search_values[arr_search_items.index(str_search_item)]

            when "age to"
              self.textfield_age_to = arr_search_values[arr_search_items.index(str_search_item)]

            when "preferred language"
              select_language_element.select(arr_search_values[arr_search_items.index(str_search_item)])

            when "allergen"
              hash_allergy = set_scenario_based_datafile(MEDICATION_ALLERGY)
              str_allergy_node = "allergy_data_with_reaction_and_mild_severity"

              str_medication_allergy = hash_allergy[str_allergy_node]["medication_allergey"]
              str_gadolinium_contrast_material_allergy = hash_allergy[str_allergy_node]["gadolinium_contrast_material_allergy"]
              str_iodine_contrast_material_allergy = hash_allergy[str_allergy_node]["iodine_contrast_material_allergy"]
              str_other_allergy = hash_allergy[str_allergy_node]["other_allergy"]

              if BROWSER.downcase == "chrome"
                div_lab_result_content_element.scroll_into_view rescue Exception
              else
                div_allergy_content_element.scroll_into_view rescue Exception
              end

              if arr_search_values[arr_search_items.index(str_search_item)].downcase == "gadolinium contrast material"
                select_allergy_element.select(str_gadolinium_contrast_material_allergy)
              elsif arr_search_values[arr_search_items.index(str_search_item)].downcase == "iodine contrast material"
                select_allergy_element.select(str_iodine_contrast_material_allergy)
              elsif arr_search_values[arr_search_items.index(str_search_item)].downcase == "medication"
                select_allergy_element.select(str_medication_allergy)
              elsif arr_search_values[arr_search_items.index(str_search_item)].downcase == "other"
                select_allergy_element.select(str_other_allergy)
              end

            when "medication allergy"
              hash_allergy = set_scenario_based_datafile(MEDICATION_ALLERGY)
              str_allergy_node = "allergy_data_with_reaction_and_mild_severity"
              str_coded_medication_name = hash_allergy[str_allergy_node]["coded_medication_name"]
              str_uncoded_medication_name = hash_allergy[str_allergy_node]["uncoded_medication_name"]

              if BROWSER.downcase == "chrome"
                div_lab_result_content_element.scroll_into_view rescue Exception
              else
                div_allergy_content_element.scroll_into_view rescue Exception
              end

              wait_for_object(textfield_medication_allergy_element, "Failure in finding textfield for medication name")
              self.textfield_medication_allergy = str_coded_medication_name
              wait_for_object(div_medication_allergy_ajax_element, "Failure in finding ajax for medication name list")
              div_medication_allergy_ajax_element.list_item_elements(:xpath => ".//ul/li").each do |list_item|
                list_item.scroll_into_view rescue Exception
                if list_item.text.downcase.strip == str_coded_medication_name.downcase
                  list_item.click
                  break
                end
              end

            when "reaction"
              hash_allergy = set_scenario_based_datafile(MEDICATION_ALLERGY)
              str_allergy_node = "allergy_data_with_reaction_and_mild_severity"
              str_adverse_reaction = hash_allergy[str_allergy_node]["adverse_reaction"]

              if BROWSER.downcase == "chrome"
                div_lab_result_content_element.scroll_into_view rescue Exception
              else
                div_allergy_content_element.scroll_into_view rescue Exception
              end
              select_adverse_reaction_element.select(str_adverse_reaction)

            when "preferred method of confidential communication"
              if BROWSER.downcase == "chrome"
                div_medication_content_element.scroll_into_view rescue Exception
              else
                select_preferred_communication_element.scroll_into_view rescue Exception
              end
              select_preferred_communication_element.select(arr_search_values[arr_search_items.index(str_search_item)])

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

            when "medication"
              if BROWSER.downcase == "chrome"
                div_copy_right_element.when_visible.scroll_into_view rescue Exception
              else
                div_medication_content_element.scroll_into_view rescue Exception
              end
              self.textfield_medication_name = arr_search_values[arr_search_items.index(str_search_item)]
              wait_for_object(div_medication_ajax_element, "Failure in finding ajax for medication name list")
              div_medication_ajax_element.list_item_elements(:xpath => ".//ul/li").each do |list_item|
                list_item.scroll_into_view rescue Exception
                if list_item.text.downcase.strip == arr_search_values[arr_search_items.index(str_search_item)].downcase
                  list_item.click
                  break
                end
              end

            when "medication status"
              select_medication_status_element.select(arr_search_values[arr_search_items.index(str_search_item)])

            when "medication from date"
              if arr_search_values[arr_search_items.index(str_search_item)].downcase == "start date of year"
                str_from_date = object_date_time.strftime("0101%Y")
              end
              self.textfield_medication_from_date = str_from_date

            when "medication to date"
              if arr_search_values[arr_search_items.index(str_search_item)].downcase == "yesterday"
                str_to_date = object_date_time - 1.days
              elsif arr_search_values[arr_search_items.index(str_search_item)].downcase == "today"
                str_to_date = object_date_time
              end
              self.textfield_medication_to_date = str_to_date.strftime(DATE_FORMAT)

            when "lab test"
              div_copy_right_element.when_visible.scroll_into_view rescue Exception
              if arr_search_values[arr_search_items.index(str_search_item)].downcase == "30313-1 - hemoglobin [mass/volume] in arterial blood"
                self.textfield_lab_test_name = "Hemoglobin"
              end
              wait_for_object(div_lab_test_ajax_element, "Failure in finding ajax for Lab Test name list")
              div_lab_test_ajax_element.list_item_elements(:xpath => ".//ul/li").each do |list_item|
                list_item.scroll_into_view rescue Exception
                if list_item.text.downcase.strip == arr_search_values[arr_search_items.index(str_search_item)].downcase
                  list_item.click
                  break
                end
              end

            when "lab result"
              arr_lab_result = arr_search_values[arr_search_items.index(str_search_item)].downcase.split(" ")

              if arr_lab_result.first == "greater"
                select_results_element.select(">")
              elsif arr_lab_result.first == "less"
                select_results_element.select("<")
              elsif arr_lab_result.first == "equal"
                select_results_element.select("=")
              else
                raise "Invalid input for lab result : #{arr_search_values[arr_search_items.index(str_search_item)]}"
              end
              sleep 1
              self.textfield_value = arr_lab_result.last

            when "lab result from date"
              if arr_search_values[arr_search_items.index(str_search_item)].downcase == "start date of year"
                str_from_date = object_date_time.strftime("0101%Y")
              end
              self.textfield_lab_result_from_date = str_from_date

            when "lab result to date"
              if arr_search_values[arr_search_items.index(str_search_item)].downcase == "yesterday"
                str_to_date = object_date_time - 1.days
              elsif arr_search_values[arr_search_items.index(str_search_item)].downcase == "today"
                str_to_date = object_date_time
              end
              self.textfield_lab_result_to_date = str_to_date.strftime(DATE_FORMAT)

            when ""
              # do nothing
            else
              raise "Invalid input for str_search_item : #{str_search_item} "
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

      # description          : verify the patient list based on search item and search value
      # Author               : Gomathi
      # Arguments            :
      #  str_list            : defines the patient list presence
      #  str_search_item     : type of search item
      #  str_search_value    : value for search item
      #
      def verify_patient_list(str_list, str_search_item1, str_search_value1, str_search_item2, str_search_value2, str_search_item3, str_search_value3, str_search_item4, str_search_value4)
        begin
          iterate = true
          object_date_time = pacific_time_calculation

          arr_search_items = [str_search_item1, str_search_item2, str_search_item3, str_search_item4]
          arr_search_values = [str_search_value1, str_search_value2, str_search_value3, str_search_value4]

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
            iterate = false
          else
            sleep 1 until !div_patient_list_element.table_element(:xpath => $xpath_table_message_row).visible?
          end

          while(iterate)
            arr_search_items.each do|str_search_item|
              case str_search_item.downcase
                when "sex"
                  index_element = @hash_patient_list_table[:SEX]
                when "race"
                  index_element = @hash_patient_list_table[:RACE]
                when "preferred language"
                  index_element = @hash_patient_list_table[:PREFERRED_LANGUAGE]
                when "age from", "age to"
                  index_element = @hash_patient_list_table[:PATIENT_DOB]
                when "exam time from", "exam time to", "exam date from", "exam date to"
                  index_element = @hash_patient_list_table[:VISIT_DATE_TIME]
                when "allergen", "medication allergy", "reaction"
                  index_element = @hash_patient_list_table[:ALLERGY]
                when "preferred method of confidential communication"
                  index_element = @hash_patient_list_table[:PREFERRED_METHOD_OF_COMMUNICATION]
                when "problem", "problem status", "problem from date", "problem to date"
                  index_element = @hash_patient_list_table[:PROBLEM]
                when "medication", "medication status", "medication from date", "medication to date"
                  index_element = @hash_patient_list_table[:MEDICATION]
                when "lab test", "lab result from date", "lab result to date"
                  index_element = @hash_patient_list_table[:LAB_TEST]
                when "lab result"
                  index_element = @hash_patient_list_table[:LAB_RESULT]
              end

              arr_search_value = arr_search_values[arr_search_items.index(str_search_item)].downcase.gsub(", ",",").split(",")
              wait_for_object(div_patient_list_element, "Failure in finding div for patient list")

              case str_search_item.downcase
                when "age from"
                  div_patient_list_element.table_elements(:xpath => $xpath_table_data_row).each do |row|
                    wait_for_object(row, "Failure in finding row in table")
                    str_patient_dob = row.cell_element(:xpath => "./td[#{index_element}]").text.strip
                    arr_patient_dob = str_patient_dob.split("/")
                    str_patient_dob_year = arr_patient_dob.pop
                    obj_patient_dob = Time.parse("#{str_patient_dob_year}#{arr_patient_dob.join}")
                    unless TimeDifference.between(object_date_time, obj_patient_dob).in_years.to_i >= arr_search_values[arr_search_items.index(str_search_item)].to_i
                      raise "The Generated Patient List not only consists Patients with #{str_search_item} #{arr_search_values[arr_search_items.index(str_search_item)]}"
                    end
                  end
                when "age to"
                  div_patient_list_element.table_elements(:xpath => $xpath_table_data_row).each do |row|
                    wait_for_object(row, "Failure in finding row in table")
                    str_patient_dob = row.cell_element(:xpath => "./td[#{index_element}]").text.strip
                    arr_patient_dob = str_patient_dob.split("/")
                    str_patient_dob_year = arr_patient_dob.pop
                    obj_patient_dob = Time.parse("#{str_patient_dob_year}#{arr_patient_dob.join}")
                    unless TimeDifference.between(object_date_time, obj_patient_dob).in_years.to_i <= arr_search_values[arr_search_items.index(str_search_item)].to_i
                      raise "The Generated Patient List not only consists Patients with #{str_search_item} #{arr_search_values[arr_search_items.index(str_search_item)]}"
                    end
                  end
                when "exam date from"
                  $str_exam_date_from = arr_search_values[arr_search_items.index(str_search_item)]
                  div_patient_list_element.table_elements(:xpath => $xpath_table_data_row).each do |row|
                    wait_for_object(row, "Failure in finding row in table")
                    str_exam_date_time = row.cell_element(:xpath => "./td[#{index_element}]").text.strip
                    arr_exam_date_time = str_exam_date_time.split(" ")
                    str_exam_date = arr_exam_date_time.first
                    arr_exam_date = str_exam_date.split("/")
                    str_exam_date_year = arr_exam_date.pop
                    obj_actual_exam_date = Time.parse("#{str_exam_date_year}#{arr_exam_date.join}")
                    if arr_search_values[arr_search_items.index(str_search_item)].downcase == "yesterday"
                      obj_exam_date = object_date_time - 1.days
                    elsif arr_search_values[arr_search_items.index(str_search_item)].downcase == "today"
                      obj_exam_date = object_date_time
                    end
                    obj_required_exam_date = Time.parse("#{obj_exam_date.strftime(DATE_FORMAT_IN_YYYYMMDD)}")
                    unless obj_required_exam_date <= obj_actual_exam_date
                      raise "The Generated Patient List not only consists Patients with #{str_search_item} #{arr_search_values[arr_search_items.index(str_search_item)]}"
                    end
                  end
                when "exam date to"
                  $str_exam_date_to = arr_search_values[arr_search_items.index(str_search_item)]
                  div_patient_list_element.table_elements(:xpath => $xpath_table_data_row).each do |row|
                    wait_for_object(row, "Failure in finding row in table")
                    str_exam_date_time = row.cell_element(:xpath => "./td[#{index_element}]").text.strip
                    arr_exam_date_time = str_exam_date_time.split(" ")
                    str_exam_date = arr_exam_date_time.first
                    arr_exam_date = str_exam_date.split("/")
                    str_exam_date_year = arr_exam_date.pop
                    obj_actual_exam_date = Time.parse("#{str_exam_date_year}#{arr_exam_date.join}")
                    if arr_search_values[arr_search_items.index(str_search_item)].downcase == "yesterday"
                      obj_exam_date = object_date_time - 1.days
                    elsif arr_search_values[arr_search_items.index(str_search_item)].downcase == "today"
                      obj_exam_date = object_date_time
                    end
                    obj_required_exam_date = Time.parse("#{obj_exam_date.strftime(DATE_FORMAT_IN_YYYYMMDD)}")
                    unless obj_required_exam_date >= obj_actual_exam_date
                      raise "The Generated Patient List not only consists Patients with #{str_search_item} #{arr_search_values[arr_search_items.index(str_search_item)]}"
                    end
                  end
                when "exam time from"
                  str_required_exam_time = arr_search_values[arr_search_items.index(str_search_item)]
                  if $str_exam_date_from.downcase == "yesterday"
                    obj_exam_date = object_date_time - 1.days
                  elsif $str_exam_date_from.downcase == "today"
                    obj_exam_date = object_date_time
                  end

                  div_patient_list_element.table_elements(:xpath => $xpath_table_data_row).each do |row|
                    wait_for_object(row, "Failure in finding row in table")
                    str_exam_date_time = row.cell_element(:xpath => "./td[#{index_element}]").text.strip
                    arr_exam_date_time = str_exam_date_time.split(" ")
                    str_exam_time = arr_exam_date_time.pop(2).join(" ")
                    str_exam_date = arr_exam_date_time.join
                    arr_exam_date = str_exam_date.split("/")
                    str_exam_date_year = arr_exam_date.pop
                    obj_actual_exam_date_time = Time.parse("#{str_exam_date_year}#{arr_exam_date.join} #{str_exam_time}")
                    obj_required_exam_date_time = Time.parse("#{obj_exam_date.strftime(DATE_FORMAT_IN_YYYYMMDD)} #{str_required_exam_time}")
                    unless obj_required_exam_date_time <= obj_actual_exam_date_time
                      raise "The Generated Patient List not only consists Patients with #{str_search_item} #{arr_search_values[arr_search_items.index(str_search_item)]}"
                    end
                  end
                when "exam time to"
                  str_required_exam_time = arr_search_values[arr_search_items.index(str_search_item)]
                  if $str_exam_date_to.downcase == "yesterday"
                    obj_exam_date = object_date_time - 1.days
                  elsif $str_exam_date_to.downcase == "today"
                    obj_exam_date = object_date_time
                  end

                  div_patient_list_element.table_elements(:xpath => $xpath_table_data_row).each do |row|
                    wait_for_object(row, "Failure in finding row in table")
                    str_exam_date_time = row.cell_element(:xpath => "./td[#{index_element}]").text.strip
                    arr_exam_date_time = str_exam_date_time.split(" ")
                    str_exam_time = arr_exam_date_time.pop(2).join(" ")
                    str_exam_date = arr_exam_date_time.join
                    arr_exam_date = str_exam_date.split("/")
                    str_exam_date_year = arr_exam_date.pop
                    obj_actual_exam_date_time = Time.parse("#{str_exam_date_year}#{arr_exam_date.join} #{str_exam_time}")
                    obj_required_exam_date_time = Time.parse("#{obj_exam_date.strftime(DATE_FORMAT_IN_YYYYMMDD)} #{str_required_exam_time}")
                    unless obj_required_exam_date_time >= obj_actual_exam_date_time
                      raise "The Generated Patient List not only consists Patients with #{str_search_item} #{arr_search_values[arr_search_items.index(str_search_item)]}"
                    end
                  end
                when "allergen"
                  if !(arr_search_values[arr_search_items.index(str_search_item)].downcase == "medication" || arr_search_values[arr_search_items.index(str_search_item)].downcase == "other")
                    div_patient_list_element.table_elements(:xpath => $xpath_table_data_row).each do |row|
                      wait_for_object(row, "Failure in finding row in table")
                      row.cell_element(:xpath => "./td[#{index_element}]").scroll_into_view rescue Exception
                      unless row.cell_element(:xpath => "./td[#{index_element}]").text == ""
                        raise "The Generated Patient List not only consists Patients with #{str_search_item} #{arr_search_values[arr_search_items.index(str_search_item)]}"
                      end
                    end
                  end

                when ""
                  # do nothing
                when "reaction"
                  div_patient_list_element.table_elements(:xpath => $xpath_table_data_row).each do |row|
                    wait_for_object(row, "Failure in finding row in table")
                    row.cell_element(:xpath => "./td[#{index_element}]").scroll_into_view rescue Exception
                    if row.cell_element(:xpath => "./td[#{index_element}]").text.nil? || row.cell_element(:xpath => "./td[#{index_element}]").text.strip == ""
                      raise "The Generated Patient List not only consists Patients with Medication Allergy"
                    end
                  end

                when "problem status", "problem from date", "problem to date"
                  div_patient_list_element.table_elements(:xpath => $xpath_table_data_row).each do |row|
                    wait_for_object(row, "Failure in finding row in table")
                    row.cell_element(:xpath => "./td[#{index_element}]").scroll_into_view rescue Exception
                    if row.cell_element(:xpath => "./td[#{index_element}]").text.nil? || row.cell_element(:xpath => "./td[#{index_element}]").text.strip == ""
                      raise "The Generated Patient List not only consists Patients with Problem"
                    end
                  end

                when "medication status", "medication from date", "medication to date"
                  div_patient_list_element.table_elements(:xpath => $xpath_table_data_row).each do |row|
                    wait_for_object(row, "Failure in finding row in table")
                    row.cell_element(:xpath => "./td[#{index_element}]").scroll_into_view rescue Exception
                    if row.cell_element(:xpath => "./td[#{index_element}]").text.nil? || row.cell_element(:xpath => "./td[#{index_element}]").text.strip == ""
                      raise "The Generated Patient List not only consists Patients with Medication list"
                    end
                  end

                when "lab result from date", "lab result to date"
                  div_patient_list_element.table_elements(:xpath => $xpath_table_data_row).each do |row|
                    wait_for_object(row, "Failure in finding row in table")
                    row.cell_element(:xpath => "./td[#{index_element}]").scroll_into_view rescue Exception
                    if row.cell_element(:xpath => "./td[#{index_element}]").text.nil? || row.cell_element(:xpath => "./td[#{index_element}]").text.strip == ""
                      raise "The Generated Patient List not only consists Patients with Lab result"
                    end
                  end

                when "lab result"
                  arr_lab_result = arr_search_values[arr_search_items.index(str_search_item)].downcase.split(" ")
                  div_patient_list_element.table_elements(:xpath => $xpath_table_data_row).each do |row|
                    wait_for_object(row, "Failure in finding row in table")
                    row.cell_element(:xpath => "./td[#{index_element}]").scroll_into_view rescue Exception
                    arr_cell_text = row.cell_element(:xpath => "./td[#{index_element}]").text.strip.downcase.split(":")
                    str_lab_result_value = arr_cell_text.last.gsub(/[^\d+]/,"")
                    if arr_lab_result.first == "greater"
                      bool_condition = (str_lab_result_value > arr_lab_result.last.strip)
                    elsif arr_lab_result.first == "less"
                      bool_condition = (str_lab_result_value < arr_lab_result.last.strip)
                    elsif arr_lab_result.first == "equal"
                      bool_condition = (str_lab_result_value == arr_lab_result.last.strip)
                    end
                    unless bool_condition
                      raise "The Generated Patient List not only consists Patients with #{str_search_item} #{arr_search_values[arr_search_items.index(str_search_item)]}"
                    end
                  end

                else
                  div_patient_list_element.table_elements(:xpath => $xpath_table_data_row).each do |row|
                    wait_for_object(row, "Failure in finding row in table")
                    row.cell_element(:xpath => "./td[#{index_element}]").scroll_into_view rescue Exception
                    str_cell_text = row.cell_element(:xpath => "./td[#{index_element}]").text.strip.downcase
                    unless arr_search_value.include?(str_cell_text) || str_cell_text.include?(arr_search_values[arr_search_items.index(str_search_item)].strip.downcase) || arr_search_values[arr_search_items.index(str_search_item)].strip.downcase.include?(str_cell_text)
                      raise "The Generated Patient List not only consists Patients with #{str_search_item} #{arr_search_values[arr_search_items.index(str_search_item)]}"
                    end
                  end
              end
            end
            div_copy_right_element.when_visible.scroll_into_view rescue Exception
            iterate = click_next(div_patient_list_element)
          end

          if (@str_row.downcase.include?("no records found") && str_list.downcase == "no") || (@str_row.downcase.include?("no records found") && str_list.downcase == "")
            $log.success("No patient records found in Generated Patient List page for '#{arr_search_items.join(" ").strip}' '#{arr_search_values.join(" ").strip}'")
          elsif !@str_row.downcase.include?("no records found") && str_list.downcase == "no"
            raise "The generated patient list should not contain any patient records"
          else
            $log.success("The Generated Patient List consists only Patients with '#{arr_search_items.join(" ").strip}' '#{arr_search_values.join(" ").strip}'")
          end

          button_clear_element.scroll_into_view rescue Exception
          button_clear_element.click
        rescue Exception => ex
          $log.error("Error while verifying Patient List for '#{arr_search_items.join(" ").strip}' '#{arr_search_values.join(" ").strip}' : #{ex}")
          exit
        end
      end

    end
  end
end