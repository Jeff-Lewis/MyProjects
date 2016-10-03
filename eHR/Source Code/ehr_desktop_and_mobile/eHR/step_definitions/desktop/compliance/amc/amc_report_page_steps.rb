# Description    : step definitions for steps related to AMC page
# Author         : Gomathi

# When get help text of "demographics" under "core set" from tooltip
When /^get help text of "(.*?)" under "(.*?)" from tooltip$/ do |str_objective, str_table|
  @str_tooltip_content = on(EHR::AMCStage).get_tooltip_content(str_table, str_objective)
end

# Then help text for "demographics" should be equal to the text
Then /^help text for "(.*?)" should be equal to the text$/ do |str_objective, str_help_text|
  $log.success("The tooltip content for '#{str_objective}' found") if @str_tooltip_content.casecmp(str_help_text)
end

# Then get "all" details of "demographics" under "core set" for "stage2 ep" as "within report range"
Then /^get "([^"]*)" details of "([^"]*)" under "([^"]*)" for "([^"]*)" as "([^"]*)"$/ do |str_field, str_objective, str_table, str_doctor_stage, str_report_range|
  step %{AMC report is generated for "#{str_doctor_stage}" as "#{str_report_range}"}

  # make objective and table values global for use in send patient reminders methods
  @str_amc_objective = str_objective
  @str_amc_table = str_table
  @str_amc_field = str_field

  numerator, denominator, percentage, requirement = on(EHR::AMCStage).get_objective_details(@str_amc_table, @str_amc_objective)

  case str_field.downcase
    when "all"
      @numerator, @denominator, @percentage, @requirement = numerator, denominator, percentage, requirement
    when "numerator"
      @numerator = numerator
    when "denominator"
      @denominator = denominator
    when "numerator and denominator"
      @numerator, @denominator = numerator, denominator
    when "percentage"
      @percentage = percentage
    when "requirement"
      @requirement = requirement
  end
end

# Then the "numerator" of "demographics" under "core set" should be "increased" by "1"
Then /^the "(.*?)" of "(.*?)" under "(.*?)" should be "(.*?)" (?:by|to) "([^"]*)"$/  do |str_attribute, str_objective, str_table, str_action, num_count|
  @numerator_old = @numerator.to_i
  @denominator_old = @denominator.to_i

  if str_attribute.downcase == "denominator" || str_attribute.downcase == "numerator" || str_attribute.downcase == "numerator and denominator"
    step %{get "#{str_attribute}" details of "#{str_objective}" under "#{str_table}" for "#{$str_ep}" as "#{$str_report_range}"}
  end

  on(EHR::AMCStage) do |page|
    case str_attribute.downcase
      when /numerator/, /denominator/
        if num_count.downcase.include?("and")
          arr_num_count = num_count.split("and")
          numerator_count = arr_num_count[0]
          denominator_count = arr_num_count[1]
        else
          denominator_count = numerator_count = num_count
        end
        begin
          page.count_verification(@denominator_old, @denominator.to_i, denominator_count.to_i, str_action, "Denominator") if str_attribute.downcase.include?("denominator")
          page.count_verification(@numerator_old, @numerator.to_i, numerator_count.to_i, str_action, "Numerator") if str_attribute.downcase.include?("numerator")
        rescue Exception => ex
          if $scenario_tags.include? "@hl7"
            step %{the latest patient record is selected}    # check for the patient record created from HL7 message
            # check for Lab order result created from HL7 message
            on(EHR::MasterPage).select_tab("order entry")
            on(EHR::OrderEntryResults).get_order_status("laboratory results")
            raise "HL7 Error message : Patient record and Lab result(s) for the patient exists but not reflected in AMC report page \n #{ex}"
          else
            raise ex
          end
        end

      when "requirement"
        page.value_verification(@requirement, num_count, "requirement")

      when "percentage"
        page.value_verification(@percentage, num_count, "percentage")

    end
  end
end

