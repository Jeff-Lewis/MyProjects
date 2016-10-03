# Description      : step definitions for steps related to Communication
# Author           : Gomathi

# And TOC is uploaded and attached with "medication" for the recent exam
And /^TOC is uploaded and attached with "([^"]*)" for the recent exam$/ do |str_type|
  on(EHR::MasterPage).select_menu_item(SUBMIT_PATIENT_CLINICAL_DOCUMENTS)
  on(EHR::Communications) do |page|
    page.upload_ccd_document
    on(EHR::MasterPage).select_menu_item(RECEIVED_CLINICAL_DOCUMENTS)
    page.select_patient_from_ccd($str_patient_id)
    page.submit_document_note
  end
end

