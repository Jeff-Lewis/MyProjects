# Description   : step definitions for steps related to text comparison
# Author        : Gomathi

# Then "Currently reporting for stage 1 - year 2" message should be displayed
Then /^"([^"]*)" message should be displayed$/ do |str_message|
  bool_condition = false
  case str_message.downcase
    when "please select a patient and visit"
      bool_condition = true unless $str_patient_id.nil? || str_message.downcase == on(EHR::CreateElectronicSummary).p_toc_related_message_element.text.downcase
      on(EHR::CreateElectronicSummary).button_toc_message_dialog_ok_element.click
    when "please select a visit"
      bool_condition = true unless !$str_patient_id.nil? || str_message.downcase == on(EHR::CreateElectronicSummary).p_toc_related_message_element.text.downcase
      on(EHR::CreateElectronicSummary).button_toc_message_dialog_ok_element.click
    when "to date can not be earlier than from date", "please select eligible professional"
      bool_condition = true unless on(EHR::GenerateCQMReports).div_error_msg_element.text.downcase == str_message.downcase
    when "currently reporting for stage 1 – year 2", "currently reporting for stage 2 – year 1"
      bool_condition = true unless on(EHR::AMCStage).div_ep_stage_message_element.text.downcase == str_message.downcase
    when "report requested date should be less than or equal to current date"
      bool_condition = true unless on(EHR::PatientRequestsHealthInformation).div_report_request_on_date_error_element.text.downcase == str_message.downcase
    else
      raise "invalid input for str_message : #{str_message}"
  end
  raise "'#{str_message}' message is not displayed" if bool_condition
  $log.success("'#{str_message}' message is getting displayed")
end