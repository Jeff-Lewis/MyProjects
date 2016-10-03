# Description      : step definitions for steps related to Lab results
# Author           : Gomathi

# And a lab result is added as "numeric affirmation" and report date is "within reporting period" for the patient
And /^a lab result is added as "([^"]*)" and report date is "([^"]*)" for the patient$/ do |str_affirmation, str_report_range|
  object_date_time = pacific_time_calculation
  str_current_year = object_date_time.strftime("%Y")
  if str_report_range.downcase.strip == "within reporting period"
    str_report_date = object_date_time
  elsif str_report_range.downcase.strip == "outside reporting period"
    str_report_date = object_date_time + 1.days
  end
  str_report_year = str_report_date.strftime("%Y")

  if str_current_year != str_report_year
    $log.success("The Lab Result Report date(#{str_report_date.strftime(DATE_FORMAT_WITH_SLASH)}) not comes under Current Year(#{str_current_year})")
    pending
  end

  on(EHR::MasterPage).select_tab("order entry")
  on(EHR::OrderEntryResults).add_lab_result(str_affirmation, str_report_range, str_report_date.strftime(DATE_FORMAT))
end

# When the lab result is "deleted" for the patient
When /^the lab result is "([^"]*)" for the patient$/ do |str_action|
  on(EHR::MasterPage).select_tab("order entry")
  on(EHR::OrderEntryResults).edit_lab_result(str_action)
end