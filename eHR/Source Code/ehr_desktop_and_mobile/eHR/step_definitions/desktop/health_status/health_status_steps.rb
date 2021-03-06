# Description      : step definitions for steps related to Health status tab
# Author           : Chandra sekaran

# And "1" "coded medication list" is created "within reporting period" under "health status"
When /^(?:|"([^"]*)" )?"([^"]*)" (?:is|are) (?:created|added) "([^"]*)" under "([^"]*)"$/ do |str_count, str_section, str_report_range, str_tab|
  str_count ||= ""
  on(EHR::MasterPage).select_tab(str_tab)
  add_to_health_status(str_count, str_section)
end

# When the "family history" is "inactivated"
When /^(?:the|a) "([^"]*)" is "([^"]*)"$/ do |str_section, str_action|
  on(EHR::MasterPage).select_tab("health status")

  on(EHR::HealthStatus) do |page|
    case str_section.downcase
      when "family history"
        page.edit_family_history(str_action)
        $num_family_history -= 1 if $num_family_history != 0
      when "medication list"
         page.edit_medication_list(str_action)
      when "medication allergy"
        page.edit_allergy(str_action)
      when "problem list"
        page.edit_problem_list(str_action)
      else
        raise "Invalid section in Health Status page : #{str_section}"
    end
  end
end

# And "Do not send patient information to the PHR" checkbox is checked in health status tab
And /^"([^"]*)" checkbox is checked in health status tab$/ do |str_checkbox_name|
  click_on(on(EHR::MasterPage).link_health_status_element)  # clicks 'Health Status' tab
  wait_for_loading
  on(EHR::HealthStatus) do |page|
    page.check_check_do_not_send_info_to_phr
    click_on(page.span_save_patient_information_element)
    wait_for_loading
    raise "Error in checking 'do not send patient information to PHR' checkbox" if !page.check_do_not_send_info_to_phr.checked?
  end
end

# And "reconcile all" button is clicked for "medication" "within reporting period"
And /^"([^"]*)" button is clicked for "([^"]*)" "([^"]*)"$/ do |str_button_name, str_section, str_report_range|
  on(EHR::MasterPage).select_tab("health status")
  on(EHR::HealthStatus).reconcile_all_and_merge(str_section)
end

# And "no change" button is clicked under "medication list"
And /^"([^"]*)" button is clicked under "([^"]*)"$/ do |str_button_name, str_section|
  on(EHR::MasterPage).select_tab("health status")
  on(EHR::HealthStatus).select_no_change_for_medication
end

# Description          : updates the health status data for the current patient
# Author               :
# Arguments            :
#   str_count          : number of records
#   str_section        : name of section under health status
#
def add_to_health_status(str_count, str_section)
  on(EHR::HealthStatus) do |page|
    case str_section.downcase
      when "coded medication list", "uncoded medication list", "none known medication list"
        $arr_medication_list_name = nil
        $arr_medication_list_name = page.add_medication_list(str_count, str_section)
      when "coded family history", "uncoded family history", "none known family history"
        page.add_family_history(str_count, str_section)
      when "coded problem list", "uncoded problem list", "none known problem list"
        $arr_problem_list_name = nil
        $arr_problem_list_name = page.add_problem_list(str_count, str_section)
      when "smoking status"
        page.add_smoking_status
      when "height weight and bp", "height and weight", "height and bp", "weight and bp", "weight", "height", "bp"
        page.add_vital_signs(str_section)
      when "coded medication allergen", "uncoded medication allergen", "gadolinium contrast material allergy", "iodine contrast material allergy", "no known medication allergies", "other allergy", "coded medication allergen with reaction and mild severity", "coded medication allergen with reaction and severe severity"
        page.add_allergy(str_count, str_section)
      when "demographics", "sex", "race", "ethnicity", "preferred language"
        page.add_demographics(str_section)
      when "count for mu"
        if str_count.downcase == "checked"
          page.check_count_for_mu_element.click if !page.check_count_for_mu_element.checked?
        elsif str_count.downcase == "unchecked"
          page.check_count_for_mu_element.click if page.check_count_for_mu_element.checked?
        end
      else
        raise "Invalid add section to Health Status page : #{str_section}"
    end
  end
end