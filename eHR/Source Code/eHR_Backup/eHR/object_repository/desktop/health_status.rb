=begin
  *Name               : HealthStatus
  *Description        : class to verify the health status of the person
  *Author             : Chandra sekaran
  *Creation Date      : 08/27/2014
  *Modification Date  :
=end

module EHR
  class HealthStatus

    include PageObject
    include DataMagic
    include PageUtils
    include Pagination
    include Demographics
    include HealthStatusTab::MedicationList
    include HealthStatusTab::FamilyHistory
    include HealthStatusTab::ProblemList
    include HealthStatusTab::Reconcile
    include HealthStatusTab::MedicationAllergy

    #Header Object
    div(:div_reconcile_all,                   :xpath     =>  "//div[@id='btnTop']/div[1]/div[1]")
    div(:div_gadolinium_checker,              :xpath     =>  "//div[contains(@id,'felix_button_gadcheckerpanel')]")
    div(:div_iodine_checker,                  :xpath     =>  "//div[contains(@id,'felix_button_gadcheckerpaneliod')]")
    div(:div_cpt_code,                        :xpath     =>  "//div[contains(@id,'felix_button_editCPTCode')]")
    div(:div_reference_info,                  :xpath     =>  "//div[contains(@id,'felix_button_Cdswarning')]")
    link(:link_health_status,                 :id        =>  "lnkHealthStatus")
    checkbox(:check_count_for_mu,             :id        => "FaceToFaceVisit")

    # Common Link in all section
    link(:link_edit,                          :link_text => "Edit")
    link(:link_delete,                        :link_text => "Delete")
    link(:link_inactivate,                    :link_text => "Inactivate")
    link(:link_imported_documents,            :link_text => "Click to see list of imported documents")

    #Patient Information
    div(:div_patient_info,                    :id        =>  "PatientHealthStatusPatientInfoDiv")
    text_field(:textfield_dob,                :name      =>  "DateOfBirth") # Same object is already identified in Create Patient class
    select_list(:select_sex,                  :id        =>  "Gender") # Same object is already identified in Create Patient class
    select_list(:select_ethnicity,            :id        =>  "Ethinicity") # Same object is already identified in Create Patient class
    select_list(:select_language,             :id        =>  "Language") # Same object is already identified in Create Patient class
    text_field(:textfield_email,              :id        =>  "Email")  # Same object is already identified in Create Patient class
    span(:span_save_patient_information,      :id        =>  "lnkUpdatePatientInformation")
    checkbox(:check_do_not_send_reminder,     :id        =>  "DoNotSendReminders")
    checkbox(:check_do_not_send_info_to_phr,  :id        =>  "DoNotSendPatientRegistrationEmail")

    # Problem List coded items
    div(:div_problem_list_section,            :id        => "problemContainer")
    span(:span_add_problem_list,              :id        => "lnkCreateProblem")
    span(:span_none_known_problem_list,       :xpath     => "//div[contains(@id,'Problem')]//div[contains(@class,'noneknown')]/span")  #id        => "ActionButton19"
    div(:div_problem_list_details,            :id        => "problems_list_details_div")
    table(:table_problem_list,                :xpath     => "//div[@id='problems_list_details_div']/table")
    link(:link_edit_problem,                  :link_text => "Edit")
    link(:link_delete_problem,                :link_text => "Delete")
    link(:link_inactivate_problem,            :link_text => "Inactivate")
    span(:span_view_all_problem,              :id        => "lnkProblemViewProblem")
    span(:span_view_active_problem,           :id        => "btnActiveProblem")
    div(:div_uncoded_problem_list,            :id        => "uncodedproblems_list_details_div")
    table(:table_uncoded_problem_list,        :xpath     => "//div[@id='uncodedproblems_list_details_div']/table")

    #Allergies
    div(:div_allergy_section,                 :id        => "allergyContainer") #"MedicationAllergyList")
    div(:div_medication_allergy,              :id        => "Medication_Allergy_details")
    table(:table_allergy_details,             :xpath     => "//div[@id='Medication_Allergy_details']/table")
    span(:span_add_allergy,                   :id        => "lnkCreateAllergy")
    div(:div_add_none_allergies,              :xpath     => "//div[contains(@id,'felix_button_contnoneknownAllergen')]")
    div(:div_no_change_allergies,             :id        => "divnoneknownAllergenNochange")   #:xpath     =>  "//div[contains(@id,'felix_button_SmallnoneknownAllergen')]")
    span(:span_view_all_allergies,            :id        => "lnkallergyviewall")
    span(:span_view_active_allergies,         :id        => "lnkViewActiveProblem")
    label(:label_edit_allergy,                :text      => "Edit")
    label(:label_delete_allergy,              :text      => "Delete")
    label(:label_inactivate_allergy,          :text      => "Inactivate")

    # Medication Lists
    div(:div_medication_list_section, 		  :id        =>  "MedicationList")
    span(:span_add_medication,                :xpath     =>  "//div[@class='healthstatus']//div[contains(@id,'felix_actionpanel_createmedicationpannel')]")  #:id        =>  "ActionButton1")   # xpath => "//div[contains(@id,"felix_actionpanel_createmedicationpannel")]"
    div(:div_add_none_medication,             :xpath     =>  "//div[contains(@id,'felix_button_contnoneknownMediaction')]")
    div(:div_no_change_medication,            :id        =>  "divnoneknownMediactionNoChange")
    div(:div_view_active_medication,          :xpath     =>  "ActionButton3")   # xpath => "//div[contains(@id,'felix_button_viewmedicationactive')]//span[contains(@id,'ActionButton')]"
    span(:span_view_all_medication,           :id        =>  "btnViewAllMedication")
    div(:div_medication_div,                  :id        =>  "Medication_div")
    table(:table_medication_details,          :xpath     =>  "//div[@id='Medication_div']/table")

    #Implant Devices
    div(:div_implant_container,               :id        =>  "implantContainer")
    div(:div_add_implant,                     :xpath     =>  "//div[contains(@id,'felix_button_createImplantActionpanel')]")
    div(:div_view_implant,                    :xpath     =>  "//div[contains(@id,'felix_button_Implanviewall')]")
    div(:div_view_active_implant,             :xpath     =>  "//div[contains(@id,'felix_button_Implanviewactive')]")
    table(:table_implant_info,                :xpath     =>  ".//*[@id='Implant_list_details_div']/table")

    #Vitals
    div(:div_vital_container,                 :id        =>  "vitalContainer")
    span(:span_vital_chart,                   :id        =>  "lnkCreateVitalChart")
    div(:div_no_change_vitals,                :xpath     =>  "//div[contains(@id,'felix_button_SmallnoneknownVital')]")  #//div[@id="createvitalsigndiv"]/div[@class="add_btns"]/div[1]/span
    text_field(:textfield_height_feet,        :id        =>  "Heightft")
    text_field(:textfield_height_inch,        :id        =>  "Heightin")
    checkbox(:check_no_change_height,         :id        =>  "NoChangeHeight")
    text_field(:textfield_weight,             :id        =>  "Weight")
    checkbox(:check_no_change_weight,         :id        =>  "NoChangeWeight")
    text_field(:textfield_bmi,                :id        =>  "BMI")
    text_field(:textfield_bp_systolic,        :id        =>  "SystolicBPtest")
    text_field(:textfield_bp_diastolic,       :id        =>  "DiastolicBPtest")
    checkbox(:check_no_change_bp,             :id        =>  "NoChangeBP")
    text_field(:textfield_pulse,              :id        =>  "Pulsetest")
    text_field(:textfield_respiration,        :id        =>  "Respiration")
    select_list(:select_vital_sign_source,    :id        =>  "VitalSignsSource")
    checkbox(:check_exclude_vital_eoe,        :id        =>  "ExcludeVitalSignFromEOE")
    span(:span_save_vital,                    :id        =>  "lnkCreateVital")
    span(:span_history_vital,                 :id        =>  "lnkViewAllVitals")

    #Smoking Status
    div(:div_smoking_container,               :id        =>  "smokingContainer")
    div(:div_no_change_smoking,               :xpath     =>  "//div[contains(@id,'felix_button_SmallnoneknownSmoking')]")
    select_list(:select_smoking_status,       :id        =>  "SmokingStatusCode")
    text_field(:textfield_start_date,         :id        =>  "felix-widget-calendar-StartDate-input")
    text_field(:textfield_stop_date,          :id        =>  "felix-widget-calendar-EndDate-input")
    checkbox(:check_exclude_smoking_eoe,      :id        =>  "ExcludeSmokingStatusFromEOE")
    span(:span_save_smoking,                  :id        =>  "lnkSmoking")

    #Family History
    div(:div_family_history_section,          :id        => "divFamilyHistory")
    div(:div_add_family_history,              :xpath     =>  "//div[contains(@id,'felix_button_createFamilyActionpanel')]")
    div(:div_add_none_family,                 :xpath     =>  "//div[contains(@id,'felix_button_noneknownFamilyHistory')]")
    div(:div_view_active_family,              :xpath     =>  "//div[contains(@id,'felix_button_FamilyHistoryviewactive')]")
    button(:button_no_change_family,          :id        =>  "nochangeFamilyId")
    div(:div_view_all_family,                 :xpath     =>  "//div[contains(@id,'felix_button_familyviewall')]")
    div(:div_family_history,                  :id        =>  "familyHistory_div")
    table(:table_family_info,                 :xpath     =>  "//div[@id='familyHistory_div']/table")
    label(:label_edit_family,                 :text      =>  "Edit")
    label(:label_delete_family,               :text      =>  "Delete")
    label(:label_inactivate_family,           :text      =>  "Inactivate")
    div(:div_confirm_dialog,                  :id        =>  "conformdialog")
    button(:button_confirm_ok,                :xpath     =>  "//div[@id='conformdialog']//button[text()='OK']")

    #Lab Results
    div(:div_lab_result_section,              :id        =>  "divRecentLabOrderResultList")
    table(:table_lab_result,                  :xpath     =>  "//div[@id='recentLabOrderResultslist']/table")

    #Immunization List
    div(:div_add_immunization,                :xpath     =>  "//div[contains(@id,'felix_button_createimmunizationpanel')]")
    div(:div_submit_immunization,             :xpath     =>  "//div[contains(@id,'felix_button_submitImmunizationpanel')]")
    table(:table_immunization_info,           :xpath     =>  ".//*[@id='dtImmunizationDiv']/table")

    #Clinical documents
    table(:table_clinic_document,             :xpath     =>  ".//*[@id='patient_doc_container_div']/table")

    #Amendments
    table(:table_amendment,                   :xpath     =>  ".//*[@id='Amendment_List_container_div']/table")

    #Labels
    label(:label_vitals,                      :text      => "Vital sign updated successfully")
    label(:label_smoking,                     :text      =>"Smoking status updated successfully")

    # Description    : automatically invoked when page class object is created
    #
    def initialize_page
      wait_for_page_load
      wait_for_loading
      create_hashes
    end

    # description  : Function for creating hash for Health status page
    # Author       : Gomathi
    #
    def create_hashes
      @hash_problem_list_table = {
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

      @hash_medication_list_table = {
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

      @hash_family_history_table_header = {
          :TASK => 1,
          :PROBLEM => 2,
          :RELATION => 3,
          :STATUS => 4,
          :DIAGNOSED_DATE => 5,
          :AGE_AT_DIAGNOSIS => 6
      }

      @hash_new_reconcile_problem_table = {
          :SELECT => 1,
          :DESCRIPTION => 2,
          :STATUS => 3,
          :MODIFIED => 4
      }
      @hash_new_reconcile_allergy_table = {
          :SELECT => 1,
          :ALLERGEN_NAME => 2,
          :STATUS => 3,
          :DIAGNOSED => 4
      }
      @hash_new_reconcile_medication_table = {
          :SELECT => 1,
          :MEDICATION_NAME => 2,
          :STATUS => 3,
          :PRESCRIBED => 4
      }

      @hash_currentlist_reconcile_problem_table = {
          :DEACTIVATE => 1,
          :DESCRIPTION => 2,
          :STATUS => 3,
          :MODIFIED => 4,
          :DELETE => 5
      }
      @hash_currentlist_reconcile_allergy_table = {
          :DEACTIVATE => 1,
          :ALLERGEN_NAME => 2,
          :STATUS => 3,
          :MODIFIED => 4,
          :DELETE => 5
      }
      @hash_currentlist_reconcile_medication_table = {
          :DEACTIVATE => 1,
          :MEDICATION_NAME => 2,
          :STATUS => 3,
          :PRESCRIBED => 4,
          :DELETE => 5
      }
    end

    # Description             : Method to add Demographics in the health status screen
    # Author                  : Gomathi
    # Arguments               :
    #  str_demographics       : string that denotes demographics information
    #  str_demographics_node  : root node of test data for demographics
    #
    def add_demographics(str_demographics, str_demographics_node = "patient_data")
      begin
        add_demographics_values(str_demographics, str_demographics_node)
        click_on(span_save_patient_information_element)
        raise "Patient #{str_demographics} information is not updated successfully" if !is_text_present(self, "Patient information updated successfully", 20)
        $log.success("Patient #{str_demographics} information updated successfully")
      rescue Exception => ex
        $log.error("Error while adding (#{str_demographics}) information for the patient : #{ex}")
        exit
      end
    end

    # Description           : Method to add vital signs in the health status screen
    # Author                : Gomathi
    # Arguments             :
    #  str_vitals           : string that denotes type of vital information
    #  str_vital_signs_node : root node of test data for vital signs
    #
    def add_vital_signs(str_vitals, str_vital_signs_node = "vital_signs_data")
      begin
        hash_vital_signs = set_scenario_based_datafile(VITAL_SIGNS)

        str_height_in_feet = hash_vital_signs[str_vital_signs_node]["textfield_height_feet"]
        str_height_in_inch = hash_vital_signs[str_vital_signs_node]["textfield_height_inch"]
        str_weight = hash_vital_signs[str_vital_signs_node]["textfield_weight"]
        str_bp_systolic = hash_vital_signs[str_vital_signs_node]["textfield_bp_systolic"]
        str_bp_diastolic = hash_vital_signs[str_vital_signs_node]["textfield_bp_diastolic"]

        wait_for_loading

        if BROWSER.downcase == "chrome"
          #div_family_history_section_element.when_visible.scroll_into_view rescue Exception
          div_family_history_element.when_visible.scroll_into_view rescue Exception
        else
          div_vital_container_element.when_visible.scroll_into_view rescue Exception
        end

        case str_vitals.downcase
          when "height weight and bp"
            self.textfield_height_feet = str_height_in_feet
            self.textfield_height_inch = str_height_in_inch
            self.textfield_weight = str_weight
            self.textfield_bp_systolic = str_bp_systolic
            self.textfield_bp_diastolic = str_bp_diastolic
          when "height and weight"
            self.textfield_height_feet = str_height_in_feet
            self.textfield_height_inch = str_height_in_inch
            self.textfield_weight = str_weight
          when "height and bp"
            self.textfield_height_feet = str_height_in_feet
            self.textfield_height_inch = str_height_in_inch
            self.textfield_bp_systolic = str_bp_systolic
            self.textfield_bp_diastolic = str_bp_diastolic
          when "weight and bp"
            self.textfield_weight = str_weight
            self.textfield_bp_systolic = str_bp_systolic
            self.textfield_bp_diastolic = str_bp_diastolic
          when "weight"
            self.textfield_weight = str_weight
          when "height"
            self.textfield_height_feet = str_height_in_feet
            self.textfield_height_inch = str_height_in_inch
          when "bp"
            self.textfield_bp_systolic = str_bp_systolic
            self.textfield_bp_diastolic = str_bp_diastolic
          else
            raise "Invalid input for str_vitals: #{str_vitals}"
        end
        click_on(span_save_vital_element)
        wait_for_loading
        $world.puts("Test data : #{hash_vital_signs.to_s}")
        if (is_text_present(self, "Vital sign created successfully", 20)||is_text_present(self, "Vital sign updated successfully", 20))
          $log.success("Vital signs (#{str_vitals}) are added for the patient (#{$str_patient_id}) successfully")
        else
          raise "Vital signs are not added for the patient (#{$str_patient_id})"
        end
      rescue Exception => ex
        $log.error("Error while adding vital signs (#{str_vitals}) for the patient : #{ex}")
        exit
      end
    end

    # Description              : Method to Save smoking information in the health status screen
    # Author                   : Gomathi
    # Arguments                :
    #  str_smoking_status_node : root node of test data for smoking status
    #
    def add_smoking_status(str_smoking_status_node = "smoking_status_data")
      begin
        hash_smoking_status = set_scenario_based_datafile(SMOKING_STATUS)

        str_smoking_status = hash_smoking_status[str_smoking_status_node]["select_smoking_status"]
        str_start_date = hash_smoking_status[str_smoking_status_node]["textfield_start_date"]
        ##wait_for_loading

        if BROWSER.downcase == "chrome"
          #div_family_history_section_element.when_visible.scroll_into_view rescue Exception
          div_family_history_element.when_visible.scroll_into_view rescue Exception
        else
          div_smoking_container_element.when_visible.scroll_into_view rescue Exception
        end

        select_smoking_status_element.when_visible.select(str_smoking_status)
        textfield_start_date_element.focus
        self.textfield_start_date = str_start_date
        $world.puts("Test data : #{hash_smoking_status.to_s}")
        click_on(span_save_smoking_element)
        ##wait_for_loading

        if is_text_present(self, "Smoking status updated successfully")
          $log.success("Smoking status updated successfully")
        else
          raise "Falure in adding smoking status"
        end
      rescue Exception => ex
        $log.error("Error while adding smoking status: #{ex}")
        exit
      end
    end

    # description          : Function to add allergy to Health status tab
    # Author               : Gomathi
    # Arguments            :
    #   str_allergy_count  : string that denotes allergy count
    #   str_allergy        : string that denotes type of allergy
    #
    def add_allergy(str_allergy_count, str_allergy)
      begin
        if BROWSER.downcase == "chrome"
          div_medication_div_element.when_visible.scroll_into_view rescue Exception
        else
          div_allergy_section_element.when_visible.scroll_into_view rescue Exception
        end
        wait_for_object(div_medication_allergy_element, "Failure in finding div for Medication Allergy")

        @str_row = nil
        if table_allergy_details_element.table_element(:xpath => $xpath_tbody_message_row).exists?
          obj_tr = table_allergy_details_element.table_element(:xpath => $xpath_tbody_message_row)
          if obj_tr.visible?
            @str_row = obj_tr.text.strip
          end
        end
        if !@str_row.nil? && @str_row.downcase.include?("no records found")
          num_old_row_count = 0
        else
          sleep 1 until !table_allergy_details_element.table_element(:xpath => $xpath_tbody_message_row).visible?
          num_old_row_count = get_table_row_count(div_medication_allergy_element)
        end

        case str_allergy.downcase
          when "coded medication allergen", "uncoded medication allergen", "gadolinium contrast material allergy", "iodine contrast material allergy", "other allergy"
            click_on(span_add_allergy_element)
            num_additional_count = str_allergy_count.to_i - 1
            num_additional_count.times do
              save_add_more_create_allergy(str_allergy)
              raise "#{str_allergy} not added successfully" if !is_text_present(self, "Allergen added successfully", 30)
              $num_medication_allergy += 1 if !(str_allergy.downcase == "other allergy")
            end
            save_close_create_allergy(str_allergy)
            $num_medication_allergy += 1 if !(str_allergy.downcase == "other allergy")
          when  "coded medication allergen with reaction and mild severity", "coded medication allergen with reaction and severe severity"
            click_on(span_add_allergy_element)
            num_additional_count = str_allergy_count.to_i - 1
            num_additional_count.times do
              save_add_more_create_allergy(str_allergy, "allergy_data_with_reaction_and_mild_severity") if str_allergy.downcase == "coded medication allergen with reaction and mild severity"
              save_add_more_create_allergy(str_allergy, "allergy_data_with_reaction_and_severe_severity") if str_allergy.downcase == "coded medication allergen with reaction and severe severity"
              raise "#{str_allergy} not added successfully" if !is_text_present(self, "Allergen added successfully", 30)
              $num_medication_allergy += 1
            end
            save_close_create_allergy(str_allergy, "allergy_data_with_reaction_and_mild_severity") if str_allergy.downcase == "coded medication allergen with reaction and mild severity"
            save_close_create_allergy(str_allergy, "allergy_data_with_reaction_and_severe_severity") if str_allergy.downcase == "coded medication allergen with reaction and severe severity"
            $num_medication_allergy += 1
          when "no known medication allergies"
            click_on(div_add_none_allergies_element)
            $num_medication_allergy += 1
          else
            raise "Invalid input for str_allergy : #{str_allergy}"
        end

        if BROWSER.downcase == "chrome"
          div_medication_div_element.when_visible.scroll_into_view rescue Exception
        else
          div_allergy_section_element.when_visible.scroll_into_view rescue Exception
        end

        num_new_row_count = get_table_row_count(div_medication_allergy_element)
        raise "Added Allergy (#{str_allergy}) is not reflected in allergy list table" if num_old_row_count >= num_new_row_count
        #$num_medication_allergy += 1
        $log.success("#{str_allergy_count} #{str_allergy} added successfully")
      rescue Exception => ex
        $log.error("Error while adding '#{str_allergy}' to Health Status tab : #{ex}")
        exit
      end
    end

    # description          : Function to Edit allergy in Health status tab
    # Author               : Gomathi
    # Arguments            :
    #   str_action         : string that denotes action to be performed on allergy
    #
    def edit_allergy(str_action)
      begin
        ##wait_for_loading
        if BROWSER.downcase == "chrome"
          div_medication_div_element.when_visible.scroll_into_view rescue Exception
          wait_for_object(div_medication_allergy_element, "Failure in finding div for Medication Allergy")
          3.times { div_medication_allergy_element.send_keys(:arrow_down) } rescue Exception
        else
          div_allergy_section_element.when_visible.scroll_into_view rescue Exception
        end

        click_on(span_view_all_allergies_element)
        str_status = table_allergy_details_element.cell_element(:xpath => "./tbody[@class='yui-dt-data']/tr[1]/td[#{@hash_allergy_table_header[:STATUS]}]").when_visible.text.strip

        if str_status.downcase != "inactive"
          click_on(span_view_active_allergies_element)
          num_old_row_count = get_table_row_count(div_medication_allergy_element)

          obj_image = table_allergy_details_element.image_element(:xpath => "./tbody[@class='yui-dt-data']/tr[1]/td[#{@hash_allergy_table_header[:TASK]}]/div/img")
          obj_image.focus
          obj_image.click rescue Exception
          obj_image.fire_event("onmouseover")

          case str_action.downcase
            when "inactivated"
              click_on(label_inactivate_allergy_element)
            when "deleted"
              message = confirm(true) do      # clicks 'Ok' button on the confirm message box
                label_delete_allergy_element.when_visible.click
              end
            else
              raise "Invalid action for allergy : #{str_action}"
          end

          ##wait_for_loading
          wait_for_object(div_medication_allergy_element, "Failure in finding div for Allergy")
          div_medication_allergy_element.scroll_into_view rescue Exception
          num_new_row_count = get_table_row_count(div_medication_allergy_element)
          raise "#{str_action.capitalize} Allergy is not reflected in Allergy list table" if (num_old_row_count - 1) != num_new_row_count

          if str_action.downcase == "inactivated"
            click_on(span_view_all_allergies_element)
            str_new_status = table_allergy_details_element.cell_element(:xpath => "./tbody[@class='yui-dt-data']/tr[1]/td[#{@hash_allergy_table_header[:STATUS]}]").when_visible.text.strip
            raise "Record for Allergy is not present under Inactive status" if !(str_new_status.downcase == "inactive")
          end
        else
          raise "Allergy is already in Inactivated status"
        end

        $log.success("Allergy is edited to '#{str_action}' status")
      rescue Exception => ex
        $log.error("Error while editing Allergy to '#{str_action}' status : #{ex}")
        exit
      end
    end

    # description                 : Function to add family history to Health status tab
    # Author                      : Gomathi
    # Arguments                   :
    #   str_family_history_count  : string that denotes family history count
    #   str_family_history        : string that denotes type of family history
    #
    def add_family_history(str_family_history_count, str_family_history)
      begin
        ##wait_for_loading
        if BROWSER.downcase == "chrome"
          div_lab_result_section_element.when_visible.scroll_into_view rescue Exception
        else
          #div_family_history_section_element.when_visible.scroll_into_view rescue Exception
          div_family_history_element.when_visible.scroll_into_view rescue Exception
        end
        wait_for_object(div_family_history_element, "Failure in finding div for family history")
        #3.times{ div_family_history_element.send_keys(:arrow_down) } rescue Exception

        @str_row = nil
        if table_family_info_element.table_element(:xpath => $xpath_tbody_message_row).exists?
          obj_tr = table_family_info_element.table_element(:xpath => $xpath_tbody_message_row)
          if obj_tr.visible?
            @str_row = obj_tr.text.strip
          end
        end
        if !@str_row.nil? && @str_row.downcase.include?("no records found")
          num_old_row_count = 0
        else
          sleep 1 until !table_family_info_element.table_element(:xpath => $xpath_tbody_message_row).visible?
          num_old_row_count = get_table_row_count(div_family_history_element)
        end

        case str_family_history.downcase
          when "coded family history", "uncoded family history"
            click_on(div_add_family_history_element)
            if !is_text_present(self, "Create Family History", 10)
              div_add_family_history_element.click
              wait_for_loading
            end

            num_additional_count = str_family_history_count.to_i - 1
            num_additional_count.times do
              save_add_more_create_family_history(str_family_history)
              raise "#{str_family_history} for the patient id(#{$str_patient_id}) not added successfully" if !is_text_present(self, "Family history added successfully", 30)
              $num_family_history += 1
            end
            save_close_create_family_history(str_family_history)
            $num_family_history += 1

            if BROWSER.downcase == "chrome"
              div_lab_result_section_element.when_visible.scroll_into_view rescue Exception
            else
              #div_family_history_section_element.when_visible.scroll_into_view rescue Exception
              div_family_history_element.when_visible.scroll_into_view rescue Exception
            end

            num_new_row_count = get_table_row_count(div_family_history_element)
            raise "Added family history is not reflected in family history list table" if num_old_row_count > num_new_row_count
            $log.success("#{str_family_history_count} #{str_family_history} added successfully")

          when "none known family history"
            click_on(div_add_none_family_element)
            if BROWSER.downcase == "chrome"
              div_lab_result_section_element.when_visible.scroll_into_view rescue Exception
            else
              #div_family_history_section_element.when_visible.scroll_into_view rescue Exception
              div_family_history_element.when_visible.scroll_into_view rescue Exception
            end

            str_message = div_family_history_element.table_element(:xpath => $xpath_table_message_row).text
            raise "None known family history is not added" if !str_message.casecmp("No Known Family History.")
            $num_family_history += 1
            $log.success("No known Family health history added successfully")
          else
            raise "Invalid family health history : #{str_family_history}"
        end
      rescue Exception => ex
        $log.error("Error while adding '#{str_family_history}' to Health Status tab : #{ex}")
        exit
      end
    end

    # description          : Function to Edit family history in Health status tab
    # Author               : Gomathi
    # Arguments            :
    #   str_action         : string that denotes action to be performed on family history
    #
    def edit_family_history(str_action)
      begin
        ##wait_for_loading
        if BROWSER.downcase == "chrome"
          div_lab_result_section_element.when_visible.scroll_into_view rescue Exception
          wait_for_object(div_family_history_element, "Failure in finding div for Family history")
          3.times { div_family_history_element.send_keys(:arrow_down) } rescue Exception
        else
          #div_family_history_section_element.when_visible.scroll_into_view rescue Exception
          div_family_history_element.when_visible.scroll_into_view rescue Exception
        end
        ##sleep 3 # static delay for sync issue
        click_on(div_view_all_family_element)
        str_status = table_family_info_element.cell_element(:xpath => "./tbody[@class='yui-dt-data']/tr[1]/td[#{@hash_family_history_table_header[:STATUS]}]").when_visible.text.strip
        
        if str_status.downcase != "inactive"
          click_on(div_view_active_family_element)
          num_old_row_count = get_table_row_count(div_family_history_element)

          obj_image = table_family_info_element.image_element(:xpath => "./tbody[@class='yui-dt-data']/tr[1]/td[#{@hash_family_history_table_header[:TASK]}]/div/img")
          obj_image.focus
          obj_image.click rescue Exception
          obj_image.fire_event("onmouseover")

          case str_action.downcase
            when "inactivated"
              click_on(label_inactivate_family_element)
            when "deleted"
              click_on(label_delete_family_element)
            else
              raise "Invalid action for family health history : #{str_action}"
          end

          wait_for_object(div_confirm_dialog_element, "Failure in finding confirm dialog box")
          click_on(button_confirm_ok_element)

          ##wait_for_loading
          wait_for_object(div_family_history_element, "Failure in finding div for Family History")
          div_family_history_element.scroll_into_view rescue Exception
          num_new_row_count = get_table_row_count(div_family_history_element)
          raise "#{str_action.capitalize} family history is not reflected in Family History list table" if (num_old_row_count - 1) != num_new_row_count

          if str_action.downcase == "inactivated"
            click_on(div_view_all_family_element)
            str_new_status = table_family_info_element.cell_element(:xpath => "./tbody[@class='yui-dt-data']/tr[1]/td[#{@hash_family_history_table_header[:STATUS]}]").when_visible.text.strip
            raise "Record for family history is not present under Inactive status" if !(str_new_status.downcase == "inactive")
          end
        else
          raise "Family History is already in Inactivated status"
        end

        $log.success("Family Health History is edited to '#{str_action}' status")
      rescue Exception => ex
        $log.error("Error while editing Family Health History to '#{str_action}' status : #{ex}")
        exit
      end
    end
		
    # Description                 : creates a medication list
    # Author                      : Chandra sekaran
    # Arguments                   :
    #   str_medication_list_count : string that denotes medication list count
    #   str_medication_list       : string that denotes type of medication list
    # Return Argument             :
    #   arr_medication            : medication name(s)
    #
    def add_medication_list(str_medication_list_count, str_medication_list)
      begin
        ##wait_for_loading
        wait_for_object(div_medication_div_element, "Failure in finding div for Medication list")

        if BROWSER.downcase == "chrome"
          div_implant_container_element.when_visible.scroll_into_view rescue Exception
        else
          div_medication_div_element.when_visible.scroll_into_view rescue Exception
        end

        @str_row = nil
        if table_medication_details_element.table_element(:xpath => $xpath_tbody_message_row).exists?
          obj_tr = table_medication_details_element.table_element(:xpath => $xpath_tbody_message_row)
          if obj_tr.visible?
            @str_row = obj_tr.text.strip
          end
        end
        if !@str_row.nil? && (@str_row.downcase.include?("no records found") || @str_row.downcase == "no reported/prescribed medication.")
          num_old_row_count = 0
        else
          sleep 1 until !table_medication_details_element.table_element(:xpath => $xpath_tbody_message_row).visible?
          num_old_row_count = get_table_row_count(div_medication_div_element)
        end

        case str_medication_list.downcase
          when "coded medication list", "uncoded medication list"
            span_add_medication_element.when_visible.click
            wait_for_loading
            if !is_text_present(self, "Create Medication", 10)
              span_add_medication_element.when_visible.click
              wait_for_loading
            end

            arr_medication = []
            if str_medication_list.downcase == "coded medication list"
              num_test_data_count = 1
              num_additional_count = str_medication_list_count.to_i - 1
              num_additional_count.times do
                arr_medication << save_and_add_create_medication(str_medication_list, "medication_list_data#{num_test_data_count}")
                raise "#{str_medication_list} for the patient id(#{$str_patient_id}) not added successfully" if !is_text_present(self, "Medication added successfully", 30)
                $num_medication_list += 1
                num_test_data_count += 1
              end
              arr_medication << save_and_close_create_medication(str_medication_list, "medication_list_data#{num_test_data_count}")
              $num_medication_list += 1

            elsif str_medication_list.downcase == "uncoded medication list"
              arr_medication << save_and_close_create_medication(str_medication_list, "medication_list_data_uncoded")
              $num_medication_list += 1
            else
              raise "Invalid argument for str_medication_list : #{str_medication_list}"
            end

            if BROWSER.downcase == "chrome"
              div_implant_container_element.when_visible.scroll_into_view rescue Exception
            else
              div_medication_div_element.when_visible.scroll_into_view rescue Exception
            end
            #div_medication_div_element.when_visible.scroll_into_view  rescue Exception
            #3.times { div_medication_div_element.when_visible.send_keys(:arrow_down) } rescue Exception

            wait_for_object(table_medication_details_element, "Failure in finding medication list table")
            sleep 1 until !table_medication_details_element.table_element(:xpath => $xpath_tbody_message_row).visible?
            num_new_row_count = get_table_row_count(div_medication_div_element)

            raise "Added medication(s) is not reflected in medication list table" if num_old_row_count > num_new_row_count
            $log.success("#{str_medication_list_count} #{str_medication_list} added successfully")
            return arr_medication

          when "none known medication list"
            click_on(div_add_none_medication_element)
            ##wait_for_object(div_medication_div_element, "Could not find Medication div element")
            if BROWSER.downcase == "chrome"
              div_implant_container_element.when_visible.scroll_into_view rescue Exception
            else
              div_medication_div_element.when_visible.scroll_into_view rescue Exception
            end
            #3.times{ div_family_history_element.send_keys(:arrow_down) } rescue Exception
            str_message = div_medication_div_element.table_element(:xpath => $xpath_table_message_row).text
            raise "None known medication list is not added" if !str_message.casecmp("No reported/prescribed medication.")
            #$num_medication_list += 1
            $log.success("No known Medication list added successfully")
          else
            raise "Invalid medication list : #{str_medication_list}"
        end
      rescue Exception => ex
        $log.error("Error while adding '#{str_medication_list}' to Health Status tab : #{ex}")
        exit
      end
    end

    # Description    : Edit the latest medication list
    # Author         : Chandra sekaran
    # Arguments      :
    #   str_action   : string that denotes whether delete or inactivate
    #
    def edit_medication_list(str_action)
      begin
        ##wait_for_loading
        if BROWSER.downcase == "chrome"
          div_implant_container_element.when_visible.scroll_into_view rescue Exception
        else
          div_medication_div_element.when_visible.scroll_into_view rescue Exception
        end
        ##wait_for_object(div_medication_div_element, "Could not find medication list table")
        #3.times { span_add_medication_element.send_keys(:arrow_down) } rescue Exception
        ##sleep 3  # static delay for sync issue

        num_old_row_count = get_table_row_count(div_medication_div_element)
        obj_image = table_medication_details_element.image_element(:xpath => "./tbody[@class='yui-dt-data']/tr[1]/td[#{@hash_medication_list_table[:TASK]}]/div/img")
        obj_image.focus
        obj_image.click rescue Exception
        obj_image.fire_event("onmouseover")

        case str_action.downcase
          when "deleted"
            message = confirm(true) do      # clicks 'Ok' button on the confirm message box
              link_delete_element.when_visible.click
            end
          when "inactivated"
            message = confirm(true) do      # clicks 'Ok' button on the confirm message box
              link_inactivate_element.when_visible.click
            end
          else
            raise "Invalid action on medication list : #{str_action}"
        end
        wait_for_loading
        wait_for_object(table_medication_details_element, "Failure in finding medication list table")
        table_medication_details_element.scroll_into_view rescue Exception
        num_new_row_count = get_table_row_count(div_medication_div_element)

        raise "#{str_action.capitalize} medication is not reflected in medication list table" if (num_old_row_count - 1) != num_new_row_count
        $log.success("Medication list #{str_action} successfully")
      rescue Exception => ex
        $log.error("Error while editing medication list to (#{str_action}) status :#{ex}")
        exit
      end
    end

    # Description               : creates problem list
    # Author                    : Chandra sekaran
    # Arguments                 :
    #   str_problem_list_count  : string that denotes problem list count
    #   str_problem_list        : string that denotes type of problem list
    # Return Argument           :
    #   arr_problem             : problem names as array
    #
    def add_problem_list(str_problem_list_count, str_problem_list)
      begin
        ##wait_for_loading
        wait_for_object(div_problem_list_details_element, "Failure in finding Problem list div element")
        if BROWSER.downcase == "chrome"
          div_allergy_section_element.when_visible.scroll_into_view rescue Exception
        else
          div_problem_list_section_element.when_visible.scroll_into_view rescue Exception
        end
        @str_row = nil

        case str_problem_list.downcase
          when "coded problem list"
            if table_problem_list_element.table_element(:xpath => $xpath_tbody_message_row).exists?
              obj_tr = table_problem_list_element.table_element(:xpath => $xpath_tbody_message_row)
              if obj_tr.visible?
                @str_row = obj_tr.text.strip
              end
            end
            if !@str_row.nil? && @str_row.downcase.include?("no records found")
              num_old_row_count = 0
            else
              sleep 1 until !table_problem_list_element.table_element(:xpath => $xpath_tbody_message_row).visible?
              num_old_row_count = get_table_row_count(div_problem_list_details_element)
            end

            span_add_problem_list_element.when_visible.click
            wait_for_loading
            if !is_text_present(self, "Create Problem", 10)
              span_add_problem_list_element.when_visible.click
              wait_for_loading
            end

            arr_problem = []
            num_test_data_count = 1
            num_additional_count = str_problem_list_count.to_i - 1
            num_additional_count.times do
              arr_problem << save_and_add_create_problem(str_problem_list, "problem_list_data#{num_test_data_count}")
              raise "#{str_problem_list} for the patient id(#{$str_patient_id}) not added successfully" if !is_text_present(self, "Problem added successfully", 30)
              $num_problem_list += 1
              num_test_data_count += 1
            end
            arr_problem << save_and_close_create_problem(str_problem_list, "problem_list_data#{num_test_data_count}")
            $num_problem_list += 1

            wait_for_object(table_problem_list_element, "Failure in finding problem list table")
            sleep 1 until !table_problem_list_element.table_element(:xpath => $xpath_tbody_message_row).visible?
            num_new_row_count = get_table_row_count(div_problem_list_details_element)

            raise "Added problem(s) is not reflected in problem list table" if num_old_row_count >= num_new_row_count
            $log.success("#{str_problem_list_count} #{str_problem_list} added successfully")
            return arr_problem

          when "uncoded problem list"
            if is_text_present(self, "Additional Problems", 10)
              if table_uncoded_problem_list_element.table_element(:xpath => $xpath_tbody_message_row).exists?
                obj_tr = table_uncoded_problem_list_element.table_element(:xpath => $xpath_tbody_message_row)
                if obj_tr.visible?
                  @str_row = obj_tr.text.strip
                end
              end
            end
            if (!@str_row.nil? && @str_row.downcase.include?("no records found")) || !is_text_present(self, "Additional Problems", 10)
              num_old_row_count = 0
            else
              sleep 1 until !table_uncoded_problem_list_element.table_element(:xpath => $xpath_tbody_message_row).visible?
              num_old_row_count = get_table_row_count(div_uncoded_problem_list_element)
            end

            span_add_problem_list_element.when_visible.click
            wait_for_loading
            if !is_text_present(self, "Create Problem", 10)
              span_add_problem_list_element.when_visible.click
              wait_for_loading
            end

            arr_problem = []
            num_test_data_count = 1
            num_additional_count = str_problem_list_count.to_i - 1
            num_additional_count.times do
              arr_problem << save_and_add_create_problem(str_problem_list, "problem_list_data#{num_test_data_count}")
              raise "#{str_problem_list} for the patient id(#{$str_patient_id}) not added successfully" if !is_text_present(self, "Problem added successfully", 30)
              num_test_data_count += 1
            end
            arr_problem << save_and_close_create_problem(str_problem_list, "problem_list_data#{num_test_data_count}")

            wait_for_object(table_uncoded_problem_list_element, "Failure in finding Uncoded problem list table")
            sleep 1 until !table_uncoded_problem_list_element.table_element(:xpath => $xpath_tbody_message_row).visible?
            num_new_row_count = get_table_row_count(div_uncoded_problem_list_element)

            raise "Added problem(s) is not reflected in problem list table" if num_old_row_count >= num_new_row_count
            $log.success("#{str_problem_list} added successfully")
            return arr_problem
          when "none known problem list"
            click_on(span_none_known_problem_list_element)
            wait_for_object(div_problem_list_details_element, "Failure in finding Problem list div element")
            str_message = div_problem_list_details_element.table_element(:xpath => $xpath_table_message_row).text
            raise "None known problem list is not added" if !str_message.casecmp("No known problem.")
            #$num_problem_list += 1  # no need for $num_problem_list variable, text in reason column of numerator link popup is "No known problems were recorded"
            $log.success("No known problem list added successfully")
          else
            raise "Invalid problem list : #{str_problem_list}"
        end
      rescue Exception => ex
        $log.error("Error while adding '#{str_problem_list}' to Health Status tab : #{ex}")
        exit
      end
    end

    # description          : Function to Edit Problem List in Health status tab
    # Author               : Gomathi
    # Arguments            :
    #   str_action         : string that denotes action to be performed on Problem List
    #
    def edit_problem_list(str_action)
      begin
        ##wait_for_loading
        if BROWSER.downcase == "chrome"
          div_allergy_section_element.when_visible.scroll_into_view rescue Exception
        else
          div_problem_list_section_element.when_visible.scroll_into_view rescue Exception
        end
        click_on(span_view_all_problem_element)
        str_status = table_problem_list_element.cell_element(:xpath => "./tbody[@class='yui-dt-data']/tr[1]/td[#{@hash_problem_list_table[:STATUS]}]").when_visible.text.strip

        if str_status.downcase != "inactive"
          click_on(span_view_active_problem_element)
          num_old_row_count = get_table_row_count(div_problem_list_details_element)

          obj_image = table_problem_list_element.image_element(:xpath => "./tbody[@class='yui-dt-data']/tr[1]/td[#{@hash_problem_list_table[:TASK]}]/div/img")
          obj_image.focus
          obj_image.click rescue Exception
          obj_image.fire_event("onmouseover")

          case str_action.downcase
            when "inactivated"
              click_on(link_inactivate_element)
            when "deleted"
              message = confirm(true) do      # clicks 'Ok' button on the confirm message box
                link_delete_element.when_visible.click
              end
            else
              raise "Invalid action for problem list : #{str_action}"
          end

          wait_for_object(div_problem_list_details_element, "Failure in finding Problem list div element")
          num_new_row_count = get_table_row_count(div_problem_list_details_element)
          raise "#{str_action.capitalize} problem list is not reflected in Problem list table" if (num_old_row_count - 1) != num_new_row_count

          if str_action.downcase == "inactivated"
            click_on(span_view_all_problem_element)
            str_new_status = table_problem_list_element.cell_element(:xpath => "./tbody[@class='yui-dt-data']/tr[1]/td[#{@hash_problem_list_table[:STATUS]}]").when_visible.text.strip
            raise "Record for problem list is not present under Inactive status" if !(str_new_status.downcase == "inactive")
          end
        else
          raise "Problem List is already in Inactivated status"
        end

        $num_problem_list -= 1 if $num_problem_list != 0
        $log.success("Problem List is edited to '#{str_action}' status")
      rescue Exception => ex
        $log.error("Error while editing Problem List to '#{str_action}' status : #{ex}")
        exit
      end
    end

    # description          : function to click Reconcile all button and merge the given section data
    # Author               : Chandra sekaran
    # Arguments            :
    #   str_section        : name of the section to be merged
    #
    def reconcile_all_and_merge(str_section)
      begin
        sleep 5
        wait_for_loading
        raise "Reconcile All button is not enabled" if div_reconcile_all_element.class_name.include?("disabled")
        div_reconcile_all_element.click
        wait_for_loading
        div_reconcile_all_element.click if !is_text_present(self, "New - Source: Transition of Care", 60)
        merge(str_section)
        $log.success("The Reconcile All has been successful and merged #{str_section} data")
      rescue Exception => ex
        $log.error("Error while selecting reconcile all button in Health Status tab for '#{str_section}' : #{ex}")
        exit
      end
    end

    # description          : function to click No Change button for Medication under Health Status
    # Author               : Gomathi
    #
    def select_no_change_for_medication
      begin
        wait_for_loading
        if BROWSER.downcase == "chrome"
          div_implant_container_element.when_visible.scroll_into_view rescue Exception
        else
          div_medication_div_element.when_visible.scroll_into_view rescue Exception
        end
        #div_medication_div_element.when_visible.scroll_into_view rescue Exception
        #3.times { div_medication_div_element.send_keys(:arrow_down) } rescue Exception if BROWSER.downcase == "chrome"
        wait_for_loading
        click_on(div_no_change_medication_element)
        wait_for_loading
        $log.success("'No Change' button has been clicked for Medication under Health Status")
      rescue Exception => ex
        $log.error("Error while selecting 'No Change' button for Medication under Health Status : #{ex}")
        exit
      end
    end

  end
end