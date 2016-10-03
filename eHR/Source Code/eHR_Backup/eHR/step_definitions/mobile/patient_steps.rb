# Description    : step definitions for steps related to Patient
# Author         : Chandra sekaran

# When a new patient is created "with Exam"
When /^a new patient is created(?:| "([^"]*)")$/ do |str_data|
  str_data = " " if str_data.nil?
  on(EHR::DashboardPage)do |page|
    page.touch(page.link_new_patient_element)
    $str_patient_id = on(EHR::PatientInfoPage).enter_patient_info
    on(EHR::ExamInfoPage).enter_exam_info if str_data.downcase == "with exam" || str_data.downcase == "with visit"
    #page.click_next      # skip problems
    #page.click_next      # skip medications
    #page.click_next      # skip Med allergies
    #page.click_next      # skip Smoking status
    #page.click_next      # skip Family history
    #page.click_next      # skip Vitals
    #page.complete_data_entry
    #page.touch(page.button_home_element)   # go to dashboard page for completion
  end
  $arr_family_history = []
  $arr_uncoded_family_history = []
  $arr_coded_family_history = []
end

# Given a patient is selected at "random" with value "auto"
Then /^(?:the recently created|a|the) patient is selected (?:by|at) "([^"]*)" with value "([^"]*)"$/ do |str_filter, str_value|
  $str_patient_id = ""
  on(EHR::DashboardPage).search_patient(str_filter, str_value)
  $arr_family_history = []
  $arr_uncoded_family_history = []
  $arr_coded_family_history = []
end

# When "All" demographics data are updated
When /^"([^"]*)" demographics data (?:is|are) updated$/ do |str_attribute|
  on(EHR::DashboardPage).touch_tab("demographics")
  on(EHR::PatientInfoPage).enter_demographics
end