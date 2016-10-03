# Description    : step definitions for steps related to Non Compliance report page
# Author         :

When /^"([^"]*)" related to "([^"]*)" is generated for "([^"]*)" and "([^"]*)" for "([^"]*)" included with "([^"]*)" for user "([^"]*)" as "([^"]*)"$/ do |str_report_type, str_relates_to, str_ep, str_site, str_visit_type, str_include_type, str_user, str_report_range|
  step %{currently in "Non Compliance Report" page}
  on(EHR::NonComplianceReport).generate_non_compliance_report(str_report_type, str_relates_to, str_ep, str_site, str_visit_type, str_visit_type, str_user, str_report_range)
end

# When the Non Compliance report for "today" is generated for "Inactive" "Visit"
When /^the Non Compliance report for "([^"]*)" is generated for "([^"]*)" "([^"]*)"$/ do |str_report_day, str_value, str_filter|
  step %{currently in "Non Compliance Report" page}
  on(EHR::NonComplianceReport) do |page|
    case str_filter.downcase
      when /ep/, /provider/
        page.generate_non_compliance_report(str_report_day, "none", str_value)
      when /site/
        page.apply_non_compliance_filter("none", $str_ep_name, str_report_day) if $scenario_tags.include?("@tc_1617") || $scenario_tags.include?("@tc_1618")
        page.generate_non_compliance_report(str_report_day, "none", "none", str_value)
      when /included visit/
        page.generate_non_compliance_report(str_report_day, "none", $str_ep_name, "none", "none", str_value)
      when /visit/
        page.generate_non_compliance_report(str_report_day, "none", $str_ep_name, "none", str_value)
      when /related/
        page.generate_non_compliance_report(str_report_day, str_value, $str_ep_name, "none", "none", "none", "current")
      when /user/
        page.apply_non_compliance_filter("none", $str_ep_name, str_report_day) if $scenario_tags.include?("@tc_7418")
        page.generate_non_compliance_report(str_report_day, "none", "none", "none", "none", "none", str_value, "none")
    end
  end
end

# When the Non Compliance report for "today" is generated for "All" "Provider" and "Current" "Site"
When /^the Non Compliance report for "([^"]*)" is generated for "([^"]*)" "([^"]*)" and "([^"]*)" "([^"]*)"$/ do |str_report_day, str_value1, str_filter1, str_value2, str_filter2|
  step %{currently in "Non Compliance Report" page}
  on(EHR::NonComplianceReport) do |page|
    case str_filter1.downcase
      when /visit/
        page.apply_non_compliance_filter("none", $str_ep_name, "none", str_value1, str_report_day)
      when /ep/, /provider/
        page.apply_non_compliance_filter("none", str_value1, str_report_day)
      when /site/
        page.apply_non_compliance_filter("none", "none", str_value1, str_report_day)
    end
  end
  step %{the Non Compliance report for "#{str_report_day}" is generated for "#{str_value2}" "#{str_filter2}"}
end

# Then "3" exams should "be" "present" in "Non Compliance report"
Then /^"([^"]*)" exam(?:|s) should "([^"]*)" "([^"]*)" in "([^"]*)"$/ do |str_expected_count, str_condition, str_action, str_page|
  if str_page.downcase == "non compliance report"
    #str_actual_count = 0
    str_actual_count = on(EHR::NonComplianceReport).get_visit_count
    if str_condition.downcase == "not be" && str_actual_count > 0
      raise "#{str_actual_count} exam for the patient (#{$str_patient_id}) exists in Non Compliance report page"
    elsif str_condition.downcase == "be" && str_actual_count < str_expected_count.to_i
      raise "Only #{str_actual_count} exam for the patient (#{$str_patient_id}) exists in Non Compliance report page"
    end
    $log.success("#{str_expected_count} exam(s) for the patient (#{$str_patient_id})#{str_condition.downcase.include?('not') ? ' does not' : ''} exists in Non Compliance report page")

  elsif str_page.downcase == "select patient tab"
    bool_status = false
    on(EHR::MasterPage).select_menu_item(HOME)
    bool_status = on(EHR::SearchPatient).update_exam_status($arr_all_exam_id, str_action)
    if str_condition.downcase == "not be" && bool_status
      raise "The visit record (#{$arr_all_exam_id}) for the patient (#{$str_patient_id}) exists in Select Patient tab"
    elsif str_condition.downcase == "be" && !bool_status
      raise "The visit record (#{$arr_all_exam_id}) for the patient (#{$str_patient_id}) does not exists in Select Patient tab"
    end
    $log.success("The visit record (#{$arr_all_exam_id}) for the patient (#{$str_patient_id})#{str_condition.downcase.include?('not') ? ' does not' : ''} exists in Select Patient tab")
  end
end

# And "Note Description" field of the exam is "updated" in "Visit"
And /^"([^"]*)" field(?:|s) of the exam (?:is|are) "([^"]*)" in "([^"]*)"$/ do |str_attribute, str_action, str_page|
  if ["visit", "exam"].include? str_page.downcase
    on(EHR::NonComplianceReport).edit_current_patient_visit
    on(EHR::CreateExam).update_visit(str_attribute, str_action)
  elsif str_page.downcase == "health status"
    on(EHR::NonComplianceReport) do |page|
      page.edit_current_patient_health_status
      add_to_health_status(str_action, str_attribute)
      click_on(page.link_close_health_status_iframe_element)
    end
  elsif str_page.downcase.include? "select patient"
    on(EHR::MasterPage).select_menu_item(HOME)
    on(EHR::SearchPatient).edit_exam_visit($arr_valid_exam_id.first)
    on(EHR::CreateExam).update_visit(str_attribute, str_action)
  else
    raise "Invalid page name : #{str_page}"
  end
