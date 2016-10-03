# Description    : step definitions for steps related to AMC page Numerator link popup
# Author         : Chandra sekaran

# Then "a record" should be in "demographics" numerator report under "core set"
Then /^"(.*?)" should (?:be|not be) in "(.*?)" numerator report under "(.*?)"$/ do |str_record, str_objective, str_table|
  if $str_ep.downcase == "stage1 ep"
    case str_objective.downcase
      when "cpoe for medication order"
        arr_visit_id = $arr_valid_exam_id
        str_reason = "Medication ordered"
      when "cpoe for medication orders - alternate"
        arr_visit_id = $arr_valid_exam_id
        str_reason = "#{$num_s1_medication_order} CPOE for medication orders"
      when "demographics"
        arr_visit_id = $arr_valid_exam_id
        str_reason = "Race, Ethinicity, Language, Gender is Recorded"
      when "generate and transmit erx"
        arr_visit_id = $arr_valid_exam_id
        str_reason = "#{$num_s1_e_prescribed_medication_order} drug formulary transmitted electronically"
      when "medication allergy list"
        arr_visit_id = $arr_valid_exam_id
        str_reason = "#{$num_medication_allergy} Medication Allergy List"
      when "medication reconciliation"
        arr_visit_id = $arr_valid_exam_id
        str_reason = "Medication reconciled"
      when "medication list"
        arr_visit_id = $arr_valid_exam_id
        str_reason = "#{$num_medication_list} Active medication were recorded"
        str_reason = "No Active medication were recorded" if $num_medication_list == 0 && str_record.downcase == "a record"
      when "patient specific education resources"
        arr_visit_id = $arr_valid_exam_id
        str_reason = "EOE Generated"
      when "problem list"
        arr_visit_id = $arr_valid_exam_id
        str_reason = "#{$num_problem_list} Active problems were recorded"
        str_reason = "No known problems were recorded" if $num_problem_list == 0 && str_record.downcase == "a record"
      when "provide clinical summary"
        arr_visit_id = $arr_valid_exam_id
        str_reason = "#{$num_s1_provide_clinical_summary} Clinical Summary provided"
      when "send reminders"
        arr_visit_id = $arr_valid_exam_id
        str_reason = "Reminder/EOE Sent"
      when "smoking status"
        arr_visit_id = $arr_valid_exam_id
        str_reason = "Smoking status recorded"
      when "transition summary of care"
        arr_visit_id = $arr_valid_exam_id
        str_reason = "#{$num_transition_summary_of_care} Transition summary of care provided"
      when "patient electronic access"
        arr_visit_id = $arr_valid_exam_id
        str_reason = "#{$num_s1_patient_electronic_access} Electronic access provided"
      when "vital signs"
        arr_visit_id = $arr_valid_exam_id
        str_reason = "Height, Weight, BP recorded"
      when "vital signs- alternate"
        arr_visit_id = $arr_valid_exam_id
        str_reason = "Height, Weight, BP recorded"
      when "vital signs - height and weight"
        arr_visit_id = $arr_valid_exam_id
        str_reason = "Height Weight recorded"
      when "vital signs - blood pressure"
        arr_visit_id = $arr_valid_exam_id
        str_reason = "BP recorded"
      else
        raise "Invalid input for str_objective : #{str_objective}"
    end

  elsif $str_ep.downcase == "stage2 ep"
    case str_objective.downcase
      when "cpoe for medication order"
        arr_visit_id = $arr_valid_exam_id
        str_reason = "#{$num_hand_written_medication_order} CPOE for medication orders"
      when "cpoe for laboratory orders"
        arr_visit_id = $arr_valid_exam_id
        str_reason = "#{$num_laboratory_order} CPOE Lab orders"
      when "cpoe for radiology orders"
        arr_visit_id = $arr_valid_exam_id
        str_reason = "#{$num_radiology_order} CPOE for radiology orders"
      when "demographics"
        arr_visit_id = $arr_valid_exam_id
        str_reason = "Race, Ethinicity, Language, Gender is Recorded"
      when "family health history"
        arr_visit_id = $arr_valid_exam_id
        str_reason = "#{$num_family_history} first degree relationship recorded"
      when "generate and transmit erx"
        arr_visit_id = $arr_valid_exam_id
        str_reason = "#{$num_s2_e_prescribed_medication_order} drug formulary transmitted electronically"
      when "incorporate clinical lab results"
        arr_visit_id = $arr_valid_exam_id
        str_reason = "#{$num_clinical_lab_results} Lab Results"
      when "medication reconciliation"
        arr_visit_id = $arr_valid_exam_id
        str_reason = "Medication reconciled"
      when "patient electronic access"
        arr_visit_id = $arr_valid_exam_id
        str_reason = "#{$num_s2_patient_electronic_access} Electronic access provided"
      when "patient specific education resources"
        arr_visit_id = $arr_valid_exam_id
        str_reason = "EOE Generated"
      when "preventive care"
        arr_visit_id = $arr_valid_exam_id
        str_reason = "Reminder sent"
      when "provide clinical summary"
        arr_visit_id = $arr_valid_exam_id
        str_reason = "#{$num_s2_provide_clinical_summary} Clinical Summary provided"
      when "record electronic notes"
        arr_visit_id = $arr_valid_exam_id
        str_reason = "Visit notes created"
      when "smoking status"
        arr_visit_id = $arr_valid_exam_id
        str_reason = "Smoking status recorded"
      when "vital signs"
        arr_visit_id = $arr_valid_exam_id
        str_reason = "Height, Weight, BP recorded"
      when "vital signs - blood pressure"
        arr_visit_id = $arr_valid_exam_id
        str_reason = "BP recorded"
      when "vital signs - height and weight"
        arr_visit_id = $arr_valid_exam_id
        str_reason = "Height Weight recorded"
      else
        raise "Invalid input for str_objective : #{str_objective}"
    end
  end

  on(EHR::AMCStage) do |page|
    sleep 2 if BROWSER.downcase == "chrome"  # static delay for chrome sync issue
    @num_numerator_count = page.click_numerator(str_table, str_objective)
    arr_record = ["cancelled record", "invalid record"]

	bool_record = !page.is_report_exists(@str_patient_id, arr_visit_id, str_reason)
    if str_record.downcase == "a record" && !bool_record
      $log.success("The patient id #{@str_patient_id} with record for #{arr_visit_id.join(", ")} and #{str_reason} exist in the Report")
    elsif str_record.downcase == "a record" && bool_record
      # for handling delayed data population of patient record in numerator pop-up
      on(EHR::MasterPage).close_application_windows
      sleep 6   # static delay
      begin
        @num_numerator_count = page.click_numerator(str_table, str_objective)
        raise "No such Patient id (#{@str_patient_id}) with record for #{arr_visit_id.join(", ")} and #{str_reason} exists in the report" if !page.is_report_exists(@str_patient_id, arr_visit_id, str_reason)
      rescue Exception => ex
        if $scenario_tags.include? "@hl7"
          step %{the latest patient record is selected}    # check for the patient record created from HL7 message
          # check for Lab order result created from HL7 message
          on(EHR::MasterPage).select_tab("order entry")
          on(EHR::OrderEntryResults).get_order_status("laboratory results")
          raise "HL7 Error message : Patient record and Lab result(s) for the patient exists but not reflected in Numerator report page \n #{ex}"
        else
          #raise ex
          $log.error("No such Patient id (#{@str_patient_id}) with record for #{arr_visit_id.join(", ")} and #{str_reason} exists in the report")  # raise ex is not working sometimes, so raise is changed by $log.error
          exit
        end
      end
    elsif arr_record.include?(str_record.downcase) && bool_record
      $log.success("The patient id #{@str_patient_id} with record for #{arr_visit_id.join(", ")} and #{str_reason} does not exist in the Report")
    elsif arr_record.include?(str_record.downcase) && !bool_record
      raise "The patient id #{@str_patient_id} with record for #{arr_visit_id.join(", ")} and #{str_reason} should not exist in the Report"
    end

    on(EHR::MasterPage).close_application_windows
  end
end