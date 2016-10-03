# Description   : step definitions for steps related to Generate CQM Reports
# Author        : Gomathi

# When "Category 1" report is "generated" for "From date greater than To date"
When /^"([^"]*)" report is "([^"]*)"(?:| for "([^"]*)")?$/ do |str_cqm_category, str_action, str_condition|
  str_condition ||= ""
  step %{currently in "Generate CQM Report" page}
  on(EHR::GenerateCQMReports).generate_cqm_report(str_cqm_category, str_action, str_condition)
end

# Then Inactivated EP is not listed in "CQM report" EP list
Then /^Inactivated EP is not listed in "([^"]*)" EP list$/ do |str_report|
  case str_report.downcase
    when "cqm report"
      step %{"Category 1" report is "generated"}
    when "amc report"
      step %{AMC report is generated for "#{$str_ep}" as "within report range"}
    else
      raise "Invalid input for str_report : #{str_report}"
  end
end