# Then the "percentage" of "Generate Patient List" under "menu set" should be "Not Performed"
Then /^the "([^"]*)" of "([^"]*)" under "([^"]*)" should be "([^"]*)"$/ do |str_attribute, str_objective, str_table, str_percentage_value|
  if str_percentage_value.downcase == "performed"
    raise "The #{str_attribute} of #{str_objective} objective is not displayed as 'Performed'" if !@percentage.downcase == str_percentage_value.downcase
    $log.success("The #{str_attribute} of #{str_objective} objective is displayed as 'Performed'")
  elsif str_percentage_value.downcase == "not performed"
    raise "The #{str_attribute} of #{str_objective} objective is not displayed as 'Not Performed'" if !@percentage.downcase == str_percentage_value.downcase
    $log.success("The #{str_attribute} of #{str_objective} objective is displayed as 'Not Performed'")
  else
    raise "Invalid checkbox status #{str_status}"
  end
end

# And get checkbox status of "Generate Patient List" under "core set" for "stage2 ep" as "within report range"
And /^get checkbox status of "(.*?)" under "(.*?)" for "(.*?)" as "(.*?)"$/ do |str_objective, str_table, str_doctor_stage, str_report_range|
  step %{get "percentage" details of "#{str_objective}" under "#{str_table}" for "#{str_doctor_stage}" as "#{str_report_range}"}
  @bool_checkbox_status = on(EHR::AMCStage).get_print_item_checkbox_status(str_table, str_objective)
end

# Then the checkbox status for "Generate Patient List" should be "unchecked"
Then /^the checkbox status for "(.*?)" should be "(.*?)"$/ do |str_objective, str_status|
  if str_status.downcase == "checked"
    raise "The selection checkbox of #{str_objective} objective is unchecked" if !(@percentage.casecmp("performed") && @bool_checkbox_status)
    $log.success("The selection checkbox of #{str_objective} objective is checked")
  elsif str_status.downcase == "unchecked"
    raise "The selection checkbox of #{str_objective} objective is checked" if !(@percentage.casecmp("not performed") && !@bool_checkbox_status)
    $log.success("The selection checkbox of #{str_objective} objective is unchecked")
  else
    raise "Invalid checkbox status #{str_status}"
  end
end

# Then verify "Vital Signs - Blood Pressure" objective is present under "core set"
Then /^verify "([^"]*)" objective is present under "([^"]*)"$/ do |str_objective, str_table|
  on(EHR::AMCStage).is_objective_exists(str_objective, str_table)
end

# And Send button "should not" be displayed for "Preventive Care"
When /^Send button "([^"]*)" be displayed for "([^"]*)"$/ do |str_condition, str_objective|
  bool_button_exists = on(EHR::AMCStage).is_send_button_exists(@str_amc_table, @str_amc_objective)
  if str_condition.downcase.strip == "should not"
    raise "Send button exists for #{@str_amc_objective}" if bool_button_exists
    $log.success("Send button does not exists for '#{@str_amc_objective}'")
  elsif str_condition.downcase.strip == "should"
    raise "Send button does not exists for #{@str_amc_objective}" if !bool_button_exists
    $log.success("Send button exists for '#{@str_amc_objective}'")
  end
end

When /^EP is selected from AMC page EP list$/ do
  on(EHR::MasterPage).select_menu_item(AUTOMATED_MEASURE_CALCULATOR)
  on(EHR::AMCStage).select_EP_element.when_visible.select($str_ep_name)
end

# When AMC report is generated "without CQM report" for "stage1 ep" as "within report range"
Given /^AMC report is generated(?:| "([^"]*)")? for "([^"]*)" as "([^"]*)"$/ do |str_cqm_option, str_doctor_stage, str_report_range|
  str_cqm_option ||= ""
  on(EHR::MasterPage).select_menu_item(AUTOMATED_MEASURE_CALCULATOR)

  $str_ep_name = set_ep(str_doctor_stage) unless str_doctor_stage.downcase == "all ep"
  str_from_date, $report_generation_time = set_report_range(str_report_range)
  object_date_time = pacific_time_calculation
  str_from_date_year = object_date_time.strftime("%Y")
  str_to_date_year = $report_generation_time.strftime("%Y")
  if str_from_date_year != str_to_date_year
    $log.success("Reporting period span across different years (From date => #{object_date_time.strftime("01/01/%Y")} & To date => #{$report_generation_time.strftime(DATE_FORMAT_WITH_SLASH)})")
    pending
  end
   if str_doctor_stage.downcase == "all ep"
     on(EHR::AMCStage).AMC_generate_report("Select All Eligible Providers", str_from_date, $report_generation_time.strftime(DATE_FORMAT), str_cqm_option)
   else
     on(EHR::AMCStage).AMC_generate_report($str_ep_name, str_from_date, $report_generation_time.strftime(DATE_FORMAT), str_cqm_option)
   end
  $str_report_range = str_report_range
  $str_ep = str_doctor_stage
end

# Then "stage1 AMC" report is generated
Then /^(?:|"([^"]*)" )?"([^"]*)" report is generated$/ do |str_report_option, str_report|
  str_report_option ||= ""
  on(EHR::AMCStage).is_table_exists(str_report_option, str_report)
end

# Then "stage1 ep" is listed in All EP report
Then /^"([^"]*)" is( not)? listed in All EP report$/ do |str_ep_stage, str_negation|
  bool_ep_avail = on(EHR::AMCStage).is_ep_exists(str_ep_stage)
  if str_negation.nil? && bool_ep_avail
    $log.success("The #{str_ep_stage} #{$str_ep_name} is listed in All EP report")
  elsif str_negation.nil? && !bool_ep_avail
    raise "The #{str_ep_stage} #{$str_ep_name} is not listed in All EP report"
  elsif !str_negation.nil? && str_negation.strip.downcase == "not" && !bool_ep_avail
    $log.success("The #{str_ep_stage} #{$str_ep_name} is not listed in All EP report")
  elsif !str_negation.nil? && str_negation.strip.downcase == "not" && bool_ep_avail
    raise "The #{str_ep_stage} #{$str_ep_name} is listed in All EP report"
  end

  switch_to_application_window
end