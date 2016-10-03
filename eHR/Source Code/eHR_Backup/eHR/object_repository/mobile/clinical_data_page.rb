=begin
  *Name             : ClinicalDataPage
  *Description      : class that holds the clinical data page objects and method definitions
  *Author           : Chandra sekaran
  *Creation Date    : 21/01/2015
  *Modification Date:
=end

module EHR
  class ClinicalDataPage
    include PageObject
    include PageUtils
    include MobileMasterPage

    # Complete patient details - page tha appears when a specific patient is selected
    list_item(:listitem_patient_info,                     :id       => "liPersonalInfo")
    list_item(:listitem_demographics,                     :id       => "liDemographics")
    list_item(:listitem_communication,                    :id       => "liCommunications")
    list_item(:listitem_exam_info,                        :id       => "liVisitInfo")
    list_item(:listitem_clinical_data,                    :id       => "liClinicalDatas")

    # Problems
    text_field(:textfield_problem,                        :id       => "txtPrblem")
    text_area(:textarea_problems_added,                   :id       => "txtProblemList")
    button(:button_add_problem,                           :id       => "btnSaveProblem")
    link(:link_none_known_problem,                        :id       => "btnNoneKnownProblem")
    link(:link_no_change_problem,                         :id       => "btnProblemNoChange")
    link(:link_edit_problem,                              :id       => "btnEditProblem")

    # Medications
    text_field(:textfield_medication,                     :id       => "txtMedication")
    text_area(:textarea_medications_added,                :id       => "txtMedicationList")
    button(:button_add_medication,                        :id       => "btnSaveMedication")
    link(:link_none_known_medication,                     :id       => "btnNoneKnownMedication")
    link(:link_no_change_medication,                      :id       => "btnNochangeMedication")
    link(:link_edit_medication,                           :id       => "btnMedicationEdit")

    # Med allergies
    text_field(:textfield_med_allergy,                    :id       => "txtAllergies")
    select_list(:select_adverse_reaction,                 :id       => "cmbAdverseReaction")
    text_area(:textarea_med_allergies_added,              :id       => "txtAllergylist")
    button(:button_add_medallergy,                        :id       => "btnSaveAlergies")
    link(:link_none_known_medallergy,                     :id       => "btnNoneKnownAllergy")
    link(:link_no_change_medallergy,                      :id       => "btnNoChangeAllergy")
    link(:link_edit_medallergy,                           :id       => "btnAllergyEdit")
    #span(:link_edit_medallergy,                           :xpath    => "//a[@id='btnAllergyEdit']/span")

    # Edit allergy pop-up (same for Med allergy, Family history)
    div(:div_edit_allergy_popup,                          :id       => "popupControl-popup")
    span(:span_close_edit_allergy_popup,                  :xpath    => "//div[@id='popupControl']/a/span/span[2]")
    list_items(:listitem_allergies,                       :xpath    => "//ul[@id='lstAllergy']/li")
    list_items(:listitem_medications,                     :xpath    => "//ul[@id='lstMedication']/li")
    list_items(:listitem_problems,                        :xpath    => "//ul[@id='lstProblems']/li")
    #link(:link_inactive_med_allergy,                      :id       => "status1")      # not used as of now
    #link(:link_active_med_allergy,                        :id       => "status2")
    #link(:link_delete_med_allergy,                        :xpath    => "//a[contains(@class,'deleteButton')]")

    # Smoking status
    select_list(:select_smoking_status,                   :id       => "cmbSmoking")
    button(:button_no_change_somking_status,              :xpath    => "//form[@id='frmSmoking']/ul/li[2]/div/div[2]/div[1]/div/button")

    # Family history
    text_field(:textfield_family_history_problem,         :id       => "txtProblemEnteredFamilyHistory")
    select_list(:select_relationship,                     :id       => "cmbRelationshipCode")
    text_field(:textfield_diagnodes_date,                 :id       => "txtDiagnosedOnFmlyHst")
    element(:numberfield_age,                             :id       => "DiagnosedAgeFmlyHst")
    text_area(:textarea_family_history_added,             :id       => "txtFamilyHistoryListString")
    button(:button_add_family_history,                    :id       => "btnSaveFamilyHistory")
    link(:link_none_known_family_history,                 :id       => "btnFamilyHistoryNoneknown")
    link(:link_no_change_family_history,                  :id       => "btnFamilyHistoryNochange")
    link(:link_edit_family_history,                       :id       => "btnEditFamilyHistory")

    # Vitals
    text_field(:textfield_height_in_feet,                 :id       => "txtHeightft")
    text_field(:textfield_height_in_inch,                 :id       => "txtHeightin")
    text_field(:textfield_weight,                         :id       => "txtWeight")
    text_field(:textfield_bmi,                            :id       => "txtBMI")
    text_field(:textfield_systolic_bp,                    :id       => "txtSystolicBP")
    text_field(:textfield_diastolic_bp,                   :id       => "txtDiastolicBP")

    image(:img_logo,                                      :src      => "/Content/themes/base/images/ehr_mu_logo.png")


    # Description            : function for adding vitals data
    # Author                 : Chandra sekaran
    # Argument               :
    #	  str_vitals_node      : test data node
    #
    def add_vitals(str_vitals_node = "vitals_data1")
      begin
        hash_vitals = set_scenario_based_datafile(VITAL_SIGNS)
        self.textfield_height_in_feet = hash_vitals[str_vitals_node]["textfield_height_in_feet"]
        self.textfield_height_in_inch = hash_vitals[str_vitals_node]["textfield_height_in_inch"]
        self.textfield_weight = hash_vitals[str_vitals_node]["textfield_weight"]
        self.textfield_systolic_bp = hash_vitals[str_vitals_node]["textfield_systolic_bp"]
        self.textfield_diastolic_bp = hash_vitals[str_vitals_node]["textfield_diastolic_bp"]
        click_next
        touch(link_entry_completion_ok_element) if link_entry_completion_ok_element.exists? # clicks the 'Ok' button in the last page
        $log.success("Successfully added vitals")
        $log.success("Test data : #{hash_vitals[str_vitals_node]}")
      rescue Exception => ex
        $log.error("Failure in filling Vitals information : #{ex}")
        exit
      end
    end

    # Description               : function for adding somking status data
    # Author                    : Chandra sekaran
    # Argument                  :
    #	  str_smoking_status_node : test data node
    # Return argument           :
    #   str_smoking_status      : somking status type
    #
    def add_smoking_status(str_smoking_status_node = "smoking_status_data1")
      begin
        hash_smoking_status = set_scenario_based_datafile(SMOKING_STATUS)
        str_smoking_status = hash_smoking_status[str_smoking_status_node]["select_smoking_status"]
        # for selecting unique problem(s)
        tmp_data = self.select_smoking_status
        if !(tmp_data.downcase.include?("-- select --"))
          num_node_id = 1
          while tmp_data.include? str_smoking_status
            num_node_id += 1
            str_smoking_status_node = "smoking_status_data#{num_node_id}"
            str_smoking_status = hash_smoking_status[str_smoking_status_node]["select_smoking_status"]
          end
        end
        select_smoking_status_element.select(str_smoking_status)
        click_next
        click_previous
        $log.success("Smoking status added successfully")
        $log.success("Test data : #{hash_smoking_status[str_smoking_status_node]}")
        str_smoking_status
      rescue Exception => ex
        $log.error("Failure in filling Smoking Status information : #{ex}")
        exit
      end
    end

    # Description            : function for adding Problem data
    # Author                 : Chandra sekaran
    # Argument               :
    #	  str_problem_node     : test data node
    # Return argument        :
    #   str_problem          : problem name
    #
    def add_problem(str_problem_node = "problem_list_data1")
      begin
        hash_problem = set_scenario_based_datafile(PROBLEM_LIST)
        str_problem = hash_problem[str_problem_node]["textfield_problem"]
        # for selecting unique problem(s)
        tmp_problem = self.textarea_problems_added
        if !tmp_problem.nil?
          num_node_id = 1
          while tmp_problem.include? str_problem
            num_node_id += 1
            str_problem_node = "problem_list_data#{num_node_id}"
            str_problem = hash_problem[str_problem_node]["textfield_problem"]
          end
        end

        self.textfield_problem = str_problem
        wait_for_image_loading
        textfield_problem_element.send_keys(:arrow_down) rescue Exception
        textfield_problem_element.send_keys(:tab) rescue Exception

        begin
          touch(button_add_problem_element)
        rescue Exception => e
          @browser.execute_script("SaveProblem(true, false, '');return false;")
        end
        $log.success("Problem added succesfully")
        $log.success("Test data : #{hash_problem[str_problem_node]}")
        click_next
        wait_for_image_loading
        click_previous
        wait_for_image_loading
        str_problem
      rescue Exception => ex
        $log.error("Failure in filling problem information : #{ex}")
        exit
      end
    end

    # Description            : function for adding Meidcation data
    # Author                 : Chandra sekaran
    # Argument               :
    #	  str_medication_node  : test data node
    # Return argument        :
    #   str_medication       : medication name
    #
    def add_medication(str_medication_node = "medication_data1")
      begin
        hash_medication = set_scenario_based_datafile(MEDICATION_LIST)
        str_medication = hash_medication[str_medication_node]["textfield_medication"]

        # for selecting unique medication(s)
        tmp_medication = self.textarea_medications_added
        if !tmp_medication.nil?
          num_node_id = 1
          while tmp_medication.include? str_medication
            num_node_id += 1
            str_medication_node = "medication_data#{num_node_id}"
            str_medication = hash_medication[str_medication_node]["textfield_medication"]
          end
        end

        self.textfield_medication = str_medication
        wait_for_image_loading
        textfield_medication_element.send_keys(:arrow_down) rescue Exception
        textfield_medication_element.send_keys(:tab) rescue Exception

        begin
          touch(button_add_medication_element)
        rescue Exception => e
          @browser.execute_script("SaveMedication(true, false, '');return false;")
        end
        $log.success("Medication added succesfully")
        $log.success("Test data : #{hash_medication[str_medication_node]}")
        str_medication
      rescue Exception => ex
        $log.error("Failure in filling problem information : #{ex}")
        exit
      end
    end

    # Description            : function for adding Med Allergy data
    # Author                 : Chandra sekaran
    # Argument               :
    #	  str_allergy_node     : test data node
    # Return argument        :
    #   str_med_allergy      : med allergy name
    #
    def add_med_allergy(str_allergy_node = "med_allergy_data1")
      begin
        hash_patient_yml = set_scenario_based_datafile(MEDICATION_ALLERGY)

        str_med_allergy = hash_patient_yml[str_allergy_node]["textfield_med_allergy"]
        str_adverse_reaction = hash_patient_yml[str_allergy_node]["select_adverse_reaction"]

        tmp_med_allergy = self.textarea_med_allergies_added
        if !tmp_med_allergy.nil?
          num_node_id = 1
          while tmp_med_allergy.include? str_med_allergy
            num_node_id += 1
            str_allergy_node = "med_allergy_data#{num_node_id}"
            str_med_allergy = hash_patient_yml[str_allergy_node]["textfield_med_allergy"]
          end
        end

        self.textfield_med_allergy = str_med_allergy
        wait_for_image_loading
        #textfield_med_allergy_element.send_keys(:arrow_down)
        textfield_med_allergy_element.send_keys(:tab)
        #select_adverse_reaction_element.select(str_adverse_reaction)  # not mandatory

        begin
          touch(button_add_medallergy_element)
        rescue Exception => e
          @browser.execute_script("SaveAllergies(true, false, '');return false;")
        end
        $log.success("Med allergy added succesfully")
        $log.success("Test data : #{hash_patient_yml[str_allergy_node]}")
        str_med_allergy
      rescue Exception => ex
        $log.error("Failure in adding med allergy information : #{ex}")
        exit
      end
    end

    # Description               : function for adding Family history data
    # Author                    : Chandra sekaran
    # Arguments                 :
    #   str_family_history_type : add family history data for specific relation
    #	  str_family_history_node : test data node
    # Return argument           :
    #   str_family_problem      : family history problem name
    #
    def add_family_history(str_family_history_type, str_family_history_node = "family_history_data")
      begin
        hash_family_history_yml = set_scenario_based_datafile(FAMILY_HISTORY)

        str_coded_family_problem = hash_family_history_yml[str_family_history_node]["textfield_coded_family_problem"]
        str_uncoded_family_problem = hash_family_history_yml[str_family_history_node]["textfield_uncoded_family_problem"]
        str_relationship = hash_family_history_yml[str_family_history_node]["select_relationship"]
        #num_diagnosed_date = hash_family_history_yml[str_family_history_node]["textfield_diagnosed_date"]
        #num_age = hash_family_history_yml[str_family_history_node]["numberfield_age"]

        str_family_problem = str_family_history_type.include?("uncoded") ? str_uncoded_family_problem : str_coded_family_problem

        case str_family_history_type.downcase
          when /father/
            str_relationship = "Father"
          when /mother/
            str_relationship = "Mother"
          when /natural son/
            str_relationship = "Natural son"
          when /natural daughter/
            str_relationship = "Natural daughter"
          when /brother/
            str_relationship = "Brother"
          when /sister/
            str_relationship = "Sister"
        end

        self.textfield_family_history_problem = str_family_problem
        wait_for_image_loading
        textfield_family_history_problem.send_keys(:arrow_down) rescue Exception
        textfield_family_history_problem.send_keys(:tab) rescue Exception

        textarea_family_history_added_element.focus rescue Exception
        textarea_family_history_added_element.click rescue Exception
        select_relationship_element.select(str_relationship)
        #self.textfield_diagnodes_date = Time.now.strftime(DATE_FORMAT)    # not mandatory
        #self.numberfield_age = num_age     # not mandatory

        button_add_family_history_element.scroll_into_view rescue Exception
        button_add_family_history_element.focus rescue Exception

        str_message = self.alert do      # clicks 'Ok' button on the alert message box for problem(s) that has already been added
          @browser.execute_script("SaveFamilyHistory(true,false,'');")
        end
        wait_for_image_loading
        $log.info("Problem alert msg : #{str_message}")

        $log.success("#{str_family_history_type.capitalize} added succesfully")
        $log.success("Test data : #{hash_family_history_yml[str_family_history_node]}")
        str_family_problem # return family history
      rescue Exception => ex
        $log.error("Failure in adding #{str_family_history_type} : #{ex}")
        exit
      end
    end

    # Description      : function for checking if the clicnical data have been added
    # Author           : Chandra sekaran
    # Argument         :
    #   str_section    : clinical data section name
    # Return argument  :
    #   bool_return    : a boolean value
    #
    def is_clinical_data_added(str_section)
      begin
        bool_return = case str_section.downcase
                        when /problem/
                          if str_section.downcase.include? "none known"
                            str_placeholder_text = @browser.find_element(:id, "txtProblemList").attribute("placeholder")     # get placeholder content
                            str_placeholder_text.downcase == "no known problem"
                          else
                            str_problem = self.textarea_problems_added
                            str_problem.downcase.include? $str_problem.downcase
                          end
                        when /medication/
                          if str_section.downcase.include? "none known"
                            str_placeholder_text = @browser.find_element(:id, "txtMedicationList").attribute("placeholder")     # get placeholder content
                            str_placeholder_text.downcase == "no reported/prescribed medication"
                          else
                            str_medication = self.textarea_medications_added
                            str_medication.downcase.include? $str_medication.downcase
                          end
                        when /med allergy/
                          if str_section.downcase.include? "none known"
                            str_placeholder_text = @browser.find_element(:id, "txtAllergylist").attribute("placeholder")     # get placeholder content
                            str_placeholder_text.downcase == "no known medication allergy"
                          else
                            str_med_allergy = self.textarea_med_allergies_added
                            str_med_allergy.downcase.include? $str_med_allergies.downcase
                          end
                        when /family history/
                          if str_section.downcase.include? "none known"
                            element = @browser.find_element(:id, "txtFamilyHistoryListString")     # get placeholder content
                            str_placeholder_text = element.attribute("placeholder")
                            str_placeholder_text.downcase == "no known family history"
                          else
                            str_family_history = self.textarea_family_history_added
                            arr_family_history = str_section.downcase.include?("uncoded") ? $arr_uncoded_family_history : $arr_coded_family_history
                            tmp_count = 0
                            arr_family_history.each do |str_family_problem|
                              tmp_count += 1 if str_family_history.downcase.include? str_family_problem.downcase
                            end
                            if str_section.downcase.include? "duplicate"
                              if str_section.downcase.include? "uncoded"
                                $arr_uncoded_family_history = []  # clear array as it can be used for successive duplicate problems
                              else
                                $arr_coded_family_history = []  # clear array as it can be used for successive duplicate problems
                              end
                              tmp_count+1 == arr_family_history.size   # for same family problem data
                            else
                              tmp_count == arr_family_history.size
                            end
                          end
                        when "smoking status"
                          tmp_smoking_status = self.select_smoking_status
                          tmp_smoking_status.strip == $str_smoking_status
                        when "vitals"
                          bool_return = true
                          hash_vitals = set_scenario_based_datafile(VITAL_SIGNS)

                          str_height_in_feet = self.textfield_height_in_feet
                          str_height_in_inch = self.textfield_height_in_inch
                          str_weight_in_pounds = self.textfield_weight
                          str_systolic_bp = self.textfield_systolic_bp
                          str_diastolic_bp = self.textfield_diastolic_bp
                          num_actual_bmi = self.textfield_bmi

                          num_height_in_inch = (str_height_in_feet.to_i*12)+str_height_in_inch.to_i
                          num_expected_bmi = str_weight_in_pounds.to_f/(num_height_in_inch*num_height_in_inch)*703
                          if num_expected_bmi.round(2) == num_actual_bmi.to_f
                            $log.success("The BMI (#{num_actual_bmi.to_f}) has been calculated correctly")
                          elsif num_expected_bmi.round(0) == num_actual_bmi.to_f.round(0)
                            $log.error("The decimal of actual BMI(#{num_actual_bmi.to_f}) differs from expected BMI(#{num_expected_bmi.round(2)})")
                          else
                            raise "The decimal of actual BMI(#{num_actual_bmi.to_f}) is not equal to expected BMI(#{num_expected_bmi.round(2)})"
                          end

                          bool_return &&= str_height_in_feet.to_i == hash_vitals["vitals_data1"]["textfield_height_in_feet"].to_i
                          bool_return &&= str_height_in_inch.to_i == hash_vitals["vitals_data1"]["textfield_height_in_inch"].to_i
                          bool_return &&= str_weight_in_pounds.to_i == hash_vitals["vitals_data1"]["textfield_weight"].to_i
                          bool_return &&= str_systolic_bp.to_i == hash_vitals["vitals_data1"]["textfield_systolic_bp"].to_i
                          bool_return &&= str_diastolic_bp.to_i == hash_vitals["vitals_data1"]["textfield_diastolic_bp"].to_i
                        else
                          raise "Invalid section name : #{str_section}"
                      end
      rescue Exception => ex
        $log.error("Failure in checking for added Clinical data in #{str_section} : #{ex}")
        exit
      end
    end

    # Description      : function for setting None Known to clinical data
    # Author           : Chandra sekaran
    # Argument         :
    #   str_section    : clinical data section name
    # Return argument  :
    #   bool_return    : a boolean value
    #
    def set_none_known_clinical_data(str_section)
      if str_section.downcase.include? "family history"
        link_none_known = link_none_known_family_history_element
        link_no_change = link_no_change_family_history_element
      elsif str_section.downcase.include? "medication"
        link_none_known = link_none_known_medication_element
        link_no_change = link_no_change_medication_element
      elsif str_section.downcase.include? "problem"
        link_none_known = link_none_known_problem_element
        link_no_change = link_no_change_problem_element
      elsif str_section.downcase.include? "med allergy"
        link_none_known = link_none_known_medallergy_element
        link_no_change = link_no_change_medallergy_element
      end
      touch(link_none_known)
      if link_no_change.exists?
        $log.success("Successfully set 'None known' to #{str_section} for patient '#{$str_patient_id}'")
        return true
      else
        raise "'None known' button has been clicked but 'No Change' button is not displayed"
      end
    end

    # Description            : function for updating clinical data
    # Author                 : Chandra sekaran
    # Arguments              :
    #   str_clinical_section : clinical data section name
    #   str_action           : update action (activate, incativate, delete)
    # Return argument        :
    #   bool_return          : a boolean value
    #
    def edit_clinical_data(str_clinical_section, str_action)
      begin
        arr_clinical_data = []   # holds the current clicnical data items
        list_item_elements = []  # holds the li tag elements
        case str_clinical_section.downcase
          when "problem"
            return set_none_known_clinical_data(str_clinical_section) if str_action.downcase == "none known"
            # if no problem exists already
            tmp_problem = self.textarea_problems_added
            if tmp_problem.nil?
              $log.info("As there is no data in problem, a new problem is added")
              $str_problem = add_problem
            end
            touch(link_edit_problem_element)
            arr_clinical_data = [$str_problem]
            list_item_elements = listitem_problems_elements
          when "medication"
            return set_none_known_clinical_data(str_clinical_section) if str_action.downcase == "none known"
            # if no medication exists already
            tmp_medication = self.textarea_medications_added
            if tmp_medication.nil?
              $log.info("As there is no data in medication, a new medication is added")
              $str_medication = add_medication
            end
            touch(link_edit_medication_element)
            arr_clinical_data = [$str_medication]
            list_item_elements = listitem_medications_elements
          when "med allergy"
            return set_none_known_clinical_data(str_clinical_section) if str_action.downcase == "none known"
            touch(link_edit_medallergy_element)
            arr_clinical_data = [$str_med_allergies]
            list_item_elements = listitem_allergies_elements
          when /family history/
            return set_none_known_clinical_data(str_clinical_section) if str_action.downcase == "none known"
            # if no problem exists for the patient, then add new problems
            tmp_problem = self.textarea_family_history_added
            if tmp_problem.nil?
              $log.info("As there is no data in family history, a new coded and uncoded problems are added")
              $arr_uncoded_family_history << add_family_history("uncoded family history")
              $arr_coded_family_history << add_family_history("coded family history")
            end

            # if problem exists for patient but not in problem array(s), the problem array(s) are created - for automation purpose
            if $arr_uncoded_family_history.empty?
              $log.info("creating new uncoded problems")
              hash_family_history_yml = set_scenario_based_datafile(FAMILY_HISTORY)
              $arr_uncoded_family_history << hash_family_history_yml["family_history_data"]["textfield_uncoded_family_problem"]
            end
            if $arr_coded_family_history.empty?
              $log.info("creating new coded problems")
              hash_family_history_yml = set_scenario_based_datafile(FAMILY_HISTORY)
              $arr_coded_family_history << hash_family_history_yml["family_history_data"]["textfield_coded_family_problem"]
            end
            arr_clinical_data = str_clinical_section.downcase.include?("uncoded") ? $arr_uncoded_family_history : $arr_coded_family_history
            touch(link_edit_family_history_element)
            list_item_elements = listitem_allergies_elements
        end

        wait_for_object(div_edit_allergy_popup_element, "Failure in finding edit allergy popup")

        arr_clinical_data.each do |str_clinical_data|
          list_item_elements.each_with_index do |li, index|
            if index > 0
              if li.h2_element(:xpath => "./h2").text.strip.downcase.include? str_clinical_data.downcase
                str_button_name = li.link_element(:xpath => "./div/div[1]/a/span/span[2]").class_name
                if str_action.downcase == "inactivated"
                  if str_button_name.strip.include? "ui-icon-inactive"
                    while(li.link_element(:xpath => "./div/div[1]/a/span/span[2]").class_name.include?("ui-icon-inactive"))
                      $log.info("inactivate : inside while")
                      str_js_method = li.link_element(:xpath => "./div/div[1]/a").attribute("onclick").split("return").last.strip
                      begin
                        li.span_element(:xpath => "./div/div[1]/a/span/span[2]").click
                      rescue Exception => e
                        if e.message.downcase.include? "element is not clickable at point"
                          $log.error("Error in clicking Inactivate button")
                          self.execute_script(str_js_method)
                        else
                          raise e
                        end
                      end
                      wait_for_image_loading
                    end
                    $log.success("The #{str_clinical_section} '#{str_clinical_data}' has been Inactivated successfully")
                  else
                    $log.info("The clinical data '#{str_clinical_data}' is already Inactivated")
                  end

                elsif str_action.downcase == "activated"
                  if str_button_name.strip.include? "ui-icon-active"
                    while(li.link_element(:xpath => "./div/div[1]/a/span/span[2]").class_name.include?("ui-icon-active"))
                      $log.info("activate : inside while")
                      str_js_method = li.link_element(:xpath => "./div/div[1]/a").attribute("onclick").split("return").last.strip
                      begin
                        li.span_element(:xpath => "./div/div[1]/a/span/span[2]").click
                      rescue Exception => e
                        if e.message.downcase.include? "element is not clickable at point"
                          $log.error("Error in clicking Inactivate button")
                          self.execute_script(str_js_method)
                        else
                          raise e
                        end
                      end
                      wait_for_image_loading
                    end
                    $log.success("The #{str_clinical_section} '#{str_clinical_data}' has been Activated successfully")
                  else
                    $log.info("The clinical data '#{str_clinical_data}' is already Activated")
                  end

                elsif str_action.downcase == "deleted"
                  str_button_name = li.link_element(:xpath => "./div/div[2]/a/span/span[2]").class_name
                  if str_button_name.strip.include? "ui-icon-delete"
                    while(li.link_element(:xpath => "./div/div[2]/a/span/span[2]").exists?)
                      $log.info("delete : inside while")
                      li.span_element(:xpath => "./div/div[2]/a/span/span[2]").click
                      wait_for_image_loading
                      begin
                        li.link_element(:xpath => './div/div[2]/a/span/span[2]').present?
                      rescue Exception => ex
                        break  # stale element reference : element not attached to dom
                      end
                    end
                    $log.success("The #{str_clinical_section} '#{str_clinical_data}' has been Deleted successfully")
                  else
                    $log.info("No record for 'delete' is found")
                  end
                end
                # when there is only one record, then after delete action the popup closes automatically
                if index > 1
                  3.times do
                    if span_close_edit_allergy_popup_element.visible?
                      span_close_edit_allergy_popup_element.focus rescue Exception
                      span_close_edit_allergy_popup_element.click rescue Exception
                    end
                  end
                end
                break
              end
            end
          end
        end
        # close the iframe, if it is visible
        3.times do
          if span_close_edit_allergy_popup_element.visible?
            self.execute_script("$('#popupControl').popup('close');")
          end
        end
        #if str_action.downcase != "deleted"    # not required as of now
        #  click_next     # moves to the next page
        #  click_previous # moves back to the previous page, as only after page navigation the updations are reflected
        #end
      rescue Exception => ex
        $log.error("Failure in updating Family history information (#{str_action}) for data '#{arr_clinical_data}' : #{ex}")
        if span_close_edit_allergy_popup_element.visible?
          self.execute_script("$('#popupControl').popup('close');")
        end
        exit
      end
    end

  end
end