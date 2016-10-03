# Description   : step definitions for steps related to Create Electronic Summary
# Author        : Gomathi

When /^export summary is generated$/ do
  on(EHR::CreateElectronicSummary).generate_export_summary
  #wait_for_page_load("Failure in loading after download", 250)
end

Then /^TOC document is generated for the patient$/ do
  step %{currently in "Generate toc document" page}
  on(EHR::CreateElectronicSummary).generate_toc_document
  switch_to_next_window    # switches to the window
  switch_to_application_window
end

Then /^TOC document is generated and downloaded for the patient$/ do
  step %{currently in "Generate toc document" page}
  on(EHR::CreateElectronicSummary) do |page|
    page.generate_toc_document
    page.download_ccd_document
  end
end



