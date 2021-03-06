And /^"([^"]*)" is clicked from MU checklist ribbon for "([^"]*)"$/ do |str_ribbon_name, str_section|
  on(EHR::MasterPage) do|page|
    case str_ribbon_name.downcase
      when "reconciliation"
        wait_for_loading
        page.link_reconciliation_ribbon_element.scroll_into_view rescue Exception
        page.link_reconciliation_ribbon_element.click
        wait_for_loading
        #raise "reconciliation ribbon is not clicked" if page.link_reconciliation_ribbon_element.visible?
      else
        raise "Invalid input for str_ribbon_name : #{str_ribbon_name}"
    end
  end
  case str_section.downcase
    when "medication"
      on(EHR::HealthStatus).merge(str_section)
    else
      raise "Invalid input for str_section : #{str_section}"
  end
end

# And EOE is generated and the patient exam details should be displayed in "End of Exam" clinical summary
When /^EOE is generated and the patient (?:specific education|exam) details should be displayed in "([^"]*)" clinical summary$/ do |str_mu_checklist|
  case str_mu_checklist.downcase
    when "end of exam"
      on(EHR::MasterPage).verify_clinical_summary
  end
end

# And EOE is generated for a visit from "non compliance report"
And /^EOE is generated for the exam from "([^"]*)"$/ do |str_page|
  on(EHR::NonComplianceReport).edit_patient_record_in_report
  on(EHR::MasterPage).verify_clinical_summary
  on(EHR::NonComplianceReport).close_health_status_iframe
end