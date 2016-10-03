# Description   : step definitions for steps related to Patient Requests Health Information
# Author        : Gomathi

# And Health Record is generated for the "patient" "with patient request" and "request date" as "future date"
And /^Health Record is generated for the "([^"]*)"(?:| "([^"]*)")?(?:| and "([^"]*)" as "([^"]*)")?$/ do |str_report_for, str_request, str_date, str_date_value|
  str_request ||= ""
  str_date ||= ""
  str_date_value ||= ""
  step %{currently in "patient requests health info" page}
  on(EHR::PatientRequestsHealthInformation).generate_health_report(str_request, str_report_for, str_date, str_date_value)
  #if str_date == "" && str_date_value == ""
  #  switch_to_next_window    # switches to the window
  #  switch_to_application_window
  #end
end

# Then patient "sex" details should be displayed in the Health Record
Then /^patient "([^"]*)" details should be displayed in the Health Record$/ do |str_option|
  switch_to_next_window    # switches to the window
  str_health_record_details = on(EHR::PatientRequestsHealthInformation).verify_health_record_details(str_option)                         # need to add
  switch_to_application_window
  bool_condition = false
  on(EHR::MasterPage).select_menu_item(HOME)
  case str_option.downcase
    when "race"
      str_race_details = on(EHR::SearchPatient).p_race_element.text.downcase.split("race:mu").last.strip
      bool_condition = true if str_health_record_details == str_race_details
    when "sex"
      str_sex_details = on(EHR::SearchPatient).p_sex_element.text.downcase.split("sex:mu").last.strip
      bool_condition = true if str_health_record_details == str_sex_details
  end
  raise "Patient #{str_option} details in Health record is not correct" unless bool_condition
  $log.success("Patient #{str_option} details displayed in Health record")
end

Then /^CCDA Clinical Summary is downloaded$/ do
  on(EHR::PatientRequestsHealthInformation).download_ccd_document
end

# Then "a record" should be added for Requested date and Delivered date
Then /^"([^"]*)" should be added for Requested date and Delivered date$/ do |str_record|
  switch_to_next_window    # switches to the window
  switch_to_application_window
  on(EHR::PatientRequestsHealthInformation).verify_generated_health_report_entry(str_record)
end