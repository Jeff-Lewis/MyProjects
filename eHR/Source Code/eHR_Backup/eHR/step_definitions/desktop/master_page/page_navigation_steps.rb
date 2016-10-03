# Description   : step definitions for steps related to Page navigation
# Author        :

#And currently in "AMC" page
Given /^currently in "([^"]*)" page$/  do |str_page|
  case str_page.downcase
    when "amc", "automated measure calculator"
      on(EHR::MasterPage).select_menu_item(AUTOMATED_MEASURE_CALCULATOR)
    when "non compliance report"
      on(EHR::MasterPage).select_menu_item(NON_COMPLIANCE_REPORT)
    when "generate export summary"
      on(EHR::MasterPage).select_menu_item(GENERATE_EXPORT_SUMMARY)
    when "generate toc document"
      on(EHR::MasterPage).select_menu_item(GENERATE_TRANSITION_OF_CARE_DOCUMENT)
    when "patient requests health info"
      on(EHR::MasterPage).select_menu_item(PATIENT_REQUESTS_HEALTH_INFORMATION)
    when "generate patient list"
      on(EHR::MasterPage).select_menu_item(GENERATE_PATIENT_LIST) if !(@browser.current_url.include?("GeneratePatientList"))
    when "generate cqm report"
      on(EHR::MasterPage).select_menu_item(GENERATE_CQM_REPORTS)
    when "generate reminder list"
      on(EHR::MasterPage).select_menu_item(GENERATE_REMINDER_LIST) unless @browser.current_url.include?("GeneratePatientReminder")
  end
end