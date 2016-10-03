# Description    : step definitions for steps related to Mobile Clinical data and desktop Health Status
# Author         : Chandra sekaran

# Then the "med allergy" data "should" be reflected in "Clinical Data" section
Then /^the "([^"]*)" (?:data|text) "([^"]*)" be (?:reflected|present|updated) in "([^"]*)" section$/ do |str_sub_section, str_condition, str_section|
  bool_status = ''
  if str_section.downcase == "clinical data"
    on(EHR::DashboardPage).touch_tab(str_sub_section)
    bool_status = on(EHR::ClinicalDataPage).is_clinical_data_added(str_sub_section)

  elsif str_section.downcase == "health status"
    on(EHR::MasterPage).select_tab("health status")
    bool_status = on(EHR::DesktopHealthStatus).is_health_status_data_added(str_sub_section)

  elsif str_section.downcase.include? "mu checklist"
    bool_status = on(EHR::DesktopMaster).is_mu_checklist_compliant(str_sub_section)

  elsif str_section.downcase == "demographics"
    on(EHR::DashboardPage).touch_tab(str_section)
    bool_status = on(EHR::PatientInfoPage).is_demographics_added(str_sub_section)

  elsif str_section.downcase == "select patient"
    on(EHR::MasterPage).select_menu_item(HOME)
    bool_status = on(EHR::DesktopVisit).is_exam_updated(str_sub_section)

  elsif str_section.downcase == "exam information"
    on(EHR::DashboardPage).touch_tab(str_section)
    bool_status = on(EHR::ExamInfoPage).is_exam_updated(str_sub_section)
  else
    raise "Invalid section name : #{str_section}"
  end

  if str_condition.downcase == "should"
    if bool_status
      $log.success("The #{str_sub_section} data #{str_sub_section.downcase.include?('all') ? 'are' : 'is'} found in #{str_section}")
    else
      raise "The #{str_sub_section} data #{str_sub_section.downcase.include?('all') ? 'are' : 'is'} not found in #{str_section}"
    end
  elsif str_condition.downcase == "should not"
    if bool_status
      raise "The #{str_sub_section} data #{str_sub_section.downcase.include?('all') ? 'are' : 'is'} found in #{str_section}"
    else
      $log.success("The #{str_sub_section} data #{str_sub_section.downcase.include?('all') ? 'are' : 'is'} not found in #{str_section}")
    end
  end
end

# And relogin into mobile web application
And /^relogin into mobile web application$/ do
  on(EHR::DashboardPage).logout
  step %{a "non EP" user is logged in "mobile" web application}
end

# When the "Auto Face to Face Visit" is "unchecked" in Organization tab
When /^the "([^"]*)" is "([^"]*)" in Organization tab$/ do |str_field, str_action|
  on(EHR::MasterPage).select_menu_item(SITE_ADMINISTRATION)
  on(EHR::SiteAdministration) do |page|
    if str_field.downcase.include? "face to face"
      page.update_auto_face_to_face_visit_status(str_action)
    elsif str_field.downcase.include? "cpt code"
      $str_cpt_code = page.update_cpt_code(str_action)
    end
  end
end