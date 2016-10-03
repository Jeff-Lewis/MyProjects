# Description   : step definitions for steps related to Order Entry/Results tab
# Author        : Chandra sekaran

# And "1" "laboratory order" is placed "within reporting period" for the patient
When /^"([^"]*)" "(.*?)" (?:is|are) placed "(.*?)" for the patient$/ do |str_order_count, str_order, str_report_range|
  on(EHR::MasterPage).select_tab("order entry")
  on(EHR::OrderEntryResults).create_new_order(str_order_count, str_order, str_report_range)
end

# When the "laboratory order" is cancelled for the patient
When /^the "(.*?)" is cancelled for the patient$/ do |str_order|
  on(EHR::MasterPage).select_tab("order entry")
  on(EHR::MasterPage).select_tab(str_order)
  on(EHR::OrderEntryResults).cancel_existing_order(str_order)
end

Then /^the status of newly placed "([^"]*)" should be changed to "([^"]*)"$/ do |str_order, str_status|
  str_current_status = on(EHR::OrderEntryResults).get_order_status(str_order)
  raise "The #{str_order} current status (#{str_current_status}) is not '#{str_status}'" if str_status.downcase.strip != str_current_status.downcase.strip
end