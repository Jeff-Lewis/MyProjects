# Description      : step definitions for steps related to Visit notes tab
# Author           : Chandra sekaran

When /^a visit note is created for the exam$/ do
  on(EHR::MasterPage).select_tab("visit notes")
  on(EHR::VisitNotes).create_visit_notes
end