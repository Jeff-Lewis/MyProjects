# Description    : step definitions for steps related to Patient Exam
# Author         : Chandra sekaran

# And an "valid" exam is added for the patient
Given /^an "([^"]*)" exam is added for the patient$/ do |str_exam_attribute|
  on(EHR::DashboardPage).touch_tab("exam")
  on(EHR::ExamInfoPage).enter_exam_info(str_exam_attribute)
  # click_previous
end