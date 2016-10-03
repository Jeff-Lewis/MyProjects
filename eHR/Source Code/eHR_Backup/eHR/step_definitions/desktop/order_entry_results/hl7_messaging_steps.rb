# When an HL-7 message with Lab order "within report range" and "Numeric" Lab result "within report range" is sent
When /^an HL-7 message with Lab order "([^"]*)" and "([^"]*)" Lab (?:result|results) "([^"]*)" is sent$/ do |str_lab_order_report_range, str_result_type, str_result_report_range|
  obj_msg = EHR::HL7_Utils.new(str_lab_order_report_range, str_result_type, str_result_report_range)
  str_status = obj_msg.send_hl7_message
  if str_status
    $log.success("HL7 message for #{str_result_type} has been sent successfully")
    if str_result_type.downcase == "multiple"
      $num_clinical_lab_results = 3     # since three lab results will be created for the patient
    else
      $num_clinical_lab_results = 1    # since only one lab result will be created for the patient
    end
    @str_patient_id = $str_patient_id
  else
    raise("Failure in sending/receiving acknowledgement for HL7 message for #{str_result_type}")
  end
  $embed_hl7 = true    # for embedding HL7 message file into Cucumber report file
end