end

# Then the "Note Description" field of the exam should "be" updated in "Non Compliance report"
Then /^the "([^"]*)" field of the exam should "([^"]*)" updated in "([^"]*)"$/ do |str_exam_attribute, str_condition, str_page|
  if str_page.downcase == "non compliance report"
    on(EHR::NonComplianceReport).edit_current_patient_visit
  elsif str_page.downcase == "select patient"
    on(EHR::MasterPage).select_menu_item(HOME)
    on(EHR::SearchPatient).edit_exam_visit($arr_valid_exam_id.first)
  end
  bool_status = on(EHR::CreateExam).is_visit_updated(str_exam_attribute)
  if str_condition.downcase == "not be" && bool_status
    raise "The visit record (#{$arr_valid_exam_id.first}) for the patient (#{$str_patient_id}) has been updated in #{str_page} page"
  elsif str_condition.downcase == "be" && !bool_status
    raise "The visit record (#{$arr_valid_exam_id.first}) for the patient (#{$str_patient_id}) has not been updated in #{str_page} page"
  end
  $log.success("The visit record for the patient (#{$str_patient_id}) has #{str_condition.downcase.include?('not') ? 'not' : ''} been updated in #{str_page} page")
end

# And the visit is "inactivated"
When /^(?:all|the) visit(?:|s) (?:is|are) "([^"]*)"$/ do |str_action|
  on(EHR::NonComplianceReport).update_visit_status(str_action)
end

# When "1" "coded medication list" is added for the exam in "non compliance report"
And /^(?:|"([^"]*)" )?"([^"]*)" (?:is|are) added for (?:a|the) exam in "([^"]*)"$/ do |str_count, str_section, str_tab|
  str_count ||= ""
  on(EHR::NonComplianceReport).edit_patient_record_in_report
  add_to_health_status(str_count, str_section)
  click_on(on(EHR::NonComplianceReport).link_close_visit_popup_element)
end

# Then "medication reconciliation" checkbox is "disabled"
Then /^"([^"]*)" checkbox is "([^"]*)"$/ do |str_checkbox_name, str_required_status|
  step %{currently in "Non Compliance Report" page}
  bool_status = on(EHR::NonComplianceReport).get_relates_to_checkbox_status(str_checkbox_name, str_required_status)
  if str_required_status.downcase == "enabled" && !bool_status
    steps %Q{
    Given "medication reconciliation" is "added" to compliance check
    And currently in "Non Compliance Report" page
    }
    bool_status = on(EHR::NonComplianceReport).get_relates_to_checkbox_status(str_checkbox_name, str_required_status)
  end
  raise "#{str_checkbox_name} checkbox is not #{str_required_status}" if !bool_status
  $log.success("#{str_checkbox_name} checkbox is #{str_required_status}")
end

# Then "All" "EP" should "be" "checked"
Then /^"([^"]*)" "([^"]*)" should "([^"]*)" "([^"]*)"$/ do |str_value, str_filter, str_condition, str_status|
  bool_status = on(EHR::NonComplianceReport).is_filter_selected(str_filter, str_value, str_status)
  if str_condition.downcase == "be" && !bool_status
    raise "The filter '#{str_filter}' for '#{str_value}' is not #{str_status}"
  elsif str_condition.downcase == "not be" && bool_status
    raise "The filter '#{str_filter}' for '#{str_value}' is #{str_status}"
  end
  $log.success("The filter '#{str_filter}' for '#{str_value}' is #{str_condition.downcase.include?('not') ? 'not ' : ''}#{str_status}")
end

And /^set Current EP in Non Compliance filter$/ do
  step %{currently in "Non Compliance Report" page}
  on(EHR::NonComplianceReport).apply_non_compliance_filter($str_ep_name)
end