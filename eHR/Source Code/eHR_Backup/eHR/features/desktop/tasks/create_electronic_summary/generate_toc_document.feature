#Name             : Generate Transition of Care Document
#Description      : covers scenarios of Generate Transition of Care Document under Tasks
#Author           : Gomathi

@all @tasks_generate_toc_document @tasks @milestone9
Feature: Tasks - Verification of Tasks Scenarios - Generate Transition of Care Document

  Background:
    Given login as "non ep"
    And set EP as "stage1 ep"

  @tc_486
  Scenario: Verification of Generate Transition of Care document without selecting the Patient and Visit
    Given currently in "Generate toc document" page
    Then "Please select a patient and visit" message should be displayed
    When a patient is created "with MU"
    And currently in "Generate toc document" page
    Then "Please select a Visit" message should be displayed

  @tc_2370 @chrome
  Scenario: Verification of TOC details for patient with multiple race
    Given a patient is created "with MU and All Race"
    And "1" exam is created for the patient as "active" and "1 day" "before" the reporting period
    When TOC document is generated for the patient
    And Health Record is generated for the "patient"
    Then patient "race" details should be displayed in the Health Record
