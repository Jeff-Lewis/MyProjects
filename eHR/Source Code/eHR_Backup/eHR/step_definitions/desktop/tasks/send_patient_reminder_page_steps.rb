# Description      : step definitions for steps related to patient reminder
# Author           : Chandra sekaran

# And the reminder is sent for the patient from "Send Patient Reminders" page
When /^the reminder is sent for the patient from "([^"]*)" page$/ do |str_page|
  if str_page.downcase == "send patient reminders"
    on(EHR::MasterPage).select_menu_item(SEND_PATIENT_REMINDERS)   # move to Send Patient Reminders page
    on(EHR::SendPatientReminders).send_reminder($str_patient_id)
  elsif str_page.downcase == "amc report"
    on(EHR::AMCStage) do |page|
      page.AMC_generate_report($str_ep_name, nil, $report_generation_time.strftime(DATE_FORMAT))   #@str_to_date)
      page.send_reminder(@str_amc_table, @str_amc_objective)
    end
  end
end

Then /^send all pending reminders$/ do
  on(EHR::MasterPage).select_menu_item(SEND_PATIENT_REMINDERS)
  on(EHR::SendPatientReminders).send_reminder_for_all_patients
end

# Then the patient record "should not" exists in "Send Patient Reminder" report page
Then /^the patient record "([^"]*)" exists in "([^"]*)" report page$/ do |str_condition, str_page|
  case str_page.downcase
    when "send patient reminder"
      on(EHR::MasterPage).select_menu_item(SEND_PATIENT_REMINDERS)
      on(EHR::SendPatientReminders).generate_report
      bool_patient_exists, num_index = on(EHR::SendPatientReminders).is_patient_exists($str_patient_id)
      if str_condition.downcase == "should not"
        raise "Patient (#{$str_patient_id}) record exists in Send Patient Reminder report table" if bool_patient_exists
        $log.success("Patient (#{$str_patient_id}) record does not exists in Send Patient Reminder report table")
      elsif str_condition.downcase == "should"
        raise "Patient (#{$str_patient_id}) record does not exists in Send Patient Reminder report table" if !bool_patient_exists
        $log.success("Patient (#{$str_patient_id}) record exists in Send Patient Reminder report table")
      end
  end
end