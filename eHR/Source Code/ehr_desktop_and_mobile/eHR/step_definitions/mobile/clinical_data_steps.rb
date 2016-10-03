# Description    : step definitions for steps related to mobile Clinical Data
# Author         : Chandra sekaran

# When a "med allergy" is "added" to the patient
When /^(?:a|an|the|the same) "([^"]*)" (?:is|is added as|is set to|are) "([^"]*)" (?:to|for) the patient$/ do |str_clinical_section, str_action|
  case str_clinical_section.downcase
    when "problem"
      on(EHR::DashboardPage).touch_tab("problem")
      if str_action.downcase == "added"
        $str_problem = on(EHR::ClinicalDataPage).add_problem
      elsif ["inactivated", "activated", "deleted", "none known"].include? str_action.downcase
        on(EHR::ClinicalDataPage).edit_clinical_data(str_clinical_section, str_action)
      end
    when "med allergy"
      on(EHR::DashboardPage).touch_tab("med allergy")
      if str_action.downcase == "added"
        $str_med_allergies = on(EHR::ClinicalDataPage).add_med_allergy
      elsif ["inactivated", "activated", "deleted", "none known"].include? str_action.downcase
        on(EHR::ClinicalDataPage).edit_clinical_data(str_clinical_section, str_action)
        $str_med_allergies = "No known medication allergy" if str_action.downcase == "none known"
      else
        raise "Invalid action on Clinical data : #{str_action}"
      end
    when /family history/
      on(EHR::DashboardPage).touch_tab("family history")
      if str_action.downcase == "added"
        str_family_problem = on(EHR::ClinicalDataPage).add_family_history(str_clinical_section)
        if str_clinical_section.downcase.include? "uncoded"
          $arr_uncoded_family_history << str_family_problem
        else
          $arr_coded_family_history << str_family_problem
        end
        $arr_family_history << str_family_problem
      elsif ["inactivated", "activated", "deleted", "none known"].include? str_action.downcase
        on(EHR::ClinicalDataPage).edit_clinical_data(str_clinical_section, str_action)
      else
        raise "Invalid action on Clinical data : #{str_action}"
      end
    when "medication"
      on(EHR::DashboardPage).touch_tab("medication")
      if str_action.downcase == "added"
        $str_medication = on(EHR::ClinicalDataPage).add_medication
      elsif ["inactivated", "activated", "deleted", "none known"].include? str_action.downcase
        on(EHR::ClinicalDataPage).edit_clinical_data(str_clinical_section, str_action)
      else
        raise "Invalid action : #{str_action}"
      end
    when "smoking status"
      on(EHR::DashboardPage).touch_tab("smoking status")
      $str_smoking_status = on(EHR::ClinicalDataPage).add_smoking_status if ["updated","added"].include? str_action.downcase
    when "vitals"
      on(EHR::DashboardPage).touch_tab("vitals")
      on(EHR::ClinicalDataPage).add_vitals if ["added", "updated"].include? str_action.downcase
    else
      raise "Invalid clinical section name : #{str_clinical_section}"
  end
  $str_action = str_action   # it is used while checking status of problem(s) in desktop Health Status page
end