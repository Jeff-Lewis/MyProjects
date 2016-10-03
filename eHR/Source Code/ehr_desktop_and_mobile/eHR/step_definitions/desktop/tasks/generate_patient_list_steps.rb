# Description    : step definitions for steps related to generate patient list page
# Author         : Gomathi

# When a patient list is generated for "Age From" "0", "Age To" "60, "Preferred Language" "English" and "Race" "Asian, American Indian or Alaska Native"
When /^a patient list is generated for "([^"]*)" "([^"]*)"(?:|, "([^"]*)" "([^"]*)")?(?:|, "([^"]*)" "([^"]*)")?(?:| and "([^"]*)" "([^"]*)")? in "([^"]*)" page$/ do |str_search_item1, str_search_value1, str_search_item2, str_search_value2, str_search_item3, str_search_value3, str_search_item4, str_search_value4, str_page|
  str_search_item2 ||= ""
  str_search_value2 ||= ""
  str_search_item3 ||= ""
  str_search_value3 ||= ""
  str_search_item4 ||= ""
  str_search_value4 ||= ""
  step %{currently in "#{str_page}" page}
  if str_page.downcase == "generate patient list"
    on(EHR::GeneratePatientList).generate_patient_list(str_search_item1, str_search_value1, str_search_item2, str_search_value2, str_search_item3, str_search_value3, str_search_item4, str_search_value4)
  else
    on(EHR::GeneratePatientReminderList).generate_patient_list(str_search_item1, str_search_value1, str_search_item2, str_search_value2, str_search_item3, str_search_value3, str_search_item4, str_search_value4)
  end
end

Then /^(?:|"([^"]*)" )?patient list(?:| with "([^"]*)" "([^"]*)")?(?:|, "([^"]*)" "([^"]*)")?(?:|, "([^"]*)" "([^"]*)")?(?:| and "([^"]*)" "([^"]*)")? should be displayed in "([^"]*)" page$/ do |str_list, str_search_item1, str_search_value1, str_search_item2, str_search_value2, str_search_item3, str_search_value3, str_search_item4, str_search_value4, str_page|
  str_list ||= ""
  str_search_item1 ||= ""
  str_search_value1 ||= ""
  str_search_item2 ||= ""
  str_search_value2 ||= ""
  str_search_item3 ||= ""
  str_search_value3 ||= ""
  str_search_item4 ||= ""
  str_search_value4 ||= ""
  if str_page.downcase == "generate patient list"
    on(EHR::GeneratePatientList).verify_patient_list(str_list, str_search_item1, str_search_value1, str_search_item2, str_search_value2, str_search_item3, str_search_value3, str_search_item4, str_search_value4)
  else
    on(EHR::GeneratePatientReminderList).verify_patient_list
  end
end
